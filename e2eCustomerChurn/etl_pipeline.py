import sys
import pandas as pd
import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv
import os

# load environment variables from .env file
load_dotenv()

# --- Database connection parameters--
DB_URL = os.getenv("DATABASE_URL")
# DB_HOST = os.getenv("DB_HOST", "localhost")
# DB_NAME = os.getenv("DB_NAME", "customer_churn_db")
# DB_USER = os.getenv("DB_USER", "postgres")
# DB_PASSWORD = os.getenv("DB_PASSWORD", "superuser")


# connect to the PostgreSQL database
def get_db_connection():
    """
    Establishes a connection to the PostgreSQL database.

    Returns:
        psycopg2.extensions.connection: A connection object to the database.
    """
    try:
        conn = psycopg2.connect(DB_URL)
        print("Database connection established successfully.")
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None


# --- ETL Pipeline ---
def extract_data(file_path):
    """
    Extracts data from a CSV file.

    Parameters:
        file_path (str): The path to the CSV file.

    Returns:
        pd.DataFrame: A DataFrame containing the extracted data.
    """
    try:
        df = pd.read_csv(file_path)
        print(f"Extracted {len(df)} rows from the file.")
        return df
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return pd.DataFrame()


def load_to_staging(df, table_name, conn):
    """
    Loads data into a staging table in the database.

    Parameters:
        df (pd.DataFrame): The DataFrame to be loaded.
        table_name (str): The name of the staging table.
    """
    conn = get_db_connection()
    if conn is None:
        return
    # if df.empty:
    #     print(f"No data to load to {table_name}.")
    #     return
    #
    cur = conn.cursor()
    cols = ", ".join(df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))
    insert_query = sql.SQL("INSERT INTO {} ({}) VALUES ({})").format(
        sql.Identifier(table_name), sql.SQL(cols), sql.SQL(placeholders)
    )
    # Execute the insert query for all rows in the DataFrame
    data_to_insert = [tuple(row) for row in df.values]

    try:
        cur.executemany(insert_query, data_to_insert)
        conn.commit()
        print(f"Loaded {len(df)} rows into the staging table '{table_name}'.")
    except Exception as e:
        print(f"Error loading data to staging table {table_name}: {e}")
    finally:
        conn.close()


def transform_and_load_core(conn):
    """
    Transforms data from the staging tables and loads it into core tables
    (dim_customer and fact_churn_events).
    Includes data quality checks and transformations

    Parameters:
        conn (psycopg2.extensions.connection): The database connection object.
    """
    if conn is None:
        print("No database connection available.")
        return

    cur = conn.cursor()
    print("Starting transformation and loading into core tables...")
    try:
        # Create dim_customer table
        cur.execute(
            """
            SELECT customerid, gender, seniorcitizen, partner, dependents
                    FROM stg_customer_demographics
                    UNION
                    SELECT customerid, null, null, null, null
                    FROM stg_customer_services;
                    """
        )
        print("Created dim_customer table.")
        raw_customers = pd.DataFrame(
            cur.fetchall(),
            columns=["customerid", "gender", "seniorcitizen", "partner", "dependents"],
        )
        raw_customers = raw_customers.drop_duplicates(subset="customerid")

        # Transformations for dim_customer
        dim_cust_df = raw_customers.copy()
        dim_cust_df["is_senior_citizen"] = dim_cust_df["seniorcitizen"].apply(
            lambda x: True
            if str(x).strip().upper() == "YES" or str(x).strip() == "1"
            else (
                False
                if str(x).strip().upper() == "NO" or str(x).strip() == "0"
                else None
            )
        )

        dim_cust_df["has_partner"] = dim_cust_df["partner"].map(
            {
                "Yes": True,
                "No": False,
                "No internet service": False,
                "No phone service": False,
                "": None,
                None: None,
            }
        )
        # print(dim_cust_df["has_partner"])
        # sys.exit("stopped for inspection")
        dim_cust_df["has_dependents"] = dim_cust_df["dependents"].map(
            {
                "Yes": True,
                "No": False,
                "No internet service": False,
                "No phone service": False,
                "": None,
                None: None,
            }
        )
        dim_cust_df["gender"] = dim_cust_df["gender"].map(
            {"Male": "Male", "Female": "Female", "": None, None: None}
        )

        # insert into dim_customer
        for index, row in dim_cust_df.iterrows():
            try:
                cur.execute(
                    """
                    INSERT INTO dim_customer
                        (customer_id, gender, is_senior_citizen, has_partner, has_dependents)
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT (customer_id) DO UPDATE SET 
                        gender = EXCLUDED.gender, 
                        is_senior_citizen = EXCLUDED.is_senior_citizen,
                        has_partner = EXCLUDED.has_partner, 
                        has_dependents = EXCLUDED.has_dependents,
                        updated_at = CURRENT_TIMESTAMP;
                    """,
                    (
                        row["customerid"],
                        row["gender"],
                        row["is_senior_citizen"],
                        row["has_partner"],
                        row["has_dependents"],
                    ),
                )
            except Exception as e:
                # print(f"Error inserting row {index} into dim_customer: {e}")
                print(
                    f"Error inserting or updating dim_customer for {row['customerid']}: {e}"
                )
                conn.rollback()
                continue
        conn.commit()
        print(f"Loaded {len(dim_cust_df)} into dim_customer table.")

        # Create fact_churn_events table

    except Exception as e:
        conn.rollback()
        print(f"An error occurred during transformation and loading: {e}")
    finally:
        cur.close()


# --- Main ETL Orchestration ---
if __name__ == "__main__":
    conn = get_db_connection()
    if conn:
        try:
            # 1.  Extract data from the CSV file
            customer_demographics_raw = extract_data("customer_demographics_raw.csv")
            customer_services_raw = extract_data("customer_services_raw.csv")

            # 2. Load data into staging tables
            print("Columns", customer_demographics_raw.columns)
            load_to_staging(
                customer_demographics_raw, "stg_customer_demographics", conn
            )
            load_to_staging(customer_services_raw, "stg_customer_services", conn)
            # var_10_col = [
            #     "PhoneService",
            #     "MultipleLines",
            #     "OnlineSecurity",
            #     "OnlineBackup",
            #     "DeviceProtection",
            #     "TechSupport",
            #     "StreamingTV",
            #     "StreamingMovies",
            #     "PaperlessBilling",
            #     "Churn",
            # ]
            # for col in var_10_col:
            #     long_vals = customer_services_raw[
            #         customer_services_raw[col].astype(str).str.len() > 10
            #     ]
            #     if not long_vals.empty:
            #         print(f"Column '{col}' has values longer than 10 characters.")
            #         print(long_vals[[col]])
            # print("Columns", customer_services_raw)
            # print("Columns", customer_services_raw.columns)

            # 3.  Transform and load data into core tables
            transform_and_load_core(conn)
        finally:
            conn.close()
            print("ETL pipeline completed successfully.")

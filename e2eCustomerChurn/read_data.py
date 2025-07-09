import pandas as pd
import numpy as np


def load_data(file_path):
    """
    Reads the customer churn data from a CSV file and processes it.

    Parameters:
    file_path (str): The path to the CSV file containing the customer churn data.

    Returns:
    pd.DataFrame: A DataFrame containing the processed customer churn data.
    """
    # Read the CSV file
    try:
        df = pd.read_csv(file_path)
        # print(df.head(10))
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return pd.DataFrame()
    return df


# split data into two data raw sets
def split_data(df):
    """
    Splits the DataFrame into two separate raw data.

    Parameters:
    df (pd.DataFrame): The DataFrame to be split.

    Returns:
    tuple: A tuple containing the two raw DataFrames.
    """
    # 1. customer_demographics_raw.csv
    demographics_cols = [
        "customerID",
        "gender",
        "SeniorCitizen",
        "Partner",
        "Dependents",
    ]
    df_demographics = df[demographics_cols].copy()
    df_demographics.to_csv("customer_demographics_raw.csv", index=False)

    # 2.customer_services_raw.csv
    services_cols = [
        "customerID",
        "PhoneService",
        "MultipleLines",
        "InternetService",
        "OnlineSecurity",
        "OnlineBackup",
        "DeviceProtection",
        "TechSupport",
        "StreamingTV",
        "StreamingMovies",
        "Contract",
        "PaperlessBilling",
        "PaymentMethod",
        "MonthlyCharges",
        "TotalCharges",
        "tenure",
        "Churn",
    ]
    df_services = df[services_cols].copy()
    df_services.to_csv("customer_services_raw.csv", index=False)
    return df_demographics, df_services


df = load_data("WA_Fn-UseC_-Telco-Customer-Churn.csv")
if not df.empty:
    df_demographics, df_services = split_data(df)
    print("Data has been successfully split and saved to CSV files.")

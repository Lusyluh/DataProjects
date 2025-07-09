--tables to create
/*
Dimension Table (dim_customer): contains unique customer attributes that don't change frequently.
e.g ID, gender, seniopr citizen status, partner status, dependents, etc.
Fact Table (fact_churn_events): contains transaction-level or time-varying data like customer ID,
service details, contract, charges, tenure, and the churn flag.
Staging Tables (stg_customer_services, stg_customer_demographics): used for initial data loading and transformation.
These tables are used to store raw data before it is cleaned and transformed into the final dimension and
*/

--drop tables is they already exist
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS fact_churn_events;
DROP TABLE IF EXISTS stg_customer_services;
DROP TABLE IF EXISTS stg_customer_demographics;

--create tables
CREATE TABLE dim_customer (
customer_pk SERIAL PRIMARY KEY,
    customer_id VARCHAR(255) UNIQUE NOT NULL,
    gender VARCHAR(10),
    is_senior_citizen BOOLEAN,
    has_partner BOOLEAN,
    has_dependents BOOLEAN,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);

CREATE TABLE stg_customer_services (
customerid VARCHAR(225),
phoneservice VARCHAR(10),
multiplelines VARCHAR(10),
internetservice VARCHAR(50),
onlinesecurity VARCHAR(10),
onlinebackup VARCHAR(10),
deviceprotection VARCHAR(10),
techsupport VARCHAR(10),
streamingtv VARCHAR(10),
streamingmovies VARCHAR(10),
    contract VARCHAR(50),
    paperlessbilling VARCHAR(10),
    paymentmethod VARCHAR(50),
    monthlycharges DECIMAL(10, 2),
    totalcharges DECIMAL(10, 2),
    tenure VARCHAR(10), --keeping it a string to handle potentila raw data issues
    churn VARCHAR(10),
    );

CREATE TABLE stg_customer_demographics (
customerid VARCHAR(255),
gender VARCHAR(10),
seniorcitizen VARCHAR(10),
partner VARCHAR(10),
dependents VARCHAR(10)
);

CREATE TABLE fact_churn_events (
event_pk SERIAL PRIMARY KEY,
customer_pk INT NOT NULL,
phone_service VARCHAR(10),
multiple_lines VARCHAR(10),
internet_service VARCHAR(50),
online_security BOOLEAN,
online_backup BOOLEAN,
device_protection BOOLEAN,
tech_support BOOLEAN,
streaming_tv BOOLEAN,
streaming_movies BOOLEAN,
contract_type VARCHAR(50),
paperless_billing BOOLEAN,
payment_method VARCHAR(50),
monthly_charges DECIMAL(10, 2),
total_charges DECIMAL(10, 2),
tenure_months INT,
churned BOOLEAN,
processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (customer_pk) REFERENCES dim_customer(customer_pk)
);

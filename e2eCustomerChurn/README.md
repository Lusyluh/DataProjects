Data Engineering Project: Building a Customer Churn Data Pipeline

Goal: To design, build, and automate a robust ETL (Extract, Transform, Load)
pipeline that ingests raw customer data, cleans and transforms it, and
loads it into a structured SQL database, ready for analysis or a data science model.

Project Overview:

This project focuses on building a ETL pipeline for customer data to support churn analysis.It basically demonstrates key data engineering skills, including:
Data Modelling and Database design
ETL Development using Python and SQL
Data Quality and Validation
Basic Orchestration
Problem solving and Data Governance.

Architecture

This project follows an ETL architecture, moving data through a Staging Layr to a Core/Analytics Layer (using a Star Chema approach with Fact and Dimension tables)

1. Extract: Reads data from CSV files into Pandas DataFrames
2. Load to Staging: Load these raw DataFrames into SQL staging tables
3. Transform and Load to Core: Read from staging tables, apply transformations, and loads into other sql tables

[Raw CSV Files]

- customer_demographics_raw.csv
- customer_services_raw.csv
  ↓
  [Python ETL Script (etl_pipeline.py)] - Extraction (Pandas) - Initial Load to Staging (SQL INSERT) - Transformation & Data Quality (Pandas/Python) - Load to Core (SQL INSERT/UPSERT)
  ↓
  [SQL Database (PostgreSQL)] - Staging Tables (stg_customer_demographics, stg_customer_services) - Core Tables (dim_customer, fact_churn_events)

Technologies Used

1. Python

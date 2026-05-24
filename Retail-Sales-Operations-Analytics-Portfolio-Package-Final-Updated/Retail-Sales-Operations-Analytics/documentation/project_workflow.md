# Project Workflow

This project follows a simple analytics workflow:

Raw CSV file  
SQL Server raw table  
Data quality checks  
Cleaning view  
Valid sales view  
Analysis views  
Power BI dashboard  
Business interpretation

## 1. Raw CSV File

The original dataset was prepared as a CSV file and imported into SQL Server.

## 2. SQL Server Raw Table

The raw file was loaded into `dbo.Online_Retail_Raw`.

Raw fields were kept flexible at import stage to avoid losing data before validation.

## 3. Data Quality Checks

The data was checked for missing CustomerID values, missing product descriptions, negative or zero quantities, cancelled invoices, and valid sales row count.

## 4. Cleaning View

`vw_retail_clean` converted raw date and price fields, calculated revenue, and flagged cancelled invoices.

## 5. Valid Sales View

`vw_retail_valid_sales` filtered records used in the main sales dashboard.

## 6. Analysis Views

Reporting-ready SQL views were created for KPI, monthly sales, product performance, customer performance, country performance, cancellation analysis, and data quality summary.

## 7. Power BI Dashboard

Power BI loaded the SQL reporting views and used them to build the three-page dashboard.

## 8. Business Interpretation

The final case study explains the findings, recommendations, scope, and limitations of the analysis.

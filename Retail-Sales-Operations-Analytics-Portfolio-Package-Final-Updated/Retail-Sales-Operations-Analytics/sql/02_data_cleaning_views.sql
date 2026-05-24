/*
Retail Sales & Operations Analytics
02_data_cleaning_views.sql

Purpose:
Create the cleaning layer and valid sales layer.
*/

USE Retail_Analytics_Portfolio;
GO

DROP VIEW IF EXISTS dbo.vw_retail_valid_sales;
GO

DROP VIEW IF EXISTS dbo.vw_retail_clean;
GO

CREATE VIEW dbo.vw_retail_clean AS
SELECT
    InvoiceNo AS invoice_no,
    StockCode AS stock_code,
    NULLIF(LTRIM(RTRIM(Description)), '') AS product_description,
    Quantity AS quantity,
    TRY_CONVERT(datetime2, InvoiceDate, 103) AS invoice_date,
    TRY_CONVERT(decimal(18,2), REPLACE(UnitPrice, ',', '.')) AS unit_price,
    NULLIF(LTRIM(RTRIM(CustomerID)), '') AS customer_id,
    Country AS country,
    CASE 
        WHEN InvoiceNo LIKE 'C%' THEN 1 
        ELSE 0 
    END AS is_cancelled,
    Quantity * TRY_CONVERT(decimal(18,2), REPLACE(UnitPrice, ',', '.')) AS revenue
FROM dbo.Online_Retail_Raw;
GO

CREATE VIEW dbo.vw_retail_valid_sales AS
SELECT
    invoice_no,
    stock_code,
    product_description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    revenue
FROM dbo.vw_retail_clean
WHERE is_cancelled = 0
  AND quantity > 0
  AND unit_price > 0
  AND invoice_date IS NOT NULL
  AND product_description IS NOT NULL;
GO

SELECT COUNT(*) AS valid_sales_rows
FROM dbo.vw_retail_valid_sales;
GO

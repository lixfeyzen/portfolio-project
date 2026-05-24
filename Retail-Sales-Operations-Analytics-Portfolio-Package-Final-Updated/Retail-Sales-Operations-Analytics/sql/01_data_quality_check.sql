/*
Retail Sales & Operations Analytics
01_data_quality_check.sql

Purpose:
Profile the raw dataset before creating dashboard-ready views.
*/

USE Retail_Analytics_Portfolio;
GO

SELECT
    COUNT(*) AS total_rows
FROM dbo.Online_Retail_Raw;
GO

SELECT TOP 10 *
FROM dbo.Online_Retail_Raw;
GO

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT InvoiceNo) AS unique_invoices,
    COUNT(DISTINCT StockCode) AS unique_products,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT Country) AS unique_countries
FROM dbo.Online_Retail_Raw;
GO

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN CustomerID IS NULL OR LTRIM(RTRIM(CustomerID)) = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN Description IS NULL OR LTRIM(RTRIM(Description)) = '' THEN 1 ELSE 0 END) AS missing_description,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS negative_or_zero_quantity,
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS cancelled_invoices
FROM dbo.Online_Retail_Raw;
GO

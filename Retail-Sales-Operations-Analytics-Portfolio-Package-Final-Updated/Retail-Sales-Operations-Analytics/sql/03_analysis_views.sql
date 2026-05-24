/*
Retail Sales & Operations Analytics
03_analysis_views.sql

Purpose:
Create dashboard-ready analysis views for Power BI.
*/

USE Retail_Analytics_Portfolio;
GO

DROP VIEW IF EXISTS dbo.vw_executive_kpi;
DROP VIEW IF EXISTS dbo.vw_monthly_sales;
DROP VIEW IF EXISTS dbo.vw_product_performance;
DROP VIEW IF EXISTS dbo.vw_product_performance_clean;
DROP VIEW IF EXISTS dbo.vw_customer_performance;
DROP VIEW IF EXISTS dbo.vw_country_performance;
DROP VIEW IF EXISTS dbo.vw_cancellation_analysis;
DROP VIEW IF EXISTS dbo.vw_data_quality_summary;
GO

CREATE VIEW dbo.vw_executive_kpi AS
SELECT
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_quantity_sold,
    SUM(revenue) AS total_revenue,
    CAST(
        SUM(revenue) / NULLIF(COUNT(DISTINCT invoice_no), 0)
        AS decimal(18,2)
    ) AS avg_order_value
FROM dbo.vw_retail_valid_sales;
GO

CREATE VIEW dbo.vw_monthly_sales AS
SELECT
    FORMAT(invoice_date, 'yyyy-MM') AS sales_month,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    SUM(revenue) AS total_revenue
FROM dbo.vw_retail_valid_sales
GROUP BY FORMAT(invoice_date, 'yyyy-MM');
GO

CREATE VIEW dbo.vw_product_performance AS
SELECT
    stock_code,
    product_description,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    SUM(revenue) AS total_revenue
FROM dbo.vw_retail_valid_sales
GROUP BY stock_code, product_description;
GO

CREATE VIEW dbo.vw_product_performance_clean AS
SELECT
    stock_code,
    product_description,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    SUM(revenue) AS total_revenue
FROM dbo.vw_retail_valid_sales
WHERE stock_code NOT IN (
    'DOT',
    'POST',
    'M',
    'D',
    'C2',
    'BANK CHARGES',
    'AMAZONFEE',
    'CRUK'
)
AND product_description NOT LIKE '%POSTAGE%'
AND product_description NOT LIKE '%CARRIAGE%'
AND product_description NOT LIKE '%DISCOUNT%'
AND product_description NOT LIKE '%MANUAL%'
AND product_description NOT LIKE '%BANK CHARGES%'
GROUP BY stock_code, product_description;
GO

CREATE VIEW dbo.vw_customer_performance AS
SELECT
    customer_id,
    country,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_quantity_bought,
    SUM(revenue) AS total_revenue
FROM dbo.vw_retail_valid_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id, country;
GO

CREATE VIEW dbo.vw_country_performance AS
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_quantity_sold,
    SUM(revenue) AS total_revenue,
    CAST(
        SUM(revenue) / NULLIF(COUNT(DISTINCT invoice_no), 0)
        AS decimal(18,2)
    ) AS avg_order_value
FROM dbo.vw_retail_valid_sales
GROUP BY country;
GO

CREATE VIEW dbo.vw_cancellation_analysis AS
SELECT
    FORMAT(invoice_date, 'yyyy-MM') AS sales_month,
    country,
    COUNT(DISTINCT invoice_no) AS cancelled_orders,
    SUM(ABS(quantity)) AS cancelled_quantity,
    SUM(ABS(revenue)) AS cancelled_revenue_impact
FROM dbo.vw_retail_clean
WHERE is_cancelled = 1
  AND invoice_date IS NOT NULL
  AND unit_price > 0
GROUP BY FORMAT(invoice_date, 'yyyy-MM'), country;
GO

CREATE VIEW dbo.vw_data_quality_summary AS
SELECT
    'Raw Data Rows' AS metric,
    COUNT(*) AS value
FROM dbo.Online_Retail_Raw

UNION ALL

SELECT
    'Missing Customer ID',
    SUM(CASE WHEN CustomerID IS NULL OR LTRIM(RTRIM(CustomerID)) = '' THEN 1 ELSE 0 END)
FROM dbo.Online_Retail_Raw

UNION ALL

SELECT
    'Missing Description',
    SUM(CASE WHEN Description IS NULL OR LTRIM(RTRIM(Description)) = '' THEN 1 ELSE 0 END)
FROM dbo.Online_Retail_Raw

UNION ALL

SELECT
    'Negative or Zero Quantity',
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END)
FROM dbo.Online_Retail_Raw

UNION ALL

SELECT
    'Cancelled Invoices',
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END)
FROM dbo.Online_Retail_Raw

UNION ALL

SELECT
    'Valid Sales Rows',
    COUNT(*)
FROM dbo.vw_retail_valid_sales;
GO

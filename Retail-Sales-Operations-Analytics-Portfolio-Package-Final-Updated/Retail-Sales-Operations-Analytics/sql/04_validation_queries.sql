/*
Retail Sales & Operations Analytics
04_validation_queries.sql

Purpose:
Validate key outputs used in the Power BI dashboard.
*/

USE Retail_Analytics_Portfolio;
GO

SELECT *
FROM dbo.vw_executive_kpi;
GO

SELECT *
FROM dbo.vw_monthly_sales
ORDER BY sales_month;
GO

SELECT TOP 10 *
FROM dbo.vw_product_performance_clean
ORDER BY total_revenue DESC;
GO

SELECT TOP 10 *
FROM dbo.vw_customer_performance
ORDER BY total_revenue DESC;
GO

SELECT TOP 10 *
FROM dbo.vw_country_performance
ORDER BY total_revenue DESC;
GO

SELECT TOP 10 *
FROM dbo.vw_cancellation_analysis
ORDER BY cancelled_revenue_impact DESC;
GO

SELECT *
FROM dbo.vw_data_quality_summary;
GO

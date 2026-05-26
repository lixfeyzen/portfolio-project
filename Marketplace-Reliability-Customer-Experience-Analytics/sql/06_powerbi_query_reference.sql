/*
Marketplace Reliability & Customer Experience Analytics
Script 06 - Power BI query reference

Use these views as the main SQL Server sources in Power BI.
Load only the views needed for the dashboard version you are building.
*/

USE Marketplace_Analytics;
GO

SELECT * FROM dbo.vw_marketplace_kpi;
SELECT * FROM dbo.vw_delivery_performance_order_level;
SELECT * FROM dbo.vw_delivery_performance_item_level;
SELECT * FROM dbo.vw_customer_review_analysis;
SELECT * FROM dbo.vw_seller_performance;
SELECT * FROM dbo.vw_product_category_performance;
SELECT * FROM dbo.vw_freight_analysis;
SELECT * FROM dbo.vw_payment_analysis;
SELECT * FROM dbo.vw_data_quality_summary;


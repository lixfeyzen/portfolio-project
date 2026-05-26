/*
Marketplace Reliability & Customer Experience Analytics
Script 01 - Data import checks

Purpose:
- Confirm raw CSV files were imported into the expected raw tables.
- Surface basic domain values before creating reporting views.
*/

USE Marketplace_Analytics;
GO

-- Row count per raw table.
SELECT 'raw_orders' AS table_name, COUNT(*) AS row_count FROM dbo.raw_orders
UNION ALL
SELECT 'raw_order_items', COUNT(*) FROM dbo.raw_order_items
UNION ALL
SELECT 'raw_order_payments', COUNT(*) FROM dbo.raw_order_payments
UNION ALL
SELECT 'raw_order_reviews', COUNT(*) FROM dbo.raw_order_reviews
UNION ALL
SELECT 'raw_customers', COUNT(*) FROM dbo.raw_customers
UNION ALL
SELECT 'raw_sellers', COUNT(*) FROM dbo.raw_sellers
UNION ALL
SELECT 'raw_products', COUNT(*) FROM dbo.raw_products
UNION ALL
SELECT 'raw_geolocation', COUNT(*) FROM dbo.raw_geolocation
UNION ALL
SELECT 'raw_category_translation', COUNT(*) FROM dbo.raw_category_translation;

-- Distinct order status values.
SELECT
    order_status,
    COUNT(*) AS order_count
FROM dbo.raw_orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Purchase date range.
SELECT
    MIN(TRY_CONVERT(datetime2(0), order_purchase_timestamp)) AS min_purchase_timestamp,
    MAX(TRY_CONVERT(datetime2(0), order_purchase_timestamp)) AS max_purchase_timestamp
FROM dbo.raw_orders;

-- Distinct payment types.
SELECT
    payment_type,
    COUNT(*) AS payment_record_count
FROM dbo.raw_order_payments
GROUP BY payment_type
ORDER BY payment_record_count DESC;

-- Distinct review scores.
SELECT
    review_score,
    COUNT(*) AS review_record_count
FROM dbo.raw_order_reviews
GROUP BY review_score
ORDER BY TRY_CONVERT(int, review_score);

-- Distinct customer states.
SELECT
    customer_state,
    COUNT(*) AS customer_row_count
FROM dbo.raw_customers
GROUP BY customer_state
ORDER BY customer_state;

-- Distinct seller states.
SELECT
    seller_state,
    COUNT(*) AS seller_row_count
FROM dbo.raw_sellers
GROUP BY seller_state
ORDER BY seller_state;

-- Distinct product categories from the products table.
SELECT
    COALESCE(NULLIF(product_category_name, ''), 'Unknown') AS product_category_name,
    COUNT(*) AS product_count
FROM dbo.raw_products
GROUP BY COALESCE(NULLIF(product_category_name, ''), 'Unknown')
ORDER BY product_count DESC;

-- Distinct order coverage by source table.
SELECT 'raw_orders' AS table_name, COUNT(DISTINCT order_id) AS distinct_orders FROM dbo.raw_orders
UNION ALL
SELECT 'raw_order_items', COUNT(DISTINCT order_id) FROM dbo.raw_order_items
UNION ALL
SELECT 'raw_order_payments', COUNT(DISTINCT order_id) FROM dbo.raw_order_payments
UNION ALL
SELECT 'raw_order_reviews', COUNT(DISTINCT order_id) FROM dbo.raw_order_reviews;

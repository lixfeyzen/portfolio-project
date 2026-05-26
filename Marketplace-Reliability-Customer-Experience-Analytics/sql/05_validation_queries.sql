/*
Marketplace Reliability & Customer Experience Analytics
Script 05 - Validation queries

Purpose:
- Validate important totals before building Power BI visuals.
- Compare SQL outputs with Power BI totals after loading views.
*/

USE Marketplace_Analytics;
GO

-- Validates the total number of unique orders in the orders table.
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM dbo.vw_orders_clean;

-- Validates the number of delivered orders used in delivery reliability metrics.
SELECT
    COUNT(DISTINCT order_id) AS total_delivered_orders
FROM dbo.vw_delivery_performance_order_level;

-- Validates product revenue definition: sum of order item price.
SELECT
    SUM(price) AS total_product_revenue
FROM dbo.vw_order_items_enriched;

-- Validates freight value definition: sum of order item freight_value.
SELECT
    SUM(freight_value) AS total_freight_value
FROM dbo.vw_order_items_enriched;

-- Validates total payment value from order-level payment aggregation.
SELECT
    SUM(total_payment_value) AS total_payment_value
FROM dbo.vw_payment_order_level;

-- Reviews freight edge cases separately.
-- Negative freight is invalid; zero freight may represent free shipping or no freight charged.
SELECT
    SUM(CASE WHEN freight_value < 0 THEN 1 ELSE 0 END) AS negative_freight_rows,
    SUM(CASE WHEN freight_value = 0 THEN 1 ELSE 0 END) AS zero_freight_rows
FROM dbo.raw_order_items;

-- Reviews payment edge cases separately.
-- Negative payment values are invalid; zero payment rows require review and are not automatically invalid.
SELECT
    SUM(CASE WHEN payment_value < 0 THEN 1 ELSE 0 END) AS negative_payment_value_rows,
    SUM(CASE WHEN payment_value = 0 THEN 1 ELSE 0 END) AS zero_payment_value_rows
FROM dbo.raw_order_payments;

-- Validates customer definition: customer_unique_id.
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM dbo.raw_customers;

-- Validates seller count from seller master data.
SELECT
    COUNT(DISTINCT seller_id) AS total_sellers
FROM dbo.raw_sellers;

-- Validates average review score after order-level review aggregation.
SELECT
    AVG(avg_review_score) AS average_review_score
FROM dbo.vw_review_order_level;

-- Validates late delivery rate for delivered orders.
SELECT
    CAST(SUM(CAST(late_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS late_delivery_rate
FROM dbo.vw_delivery_performance_order_level;

-- Validates on-time delivery rate for delivered orders.
SELECT
    CAST(SUM(CAST(on_time_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS on_time_delivery_rate
FROM dbo.vw_delivery_performance_order_level;

-- Reviews the top sellers by product revenue.
SELECT TOP (10)
    seller_id,
    seller_state,
    total_orders,
    total_items,
    total_revenue,
    late_delivery_rate,
    avg_review_score,
    seller_segment
FROM dbo.vw_seller_performance
ORDER BY total_revenue DESC;

-- Reviews the top product categories by product revenue.
SELECT TOP (10)
    product_category,
    total_orders,
    total_items,
    total_revenue,
    late_delivery_rate,
    avg_review_score,
    avg_freight_to_price_ratio
FROM dbo.vw_product_category_performance
ORDER BY total_revenue DESC;

-- Checks whether late delivery appears associated with lower review scores.
-- This is descriptive only and does not establish causality.
SELECT
    delivery_status,
    COUNT(*) AS delivered_orders,
    AVG(avg_review_score) AS avg_review_score,
    AVG(CAST(delay_days AS decimal(18, 2))) AS avg_delay_days
FROM dbo.vw_customer_review_analysis
GROUP BY delivery_status
ORDER BY delivery_status;

-- Compares total payment value with product revenue plus freight value.
-- Values may differ due to payment adjustments, vouchers, missing records, or data coverage.
WITH item_totals AS (
    SELECT
        SUM(price) AS total_product_revenue,
        SUM(freight_value) AS total_freight_value,
        SUM(price + freight_value) AS product_plus_freight_value
    FROM dbo.vw_order_items_enriched
),
payment_totals AS (
    SELECT
        SUM(total_payment_value) AS total_payment_value
    FROM dbo.vw_payment_order_level
)
SELECT
    i.total_product_revenue,
    i.total_freight_value,
    i.product_plus_freight_value,
    p.total_payment_value,
    p.total_payment_value - i.product_plus_freight_value AS payment_minus_product_plus_freight
FROM item_totals AS i
CROSS JOIN payment_totals AS p;

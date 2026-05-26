/*
Marketplace Reliability & Customer Experience Analytics
Script 03 - Cleaning views

Purpose:
- Convert raw string data into typed reporting fields.
- Keep row grain explicit.
*/

USE Marketplace_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_orders_clean AS
/*
Grain: one row per order_id.
*/
WITH typed_orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        TRY_CONVERT(datetime2(0), order_purchase_timestamp) AS purchase_timestamp,
        TRY_CONVERT(datetime2(0), order_approved_at) AS approved_timestamp,
        TRY_CONVERT(datetime2(0), order_delivered_carrier_date) AS carrier_delivered_timestamp,
        TRY_CONVERT(datetime2(0), order_delivered_customer_date) AS customer_delivered_timestamp,
        TRY_CONVERT(datetime2(0), order_estimated_delivery_date) AS estimated_delivery_timestamp
    FROM dbo.raw_orders
)
SELECT
    order_id,
    customer_id,
    order_status,
    purchase_timestamp,
    approved_timestamp,
    carrier_delivered_timestamp,
    customer_delivered_timestamp,
    estimated_delivery_timestamp,
    CASE
        WHEN purchase_timestamp IS NULL THEN NULL
        ELSE CONVERT(date, DATEFROMPARTS(YEAR(purchase_timestamp), MONTH(purchase_timestamp), 1))
    END AS purchase_month,
    CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END AS is_delivered,
    CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END AS is_cancelled,
    CASE WHEN order_status = 'unavailable' THEN 1 ELSE 0 END AS is_unavailable,
    CASE WHEN customer_delivered_timestamp IS NOT NULL THEN 1 ELSE 0 END AS has_customer_delivery_date,
    CASE WHEN estimated_delivery_timestamp IS NOT NULL THEN 1 ELSE 0 END AS has_estimated_delivery_date
FROM typed_orders;
GO

CREATE OR ALTER VIEW dbo.vw_order_items_enriched AS
/*
Grain: one row per order item.
Revenue and freight metrics should be summed from this item-level view.
*/
WITH typed_items AS (
    SELECT
        oi.order_id,
        TRY_CONVERT(int, oi.order_item_id) AS order_item_id,
        oi.product_id,
        oi.seller_id,
        TRY_CONVERT(datetime2(0), oi.shipping_limit_date) AS shipping_limit_timestamp,
        TRY_CONVERT(decimal(18, 2), oi.price) AS price,
        TRY_CONVERT(decimal(18, 2), oi.freight_value) AS freight_value
    FROM dbo.raw_order_items AS oi
)
SELECT
    ti.order_id,
    ti.order_item_id,
    ti.product_id,
    ti.seller_id,
    s.seller_city,
    s.seller_state,
    p.product_category_name AS product_category_original,
    COALESCE(
        NULLIF(t.product_category_name_english, ''),
        NULLIF(p.product_category_name, ''),
        'Unknown'
    ) AS product_category,
    ti.price,
    ti.freight_value,
    CAST(ti.freight_value / NULLIF(ti.price, 0) AS decimal(18, 4)) AS freight_to_price_ratio,
    TRY_CONVERT(int, p.product_weight_g) AS product_weight_g,
    TRY_CONVERT(int, p.product_length_cm) AS product_length_cm,
    TRY_CONVERT(int, p.product_height_cm) AS product_height_cm,
    TRY_CONVERT(int, p.product_width_cm) AS product_width_cm
FROM typed_items AS ti
LEFT JOIN dbo.raw_products AS p
    ON p.product_id = ti.product_id
LEFT JOIN dbo.raw_category_translation AS t
    ON t.product_category_name = p.product_category_name
LEFT JOIN dbo.raw_sellers AS s
    ON s.seller_id = ti.seller_id;
GO


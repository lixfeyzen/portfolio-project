/*
Marketplace Reliability & Customer Experience Analytics
Script 04 - Analysis views

Purpose:
- Build reporting views for SQL validation and Power BI.
- Keep order-level, item-level, review, payment, seller, and category grains separate.

Important grain rule:
- Do not join item-level revenue directly to payment records without pre-aggregation.
- Use item-level views for price and freight.
- Use order-level views for delivery and review comparison.
*/

USE Marketplace_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_delivery_performance_order_level AS
/*
Grain: one row per delivered order.
Scope: delivered orders with a valid customer delivery timestamp.
*/
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.purchase_timestamp,
    o.customer_delivered_timestamp,
    o.estimated_delivery_timestamp,
    CASE
        WHEN o.purchase_timestamp IS NULL
          OR o.customer_delivered_timestamp IS NULL THEN NULL
        ELSE DATEDIFF(DAY, o.purchase_timestamp, o.customer_delivered_timestamp)
    END AS delivery_days,
    CASE
        WHEN o.estimated_delivery_timestamp IS NULL
          OR o.customer_delivered_timestamp IS NULL THEN NULL
        ELSE DATEDIFF(DAY, o.estimated_delivery_timestamp, o.customer_delivered_timestamp)
    END AS delay_days,
    CASE
        WHEN o.customer_delivered_timestamp IS NULL
          OR o.estimated_delivery_timestamp IS NULL THEN 'Unknown'
        WHEN o.customer_delivered_timestamp > o.estimated_delivery_timestamp THEN 'Late'
        WHEN o.customer_delivered_timestamp <= o.estimated_delivery_timestamp THEN 'On Time'
        ELSE 'Unknown'
    END AS delivery_status,
    CASE
        WHEN o.customer_delivered_timestamp > o.estimated_delivery_timestamp THEN 1
        ELSE 0
    END AS late_order_flag,
    CASE
        WHEN o.customer_delivered_timestamp <= o.estimated_delivery_timestamp THEN 1
        ELSE 0
    END AS on_time_order_flag,
    o.purchase_month
FROM dbo.vw_orders_clean AS o
LEFT JOIN dbo.raw_customers AS c
    ON c.customer_id = o.customer_id
WHERE o.is_delivered = 1
  AND o.customer_delivered_timestamp IS NOT NULL;
GO

CREATE OR ALTER VIEW dbo.vw_delivery_performance_item_level AS
/*
Grain: one row per delivered order item.
Purpose: seller, product category, revenue, freight, and delivery analysis.
*/
SELECT
    d.order_id,
    d.customer_id,
    d.customer_unique_id,
    d.customer_city,
    d.customer_state,
    d.order_status,
    d.purchase_timestamp,
    d.customer_delivered_timestamp,
    d.estimated_delivery_timestamp,
    d.delivery_days,
    d.delay_days,
    d.delivery_status,
    d.late_order_flag,
    d.on_time_order_flag,
    d.purchase_month,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    i.seller_city,
    i.seller_state,
    i.product_category_original,
    i.product_category,
    i.price,
    i.freight_value,
    i.freight_to_price_ratio,
    i.product_weight_g,
    i.product_length_cm,
    i.product_height_cm,
    i.product_width_cm
FROM dbo.vw_delivery_performance_order_level AS d
INNER JOIN dbo.vw_order_items_enriched AS i
    ON i.order_id = d.order_id;
GO

CREATE OR ALTER VIEW dbo.vw_review_order_level AS
/*
Grain: one row per order_id.
Assumption: when multiple reviews exist for one order, review score is averaged at order level.
*/
SELECT
    order_id,
    CAST(AVG(TRY_CONVERT(decimal(10, 2), review_score)) AS decimal(10, 2)) AS avg_review_score,
    COUNT(*) AS review_count,
    MIN(TRY_CONVERT(datetime2(0), review_creation_date)) AS first_review_creation_date,
    MAX(TRY_CONVERT(datetime2(0), review_answer_timestamp)) AS last_review_answer_timestamp
FROM dbo.raw_order_reviews
GROUP BY order_id;
GO

CREATE OR ALTER VIEW dbo.vw_customer_review_analysis AS
/*
Grain: one row per delivered order with review data when available.
Scope: review score is a customer experience proxy, not proof of causality.
*/
SELECT
    d.order_id,
    d.customer_unique_id,
    d.customer_state,
    d.purchase_month,
    d.delivery_status,
    d.late_order_flag,
    d.delay_days,
    d.delivery_days,
    r.avg_review_score,
    r.review_count
FROM dbo.vw_delivery_performance_order_level AS d
LEFT JOIN dbo.vw_review_order_level AS r
    ON r.order_id = d.order_id;
GO

CREATE OR ALTER VIEW dbo.vw_seller_performance AS
/*
Grain: one row per seller_id.
Scope: delivered order items only.

Segment logic:
- High revenue means seller revenue is at or above the average seller revenue.
- High late delivery risk means seller late delivery rate is above the average seller late delivery rate.
- Strong seller: high revenue and low or average late delivery rate.
- Operational risk seller: high revenue and above-average late delivery rate.
- Potential growth seller: lower revenue, strong review score, and low or average late delivery rate.
- Low priority seller: lower revenue and above-average late delivery rate.
*/
WITH seller_base AS (
    SELECT
        i.seller_id,
        i.seller_state,
        i.order_id,
        i.order_item_id,
        i.price,
        i.freight_value,
        i.freight_to_price_ratio,
        i.delivery_days,
        i.delay_days,
        i.late_order_flag,
        i.on_time_order_flag,
        r.avg_review_score
    FROM dbo.vw_delivery_performance_item_level AS i
    LEFT JOIN dbo.vw_review_order_level AS r
        ON r.order_id = i.order_id
),
seller_metrics AS (
    SELECT
        seller_id,
        MAX(seller_state) AS seller_state,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(*) AS total_items,
        SUM(price) AS total_revenue,
        SUM(freight_value) AS total_freight_value,
        CAST(AVG(price) AS decimal(18, 2)) AS avg_price,
        CAST(AVG(freight_value) AS decimal(18, 2)) AS avg_freight_value,
        CAST(AVG(freight_to_price_ratio) AS decimal(18, 4)) AS avg_freight_to_price_ratio,
        CAST(AVG(CAST(delivery_days AS decimal(18, 2))) AS decimal(18, 2)) AS avg_delivery_days,
        CAST(AVG(CAST(delay_days AS decimal(18, 2))) AS decimal(18, 2)) AS avg_delay_days,
        CAST(SUM(CAST(late_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS late_delivery_rate,
        CAST(SUM(CAST(on_time_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS on_time_delivery_rate,
        CAST(AVG(avg_review_score) AS decimal(10, 2)) AS avg_review_score
    FROM seller_base
    GROUP BY seller_id
),
overall AS (
    SELECT
        AVG(total_revenue) AS avg_seller_revenue,
        AVG(late_delivery_rate) AS avg_seller_late_delivery_rate,
        AVG(avg_review_score) AS avg_seller_review_score
    FROM seller_metrics
)
SELECT
    sm.seller_id,
    sm.seller_state,
    sm.total_orders,
    sm.total_items,
    sm.total_revenue,
    sm.total_freight_value,
    sm.avg_price,
    sm.avg_freight_value,
    sm.avg_freight_to_price_ratio,
    sm.avg_delivery_days,
    sm.avg_delay_days,
    sm.late_delivery_rate,
    sm.on_time_delivery_rate,
    sm.avg_review_score,
    CASE
        WHEN sm.total_revenue >= o.avg_seller_revenue
         AND sm.late_delivery_rate <= o.avg_seller_late_delivery_rate
            THEN 'Strong seller'
        WHEN sm.total_revenue >= o.avg_seller_revenue
         AND sm.late_delivery_rate > o.avg_seller_late_delivery_rate
            THEN 'Operational risk seller'
        WHEN sm.total_revenue < o.avg_seller_revenue
         AND sm.late_delivery_rate <= o.avg_seller_late_delivery_rate
         AND sm.avg_review_score >= o.avg_seller_review_score
            THEN 'Potential growth seller'
        WHEN sm.total_revenue < o.avg_seller_revenue
         AND sm.late_delivery_rate > o.avg_seller_late_delivery_rate
            THEN 'Low priority seller'
        ELSE 'Monitor'
    END AS seller_segment
FROM seller_metrics AS sm
CROSS JOIN overall AS o;
GO

CREATE OR ALTER VIEW dbo.vw_product_category_performance AS
/*
Grain: one row per product_category.
Scope: delivered order items only.
*/
WITH category_base AS (
    SELECT
        i.product_category,
        i.order_id,
        i.order_item_id,
        i.price,
        i.freight_value,
        i.freight_to_price_ratio,
        i.delivery_days,
        i.delay_days,
        i.late_order_flag,
        i.on_time_order_flag,
        r.avg_review_score
    FROM dbo.vw_delivery_performance_item_level AS i
    LEFT JOIN dbo.vw_review_order_level AS r
        ON r.order_id = i.order_id
)
SELECT
    product_category,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS total_items,
    SUM(price) AS total_revenue,
    SUM(freight_value) AS total_freight_value,
    CAST(AVG(price) AS decimal(18, 2)) AS avg_price,
    CAST(AVG(freight_value) AS decimal(18, 2)) AS avg_freight_value,
    CAST(AVG(freight_to_price_ratio) AS decimal(18, 4)) AS avg_freight_to_price_ratio,
    CAST(AVG(CAST(delivery_days AS decimal(18, 2))) AS decimal(18, 2)) AS avg_delivery_days,
    CAST(AVG(CAST(delay_days AS decimal(18, 2))) AS decimal(18, 2)) AS avg_delay_days,
    CAST(SUM(CAST(late_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS late_delivery_rate,
    CAST(SUM(CAST(on_time_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS on_time_delivery_rate,
    CAST(AVG(avg_review_score) AS decimal(10, 2)) AS avg_review_score
FROM category_base
GROUP BY product_category;
GO

CREATE OR ALTER VIEW dbo.vw_freight_analysis AS
/*
Grain: one row per delivered order item.
Purpose: analyze freight burden by category, seller region, customer region, and experience proxy.
*/
SELECT
    i.order_id,
    i.order_item_id,
    i.product_category,
    i.seller_state,
    i.customer_state,
    i.price,
    i.freight_value,
    i.freight_to_price_ratio,
    i.delivery_status,
    i.delay_days,
    r.avg_review_score
FROM dbo.vw_delivery_performance_item_level AS i
LEFT JOIN dbo.vw_review_order_level AS r
    ON r.order_id = i.order_id;
GO

CREATE OR ALTER VIEW dbo.vw_payment_analysis AS
/*
Grain: one row per payment_type.
Scope: payment records. Payment value is not mixed with product revenue.
*/
SELECT
    COALESCE(NULLIF(payment_type, ''), 'Unknown') AS payment_type,
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(TRY_CONVERT(decimal(18, 2), payment_value)) AS total_payment_value,
    CAST(AVG(TRY_CONVERT(decimal(18, 2), payment_value)) AS decimal(18, 2)) AS avg_payment_value,
    CAST(AVG(TRY_CONVERT(decimal(18, 2), payment_installments)) AS decimal(18, 2)) AS avg_installments
FROM dbo.raw_order_payments
GROUP BY COALESCE(NULLIF(payment_type, ''), 'Unknown');
GO

CREATE OR ALTER VIEW dbo.vw_payment_order_level AS
/*
Grain: one row per order_id.
Purpose: reconcile payment records before joining to order-level views.
*/
WITH cleaned_payments AS (
    SELECT
        order_id,
        COALESCE(NULLIF(payment_type, ''), 'Unknown') AS payment_type,
        TRY_CONVERT(int, payment_sequential) AS payment_sequential,
        TRY_CONVERT(int, payment_installments) AS payment_installments,
        TRY_CONVERT(decimal(18, 2), payment_value) AS payment_value
    FROM dbo.raw_order_payments
),
ranked_payments AS (
    SELECT
        order_id,
        payment_type,
        payment_installments,
        payment_value,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY payment_value DESC, payment_sequential ASC
        ) AS payment_rank
    FROM cleaned_payments
)
SELECT
    order_id,
    SUM(payment_value) AS total_payment_value,
    COUNT(*) AS payment_record_count,
    MAX(CASE WHEN payment_rank = 1 THEN payment_type END) AS primary_payment_type,
    MAX(payment_installments) AS max_installments
FROM ranked_payments
GROUP BY order_id;
GO

CREATE OR ALTER VIEW dbo.vw_marketplace_kpi AS
/*
Grain: single row.
Purpose: high-level KPI cards for the marketplace dashboard.
*/
WITH orders_all AS (
    SELECT COUNT(DISTINCT order_id) AS total_orders
    FROM dbo.vw_orders_clean
),
delivery AS (
    SELECT
        COUNT(DISTINCT order_id) AS delivered_orders,
        CAST(SUM(CAST(on_time_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS on_time_delivery_rate,
        CAST(SUM(CAST(late_order_flag AS decimal(18, 4))) / NULLIF(COUNT(*), 0) AS decimal(18, 4)) AS late_delivery_rate,
        CAST(AVG(CAST(delivery_days AS decimal(18, 2))) AS decimal(18, 2)) AS avg_delivery_days,
        CAST(AVG(CAST(delay_days AS decimal(18, 2))) AS decimal(18, 2)) AS avg_delay_days
    FROM dbo.vw_delivery_performance_order_level
),
items AS (
    SELECT
        SUM(price) AS total_revenue,
        SUM(freight_value) AS total_freight_value
    FROM dbo.vw_order_items_enriched
),
customers AS (
    SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
    FROM dbo.raw_customers
),
sellers AS (
    SELECT COUNT(DISTINCT seller_id) AS total_sellers
    FROM dbo.raw_sellers
),
reviews AS (
    SELECT CAST(AVG(avg_review_score) AS decimal(10, 2)) AS avg_review_score
    FROM dbo.vw_review_order_level
),
payments AS (
    SELECT SUM(total_payment_value) AS total_payment_value
    FROM dbo.vw_payment_order_level
)
SELECT
    oa.total_orders,
    d.delivered_orders,
    i.total_revenue,
    i.total_freight_value,
    c.total_customers,
    s.total_sellers,
    r.avg_review_score,
    d.on_time_delivery_rate,
    d.late_delivery_rate,
    d.avg_delivery_days,
    d.avg_delay_days,
    p.total_payment_value
FROM orders_all AS oa
CROSS JOIN delivery AS d
CROSS JOIN items AS i
CROSS JOIN customers AS c
CROSS JOIN sellers AS s
CROSS JOIN reviews AS r
CROSS JOIN payments AS p;
GO

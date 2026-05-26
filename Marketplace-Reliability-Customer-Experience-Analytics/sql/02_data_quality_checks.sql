/*
Marketplace Reliability & Customer Experience Analytics
Script 02 - Data quality checks

Purpose:
- Identify data quality issues that can affect interpretation.
- Create a summary view that Power BI can load.

Important:
- These checks are diagnostic. They do not modify source data.
*/

USE Marketplace_Analytics;
GO

-- Missing delivered customer date for delivered orders.
SELECT
    COUNT(*) AS delivered_orders_missing_customer_delivery_date
FROM dbo.raw_orders
WHERE order_status = 'delivered'
  AND NULLIF(order_delivered_customer_date, '') IS NULL;

-- Missing estimated delivery date.
SELECT
    COUNT(*) AS orders_missing_estimated_delivery_date
FROM dbo.raw_orders
WHERE NULLIF(order_estimated_delivery_date, '') IS NULL;

-- Missing approved date.
SELECT
    COUNT(*) AS orders_missing_approved_date
FROM dbo.raw_orders
WHERE NULLIF(order_approved_at, '') IS NULL;

-- Cancelled orders.
SELECT
    COUNT(*) AS cancelled_orders
FROM dbo.raw_orders
WHERE order_status = 'canceled';

-- Unavailable orders.
SELECT
    COUNT(*) AS unavailable_orders
FROM dbo.raw_orders
WHERE order_status = 'unavailable';

-- Orders without payment.
SELECT
    COUNT(*) AS orders_without_payment
FROM dbo.raw_orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.raw_order_payments AS p
    WHERE p.order_id = o.order_id
);

-- Orders without review.
SELECT
    COUNT(*) AS orders_without_review
FROM dbo.raw_orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.raw_order_reviews AS r
    WHERE r.order_id = o.order_id
);

-- Products without category.
SELECT
    COUNT(*) AS products_without_category
FROM dbo.raw_products
WHERE NULLIF(product_category_name, '') IS NULL;

-- Product categories without English translation.
SELECT
    COUNT(DISTINCT p.product_category_name) AS product_categories_missing_translation
FROM dbo.raw_products AS p
LEFT JOIN dbo.raw_category_translation AS t
    ON t.product_category_name = p.product_category_name
WHERE NULLIF(p.product_category_name, '') IS NOT NULL
  AND NULLIF(t.product_category_name_english, '') IS NULL;

-- Duplicate order_id in raw_orders.
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM dbo.raw_orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Zero or negative price.
SELECT
    COUNT(*) AS zero_or_negative_price_rows
FROM dbo.raw_order_items
WHERE TRY_CONVERT(decimal(18, 2), price) <= 0;

-- Negative freight is invalid and should be investigated.
SELECT
    COUNT(*) AS negative_freight_rows
FROM dbo.raw_order_items
WHERE TRY_CONVERT(decimal(18, 2), freight_value) < 0;

-- Zero freight may represent free shipping or no freight charged.
-- It requires review but is not automatically invalid.
SELECT
    COUNT(*) AS zero_freight_rows
FROM dbo.raw_order_items
WHERE TRY_CONVERT(decimal(18, 2), freight_value) = 0;

-- Invalid delivery sequence: customer delivery before purchase.
SELECT
    COUNT(*) AS delivered_before_purchase_rows
FROM dbo.raw_orders
WHERE TRY_CONVERT(datetime2(0), order_delivered_customer_date)
    < TRY_CONVERT(datetime2(0), order_purchase_timestamp);

-- Invalid delivery sequence: carrier delivery before approval.
SELECT
    COUNT(*) AS carrier_before_approval_rows
FROM dbo.raw_orders
WHERE TRY_CONVERT(datetime2(0), order_delivered_carrier_date)
    < TRY_CONVERT(datetime2(0), order_approved_at);

-- Invalid delivery sequence: customer delivery before carrier handoff.
SELECT
    COUNT(*) AS customer_delivery_before_carrier_rows
FROM dbo.raw_orders
WHERE TRY_CONVERT(datetime2(0), order_delivered_customer_date)
    < TRY_CONVERT(datetime2(0), order_delivered_carrier_date);

-- Review score outside expected range.
SELECT
    COUNT(*) AS review_scores_outside_1_to_5
FROM dbo.raw_order_reviews
WHERE TRY_CONVERT(int, review_score) NOT BETWEEN 1 AND 5;

-- Negative payment values are invalid and should be investigated.
SELECT
    COUNT(*) AS negative_payment_value_rows
FROM dbo.raw_order_payments
WHERE TRY_CONVERT(decimal(18, 2), payment_value) < 0;

-- Zero payment may reflect vouchers, adjustments, or other dataset behavior.
-- It requires review but is not automatically invalid.
SELECT
    COUNT(*) AS zero_payment_value_rows
FROM dbo.raw_order_payments
WHERE TRY_CONVERT(decimal(18, 2), payment_value) = 0;
GO

CREATE OR ALTER VIEW dbo.vw_data_quality_summary AS
SELECT
    CAST('Delivered orders missing customer delivery date' AS NVARCHAR(150)) AS metric,
    CAST(COUNT(*) AS BIGINT) AS value,
    CAST('Delivered-order reliability analysis requires a customer delivery timestamp.' AS NVARCHAR(300)) AS notes
FROM dbo.raw_orders
WHERE order_status = 'delivered'
  AND NULLIF(order_delivered_customer_date, '') IS NULL
UNION ALL
SELECT
    'Orders missing estimated delivery date',
    CAST(COUNT(*) AS BIGINT),
    'Late and on-time classification requires an estimated delivery timestamp.'
FROM dbo.raw_orders
WHERE NULLIF(order_estimated_delivery_date, '') IS NULL
UNION ALL
SELECT
    'Orders missing approved date',
    CAST(COUNT(*) AS BIGINT),
    'Approval timestamp is useful for checking fulfillment sequence quality.'
FROM dbo.raw_orders
WHERE NULLIF(order_approved_at, '') IS NULL
UNION ALL
SELECT
    'Cancelled orders',
    CAST(COUNT(*) AS BIGINT),
    'Cancelled orders are separated from delivery reliability metrics.'
FROM dbo.raw_orders
WHERE order_status = 'canceled'
UNION ALL
SELECT
    'Unavailable orders',
    CAST(COUNT(*) AS BIGINT),
    'Unavailable orders are separated from delivery reliability metrics.'
FROM dbo.raw_orders
WHERE order_status = 'unavailable'
UNION ALL
SELECT
    'Orders without payment',
    CAST(COUNT(*) AS BIGINT),
    'Payment coverage affects payment value analysis.'
FROM dbo.raw_orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.raw_order_payments AS p
    WHERE p.order_id = o.order_id
)
UNION ALL
SELECT
    'Orders without review',
    CAST(COUNT(*) AS BIGINT),
    'Missing reviews reduce review-score coverage.'
FROM dbo.raw_orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.raw_order_reviews AS r
    WHERE r.order_id = o.order_id
)
UNION ALL
SELECT
    'Products without category',
    CAST(COUNT(*) AS BIGINT),
    'Missing categories limit product category analysis.'
FROM dbo.raw_products
WHERE NULLIF(product_category_name, '') IS NULL
UNION ALL
SELECT
    'Product categories missing translation',
    CAST(COUNT(DISTINCT p.product_category_name) AS BIGINT),
    'Untranslated categories fall back to the original category name.'
FROM dbo.raw_products AS p
LEFT JOIN dbo.raw_category_translation AS t
    ON t.product_category_name = p.product_category_name
WHERE NULLIF(p.product_category_name, '') IS NOT NULL
  AND NULLIF(t.product_category_name_english, '') IS NULL
UNION ALL
SELECT
    'Duplicate order_id rows in raw_orders',
    CAST(COUNT(*) AS BIGINT),
    'raw_orders is expected to have one row per order_id.'
FROM (
    SELECT order_id
    FROM dbo.raw_orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicate_orders
UNION ALL
SELECT
    'Zero or negative price rows',
    CAST(COUNT(*) AS BIGINT),
    'Product revenue analysis expects positive item price values.'
FROM dbo.raw_order_items
WHERE TRY_CONVERT(decimal(18, 2), price) <= 0
UNION ALL
SELECT
    'Negative freight rows',
    CAST(COUNT(*) AS BIGINT),
    'Negative freight values are invalid and should be investigated.'
FROM dbo.raw_order_items
WHERE TRY_CONVERT(decimal(18, 2), freight_value) < 0
UNION ALL
SELECT
    'Zero freight rows',
    CAST(COUNT(*) AS BIGINT),
    'Zero freight may represent free shipping or no freight charged; requires review and is not automatically invalid.'
FROM dbo.raw_order_items
WHERE TRY_CONVERT(decimal(18, 2), freight_value) = 0
UNION ALL
SELECT
    'Delivered before purchase rows',
    CAST(COUNT(*) AS BIGINT),
    'Delivery timestamp should not be earlier than purchase timestamp.'
FROM dbo.raw_orders
WHERE TRY_CONVERT(datetime2(0), order_delivered_customer_date)
    < TRY_CONVERT(datetime2(0), order_purchase_timestamp)
UNION ALL
SELECT
    'Carrier before approval rows',
    CAST(COUNT(*) AS BIGINT),
    'Carrier handoff should normally occur after order approval.'
FROM dbo.raw_orders
WHERE TRY_CONVERT(datetime2(0), order_delivered_carrier_date)
    < TRY_CONVERT(datetime2(0), order_approved_at)
UNION ALL
SELECT
    'Customer delivery before carrier rows',
    CAST(COUNT(*) AS BIGINT),
    'Customer delivery should not occur before carrier handoff.'
FROM dbo.raw_orders
WHERE TRY_CONVERT(datetime2(0), order_delivered_customer_date)
    < TRY_CONVERT(datetime2(0), order_delivered_carrier_date)
UNION ALL
SELECT
    'Review scores outside 1 to 5',
    CAST(COUNT(*) AS BIGINT),
    'Review score analysis expects the standard 1 to 5 scale.'
FROM dbo.raw_order_reviews
WHERE TRY_CONVERT(int, review_score) NOT BETWEEN 1 AND 5
UNION ALL
SELECT
    'Negative payment value rows',
    CAST(COUNT(*) AS BIGINT),
    'Negative payment values are invalid and should be investigated.'
FROM dbo.raw_order_payments
WHERE TRY_CONVERT(decimal(18, 2), payment_value) < 0
UNION ALL
SELECT
    'Zero payment value rows',
    CAST(COUNT(*) AS BIGINT),
    'Zero payment requires review and is not automatically invalid unless later validation confirms an issue.'
FROM dbo.raw_order_payments
WHERE TRY_CONVERT(decimal(18, 2), payment_value) = 0;
GO

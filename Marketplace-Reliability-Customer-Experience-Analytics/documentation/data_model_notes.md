# Data Model Notes

## Source Profile

The local Olist CSV headers matched the expected schema used by the SQL scripts.

Profiled row counts:

- Orders: 99,441
- Order items: 112,650
- Payments: 103,886
- Reviews: 99,224
- Customers: 99,441
- Sellers: 3,095
- Products: 32,951
- Geolocation: 1,000,163
- Category translation: 71

See `documentation/data_profile_summary.md` for column lists, missing-value counts, date ranges, and domain summaries.

## Table Descriptions

### Orders

- Raw table: `raw_orders`
- Main view: `vw_orders_clean`
- Grain: one row per order
- Key: `order_id`
- Used for order status, purchase date, approval date, delivery timestamps, and estimated delivery date.

### Order Items

- Raw table: `raw_order_items`
- Main view: `vw_order_items_enriched`
- Grain: one row per order item
- Keys: `order_id`, `order_item_id`
- Used for product revenue, freight value, seller, product, and item-level analysis.

### Payments

- Raw table: `raw_order_payments`
- Views: `vw_payment_analysis`, `vw_payment_order_level`
- Grain: one row per payment record in raw data; one row per order in `vw_payment_order_level`
- Key: `order_id`
- Used for payment type and payment value analysis.

### Reviews

- Raw table: `raw_order_reviews`
- View: `vw_review_order_level`
- Grain: one row per order after aggregation
- Key: `order_id`
- Used as a customer experience proxy.

### Customers

- Raw table: `raw_customers`
- Grain: one row per customer order identifier
- Keys: `customer_id`, `customer_unique_id`
- Used for customer state, city, and unique customer count.

### Sellers

- Raw table: `raw_sellers`
- Grain: one row per seller
- Key: `seller_id`
- Used for seller city and state.

### Products

- Raw table: `raw_products`
- Grain: one row per product
- Key: `product_id`
- Used for category and product dimension fields.

### Category Translation

- Raw table: `raw_category_translation`
- Grain: one row per original category name
- Key: `product_category_name`
- Used to translate product category names into English where available.

### Geolocation

- Raw table: `raw_geolocation`
- Grain: postal-code prefix and coordinate rows
- Key: `geolocation_zip_code_prefix`
- Optional for first dashboard version.

## Join Keys

- `raw_orders.customer_id` to `raw_customers.customer_id`
- `raw_orders.order_id` to `raw_order_items.order_id`
- `raw_orders.order_id` to `raw_order_payments.order_id`
- `raw_orders.order_id` to `raw_order_reviews.order_id`
- `raw_order_items.product_id` to `raw_products.product_id`
- `raw_order_items.seller_id` to `raw_sellers.seller_id`
- `raw_products.product_category_name` to `raw_category_translation.product_category_name`

## Grain Warnings

- `raw_orders` is order-level.
- `raw_order_items` is item-level and can contain multiple rows per order.
- `raw_order_payments` can contain multiple rows per order.
- `raw_order_reviews` can contain multiple rows per order.
- Joining order items directly to payments can duplicate revenue or payment values.
- Joining reviews directly to items can repeat order-level review values across multiple items.

## Double-Counting Risks

Avoid these patterns:

- Summing payment value after joining payments to order items.
- Counting orders from item-level views without `COUNT(DISTINCT order_id)`.
- Summing order-level metrics after joining to item-level data.
- Treating product revenue, freight value, and payment value as the same metric.

## Recommended Power BI Model Notes

Recommended loaded views:

- `vw_marketplace_kpi`
- `vw_delivery_performance_order_level`
- `vw_delivery_performance_item_level`
- `vw_customer_review_analysis`
- `vw_seller_performance`
- `vw_product_category_performance`
- `vw_freight_analysis`
- `vw_payment_analysis`
- `vw_data_quality_summary`

Modeling guidance:

- Use reporting views as prepared fact tables.
- Keep `vw_marketplace_kpi` disconnected for KPI cards if needed.
- Avoid building many-to-many relationships unless required.
- Prefer measures over calculated columns for dashboard totals.
- Validate Power BI totals against `sql/05_validation_queries.sql`.

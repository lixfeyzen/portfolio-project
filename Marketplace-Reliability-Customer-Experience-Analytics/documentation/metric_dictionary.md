# Metric Dictionary

This document defines the main metrics used in the marketplace reliability and customer experience analysis.

## Total Orders

- Metric name: Total Orders
- Definition: Count of unique orders in the orders table.
- Formula: `COUNT(DISTINCT order_id)`
- Grain: Marketplace level, all orders
- Notes: Includes all order statuses unless filtered.

## Delivered Orders

- Metric name: Delivered Orders
- Definition: Count of delivered orders with a valid customer delivery timestamp.
- Formula: `COUNT(DISTINCT order_id)` where `order_status = 'delivered'` and customer delivery date is not null
- Grain: Order level
- Notes: Used as the base for delivery reliability metrics.

## Total Revenue

- Metric name: Total Revenue
- Definition: Total product revenue from order item price.
- Formula: `SUM(order_items.price)`
- Grain: Order item level
- Notes: Does not include freight value or payment value.

## Total Freight Value

- Metric name: Total Freight Value
- Definition: Total freight charged at the order item level.
- Formula: `SUM(order_items.freight_value)`
- Grain: Order item level
- Notes: Analyzed separately from product revenue.

## Total Payment Value

- Metric name: Total Payment Value
- Definition: Total payment value from payment records.
- Formula: `SUM(order_payments.payment_value)`
- Grain: Payment record level or order-level payment aggregation
- Notes: Keep separate from product revenue unless reconciled.

## Total Customers

- Metric name: Total Customers
- Definition: Count of unique customers using the stable customer identifier.
- Formula: `COUNT(DISTINCT customer_unique_id)`
- Grain: Customer level
- Notes: Use `customer_id` for order joins and `customer_unique_id` for unique customer counts.

## Total Sellers

- Metric name: Total Sellers
- Definition: Count of unique sellers.
- Formula: `COUNT(DISTINCT seller_id)`
- Grain: Seller level
- Notes: Can be counted from seller master data or item activity depending on analysis scope.

## Average Review Score

- Metric name: Average Review Score
- Definition: Average customer review score after aggregating reviews at order level.
- Formula: `AVG(avg_review_score)`
- Grain: Order level
- Notes: Review score is a customer experience proxy, not a complete satisfaction measure.

## Delivery Days

- Metric name: Delivery Days
- Definition: Number of days between purchase timestamp and customer delivery timestamp.
- Formula: `DATEDIFF(DAY, purchase_timestamp, customer_delivered_timestamp)`
- Grain: Delivered order level
- Notes: Requires valid purchase and delivery timestamps.

## Delay Days

- Metric name: Delay Days
- Definition: Number of days between estimated delivery timestamp and customer delivery timestamp.
- Formula: `DATEDIFF(DAY, estimated_delivery_timestamp, customer_delivered_timestamp)`
- Grain: Delivered order level
- Notes: Positive values indicate delivery after the estimate.

## Late Delivery Rate

- Metric name: Late Delivery Rate
- Definition: Share of delivered orders delivered after the estimated delivery timestamp.
- Formula: `SUM(late_order_flag) / COUNT(delivered_orders)`
- Grain: Delivered order level
- Notes: Only delivered orders are included.

## On-Time Delivery Rate

- Metric name: On-Time Delivery Rate
- Definition: Share of delivered orders delivered on or before the estimated delivery timestamp.
- Formula: `SUM(on_time_order_flag) / COUNT(delivered_orders)`
- Grain: Delivered order level
- Notes: Complements late delivery rate when delivery status is known.

## Freight-to-Price Ratio

- Metric name: Freight-to-Price Ratio
- Definition: Freight burden relative to product price.
- Formula: `freight_value / NULLIF(price, 0)`
- Grain: Order item level
- Notes: High values may indicate categories or regions with heavier shipping burden.

## Seller Risk Segment

- Metric name: Seller Risk Segment
- Definition: Seller classification based on revenue, late delivery rate, and review score.
- Formula: Compares seller metrics against overall seller averages.
- Grain: Seller level
- Notes: Implemented as `seller_segment` in `vw_seller_performance`. Segment labels are descriptive and should be reviewed before operational use.

## Product Category Experience Risk

- Metric name: Product Category Experience Risk
- Definition: Category-level signal combining revenue, review score, late delivery rate, and freight burden.
- Formula: Derived from category metrics in `vw_product_category_performance`.
- Grain: Product category level
- Notes: This is an interpretation layer, not a causal model.

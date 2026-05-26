# Project Brief

## Project Title

Marketplace Reliability & Customer Experience Analytics

## Objective

Build a portfolio-ready analytics project that uses SQL Server and Power BI planning to evaluate marketplace reliability through delivery performance, seller reliability, customer review behavior, freight burden, product category quality, payment behavior, and data quality.

## Business Context

An online marketplace can show strong revenue while still having operational issues that affect customer experience. Delivery delays, high freight burden, uneven seller performance, and product category quality issues can create risk that is not visible in sales totals alone.

This project prepares a reporting layer that supports business questions around marketplace health, reliability, and customer experience.

## Main Business Question

How do delivery performance, seller reliability, freight cost, payment behavior, and product categories relate to customer experience in a marketplace?

## Business Questions

1. How healthy is the marketplace overall?
2. How many orders, customers, sellers, and product categories are represented?
3. What is the total product revenue and total freight value?
4. What is the average review score?
5. What share of delivered orders arrived on time versus late?
6. Which customer regions show higher delivery delays?
7. Do late deliveries appear associated with lower review scores?
8. Which sellers generate high revenue but show high late delivery risk?
9. Which product categories generate strong revenue but weaker customer experience?
10. Which product categories have high freight-to-price burden?
11. Which payment types are most common?
12. What data quality issues affect interpretation?

## Dataset Tables

- Orders
- Order items
- Payments
- Reviews
- Customers
- Sellers
- Products
- Geolocation
- Product category translation

The real CSV headers were profiled and matched the expected Olist schema. The profile summary is available in `documentation/data_profile_summary.md`.

## Planned SQL Views

- `vw_orders_clean`
- `vw_order_items_enriched`
- `vw_delivery_performance_order_level`
- `vw_delivery_performance_item_level`
- `vw_review_order_level`
- `vw_customer_review_analysis`
- `vw_seller_performance`
- `vw_product_category_performance`
- `vw_freight_analysis`
- `vw_payment_analysis`
- `vw_payment_order_level`
- `vw_marketplace_kpi`
- `vw_data_quality_summary`

## Planned Dashboard Pages

1. Marketplace Health Overview
2. Delivery Reliability
3. Customer Experience
4. Seller Risk & Performance
5. Product Category & Freight Economics

## Metric Definitions

Core metric definitions are documented in `documentation/metric_dictionary.md`. Important definitions include:

- Product revenue = sum of `order_items.price`
- Freight value = sum of `order_items.freight_value`
- Payment value = sum of `order_payments.payment_value`
- Customer count = distinct `customer_unique_id`
- Delivery reliability = delivered orders only
- Review score = customer experience proxy

## Assumptions

- Raw Olist CSV files are imported into SQL Server raw tables.
- Delivered orders are the valid scope for delivery reliability.
- Multiple reviews for one order are averaged at order level.
- Product category names use English translation when available.
- Missing category translations fall back to the original category name.
- Geolocation is optional for the first dashboard version.

## Success Criteria

- SQL Server raw tables can receive the expected Olist CSV files.
- Data profiling summary documents row counts, headers, missing values, date ranges, and key domain values.
- Local automation scripts can check the environment, import CSV files, run SQL scripts, and export validation outputs when SQL Server is reachable.
- Cleaning views convert raw strings into analysis-ready fields.
- Reporting views keep grain clear and reduce double-counting risk.
- Power BI can load the recommended SQL views.
- Documentation explains metrics, assumptions, workflow, and limitations.
- The project can be uploaded to GitHub without fake screenshots, credentials, or unsupported claims.
- Raw dataset files remain local and are excluded from Git through `.gitignore`.

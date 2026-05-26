# Marketplace Reliability & Customer Experience Analytics

## 1. Project Overview

This project is a SQL Server and Power BI case study focused on marketplace reliability, customer experience, seller risk, and data quality.

The goal is to evaluate whether the marketplace is reliable, not only whether it generates revenue. The analysis uses delivery performance, review behavior, seller-level risk indicators, payment coverage, and data quality checks to support a more complete view of marketplace health.

The final deliverable is a five-page Power BI dashboard supported by SQL Server reporting views and portfolio documentation.

## 2. Business Problem

Marketplace revenue shows scale, but it does not fully explain marketplace health.

A marketplace can process many orders while still facing operational issues such as late deliveries, sellers with elevated delivery risk, missing reviews, incomplete product categories, or records that require data quality review.

The main business question is:

> How reliable is the marketplace experience across delivery performance, customer satisfaction, seller behavior, and data quality?

This project addresses that question through descriptive analysis. It highlights patterns that should be monitored or investigated further without claiming causality.

## 3. Dataset and Tools

Dataset:

- Olist Brazilian E-Commerce Public Dataset

Main tables used:

- Orders
- Order items
- Payments
- Reviews
- Customers
- Sellers
- Products
- Geolocation
- Product category translation

Tools used:

- SQL Server
- SQL Server Management Studio
- Power BI Desktop
- Power Query
- DAX
- Python for data profiling
- GitHub

The CSV headers were validated against the expected Olist schema before the SQL workflow was prepared.

## 4. Data Preparation Workflow

The workflow followed a staged approach:

1. Profile raw CSV files for row counts, columns, missing values, date ranges, and domain values.
2. Create SQL Server raw tables for each Olist CSV file.
3. Import the CSV files into SQL Server.
4. Run import checks to validate row counts and key values.
5. Run data quality checks for missing reviews, missing payments, missing product categories, timestamp issues, zero freight, and zero payment rows.
6. Create cleaning views to convert raw fields into analysis-ready dates, numbers, and flags.
7. Create analysis views for Power BI.
8. Validate key totals before building the dashboard.
9. Build the Power BI dashboard and export the final PDF.

This workflow keeps raw data, cleaning logic, analysis views, and dashboard outputs separated.

## 5. SQL and Data Modeling Approach

The SQL layer was designed to control analytical grain and reduce double-counting risk.

Order-level views support delivery and review analysis. Item-level views support revenue and seller analysis. Payment views are kept separate because payment value should not be mixed with product revenue unless it is being reconciled explicitly.

Key reporting views include:

- `vw_marketplace_kpi`
- `vw_delivery_performance_order_level`
- `vw_delivery_performance_item_level`
- `vw_customer_review_analysis`
- `vw_payment_analysis`
- `vw_seller_performance`
- `vw_data_quality_summary`

Important metric definitions:

- Product Revenue = sum of item price from order items.
- Total Payment Value = sum of payment value from payment records.
- On-Time Delivery Rate = delivered orders where customer delivery date is on or before estimated delivery date.
- Late Delivery Rate = delivered orders where customer delivery date is after estimated delivery date.
- Review Gap = difference between average review score for on-time and late delivered orders.
- High-Risk Sellers = sellers flagged based on revenue, order volume, and late delivery rate.

## 6. Dashboard Walkthrough

### Page 1 - Marketplace Health Overview

This page provides an executive view of marketplace scale and overall business health.

It includes KPI cards for total orders, product revenue, unique customers, average review score, on-time delivery rate, and late delivery rate.

The visuals show monthly product revenue, on-time versus late delivery share, average review score by delivery status, payment type distribution, and a key insight text box.

### Page 2 - Delivery Reliability

This page analyzes delivery reliability across time and customer states.

It includes KPI cards for delivered orders, on-time delivery rate, late delivery rate, average delivery days, and average delay days.

The visuals show late delivery rate by month, average delivery days by month, late delivery rate by customer state, and average delivery days by customer state.

### Page 3 - Customer Experience

This page analyzes review behavior and customer experience signals.

It includes KPI cards for average review score, on-time average review, late average review, review gap, and orders without review.

The visuals show average review score by delivery status, review score distribution, lowest review score by customer state, and average review score by delay bucket.

Late deliveries show lower average review scores than on-time deliveries, but this is interpreted as an association, not a causal result.

### Page 4 - Seller Risk & Performance

This page identifies sellers with meaningful revenue and elevated delivery risk.

It includes KPI cards for total sellers, total revenue, average seller review, average late delivery rate, and high-risk sellers.

The visuals include a seller risk matrix and seller risk watchlist. Sellers are flagged based on revenue, order volume, and late delivery rate.

### Page 5 - Data Quality & Trust

This page summarizes data quality issues that affect interpretation.

It includes KPI cards for orders without review, orders without payment, products without category, zero freight rows, and zero payment rows.

The visual shows a data quality issue summary with a key insight text box.

Zero freight and zero payment rows require review, but they are not automatically invalid.

## 7. Key Findings

### Marketplace Health

The marketplace processed approximately 99K orders and generated 13.59M in product revenue.

It served approximately 96K unique customers and had an average review score of 4.09.

These figures show meaningful marketplace scale, but they do not fully explain operational reliability or customer experience.

### Delivery Reliability

The dashboard shows 96.47K delivered orders.

Delivery reliability is strong overall:

- On-Time Delivery Rate: 91.89%
- Late Delivery Rate: 8.11%
- Average Delivery Days: 12.50
- Average Delay Days: -11.88

Delivery performance varies across time and customer states, so regional delivery performance should be monitored.

### Customer Experience

Late deliveries appear associated with lower review scores:

- On-Time Average Review: 4.29
- Late Average Review: 2.57
- Review Gap: 1.73

This does not prove that late delivery causes lower review scores. It suggests that delivery delay is an important customer experience signal to monitor.

The dashboard also identifies 768 orders without review, which limits complete visibility into customer feedback.

### Seller Risk

The dashboard includes approximately 3K sellers.

Seller-level metrics include:

- Average Seller Review: 4.15
- Average Late Delivery Rate: 8.37%
- High-Risk Sellers: 52

High-risk sellers are flagged using revenue, order volume, and late delivery rate. These sellers should be treated as monitoring priorities rather than final performance judgments.

### Data Quality

The dashboard identifies several data quality issues:

- Orders Without Review: 768
- Orders Without Payment: 1
- Products Without Category: 610
- Zero Freight Rows: 383
- Zero Payment Rows: 9

These issues do not automatically invalidate the analysis, but they should be considered when interpreting customer experience, payment coverage, product completeness, and freight-related records.

## 8. Business Recommendations

### Prioritize high-risk seller monitoring

High-risk sellers should be monitored first because they combine meaningful business activity with elevated delivery risk.

### Use delivery reliability as a customer experience signal

Late deliveries appear associated with lower review scores. Delivery delay should be monitored as a customer experience risk indicator.

### Investigate regional delivery patterns

Customer states with higher late delivery rates or longer delivery times should be reviewed for possible logistics or fulfillment issues.

### Improve review coverage tracking

Orders without review reduce visibility into customer experience. Review coverage should be monitored before drawing broad conclusions about satisfaction.

### Review zero freight and zero payment cases carefully

Zero freight and zero payment rows should be reviewed as business or data interpretation cases. They should not be automatically treated as invalid without further validation.

## 9. Assumptions and Limitations

- Delivery reliability analysis uses delivered orders only.
- Cancelled and unavailable orders are not mixed into delivery reliability metrics.
- Review score is used as a customer experience proxy.
- Late delivery is treated as associated with review score, not causal.
- Product revenue is calculated from item price.
- Payment value is analyzed separately from product revenue.
- Order-level, item-level, and payment-level grains are separated to reduce double-counting risk.
- Missing reviews limit complete customer experience interpretation.
- Zero freight and zero payment rows require review but are not automatically invalid.
- Seller risk flags are monitoring signals, not final operational conclusions.

## 10. Skills Demonstrated

- SQL Server database setup
- Raw data staging
- CSV profiling
- Data quality validation
- T-SQL cleaning views
- SQL reporting view design
- Grain-aware data modeling
- Power BI dashboard design
- DAX metric development
- Customer experience analysis
- Seller risk analysis
- Business interpretation
- Portfolio documentation

## 11. Project Deliverables

- SQL Server raw table setup
- Data import checks
- Data quality checks
- SQL cleaning views
- SQL analysis views
- Validation queries
- Power BI dashboard
- Dashboard PDF export
- Metric dictionary
- Data model notes
- Data quality notes
- Power BI build guide
- Portfolio README
- Case study documentation

# Dashboard Page Notes

## Page 1 - Marketplace Health Overview

Purpose:

Executive view of marketplace scale, revenue, customers, review score, delivery reliability, payment behavior, and high-level business health.

Business question answered:

How healthy is the marketplace overall when revenue, customer scale, delivery reliability, review score, and payment behavior are viewed together?

Main KPI cards:

- Total Orders
- Product Revenue
- Unique Customers
- Average Review Score
- On-Time Delivery Rate
- Late Delivery Rate

Visuals used:

- Monthly Product Revenue Trend
- On-Time vs Late Delivery Share
- Average Review Score by Delivery Status
- Payment Type Distribution
- Key Insight text box

Interpretation notes:

This page should frame marketplace health as more than sales volume. Revenue shows scale, while delivery reliability and review score provide operational and customer experience context.

## Page 2 - Delivery Reliability

Purpose:

Analyze delivery reliability across time and customer states.

Business question answered:

Which months and customer states show weaker delivery reliability or longer delivery times?

Main KPI cards:

- Delivered Orders
- On-Time Delivery Rate
- Late Delivery Rate
- Average Delivery Days
- Average Delay Days

Visuals used:

- Late Delivery Rate by Month
- Average Delivery Days by Month
- Late Delivery Rate by Customer State
- Average Delivery Days by Customer State

Interpretation notes:

Delivery reliability metrics use delivered orders only. Cancelled and unavailable orders should not be mixed into delivery performance interpretation.

## Page 3 - Customer Experience

Purpose:

Analyze review behavior and customer experience signals.

Business question answered:

How do review scores differ across delivery outcomes, customer states, and delay patterns?

Main KPI cards:

- Average Review Score
- On-Time Average Review
- Late Average Review
- Review Gap
- Orders Without Review

Visuals used:

- Average Review Score by Delivery Status
- Review Score Distribution
- Lowest Review Score by Customer State
- Average Review Score by Delay Bucket

Interpretation notes:

Late deliveries appear associated with lower review scores, but this dashboard does not claim causality. Review score is treated as a customer experience proxy, not a complete satisfaction measure.

## Page 4 - Seller Risk & Performance

Purpose:

Identify sellers with meaningful revenue and elevated delivery risk.

Business question answered:

Which sellers should be monitored first because they combine meaningful business value with elevated delivery risk?

Main KPI cards:

- Total Sellers
- Total Revenue
- Average Seller Review
- Average Late Delivery Rate
- High-Risk Sellers

Visuals used:

- Seller Risk Matrix
- Seller Risk Watchlist

Interpretation notes:

Sellers are flagged as high risk based on revenue, order volume, and late delivery rate. This should be used as a monitoring signal, not as a final seller performance judgment without further operational review.

## Page 5 - Data Quality & Trust

Purpose:

Show data quality issues that affect interpretation.

Business question answered:

Which data quality issues should be considered before using the dashboard for business interpretation?

Main KPI cards:

- Orders Without Review
- Orders Without Payment
- Products Without Category
- Zero Freight Rows
- Zero Payment Rows

Visuals used:

- Data Quality Issue Summary
- Key Insight text box

Interpretation notes:

Zero freight and zero payment rows require review, but they are not automatically invalid. Data quality issues should be disclosed so dashboard users understand where interpretation may be limited.

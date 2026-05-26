# Marketplace Reliability & Customer Experience Analytics

## Summary

This project is a SQL Server and Power BI portfolio case study focused on marketplace reliability, customer experience, seller risk, and data quality.

Instead of evaluating marketplace performance only from revenue, this project analyzes whether the marketplace can deliver orders reliably, maintain customer satisfaction, identify risky sellers, and trust the data used for business decisions.

The project uses the **Olist Brazilian E-Commerce Public Dataset** and transforms raw e-commerce data into SQL reporting views and a five-page Power BI dashboard.

This project demonstrates practical skills for:

- Data Analyst roles
- Business Intelligence roles
- Junior Data Analyst roles
- BI Analyst roles
- Analytics portfolio review

---

## Business Problem

Marketplace revenue shows scale, but it does not fully explain marketplace health.

A marketplace can generate strong revenue while still facing operational risk from late deliveries, unreliable sellers, weak customer review signals, incomplete product data, or data quality limitations.

The main business question is:

> How reliable is the marketplace experience across delivery performance, customer satisfaction, seller behavior, and data quality?

This project answers that question through SQL analysis, Power BI dashboarding, and documented business interpretation.

---

## Dataset

Dataset used:

**Olist Brazilian E-Commerce Public Dataset**

Dataset source:

[Olist Brazilian E-Commerce Public Dataset on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Expected raw CSV files:

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_sellers_dataset.csv`
- `olist_products_dataset.csv`
- `olist_geolocation_dataset.csv`
- `product_category_name_translation.csv`

Raw CSV files are not included in this repository.

Place the CSV files in:

```text
data/raw/
```

The raw files are intentionally excluded from Git using `.gitignore`.

The CSV headers were validated against the expected Olist schema. See:

```text
documentation/data_profile_summary.md
```

---

## Tools Used

- SQL Server
- SQL Server Management Studio
- Power BI Desktop
- Power Query
- DAX
- Python for data profiling
- GitHub
- Olist CSV files

---

## Project Workflow

1. Profile the raw CSV files.
2. Create SQL Server database and raw tables.
3. Import Olist CSV files into SQL Server.
4. Validate row counts and schema coverage.
5. Run data quality checks.
6. Create SQL cleaning views.
7. Create SQL analysis views for Power BI.
8. Validate business totals.
9. Build the Power BI dashboard.
10. Export the dashboard PDF.
11. Document insights, assumptions, and limitations.

---

## Repository Structure

```text
Marketplace-Reliability-Customer-Experience-Analytics/
├── README.md
├── project_brief.md
├── case-study/
│   └── Marketplace_Reliability_Customer_Experience_Case_Study.md
├── dashboard/
│   ├── powerbi/
│   │   └── Marketplace_Reliability_Customer_Experience.pbix
│   └── screenshots/
│       └── Marketplace_Reliability_Customer_Experience.pdf
├── sql/
│   ├── 00_create_database_and_raw_tables.sql
│   ├── 01_data_import_checks.sql
│   ├── 02_data_quality_checks.sql
│   ├── 03_cleaning_views.sql
│   ├── 04_analysis_views.sql
│   ├── 05_validation_queries.sql
│   └── 06_powerbi_query_reference.sql
├── data/
│   ├── data_source.md
│   └── raw/
│       └── README.md
├── documentation/
│   ├── metric_dictionary.md
│   ├── assumptions_and_limitations.md
│   ├── project_workflow.md
│   ├── data_model_notes.md
│   ├── dashboard_page_notes.md
│   ├── data_quality_notes.md
│   ├── data_profile_summary.md
│   └── powerbi_build_guide.md
├── scripts/
│   ├── README.md
│   └── profile_data.py
└── assets/
    └── README.md
```

---

## Dashboard Deliverables

The final Power BI dashboard is included as the main business intelligence deliverable.

```text
dashboard/powerbi/Marketplace_Reliability_Customer_Experience.pbix
dashboard/screenshots/Marketplace_Reliability_Customer_Experience.pdf
```

The dashboard contains five pages:

1. Marketplace Health Overview
2. Delivery Reliability
3. Customer Experience
4. Seller Risk & Performance
5. Data Quality & Trust

---

## Dashboard Page Overview

### 1. Marketplace Health Overview

This page provides an executive view of marketplace scale and overall business health.

Main metrics:

- Total Orders
- Product Revenue
- Unique Customers
- Average Review Score
- On-Time Delivery Rate
- Late Delivery Rate

Key visuals:

- Monthly Product Revenue Trend
- On-Time vs Late Delivery Share
- Average Review Score by Delivery Status
- Payment Type Distribution

---

### 2. Delivery Reliability

This page evaluates delivery performance and regional delivery risk.

Main metrics:

- Delivered Orders
- On-Time Delivery Rate
- Late Delivery Rate
- Average Delivery Days
- Average Delay Days

Key visuals:

- Late Delivery Rate by Month
- Average Delivery Days by Month
- Late Delivery Rate by Customer State
- Average Delivery Days by Customer State

---

### 3. Customer Experience

This page analyzes review behavior and how review scores differ by delivery performance and customer location.

Main metrics:

- Average Review Score
- On-Time Average Review
- Late Average Review
- Review Gap
- Orders Without Review

Key visuals:

- Average Review Score by Delivery Status
- Review Score Distribution
- Lowest Review Score by Customer State
- Average Review Score by Delay Bucket

---

### 4. Seller Risk & Performance

This page identifies sellers that may create operational or customer experience risk.

Main metrics:

- Total Sellers
- Total Revenue
- Average Seller Review
- Average Late Delivery Rate
- High-Risk Sellers

Key visuals:

- Seller Risk Matrix
- Seller Risk Watchlist

High-risk sellers are identified using revenue, order volume, and late delivery rate.

---

### 5. Data Quality & Trust

This page summarizes data quality issues that may affect business interpretation.

Main metrics:

- Orders Without Review
- Orders Without Payment
- Products Without Category
- Zero Freight Rows
- Zero Payment Rows

Key visual:

- Data Quality Issue Summary

---

## Key Findings

### Marketplace Health

The marketplace processed approximately **99K orders** and generated **13.59M** in product revenue.

The marketplace also served approximately **96K unique customers** and had an average review score of **4.09**.

---

### Delivery Reliability

Delivered orders show strong overall reliability.

- On-Time Delivery Rate: **91.89%**
- Late Delivery Rate: **8.11%**

Delivery performance varies by month and customer state, making regional monitoring important.

---

### Customer Experience

Late deliveries appear associated with lower review scores.

- On-time orders have an average review score of around **4.29**.
- Late orders have an average review score of around **2.57**.
- The review gap is around **1.73 points**.

This does not prove causality, but it suggests that delivery delay should be monitored as an important customer experience signal.

---

### Seller Risk

The seller risk analysis flagged **52 high-risk sellers**.

A seller is considered high-risk when it has meaningful revenue, sufficient order volume, and an elevated late delivery rate.

The Seller Risk Matrix helps separate:

- Strong sellers
- Operational-risk sellers
- Potential-growth sellers
- Low-priority sellers

The Seller Risk Watchlist gives a focused list of sellers that should be monitored first.

---

### Data Quality

Important data quality limitations were identified:

- **768** orders without review
- **1** order without payment
- **610** products without category
- **383** zero freight rows
- **9** zero payment rows

These issues do not automatically invalidate the analysis, but they should be considered when interpreting review behavior, payment coverage, product completeness, and freight-related records.

---

## Business Recommendations

### 1. Prioritize high-risk seller monitoring

High-revenue sellers with elevated late delivery rates should be monitored first because they can affect both revenue and customer satisfaction.

---

### 2. Use delivery reliability as a customer experience signal

Late deliveries appear associated with lower review scores. Delivery delay should be treated as a key customer experience risk indicator.

---

### 3. Investigate regional delivery issues

Customer states with higher late delivery rates or longer delivery times should be investigated for potential logistics bottlenecks.

---

### 4. Improve review coverage tracking

Orders without review reduce customer satisfaction visibility. Review coverage should be monitored before making final conclusions about customer experience.

---

### 5. Treat zero freight and zero payment rows carefully

Zero freight and zero payment cases should be reviewed as business or data quality cases, not automatically treated as errors.

---

## Metric Definitions

Important metric definitions used in this project:

- **Total Orders**  
  Count of unique orders.

- **Product Revenue**  
  Sum of item price from the order items table. Freight and payment values are handled separately.

- **Total Freight Value**  
  Sum of freight value from the order items table.

- **Total Payment Value**  
  Sum of payment value from the payments table.

- **On-Time Delivery Rate**  
  Percentage of delivered orders where the customer delivery date is on or before the estimated delivery date.

- **Late Delivery Rate**  
  Percentage of delivered orders where the customer delivery date is after the estimated delivery date.

- **Average Review Score**  
  Average customer review score.

- **Review Gap**  
  Difference between average review score for on-time orders and late orders.

- **High-Risk Sellers**  
  Sellers with meaningful revenue, sufficient order volume, and elevated late delivery rate.

Full metric documentation is available in:

```text
documentation/metric_dictionary.md
```

---

## SQL Workflow

Run the SQL files in this order:

```text
sql/00_create_database_and_raw_tables.sql
sql/01_data_import_checks.sql
sql/02_data_quality_checks.sql
sql/03_cleaning_views.sql
sql/04_analysis_views.sql
sql/05_validation_queries.sql
sql/06_powerbi_query_reference.sql
```

Purpose of each file:

- `00_create_database_and_raw_tables.sql`  
  Creates the database and raw table structure.

- `01_data_import_checks.sql`  
  Checks row counts and imported domain values.

- `02_data_quality_checks.sql`  
  Identifies missing values, invalid dates, missing reviews, payment gaps, and other interpretation risks.

- `03_cleaning_views.sql`  
  Creates typed and cleaned SQL views.

- `04_analysis_views.sql`  
  Creates Power BI-ready reporting views.

- `05_validation_queries.sql`  
  Validates key totals before dashboard building.

- `06_powerbi_query_reference.sql`  
  Provides final SQL view references for Power BI.

---

## Power BI Data Sources

The dashboard is built from SQL reporting views, including:

```text
vw_marketplace_kpi
vw_delivery_performance_order_level
vw_delivery_performance_item_level
vw_customer_review_analysis
vw_payment_analysis
vw_seller_performance
vw_data_quality_summary
```

These views separate the analytical grains used in the dashboard:

- Order-level views for delivery and review analysis
- Item-level views for revenue and seller analysis
- Payment views for payment behavior
- Data quality views for interpretation risk

---

## Data Quality Notes

The dataset is suitable for marketplace reliability analysis, but several limitations should be considered.

Known limitations include:

- Missing reviews
- Missing payment records
- Missing product categories
- Zero freight rows
- Zero payment rows
- Some timestamp sequence issues

These limitations are documented in:

```text
documentation/data_quality_notes.md
documentation/assumptions_and_limitations.md
documentation/data_profile_summary.md
```

---

## Interpretation Notes

This project uses review score as a proxy for customer experience.

The dashboard shows that late deliveries have lower average review scores than on-time deliveries. This is interpreted as an association, not a causal claim.

The project also separates product revenue, freight value, and payment value to avoid misleading revenue interpretation.

---

## How to Reproduce

1. Download the Olist dataset from Kaggle.
2. Place all raw CSV files in:

```text
data/raw/
```

3. Run the SQL setup and import workflow.
4. Validate the imported data.
5. Run the cleaning and analysis SQL views.
6. Open the Power BI file.
7. Refresh the dataset connection.
8. Review dashboard pages and exported PDF.

---

## Dashboard Output

Final Power BI file:

```text
dashboard/powerbi/Marketplace_Reliability_Customer_Experience.pbix
```

Final dashboard PDF export:

```text
dashboard/screenshots/Marketplace_Reliability_Customer_Experience.pdf
```

---

## Portfolio Value

This project demonstrates:

- SQL data modeling
- SQL data cleaning
- Data quality validation
- Power BI dashboard design
- DAX measure creation
- Business KPI development
- Customer experience analysis
- Seller risk analysis
- Marketplace operations analysis
- Portfolio-ready documentation

---

## Project Status

```text
Status: Completed
```

Completed deliverables:

- SQL workflow
- Data quality checks
- Analysis views
- Power BI dashboard
- Dashboard PDF export
- Documentation structure
- Portfolio README

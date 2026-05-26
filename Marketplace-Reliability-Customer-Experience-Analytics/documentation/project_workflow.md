# Project Workflow

## 1. Raw CSV Files

Download the Olist CSV files and place them in `data/raw/`.

## 2. SQL Server Raw Tables

Optional before SQL import:

Run `scripts/profile_data.py` to regenerate `documentation/data_profile_summary.md` from local CSV files.

Automated path:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\auto_setup_sql_workflow.ps1 -ServerInstance localhost
```

This checks the environment, profiles CSV files, creates SQL objects, imports raw CSV files, creates views, and exports validation outputs when SQL Server is reachable.

Run `sql/00_create_database_and_raw_tables.sql` to create:

- `Marketplace_Analytics`
- Raw staging tables for orders, items, payments, reviews, customers, sellers, products, geolocation, and category translations

## 3. Data Import Checks

Run `sql/01_data_import_checks.sql` after importing CSV files.

Checks include:

- Row count per raw table
- Distinct order status values
- Purchase date range
- Payment type values
- Review score values
- Customer and seller states
- Distinct order coverage across key tables

## 4. Data Quality Checks

Run `sql/02_data_quality_checks.sql`.

Checks include:

- Missing delivery timestamps
- Missing estimated delivery dates
- Missing approval dates
- Cancelled and unavailable orders
- Orders without payments
- Orders without reviews
- Missing product categories
- Missing category translations
- Duplicate orders
- Non-positive price, freight, or payment values
- Invalid delivery sequences
- Review scores outside 1 to 5

## 5. Cleaning Views

Run `sql/03_cleaning_views.sql`.

Cleaning views:

- Convert raw date strings into `datetime2`
- Convert price and freight fields into numeric values
- Add delivered, cancelled, unavailable, and timestamp availability flags
- Enrich order items with seller and product category information

## 6. Analysis Views

Run `sql/04_analysis_views.sql`.

Analysis views support:

- Marketplace KPI cards
- Delivery reliability
- Customer review analysis
- Seller risk and performance
- Product category performance
- Freight burden analysis
- Payment analysis
- Data quality reporting

## 7. Power BI Dashboard

Use `sql/06_powerbi_query_reference.sql` to identify views for Power BI loading.

Recommended dashboard pages:

1. Marketplace Health Overview
2. Delivery Reliability
3. Customer Experience
4. Seller Risk & Performance
5. Product Category & Freight Economics

## 8. Business Interpretation

Interpretation should separate:

- Revenue scale
- Delivery reliability
- Customer experience proxy
- Seller operational risk
- Freight burden
- Data quality constraints

Avoid causal claims unless causal analysis is performed.

## 9. Case Study

Use `case-study/Marketplace_Reliability_Customer_Experience_Case_Study.md` as the final written project narrative.

After importing data and building the dashboard, replace analysis targets with data-backed findings only.

## 10. GitHub Portfolio Package

Before publishing:

- Confirm required files exist.
- Confirm no fake screenshots or placeholder `.pbix` files were added.
- Confirm no local file paths or credentials are committed.
- Confirm README explains limitations and manual setup steps.

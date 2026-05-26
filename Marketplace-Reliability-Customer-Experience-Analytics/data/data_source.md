# Data Source

## Dataset Name

Olist Brazilian E-Commerce Public Dataset

## Source

The dataset is publicly available on Kaggle as the Olist Brazilian E-Commerce Public Dataset.

## Tables Used

- Orders
- Order items
- Payments
- Reviews
- Customers
- Sellers
- Products
- Geolocation
- Product category translation

## Expected Files

Place raw CSV files in:

```text
Marketplace-Reliability-Customer-Experience-Analytics/data/raw/
```

Expected files:

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_sellers_dataset.csv`
- `olist_products_dataset.csv`
- `olist_geolocation_dataset.csv`
- `product_category_name_translation.csv`

## How to Place Raw Files

1. Download the CSV files from the dataset source.
2. Copy the files into `data/raw/`.
3. Import the CSV files into SQL Server using the raw table names in `sql/00_create_database_and_raw_tables.sql`.
4. Run `sql/01_data_import_checks.sql` to confirm import coverage.

## Data Usage Note

Raw data files are not included in this repository. The project `.gitignore` excludes raw dataset files from `data/raw/` so the GitHub repository stays lightweight. The SQL scripts are prepared for the expected Olist schema.

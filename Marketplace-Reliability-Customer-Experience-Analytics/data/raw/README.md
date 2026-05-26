# Raw Data Folder

Place the Olist CSV files in this folder locally before importing them into SQL Server.

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

Raw dataset files are excluded from GitHub through the project `.gitignore`.

Download the dataset manually from Kaggle, extract the CSV files, and place them here when you are ready to run the SQL import workflow.

Do not commit private data, credentials, or local machine paths.

/*
Marketplace Reliability & Customer Experience Analytics
Script 00 - Create database and raw tables

Purpose:
- Create the SQL Server database used for this project.
- Create flexible raw staging tables for Olist CSV imports.

Notes:
- Raw table definitions match the validated Olist CSV headers.
- Text and date-like raw fields use NVARCHAR for safer CSV import.
- Numeric amount, count, sequence, and coordinate fields use SQL numeric types where appropriate.
- Date parsing is still handled in cleaning and analysis views with TRY_CONVERT.
- This script avoids dropping existing objects.
- If a raw table already exists with an older schema, this script will not alter it automatically.
- CSV file paths are intentionally placeholders. Do not commit local paths.
*/

IF DB_ID(N'Marketplace_Analytics') IS NULL
BEGIN
    CREATE DATABASE Marketplace_Analytics;
END;
GO

USE Marketplace_Analytics;
GO

IF OBJECT_ID(N'dbo.raw_orders', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_orders (
        order_id NVARCHAR(100) NULL,
        customer_id NVARCHAR(100) NULL,
        order_status NVARCHAR(50) NULL,
        order_purchase_timestamp NVARCHAR(50) NULL,
        order_approved_at NVARCHAR(50) NULL,
        order_delivered_carrier_date NVARCHAR(50) NULL,
        order_delivered_customer_date NVARCHAR(50) NULL,
        order_estimated_delivery_date NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_order_items', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_order_items (
        order_id NVARCHAR(100) NULL,
        order_item_id INT NULL,
        product_id NVARCHAR(100) NULL,
        seller_id NVARCHAR(100) NULL,
        shipping_limit_date NVARCHAR(50) NULL,
        price DECIMAL(18, 2) NULL,
        freight_value DECIMAL(18, 2) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_order_payments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_order_payments (
        order_id NVARCHAR(100) NULL,
        payment_sequential INT NULL,
        payment_type NVARCHAR(50) NULL,
        payment_installments INT NULL,
        payment_value DECIMAL(18, 2) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_order_reviews', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_order_reviews (
        review_id NVARCHAR(100) NULL,
        order_id NVARCHAR(100) NULL,
        review_score INT NULL,
        review_comment_title NVARCHAR(4000) NULL,
        review_comment_message NVARCHAR(MAX) NULL,
        review_creation_date NVARCHAR(50) NULL,
        review_answer_timestamp NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_customers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_customers (
        customer_id NVARCHAR(100) NULL,
        customer_unique_id NVARCHAR(100) NULL,
        customer_zip_code_prefix NVARCHAR(50) NULL,
        customer_city NVARCHAR(255) NULL,
        customer_state NVARCHAR(10) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_sellers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_sellers (
        seller_id NVARCHAR(100) NULL,
        seller_zip_code_prefix NVARCHAR(50) NULL,
        seller_city NVARCHAR(255) NULL,
        seller_state NVARCHAR(10) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_products (
        product_id NVARCHAR(100) NULL,
        product_category_name NVARCHAR(255) NULL,
        product_name_lenght INT NULL,
        product_description_lenght INT NULL,
        product_photos_qty INT NULL,
        product_weight_g INT NULL,
        product_length_cm INT NULL,
        product_height_cm INT NULL,
        product_width_cm INT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_geolocation', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_geolocation (
        geolocation_zip_code_prefix NVARCHAR(50) NULL,
        geolocation_lat DECIMAL(18, 15) NULL,
        geolocation_lng DECIMAL(18, 15) NULL,
        geolocation_city NVARCHAR(255) NULL,
        geolocation_state NVARCHAR(10) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.raw_category_translation', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_category_translation (
        product_category_name NVARCHAR(255) NULL,
        product_category_name_english NVARCHAR(255) NULL
    );
END;
GO

/*
CSV import options:

Option 1 - SQL Server Import and Export Wizard
1. Right-click Marketplace_Analytics.
2. Choose Tasks > Import Flat File or Import Data.
3. Load each CSV into the matching raw_* table.
4. Keep the first row as headers.
5. Validate row counts with sql/01_data_import_checks.sql.

Option 2 - BULK INSERT placeholder
Replace <path-to-csv> with a local path on your machine before running.
Do not commit local machine paths to GitHub.
If BULK INSERT has trouble with nullable numeric fields, use the SQL Server
Import and Export Wizard or import into temporary NVARCHAR staging columns first.

Example:
BULK INSERT dbo.raw_orders
FROM '<path-to-csv>\olist_orders_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
*/

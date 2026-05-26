# Data Profile Summary

This profile was generated from local Olist CSV files. Raw CSV files are excluded from GitHub.

Profile source: project data/raw directory

## Schema Validation

| File | Rows | Columns | Header matched expected schema |
| --- | --- | --- | --- |
| olist_customers_dataset.csv | 99,441 | 5 | Yes |
| olist_geolocation_dataset.csv | 1,000,163 | 5 | Yes |
| olist_orders_dataset.csv | 99,441 | 8 | Yes |
| olist_order_items_dataset.csv | 112,650 | 7 | Yes |
| olist_order_payments_dataset.csv | 103,886 | 5 | Yes |
| olist_order_reviews_dataset.csv | 99,224 | 7 | Yes |
| olist_products_dataset.csv | 32,951 | 9 | Yes |
| olist_sellers_dataset.csv | 3,095 | 4 | Yes |
| product_category_name_translation.csv | 71 | 2 | Yes |

## Columns

### olist_customers_dataset.csv

`customer_id`, `customer_unique_id`, `customer_zip_code_prefix`, `customer_city`, `customer_state`

### olist_geolocation_dataset.csv

`geolocation_zip_code_prefix`, `geolocation_lat`, `geolocation_lng`, `geolocation_city`, `geolocation_state`

### olist_orders_dataset.csv

`order_id`, `customer_id`, `order_status`, `order_purchase_timestamp`, `order_approved_at`, `order_delivered_carrier_date`, `order_delivered_customer_date`, `order_estimated_delivery_date`

### olist_order_items_dataset.csv

`order_id`, `order_item_id`, `product_id`, `seller_id`, `shipping_limit_date`, `price`, `freight_value`

### olist_order_payments_dataset.csv

`order_id`, `payment_sequential`, `payment_type`, `payment_installments`, `payment_value`

### olist_order_reviews_dataset.csv

`review_id`, `order_id`, `review_score`, `review_comment_title`, `review_comment_message`, `review_creation_date`, `review_answer_timestamp`

### olist_products_dataset.csv

`product_id`, `product_category_name`, `product_name_lenght`, `product_description_lenght`, `product_photos_qty`, `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm`

### olist_sellers_dataset.csv

`seller_id`, `seller_zip_code_prefix`, `seller_city`, `seller_state`

### product_category_name_translation.csv

`product_category_name`, `product_category_name_english`

## Important Missing Values

| File | Column | Missing rows | Missing share |
| --- | --- | --- | --- |
| olist_orders_dataset.csv | order_delivered_customer_date | 2,965 | 2.98% |
| olist_orders_dataset.csv | order_delivered_carrier_date | 1,783 | 1.79% |
| olist_orders_dataset.csv | order_approved_at | 160 | 0.16% |
| olist_order_reviews_dataset.csv | review_comment_title | 87,658 | 88.34% |
| olist_order_reviews_dataset.csv | review_comment_message | 58,274 | 58.73% |
| olist_products_dataset.csv | product_category_name | 610 | 1.85% |
| olist_products_dataset.csv | product_name_lenght | 610 | 1.85% |
| olist_products_dataset.csv | product_description_lenght | 610 | 1.85% |
| olist_products_dataset.csv | product_photos_qty | 610 | 1.85% |
| olist_products_dataset.csv | product_weight_g | 2 | 0.01% |
| olist_products_dataset.csv | product_length_cm | 2 | 0.01% |
| olist_products_dataset.csv | product_height_cm | 2 | 0.01% |
| olist_products_dataset.csv | product_width_cm | 2 | 0.01% |

## Date Ranges

| File | Date column | Minimum | Maximum | Invalid nonblank values |
| --- | --- | --- | --- | --- |
| olist_orders_dataset.csv | order_purchase_timestamp | 2016-09-04 21:15:19 | 2018-10-17 17:30:18 | 0 |
| olist_orders_dataset.csv | order_approved_at | 2016-09-15 12:16:38 | 2018-09-03 17:40:06 | 0 |
| olist_orders_dataset.csv | order_delivered_carrier_date | 2016-10-08 10:34:01 | 2018-09-11 19:48:28 | 0 |
| olist_orders_dataset.csv | order_delivered_customer_date | 2016-10-11 13:46:32 | 2018-10-17 13:22:46 | 0 |
| olist_orders_dataset.csv | order_estimated_delivery_date | 2016-09-30 00:00:00 | 2018-11-12 00:00:00 | 0 |
| olist_order_items_dataset.csv | shipping_limit_date | 2016-09-19 00:15:34 | 2020-04-09 22:35:08 | 0 |
| olist_order_reviews_dataset.csv | review_creation_date | 2016-10-02 00:00:00 | 2018-08-31 00:00:00 | 0 |
| olist_order_reviews_dataset.csv | review_answer_timestamp | 2016-10-07 18:32:28 | 2018-10-29 12:27:35 | 0 |

## Domain Summaries

### order_status

| Value | Rows |
| --- | --- |
| approved | 2 |
| canceled | 625 |
| created | 5 |
| delivered | 96,478 |
| invoiced | 314 |
| processing | 301 |
| shipped | 1,107 |
| unavailable | 609 |

### payment_type

| Value | Rows |
| --- | --- |
| boleto | 19,784 |
| credit_card | 76,795 |
| debit_card | 1,529 |
| not_defined | 3 |
| voucher | 5,775 |

### review_score

| Value | Rows |
| --- | --- |
| 1 | 11,424 |
| 2 | 3,151 |
| 3 | 8,179 |
| 4 | 19,142 |
| 5 | 57,328 |

### customer_state

| Value | Rows |
| --- | --- |
| AC | 81 |
| AL | 413 |
| AM | 148 |
| AP | 68 |
| BA | 3,380 |
| CE | 1,336 |
| DF | 2,140 |
| ES | 2,033 |
| GO | 2,020 |
| MA | 747 |
| MG | 11,635 |
| MS | 715 |
| MT | 907 |
| PA | 975 |
| PB | 536 |
| PE | 1,652 |
| PI | 495 |
| PR | 5,045 |
| RJ | 12,852 |
| RN | 485 |
| RO | 253 |
| RR | 46 |
| RS | 5,466 |
| SC | 3,637 |
| SE | 350 |
| SP | 41,746 |
| TO | 280 |

### seller_state

| Value | Rows |
| --- | --- |
| AC | 1 |
| AM | 1 |
| BA | 19 |
| CE | 13 |
| DF | 30 |
| ES | 23 |
| GO | 40 |
| MA | 1 |
| MG | 244 |
| MS | 5 |
| MT | 4 |
| PA | 1 |
| PB | 6 |
| PE | 9 |
| PI | 1 |
| PR | 349 |
| RJ | 171 |
| RN | 5 |
| RO | 2 |
| RS | 129 |
| SC | 190 |
| SE | 2 |
| SP | 1,849 |

## SQL Data Quality Pre-Checks

| Metric | Value | Notes |
| --- | --- | --- |
| Delivered orders missing customer delivery date | 8 | Excluded from delivery reliability until reviewed. |
| Orders missing estimated delivery date | 0 | Late or on-time status requires an estimated delivery date. |
| Orders missing approved date | 160 | Useful for fulfillment sequence validation. |
| Cancelled orders | 625 | Tracked separately from delivered-order reliability. |
| Unavailable orders | 609 | Tracked separately from delivered-order reliability. |
| Orders without payment | 1 | Affects payment coverage and reconciliation. |
| Orders without review | 768 | Reduces review-score coverage. |
| Duplicate order_id values in orders | 0 | raw_orders is expected to be one row per order. |
| Delivered date before purchase date | 0 | Invalid delivery sequence. |
| Carrier date before approved date | 1359 | Invalid fulfillment sequence. |
| Customer delivered date before carrier date | 23 | Invalid delivery sequence. |
| Zero or negative price rows | 0 | Product revenue expects positive item price values. |
| Negative freight rows | 0 | Negative freight is invalid and should be investigated. |
| Zero freight rows | 383 | Zero freight may represent free shipping or no freight charged; requires review and is not automatically invalid. |
| Negative payment value rows | 0 | Negative payment values are invalid and should be investigated. |
| Zero payment value rows | 9 | Zero payment requires review and is not automatically invalid unless later validation confirms an issue. |
| Review score outside 1 to 5 | 0 | Review analysis expects the standard 1 to 5 scale. |
| Products without category | 610 | Category analysis should group these as Unknown. |
| Product categories missing translation | 2 | Untranslated categories should fall back to original names. |

## Key Notes for Analysis

- All final business findings should wait until the SQL views and Power BI totals are validated.
- Review score is a customer experience proxy and should not be treated as a complete satisfaction measure.
- Late delivery can be evaluated as associated with review score, but this profile does not establish causality.
- Optional review comment fields have high missingness and should not be required for review score analysis.
- Delivery reliability should use delivered orders with valid customer delivery timestamps.
- Payment values, product revenue, and freight values should stay separate unless explicitly reconciled.

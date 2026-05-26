# Data Quality Notes

## Data Quality Dimensions

This project checks data quality across:

- Completeness
- Validity
- Uniqueness
- Consistency
- Referential coverage
- Analytical usability

## Checks Performed

## Profile-Backed Observations

The local CSV profile found:

- `olist_orders_dataset.csv`: 99,441 rows.
- `olist_order_items_dataset.csv`: 112,650 rows.
- `olist_order_payments_dataset.csv`: 103,886 rows.
- `olist_order_reviews_dataset.csv`: 99,224 rows.
- `olist_products_dataset.csv`: 32,951 rows.
- `olist_customers_dataset.csv`: 99,441 rows.
- `olist_sellers_dataset.csv`: 3,095 rows.
- `olist_geolocation_dataset.csv`: 1,000,163 rows.
- `product_category_name_translation.csv`: 71 rows.

Important missing values from profiling:

- `order_delivered_customer_date`: 2,965 missing rows.
- `order_delivered_carrier_date`: 1,783 missing rows.
- `order_approved_at`: 160 missing rows.
- `review_comment_title`: 87,658 missing rows.
- `review_comment_message`: 58,274 missing rows.
- `product_category_name`: 610 missing rows.
- Product dimension fields have 2 missing rows each for weight, length, height, and width.

SQL-aligned pre-checks from the CSV profile:

- Delivered orders missing customer delivery date: 8.
- Orders without payment: 1.
- Orders without review: 768.
- Duplicate `order_id` values in orders: 0.
- Carrier date before approved date: 1,359.
- Customer delivered date before carrier date: 23.
- Zero or negative price rows: 0.
- Negative freight rows: 0.
- Zero freight rows: 383. These may represent free shipping or no freight charged and are not automatically invalid.
- Negative payment value rows: 0.
- Zero payment value rows: 9. These require review and should not be automatically excluded unless later validation confirms an issue.
- Review score outside 1 to 5: 0.
- Product categories missing translation: 2.

These are raw CSV profile observations. Final dashboard interpretation should use the SQL validation queries after import.

### Missing Delivery Timestamps

Why it matters:

Delivery reliability metrics require customer delivery timestamps.

Effect on analysis:

Orders without valid delivery timestamps cannot be reliably classified as on time or late.

Recommended treatment:

Exclude from delivery reliability metrics and report the count in data quality notes.

### Cancelled Orders

Why it matters:

Cancelled orders are not completed fulfillment events.

Effect on analysis:

Including cancelled orders in delivery metrics would distort reliability rates.

Recommended treatment:

Separate from delivered-order reliability analysis.

### Unavailable Orders

Why it matters:

Unavailable orders represent fulfillment failure or inventory availability issues.

Effect on analysis:

They should be monitored, but not mixed with delivered-order lateness.

Recommended treatment:

Report separately in marketplace health and data quality views.

### Missing Reviews

Why it matters:

Review coverage affects customer experience analysis.

Effect on analysis:

Average review score may reflect only orders with reviews.

Recommended treatment:

Track orders without reviews and avoid overgeneralizing review-based findings.

### Missing Product Categories

Why it matters:

Category-level revenue, freight, and experience analysis depends on category availability.

Effect on analysis:

Missing categories reduce visibility into product performance.

Recommended treatment:

Use `Unknown` category label and report missing category count.

### Invalid Delivery Sequences

Why it matters:

Delivery events should occur in a logical sequence.

Effect on analysis:

Invalid sequences may create incorrect delivery day or delay day values.

Recommended treatment:

Flag records and review before relying on delivery duration metrics.

### Orders Without Payments

Why it matters:

Payment analysis depends on order coverage in payment records.

Effect on analysis:

Missing payments can create differences between product revenue plus freight and payment totals.

Recommended treatment:

Keep payment analysis separate and reconcile totals before interpretation.

### Zero Freight Rows

Why it matters:

Zero freight can affect freight-to-price ratio and freight burden analysis.

Effect on analysis:

Zero freight may represent free shipping, no freight charged, or dataset-specific transaction behavior.

Recommended treatment:

Keep zero freight rows in the dataset. They require review, but they are not automatically invalid.

### Negative Freight Rows

Why it matters:

Negative freight would not be expected in normal freight charge analysis.

Effect on analysis:

Negative freight could distort freight totals and freight-to-price ratios.

Recommended treatment:

Treat negative freight as invalid and investigate before final reporting.

### Zero Payment Rows

Why it matters:

Zero payment rows can affect payment reconciliation and payment type analysis.

Effect on analysis:

Zero payment may reflect vouchers, adjustments, or other dataset behavior.

Recommended treatment:

Do not automatically exclude zero payment rows. They require review and should be investigated during reconciliation.

### Negative Payment Rows

Why it matters:

Negative payment values would not be expected in standard payment value analysis.

Effect on analysis:

Negative payment values could distort total payment value.

Recommended treatment:

Treat negative payment values as invalid and investigate before final reporting.

### Potential Duplicate Records

Why it matters:

Duplicate order records can inflate order counts.

Effect on analysis:

Duplicates can distort KPI cards and rates.

Recommended treatment:

Investigate duplicate `order_id` rows in `raw_orders` before final reporting.

## Recommended Reporting Treatment

- Show data quality summary as a supporting table or appendix.
- Mention unresolved issues in the case study limitations section.
- Avoid hiding data quality caveats from dashboard users.
- Validate Power BI totals against SQL validation queries.

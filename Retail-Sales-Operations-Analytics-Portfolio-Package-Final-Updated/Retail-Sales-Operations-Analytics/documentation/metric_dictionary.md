# Metric Dictionary

## Total Revenue

Revenue from valid sales transactions.

Formula:
`quantity * unit_price`

Only records from `vw_retail_valid_sales` are used.

## Total Orders

Distinct count of invoice numbers from valid sales transactions.

## Total Customers

Distinct count of available CustomerID values from valid sales transactions.

Missing CustomerID values are documented in the data quality summary because they limit customer-level analysis.

## Quantity Sold

Total quantity sold from valid sales transactions.

## Average Order Value

Total revenue divided by total valid orders.

Formula:
`total_revenue / total_orders`

## Cancellation Revenue Impact

Absolute revenue value from cancelled invoices.

This metric is used to understand how much cancellation activity may affect revenue interpretation.

## Valid Sales Rows

Rows that pass the filtering rules for the main sales dashboard.

Valid sales rows exclude:
Cancelled invoices  
Invalid quantities  
Invalid prices  
Invalid dates  
Missing product descriptions

## Product Performance

Product performance is calculated only from clean product records.

Postage, manual charges, discounts, and service-related records are excluded from clean product ranking to avoid misleading product analysis.

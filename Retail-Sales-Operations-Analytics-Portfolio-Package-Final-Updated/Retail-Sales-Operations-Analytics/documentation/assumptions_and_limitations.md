# Assumptions and Limitations

## Assumptions

Cancelled invoices are separated from the main sales dashboard and analyzed in a dedicated cancellation view.

Rows with invalid quantities, invalid prices, invalid dates, or missing product descriptions are excluded from the valid sales view.

Missing CustomerID values are kept visible in the data quality summary because they affect customer-level analysis.

Postage, manual charges, discounts, and service-related records are excluded from product performance ranking.

December 2011 is interpreted carefully because the dataset only contains part of that month.

## Limitations

The dataset does not provide clean product categories, so product analysis is based on product descriptions and stock codes.

Some transactions have missing CustomerID values, which limits customer-level analysis.

Profit and margin analysis could not be performed because product cost data is not available.

The dashboard focuses on historical analysis, not forecasting.

The analysis is useful for sales and operational interpretation, but it should not be treated as a complete business performance model without cost, margin, and inventory data.

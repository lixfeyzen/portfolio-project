# Assumptions and Limitations

## Analysis Assumptions

- Only delivered orders are used for delivery reliability analysis.
- Cancelled and unavailable orders are separated from fulfillment analysis.
- Review score is used as a customer experience proxy.
- Late delivery is treated as associated with review score, not causal.
- Product revenue is calculated from item price.
- Freight is analyzed separately from product revenue.
- Customer uniqueness uses `customer_unique_id`.
- Order-level joins use `customer_id`.
- Order-item views may have multiple rows per order.
- Payment values are analyzed separately to avoid double-counting.
- Multiple reviews for the same order are aggregated using average review score.
- Product category names use English translation when available.
- Geolocation analysis is optional and not required for the first dashboard version.

## Limitations

- Review score does not capture all reasons for customer satisfaction or dissatisfaction.
- Delivery timestamps may be missing or invalid for some orders.
- Freight value may reflect shipping charge, not actual logistics cost.
- Seller segmentation uses descriptive thresholds, not a predictive risk model.
- Product category analysis can be affected by missing or untranslated categories.
- Payment totals may not exactly match product revenue plus freight due to vouchers, adjustments, missing records, or dataset-specific behavior.
- Descriptive comparisons do not establish causality.

## Interpretation Rules

- Do not frame late delivery as the reason for low review score unless a causal study is performed.
- Use wording such as "appears associated", "suggests", "should be monitored", or "requires further investigation".
- Validate SQL totals before using Power BI results in the final case study.
- Document missing data and data quality risks before making business recommendations.

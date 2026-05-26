# Power BI Measures

These DAX measures are intended for the manual Power BI build after SQL Server views are loaded.

Use the SQL validation outputs as the source of truth before relying on dashboard totals.

Grain guardrails:

- Use `vw_marketplace_kpi` for marketplace-level order cards.
- Use `vw_delivery_performance_item_level` for revenue and freight.
- Use `vw_delivery_performance_order_level` for delivered-order rates and delivery-day averages.

## Marketplace Health

```DAX
Total Orders =
SUM(vw_marketplace_kpi[total_orders])
```

```DAX
Delivered Orders =
SUM(vw_marketplace_kpi[delivered_orders])
```

```DAX
Total Revenue =
SUM(vw_delivery_performance_item_level[price])
```

```DAX
Total Freight Value =
SUM(vw_delivery_performance_item_level[freight_value])
```

```DAX
Average Review Score =
AVERAGE(vw_customer_review_analysis[avg_review_score])
```

## Delivery Reliability

```DAX
Late Delivery Rate =
DIVIDE(
    SUM(vw_delivery_performance_order_level[late_order_flag]),
    COUNTROWS(vw_delivery_performance_order_level)
)
```

```DAX
On-Time Delivery Rate =
DIVIDE(
    SUM(vw_delivery_performance_order_level[on_time_order_flag]),
    COUNTROWS(vw_delivery_performance_order_level)
)
```

```DAX
Average Delivery Days =
AVERAGE(vw_delivery_performance_order_level[delivery_days])
```

```DAX
Average Delay Days =
AVERAGE(vw_delivery_performance_order_level[delay_days])
```

## Freight

```DAX
Average Freight-to-Price Ratio =
AVERAGE(vw_delivery_performance_item_level[freight_to_price_ratio])
```

```DAX
Zero Freight Items =
CALCULATE(
    COUNTROWS(vw_delivery_performance_item_level),
    vw_delivery_performance_item_level[freight_value] = 0
)
```

Zero freight may represent free shipping or no freight charged. It requires review but is not automatically invalid.

## Seller and Category Review

```DAX
Seller Count =
DISTINCTCOUNT(vw_seller_performance[seller_id])
```

```DAX
Category Count =
DISTINCTCOUNT(vw_product_category_performance[product_category])
```

Use seller and category summary views for ranking visuals to reduce grain-related double-counting risk.

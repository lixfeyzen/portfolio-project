# Power BI Build Guide

## Views to Load

Load these SQL Server views:

- `vw_marketplace_kpi`
- `vw_delivery_performance_order_level`
- `vw_delivery_performance_item_level`
- `vw_customer_review_analysis`
- `vw_seller_performance`
- `vw_product_category_performance`
- `vw_freight_analysis`
- `vw_payment_analysis`
- `vw_data_quality_summary`

Optional supporting views:

- `vw_orders_clean`
- `vw_order_items_enriched`
- `vw_review_order_level`
- `vw_payment_order_level`

## Recommended Relationships

Use the reporting views carefully because several are already aggregated.

Recommended approach:

- Use `vw_marketplace_kpi` as a disconnected KPI table.
- Use `vw_delivery_performance_order_level` for order-level delivery charts.
- Use `vw_delivery_performance_item_level` for seller, product, revenue, and freight analysis.
- Use `vw_customer_review_analysis` for delivery and review comparison.
- Use `vw_seller_performance` as a seller summary table.
- Use `vw_product_category_performance` as a category summary table.
- Use `vw_payment_analysis` as a payment summary table.

Avoid joining payment summary views to item-level views unless a specific reconciliation model is created.

## Recommended Measures

Use `documentation/powerbi_measures.md` as the main measure reference.

These DAX measure patterns can be adjusted if the Power BI model uses different table names. Keep the source grain consistent:

- `vw_marketplace_kpi`: marketplace-level order cards.
- `vw_delivery_performance_item_level`: revenue and freight.
- `vw_delivery_performance_order_level`: delivered-order rates and delivery-day averages.

```DAX
Total Orders = SUM(vw_marketplace_kpi[total_orders])
```

```DAX
Delivered Orders = SUM(vw_marketplace_kpi[delivered_orders])
```

```DAX
Total Revenue = SUM(vw_delivery_performance_item_level[price])
```

```DAX
Total Freight Value = SUM(vw_delivery_performance_item_level[freight_value])
```

```DAX
Average Review Score = AVERAGE(vw_customer_review_analysis[avg_review_score])
```

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
Average Delivery Days = AVERAGE(vw_delivery_performance_order_level[delivery_days])
```

```DAX
Average Delay Days = AVERAGE(vw_delivery_performance_order_level[delay_days])
```

```DAX
Average Freight-to-Price Ratio =
AVERAGE(vw_delivery_performance_item_level[freight_to_price_ratio])
```

## Recommended Page Layout

Use five dashboard pages:

1. Marketplace Health Overview
2. Delivery Reliability
3. Customer Experience
4. Seller Risk & Performance
5. Product Category & Freight Economics

Keep each page focused. Avoid crowding too many charts into one page.

## Visual Selection

Recommended visuals:

- KPI cards for totals and rates
- Line charts for monthly trends
- Bar charts for category, seller, state, and payment breakdowns
- Scatter plots for seller risk matrix and delay versus review score
- Matrix or table for data quality summary
- Slicers for date, customer state, seller state, product category, and delivery status

## Slicer Suggestions

Useful slicers:

- Purchase month
- Customer state
- Seller state
- Product category
- Delivery status
- Payment type

Use slicers only where they improve interpretation.

## Formatting Principles

- Clean white background
- Dark text
- One accent color
- Minimal gridlines
- Human-readable titles
- No technical axis labels unless necessary
- Consistent spacing
- Limited visuals per page
- Clear units for currency, rates, and days
- Top N filters for crowded category or seller charts

## Screenshot Export Checklist

This guide is preparation only. Do not claim a `.pbix` file or screenshots exist until they are manually created and reviewed.

Before exporting screenshots:

- Hide visual header icons.
- Avoid hover lines in screenshots.
- Use readable chart titles.
- Use Top N filters for crowded charts.
- Check SQL totals against Power BI totals.
- Confirm slicers are in a neutral default state.
- Confirm no local server names or private paths are visible.
- Export one clean screenshot per dashboard page.

Target screenshot filenames after export:

- `01_marketplace_health_overview.png`
- `02_delivery_reliability.png`
- `03_customer_experience.png`
- `04_seller_risk_performance.png`
- `05_product_freight_economics.png`

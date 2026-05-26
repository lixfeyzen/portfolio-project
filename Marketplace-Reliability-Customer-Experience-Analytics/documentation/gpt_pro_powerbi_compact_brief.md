# GPT Pro Compact Brief: Power BI Dashboard Planning

Use this single file in GPT Pro if uploading many project files is inconvenient. It contains the essential project context, computed results, data quality cautions, available SQL views, and one complete prompt for Power BI dashboard planning.

## Project Context

Project title:
Marketplace Reliability & Customer Experience Analytics

Project type:
SQL Server and Power BI portfolio project.

Dataset:
Olist Brazilian E-Commerce Public Dataset.

Tools:
SQL Server, SQL Server Management Studio, Power BI Desktop, GitHub.

Main business question:
How do delivery performance, seller reliability, freight cost, payment behavior, and product categories relate to customer experience in a marketplace?

Positioning:
This is not a generic e-commerce sales dashboard. It is a decision-oriented marketplace reliability case study. The project evaluates marketplace health through operational reliability, customer experience signals, seller risk, freight burden, product category quality, payment behavior, and data quality.

Core analytical narrative:
- Revenue shows marketplace scale.
- Delivery reliability shows operational quality.
- Review score is a proxy for customer experience.
- Seller performance shows account-level operational risk.
- Freight-to-price ratio shows shipping burden.
- Data quality determines how much the analysis can be trusted.

## Important Analytical Rules

- Do not claim late delivery causes lower review scores.
- Late delivery may only be described as appearing associated with lower review scores.
- Do not invent findings beyond the computed results below.
- Use careful wording such as "appears associated", "suggests", "requires review", "should be monitored", and "requires further investigation".
- Review score is a customer experience proxy, not a perfect satisfaction measure.
- Product revenue, freight value, and payment value must be kept separate unless explicitly reconciled.
- Be careful with grain:
  - order-level views are for order and delivery analysis
  - item-level views are for revenue, seller, product, and freight analysis
  - payment-level views are separate to avoid double-counting

## Computed Results From SQL

These results were produced after loading the Olist CSV files into SQL Server and creating reporting views.

| Metric | Value |
|---|---:|
| Total orders | 99,441 |
| Delivered orders | 96,470 |
| Product revenue | 13,591,643.70 |
| Freight value | 2,251,909.54 |
| Payment value | 16,008,872.12 |
| Unique customers | 96,096 |
| Sellers | 3,095 |
| Average review score | 4.09 |
| On-time delivery rate | 91.89% |
| Late delivery rate | 8.11% |
| Average delivery days | 12.50 |
| Average delay days | -11.88 |
| On-time delivered orders average review score | 4.29 |
| Late delivered orders average review score | 2.57 |

Interpretation caution:
Late delivered orders appear associated with lower review scores in this dataset, but this project does not perform causal analysis.

## Data Quality Notes

- Delivered orders missing customer delivery date: 8.
- Orders missing approved date: 160.
- Orders without payment: 1.
- Orders without review: 768.
- Products without category: 610.
- Categories missing translation: 2.
- Duplicate order IDs in raw orders: 0.
- Negative freight rows: 0.
- Zero freight rows: 383.
- Negative payment rows: 0.
- Zero payment rows: 9.
- Review scores outside 1 to 5: 0.

Interpretation:
- Zero freight is not automatically invalid. It may represent free shipping or no freight charged.
- Zero payment requires review and should not be automatically excluded without further validation.
- Negative freight or negative payment values would be invalid if present.
- Missing reviews, missing timestamps, cancelled orders, unavailable orders, and missing categories should be disclosed as limitations.

## Available Power BI Views

Load these SQL Server views into Power BI:

- `vw_marketplace_kpi`
- `vw_delivery_performance_order_level`
- `vw_delivery_performance_item_level`
- `vw_customer_review_analysis`
- `vw_seller_performance`
- `vw_product_category_performance`
- `vw_freight_analysis`
- `vw_payment_analysis`
- `vw_data_quality_summary`

SQL Server connection:

```text
Server: localhost
Database: Marketplace_Analytics
Connection mode: Import
```

## Planned Dashboard Pages

1. Marketplace Health Overview
2. Delivery Reliability
3. Customer Experience
4. Seller Risk & Performance
5. Product Category & Freight Economics

## Suggested Dashboard Direction

The dashboard should answer:

```text
Is the marketplace reliable, not just large?
```

Recommended focus:
- Start with marketplace health and reliability KPIs.
- Make delivery reliability the main operational story.
- Show review score as a customer experience signal.
- Identify sellers with high revenue and high late delivery risk.
- Compare product categories by revenue, review score, late delivery rate, and freight burden.
- Include data quality so the analysis feels credible and realistic.

Avoid:
- treating this as only a sales dashboard
- overloading the first page with too many visuals
- mixing product revenue and payment value without explanation
- claiming causality between delivery delay and review score
- hiding data quality issues

## Full GPT Pro Prompt

Copy and paste the prompt below into GPT Pro after uploading this file.

```text
You are a senior Power BI dashboard architect, BI hiring manager, and analytics portfolio reviewer.

I want you to fully lead the Power BI planning and critique for my portfolio project.

Use the uploaded compact brief as the source of truth.

Project title:
Marketplace Reliability & Customer Experience Analytics

Project positioning:
This is not a generic e-commerce sales dashboard. It is a decision-oriented marketplace reliability analytics project.

The dashboard should evaluate:
- delivery performance
- seller reliability
- customer review behavior
- freight burden
- product category quality
- payment behavior
- data quality

Main business question:
How do delivery performance, seller reliability, freight cost, payment behavior, and product categories relate to customer experience in a marketplace?

Important analytical rules:
- Do not claim late delivery causes lower review scores.
- You may only say late delivery appears associated with lower review scores if supported by the uploaded computed results.
- Do not invent findings beyond the uploaded compact brief.
- Keep product revenue, freight value, and payment value separate unless explicitly reconciling them.
- Respect view grain so the dashboard avoids double-counting.
- Use professional, realistic wording suitable for a BI portfolio.

Your task:
Design the best possible Power BI dashboard plan for this project.

Please provide:
1. The strongest dashboard story and executive narrative.
2. The best dashboard page order.
3. For each page:
   - page purpose
   - KPI cards
   - visuals
   - chart type
   - fields to use
   - filters and slicers
   - insight callouts
   - layout guidance
4. Exact visual titles that sound professional and recruiter-friendly.
5. Recommended DAX measures with names and formulas.
6. Recommended slicers across the report.
7. Recommended color/style direction for a clean portfolio dashboard.
8. What to avoid so the dashboard does not look like a generic e-commerce sales report.
9. What to simplify if I have limited time.
10. What would make the dashboard look more senior and decision-oriented.
11. How to explain the dashboard to recruiters and hiring managers.
12. A beginner-friendly step-by-step build workflow in Power BI Desktop.
13. A final quality checklist before exporting screenshots and publishing to GitHub.

Please format your answer so I can directly follow it while building the dashboard in Power BI Desktop.
Use clear sections, concise tables, and practical instructions.
```

## Follow-Up Prompt

Use this after GPT Pro gives the first dashboard plan:

```text
Now critique your own dashboard plan as a senior BI hiring manager.

Tell me:
1. Which parts would impress a recruiter or BI hiring manager?
2. Which parts still look weak, generic, or overcomplicated?
3. Which visuals should be removed or simplified?
4. Which insights should be emphasized more carefully?
5. What should I build first if I only have limited time?
6. What would make this dashboard look more senior and decision-oriented?
7. What wording should I avoid in the dashboard and case study?
8. What final checklist should I use before adding screenshots to GitHub?
```

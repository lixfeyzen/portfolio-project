# GPT Pro Power BI Review Prompt

Use this prompt in GPT Pro after uploading the project context files listed below. The goal is to make GPT Pro act as the main dashboard strategy and review partner, while the local project files remain the source of truth.

## Files To Upload

Upload these files to GPT Pro:

- `README.md`
- `project_brief.md`
- `documentation/computed_findings.md`
- `documentation/data_profile_summary.md`
- `documentation/data_quality_notes.md`
- `documentation/metric_dictionary.md`
- `documentation/dashboard_page_notes.md`
- `documentation/powerbi_build_guide.md`
- `documentation/powerbi_measures.md`
- `documentation/data_model_notes.md`
- `case-study/Marketplace_Reliability_Customer_Experience_Case_Study.md`
- `sql/06_powerbi_query_reference.sql`

Do not upload raw CSV files unless there is a specific reason. GPT Pro can review the dashboard plan using the computed findings and documentation.

## Do Not Upload

- `data/raw/*.csv`
- `.pbix` files
- fake screenshots
- local SQL execution logs unless specifically needed

## Full Prompt

```text
You are a senior Power BI dashboard architect, BI hiring manager, and analytics portfolio reviewer.

I want you to fully lead the Power BI planning and critique for my portfolio project.

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

Dataset:
Olist Brazilian E-Commerce Public Dataset.

Tools:
SQL Server, SQL Server Management Studio, Power BI Desktop, GitHub.

Main business question:
How do delivery performance, seller reliability, freight cost, payment behavior, and product categories relate to customer experience in a marketplace?

Core analytical narrative:
Marketplace performance should not be evaluated by revenue alone.

Revenue shows scale.
Delivery reliability shows operational quality.
Review score is a proxy for customer experience.
Seller performance shows account-level operational risk.
Freight-to-price ratio shows shipping burden.
Data quality determines how much we can trust the analysis.

Important analytical rules:
- Do not claim that late delivery causes lower review scores.
- You may say late delivery appears associated with lower review scores if the data supports it.
- Do not invent findings beyond the uploaded files and computed results.
- Do not overclaim.
- Use careful wording such as "appears associated", "suggests", "requires review", "should be monitored", and "requires further investigation".
- Treat review score as a customer experience proxy, not a perfect satisfaction measure.
- Keep product revenue, freight value, and payment value separate unless explicitly reconciling them.
- Respect grain: order-level views, item-level views, and payment-level views should not be mixed in ways that double-count revenue.

Computed results from SQL:
- Total orders: 99,441
- Delivered orders: 96,470
- Product revenue: 13,591,643.70
- Freight value: 2,251,909.54
- Payment value: 16,008,872.12
- Unique customers: 96,096
- Sellers: 3,095
- Average review score: 4.09
- On-time delivery rate: 91.89%
- Late delivery rate: 8.11%
- Average delivery days: 12.50
- Average delay days: -11.88
- On-time delivered orders average review score: 4.29
- Late delivered orders average review score: 2.57

Data quality notes:
- Zero freight rows are not automatically invalid. They may represent free shipping or no freight charged.
- Zero payment rows require review and should not be automatically excluded without further validation.
- Negative freight or negative payment values should be treated as invalid if present.
- Missing reviews, missing delivery timestamps, missing categories, cancelled orders, unavailable orders, and orders without payment affect interpretation.

Planned Power BI pages:
1. Marketplace Health Overview
2. Delivery Reliability
3. Customer Experience
4. Seller Risk & Performance
5. Product Category & Freight Economics

Available Power BI views:
- vw_marketplace_kpi
- vw_delivery_performance_order_level
- vw_delivery_performance_item_level
- vw_customer_review_analysis
- vw_seller_performance
- vw_product_category_performance
- vw_freight_analysis
- vw_payment_analysis
- vw_data_quality_summary

Your task:
Design the best possible Power BI dashboard plan for this portfolio project.

Please provide:
1. The strongest dashboard story and executive narrative.
2. The best dashboard page order.
3. For each page:
   - page purpose
   - recommended KPI cards
   - recommended visuals
   - chart type
   - fields to use
   - filters and slicers
   - suggested insight callouts
   - layout guidance
4. Exact visual titles that sound professional and recruiter-friendly.
5. Recommended DAX measures, with clear names and formulas.
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

## Follow-Up Prompt For GPT Pro

After GPT Pro gives the first plan, use this follow-up:

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

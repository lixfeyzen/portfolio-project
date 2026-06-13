# Executive Brief — Marketplace Reliability & Customer Experience

> An executive layer on top of the SQL + Power BI analysis. Where the case study *describes* marketplace health, this brief *quantifies the business stakes, ranks the risk, and recommends action* — the decision-maker's view. All figures are in the dataset's currency (BRL) and derived from the SQL validation outputs in `documentation/computed_findings.md`.

---

## 1. Executive summary

The marketplace looks healthy on revenue (99,441 orders, ~R$16.0M payments, 4.09 average review). But reliability — not revenue — is the risk: **8.11% of deliveries are late, and late orders carry an average review of 2.57 vs 4.29 for on-time** — a 1.7-point satisfaction gap concentrated in a small, identifiable set of sellers. I estimate late deliveries put **~R$130k–R$380k of repeat revenue at risk** (model below) and recommend a seller-level SLA intervention on the top-risk sellers, expected to recover the majority of that exposure at low effort.

## 2. Headline findings

| Finding | Evidence | So what |
| --- | --- | --- |
| Late delivery is the dominant satisfaction driver | Late review 2.57 vs on-time 4.29 (n=7,826 late) | Reliability, not price, is the lever on CSAT |
| Risk is concentrated, not diffuse | 10 sellers combine high revenue with 9–17% late rates | A small, targetable intervention surface |
| Some categories carry structural freight cost | freight-to-price up to 0.93 (home_comfort_2), 0.68 (electronics) | Freight may suppress conversion & reviews |
| Decision data needs cleanup first | 768 missing reviews; R$165k payment-vs-(revenue+freight) gap | Don't run finance decisions on it until reconciled |

## 3. Business impact — revenue at risk (quantified, with assumptions)

Late deliveries depress reviews; low reviews depress repurchase. Translating that into money:

**Inputs (from data):** Average order value (AOV) = R$16,008,872 ÷ 99,441 = **R$161**. Late orders = **7,826**.

**Model:** `At-risk repeat revenue = late_orders × AOV × incremental_churn × additional_orders_if_retained`

**Stated assumptions:** `additional_orders_if_retained = 1` (conservative for a marketplace); `incremental_churn` from a poor delivery experience tested across a range. This is an **illustrative** estimate to size the opportunity, not a forecast.

| Incremental churn from a late delivery | At-risk repeat revenue |
| --- | ---: |
| 10% | ~R$126,000 |
| 20% | ~R$252,000 |
| 30% | ~R$378,000 |

**Improvement scenario:** cutting the late rate from 8.11% to a 5% target moves ~3,000 orders from late to on-time, protecting **~R$48k–R$145k** by the same model.

## 4. Seller Risk Scorecard (a reusable framework)

Rather than a one-off list, this is a scoring method the operations team can re-run each period.

`Risk score = 0.45 × Revenue exposure + 0.35 × Late-rate risk + 0.20 × Review risk` (each component min-max normalized, scaled 0–100).

Tiers: **Critical ≥ 65 · High 60–65 · Medium 45–60 · Watch < 45.**

| Rank | Seller (id prefix) | State | Revenue | Late rate | Review | Risk score | Tier |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| 1 | 4869f7 | SP | 226,988 | 11.59% | 4.14 | 73 | Critical |
| 2 | 4a3ca9 | SP | 196,882 | 10.98% | 3.83 | 67 | Critical |
| 3 | 7c67e1 | SP | 186,570 | 9.59% | **3.35** | 64 | High |
| 4 | fa1c13 | SP | 190,917 | 10.19% | 4.37 | 62 | High |
| 5 | f7ba60 | SP | 68,070 | **16.59%** | 4.22 | 52 | Medium |

*Interpretation:* sellers 1–2 are Critical because they pair the **largest revenue exposure** with above-average late rates; seller 3 escalates on the **lowest review score**; seller 5 is the worst on pure operations (16.59% late) but lower exposure. The framework deliberately weights revenue highest so effort follows money at risk.

## 5. Prioritized recommendations

| # | Action | Rationale | Impact | Effort | Priority |
| --- | --- | --- | --- | --- | --- |
| 1 | Put the 2 Critical + 2 High sellers on an enforced delivery SLA with weekly review | Concentrated revenue + late risk; fastest payback | High | Low | **P1** |
| 2 | Operationalize the Seller Risk Scorecard as a monthly watchlist | Turns a one-off finding into ongoing control | High | Med | **P1** |
| 3 | Review high freight-to-price categories (electronics, home_comfort_2) | Freight may be suppressing conversion & reviews | Med | Low | P2 |
| 4 | Reconcile the R$165k payment gap and fill 768 missing reviews before financial reporting | Protects trust in the numbers | Med | Low | P2 |
| 5 | Drive late rate 8.11% → 5% via carrier/seller intervention in São Paulo (where risk concentrates) | Largest structural upside | High | High | P3 |

## 6. Limitations & assumptions

- **Correlation, not causation.** Late delivery is *associated* with lower reviews here; other factors (product, seller) may contribute. The revenue model sizes an opportunity, it does not prove a causal lift.
- **Illustrative economics.** AOV is treated as flat; churn and repeat-rate are assumptions tested via sensitivity, not measured from a longitudinal cohort (the dataset is largely single-purchase).
- **Data caveats (cleanup first).** 768 orders lack reviews, 160 lack an approved date, and payments exceed revenue+freight by R$165k — these are flagged for reconciliation before the figures drive spend.
- **Public dataset.** Olist Brazilian E-Commerce; findings illustrate method and judgment, not a live business.

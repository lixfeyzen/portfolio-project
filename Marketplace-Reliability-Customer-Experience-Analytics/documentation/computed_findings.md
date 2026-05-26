# Computed Findings

Source: SQL Server validation outputs generated from the Olist CSV files.

Status: SQL import, cleaning views, analysis views, and validation queries completed successfully.

## Marketplace KPI Snapshot

| Metric | Value |
| --- | ---: |
| Total orders | 99,441 |
| Delivered orders used for delivery reliability | 96,470 |
| Total product revenue | 13,591,643.70 |
| Total freight value | 2,251,909.54 |
| Total payment value | 16,008,872.12 |
| Unique customers | 96,096 |
| Sellers | 3,095 |
| Average review score | 4.09 |
| On-time delivery rate | 91.89% |
| Late delivery rate | 8.11% |
| Average delivery days | 12.50 |
| Average delay days | -11.88 |

## Delivery And Review Pattern

| Delivery status | Delivered orders | Average review score | Average delay days |
| --- | ---: | ---: | ---: |
| On Time | 88,644 | 4.29 | -13.71 |
| Late | 7,826 | 2.57 | 8.87 |

Late delivered orders appear associated with lower average review scores in this dataset. This is descriptive and does not establish causality.

## Top Product Categories By Revenue

| Product category | Orders | Revenue | Late delivery rate | Avg review score | Avg freight-to-price ratio |
| --- | ---: | ---: | ---: | ---: | ---: |
| health_beauty | 8,647 | 1,233,131.72 | 9.05% | 4.19 | 0.3012 |
| watches_gifts | 5,493 | 1,165,898.98 | 8.28% | 4.07 | 0.1712 |
| bed_bath_table | 9,272 | 1,023,434.76 | 8.40% | 3.92 | 0.2841 |
| sports_leisure | 7,529 | 954,673.55 | 7.41% | 4.17 | 0.2936 |
| computers_accessories | 6,529 | 888,613.62 | 7.77% | 3.99 | 0.2949 |
| furniture_decor | 6,307 | 711,927.69 | 8.43% | 3.95 | 0.3459 |
| housewares | 5,743 | 615,628.69 | 6.49% | 4.11 | 0.4030 |
| cool_stuff | 3,559 | 610,204.10 | 6.75% | 4.19 | 0.2203 |
| auto | 3,809 | 578,849.35 | 8.29% | 4.12 | 0.3320 |
| toys | 3,803 | 471,097.49 | 7.42% | 4.21 | 0.2651 |

## High Revenue Sellers With Operational Risk Segment

| Seller ID | State | Orders | Revenue | Late delivery rate | Avg review score |
| --- | --- | ---: | ---: | ---: | ---: |
| 4869f7a5dfa277a7dca6462dcf3b52b2 | SP | 1,124 | 226,987.93 | 11.59% | 4.14 |
| 4a3ca9315b744ce9f8e9374361493884 | SP | 1,772 | 196,882.12 | 10.98% | 3.83 |
| fa1c13f2614d7b5c4749cbc52fecda94 | SP | 578 | 190,917.14 | 10.19% | 4.37 |
| 7c67e1448b00f6e969d365cea6b010ab | SP | 973 | 186,570.05 | 9.59% | 3.35 |
| 1025f0e2d44d7041d6cf58b6550e0bfa | SP | 910 | 138,208.56 | 9.23% | 3.87 |
| 620c87c171fb2a6dd6e8bb4dec959fc6 | RJ | 722 | 112,461.50 | 9.51% | 4.27 |
| 7d13fca15225358621be4086e1eb0964 | SP | 558 | 112,436.18 | 11.91% | 4.02 |
| 1f50f920176fa81dab994f9023523100 | SP | 1,399 | 106,655.71 | 9.45% | 3.99 |
| f7ba60f8c3f99e7ee4042fdef03b70c4 | SP | 218 | 68,070.00 | 16.59% | 4.22 |
| fe2032dab1a61af8794248c8196565c9 | SP | 293 | 65,689.71 | 8.52% | 4.40 |

These sellers should be monitored because they combine meaningful revenue with above-average late delivery risk.

## Categories With High Freight-To-Price Ratio

| Product category | Orders | Revenue | Avg freight-to-price ratio | Avg review score | Late delivery rate |
| --- | ---: | ---: | ---: | ---: | ---: |
| home_comfort_2 | 24 | 760.27 | 0.9339 | 3.63 | 16.67% |
| dvds_blu_ray | 56 | 4,542.59 | 0.8356 | 4.18 | 6.56% |
| electronics | 2,517 | 155,043.93 | 0.6839 | 4.07 | 9.75% |
| christmas_supplies | 125 | 8,737.84 | 0.6755 | 4.07 | 12.00% |
| flowers | 29 | 1,110.04 | 0.5650 | 4.42 | 3.03% |
| fashion_underwear_beach | 117 | 9,305.95 | 0.5512 | 4.05 | 12.60% |
| signaling_and_security | 138 | 21,315.05 | 0.5500 | 4.09 | 5.58% |
| telephony | 4,093 | 309,860.23 | 0.5076 | 3.99 | 8.33% |
| food_drink | 221 | 14,942.88 | 0.4916 | 4.37 | 6.32% |
| furniture_mattress_and_upholstery | 37 | 4,323.38 | 0.4723 | 3.89 | 13.51% |

Some high freight-to-price categories have low order volume, so they should be reviewed carefully before making broad business decisions.

## Data Quality Notes

| Check | Value | Interpretation |
| --- | ---: | --- |
| Delivered orders missing customer delivery date | 8 | Requires review before delivery reliability reporting. |
| Orders missing approved date | 160 | Should be investigated for fulfillment sequence analysis. |
| Orders without payment | 1 | Requires payment reconciliation review. |
| Orders without review | 768 | Reduces review coverage. |
| Products without category | 610 | Grouped as `Unknown` in category analysis. |
| Product categories missing translation | 2 | Falls back to original category name. |
| Duplicate order IDs in raw orders | 0 | No duplicate order IDs found in `raw_orders`. |
| Negative freight rows | 0 | No negative freight values found. |
| Zero freight rows | 383 | Not automatically invalid; may represent free shipping or no freight charged. |
| Negative payment value rows | 0 | No negative payment values found. |
| Zero payment value rows | 9 | Requires review; not automatically invalid. |
| Review scores outside 1 to 5 | 0 | No invalid review scores found. |

## Payment Reconciliation Note

Product revenue plus freight value equals 15,843,553.24, while total payment value equals 16,008,872.12. The difference is 165,318.88 and should be reconciled before using payment value as a replacement for product revenue plus freight.


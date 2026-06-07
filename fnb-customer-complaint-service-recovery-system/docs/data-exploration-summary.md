# Data Exploration Summary

## Purpose

This document summarizes the initial data layer for the **F&B Customer Complaint & Service Recovery Management System**.

The goal is not to build a large dashboard. The goal is to use complaint data structure and sample complaint patterns to justify a service recovery workflow: complaint intake, triage, SLA, assignment, investigation, resolution, approval, and repeat-issue monitoring.

## Source dataset

Primary source: **NYC Open Data — 311 Service Requests from 2020 to Present**  
Dataset page: https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9

The official dataset contains service request records with fields such as complaint type, responding agency, location grouping, status, due date, resolution description, and submission channel. For public repository safety, the local sample removes street-level address and exact coordinate fields.

## Local sample design

| Item | Value |
|---|---:|
| Sample records | 24 |
| Sample period | 2026-05-24 to 2026-06-05 |
| Data grain | One complaint / service request record |
| Focus | Food establishment complaint scenarios |
| Privacy handling | No customer identity, street address, latitude, longitude, or establishment name |

## Fields used

| Field | Reason used |
|---|---|
| `sample_record_id` | Anonymized complaint identifier |
| `source_request_code` | Generalized source request reference |
| `created_date`, `closed_date`, `due_date` | Used for SLA and response time analysis |
| `agency` | Responding agency reference |
| `complaint_type` | Main complaint category |
| `descriptor` | Complaint detail used for triage |
| `location_type` | Helps identify restaurant/bar/deli/bakery context |
| `status` | Current service request status |
| `borough` | General location grouping, not exact address |
| `open_data_channel_type` | Complaint intake channel |
| `outlet_code` | Anonymized outlet reference for repeat issue monitoring |
| `complaint_category` | Analyst-defined triage category |
| `proposed_severity` | Simplified triage level for MVP |
| `sla_status` | On-time, late, or overdue condition |
| `response_hours` | Approximate response/closure duration for closed cases |
| `ticket_candidate` | Whether the complaint should become a service recovery ticket |
| `suggested_owner` | Initial owner role suggestion for workflow routing |

## Basic profile

### Status distribution

| Status | Records |
|---|---:|
| Closed | 14 |
| In Progress | 7 |
| Open | 3 |

### Complaint category distribution

| Complaint category | Records |
|---|---:|
| Pest Control | 4 |
| Sanitation | 3 |
| Food Handling | 3 |
| Temperature Control | 2 |
| Hygiene | 2 |
| Facility Maintenance | 2 |
| Waste / Sewage | 2 |
| Employee Health | 1 |
| Permit / Documentation | 1 |
| Food Quality | 1 |
| Facility Control | 1 |
| Storage Practice | 1 |
| Odor / Spoilage | 1 |

### Severity distribution

| Severity | Records |
|---|---:|
| High | 10 |
| Critical | 9 |
| Medium | 5 |

### SLA status distribution

| SLA status | Records |
|---|---:|
| Closed on time | 11 |
| Open overdue | 9 |
| Closed late | 3 |
| Open within SLA | 1 |

### Channel distribution

| Channel | Records |
|---|---:|
| Online | 12 |
| Phone | 6 |
| Mobile | 6 |

### Suggested owner distribution

| Suggested owner | Records |
|---|---:|
| Outlet Manager | 10 |
| Outlet Manager + QA | 9 |
| Outlet Manager + Area Manager | 4 |
| Area Manager + QA | 1 |

## Sample metrics

| Metric | Value |
|---|---:|
| Total sample records | 24 |
| Service recovery candidates | 20 |
| Monitor-only records | 4 |
| Critical / High severity records | 19 |
| Open overdue records | 9 |
| Closed late records | 3 |
| Closed records with response time | 14 |
| Average response time for closed records | 53.21 hours |
| Median response time for closed records | 30.2 hours |

## Key observations

1. Most records are service recovery candidates because food safety, hygiene, sanitation, temperature control, and pest-related complaints need accountable follow-up.
2. Complaint descriptors need business-friendly categorization. A raw descriptor such as handwashing, roaches, food temperature, or dirty cutting boards should map into clear operational categories.
3. SLA status is central. The workflow must separate open within SLA, open overdue, closed on time, and closed late.
4. Critical and high-severity complaints need faster escalation and stronger review, especially food handling, temperature, employee health, pest control, and contamination issues.
5. Closure alone is not enough. A service recovery system should capture investigation notes, recovery action, evidence or documentation, and manager/QA review.

## Design implications

| Data finding | System implication |
|---|---|
| Complaints have status and due dates | System should track SLA and overdue tickets |
| Complaint descriptors vary by issue type | System should support internal category and severity mapping |
| High-risk categories exist | System should route high/critical tickets to QA, Outlet Manager, or Area Manager |
| Some closed cases are late | System should measure response time and SLA performance |
| Outlet codes can repeat | System should monitor repeat complaints by outlet/category |
| Complaints come from multiple channels | System should preserve source channel for service analysis |

## Candidate ticket logic

For MVP design, a complaint should become a service recovery ticket when it meets at least one condition:

- food safety, hygiene, sanitation, product quality, or facility risk;
- high or critical severity;
- open overdue;
- closed late;
- repeated complaint category for the same outlet or area.

## Design decision

The next analysis should not expand into a full CRM. The MVP should focus on one workflow:

```text
Complaint received
→ categorized
→ severity and SLA assigned
→ service recovery ticket created
→ PIC assigned
→ investigation started
→ recovery action submitted
→ manager/QA review
→ closed or reworked
→ repeat issue monitored
```

## Limitation

This sample is intentionally small and anonymized/generalized. It is used to support system analysis, not to claim a city-wide statistical conclusion. In a real implementation, the same logic should be tested on a larger extract and validated with Customer Service, Operations, QA, Outlet Managers, and Area Managers.

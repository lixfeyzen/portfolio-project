# Data Exploration Summary

## Purpose

This document explains how the public food inspection data supports the need for a corrective action workflow system.

The goal is not to build a complex analytics project. The goal is to use data as evidence for system analysis:

> inspection records show the issue; the proposed system ensures the issue is assigned, fixed, reviewed, and monitored.

## Dataset Source

**Primary dataset:** City of Chicago Food Inspections Dataset  
**Source link:** https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5

The dataset contains inspection records for restaurants and other food establishments. The fields used in this project include inspection result, facility type, risk level, inspection date, inspection type, violation notes, and location fields. The local sample removes business names and street addresses.

## Working Sample

For repository readability, this project stores a small anonymized working sample instead of the full raw dataset.

**Sample file:** `../data/sample-food-inspections.csv`  
**Sample size:** 18 recent public API records  
**Sample period:** 2026-05-26 to 2026-06-05  
**Purpose:** demonstrate the data-to-system logic before designing workflow, requirements, ERD, and UAT.

The full dataset should be downloaded directly from the official source when running the analysis at full scale.

## Fields Used

| Field | Use in This Project |
|---|---|
| sample_record_id | Local row identifier for the anonymized sample. |
| establishment_code | Anonymized establishment code used for repeat issue logic. |
| facility_type | Helps define MVP focus and segmentation. |
| risk | Used for priority and due date rule. |
| inspection_date | Used for ticket creation date and monitoring period. |
| inspection_type | Helps identify complaint, canvass, license, or re-inspection context. |
| results | Main trigger for corrective action. |
| violation_summary | Human-readable problem summary. |
| violation_category | Simple classification for ticket category. |
| ticket_candidate | Whether the record should create a ticket, be monitored, or be ignored. |
| proposed_priority | Initial priority based on result and risk level. |

## Sample Findings

### 1. Inspection Result Distribution

| Inspection Result | Sample Count |
|---|---:|
| Pass | 9 |
| Pass w/ Conditions | 5 |
| Fail | 4 |

**Interpretation:** Fail and Pass w/ Conditions are direct candidates for corrective action workflow. Pass records may still be monitored if violation notes exist.

### 2. Risk Distribution

| Risk Level | Sample Count |
|---|---:|
| Risk 1 (High) | 16 |
| Risk 3 (Low) | 1 |
| Risk 2 (Medium) | 1 |

**Interpretation:** Most actionable sample records are Risk 1 / High. This supports using risk level as an input for priority and SLA rules.

### 3. Facility Type Distribution

| Facility Type | Sample Count |
|---|---:|
| Restaurant | 12 |
| Grocery Store | 2 |
| School | 1 |
| Grocery Store / Gas Station | 1 |
| Bakery | 1 |
| Long Term Care | 1 |

**Interpretation:** Restaurant records appear frequently in the working sample, which supports using restaurant operations as the MVP focus.

### 4. Corrective Action Candidate Split

| Ticket Candidate | Sample Count |
|---|---:|
| Yes | 9 |
| Monitor | 8 |
| No | 1 |

**Interpretation:** Records with Fail or Pass w/ Conditions should trigger ticket creation or review. Pass records with violation notes can be monitored but do not need the same urgency.

### 5. Common Violation Categories in Sample

| Violation Category Keyword | Sample Count |
|---|---:|
| Handwashing | 6 |
| Facility Cleanliness | 5 |
| Plumbing | 3 |
| Labeling | 3 |
| Certification | 3 |
| Pest Control | 3 |
| Equipment | 2 |
| Employee Training | 2 |
| Cleanliness | 2 |
| Training | 2 |
| Food Storage | 1 |
| Personal Cleanliness | 1 |
| Warewashing | 1 |
| Waste Management | 1 |
| Contamination Prevention | 1 |
| Ventilation | 1 |
| Follow-Up | 1 |

**Interpretation:** The violation notes are text-heavy and operational. The system should support violation categorization, not just store raw notes.

## Data-to-System Logic

| Data Signal | System Response |
|---|---|
| Result = Fail | Create corrective action ticket automatically. |
| Result = Pass w/ Conditions | Create review item or conditional corrective action ticket. |
| Risk = Risk 1 / High | Assign high priority and shorter due date. |
| Violation contains pest / handwashing / temperature / sanitation / training issue | Classify ticket category for QA review. |
| Same establishment code has repeated failed/conditional records | Flag repeat issue and escalate to Area Manager / QA. |

## Business Insight

The dataset provides inspection results and violation notes, but the raw data does not provide an internal follow-up workflow.

A business still needs to answer:

- Who owns the fix?
- What is the deadline?
- What evidence proves the issue was fixed?
- Who approves closure?
- Which outlets have repeated issues?
- Which corrective actions are overdue?

This gap supports the proposed system:

> Restaurant Inspection Corrective Action Management System.

## Requirement Impact

| Requirement ID | Requirement Direction | Data Evidence |
|---|---|---|
| FR-01 | Import inspection records | Public inspection dataset fields. |
| FR-02 | Identify Fail / Pass w/ Conditions records | `results` field. |
| FR-03 | Review violation details before ticket confirmation | `violation_summary` and `violation_category`. |
| FR-04 | Create corrective action ticket | Fail and conditional records. |
| FR-05, FR-06 | Assign PIC, due date, and priority | `risk`, `results`, and proposed priority logic. |
| FR-07, FR-08 | Support evidence submission and QA review | Missing from raw data; required by the target workflow. |
| FR-10, FR-11, FR-12 | Monitor overdue and repeated issues | Establishment code, date, result, category, and ticket status logic. |

## Reproducibility Note

The included SQL files are designed to reproduce this exploration after importing the local anonymized sample CSV:

- `../sql/create-staging-table.sql`
- `../sql/analysis-queries.sql`

The sample CSV is intentionally small to keep the repository lightweight. For full-scale analysis, download the official dataset directly and map the source fields into the same clean-view structure.

## Scope Boundary

The data exploration is intentionally narrow. It supports one System Analyst decision:

> Design a workflow that converts inspection violations into corrective actions with ownership, due date, evidence, QA approval, and monitoring.

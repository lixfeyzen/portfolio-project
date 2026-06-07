# Case Brief and Sources

## Project Title

**Restaurant Inspection Corrective Action Management System**

## Overview

This project designs a corrective action workflow for restaurant inspection findings.

The starting point is simple: public inspection data can show whether a food establishment passed, failed, or received a conditional result. For an operator, the next question is more operational: how should each issue be assigned, fixed, verified, and monitored?

The proposed system turns inspection findings into corrective action tickets with an owner, due date, evidence submission, QA review, and status monitoring.

This design uses public data as the reference dataset and does not contain proprietary company data.

## Case Question

How can a multi-outlet F&B operator turn inspection violations from raw inspection records into corrective actions that are assigned, tracked, verified, and monitored?

## Core Logic

> Data shows the issue.  
> The workflow makes sure the issue is followed up.

Inspection records can reveal operational problems, but the raw data does not manage the follow-up work. A business still needs ownership, deadlines, evidence, approval, and visibility.

## Real-World Sources

| Source | How it is used |
|---|---|
| City of Chicago Food Inspections Dataset | Main public dataset for inspection records, risk level, inspection result, inspection type, and violation notes. |
| NYC Health Restaurant Grades | Business context for inspection scoring, violation points, and restaurant grading. |
| FDA Inspections to Protect the Food Supply | Process context for inspection, compliance follow-up, and corrective action verification. |

Source links:

- City of Chicago Food Inspections Dataset: https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5
- City of Chicago Dataset Metadata API: https://data.cityofchicago.org/api/views/4ijn-s7e5
- NYC Health Restaurant Grades: https://www.nyc.gov/site/doh/services/restaurant-grades.page
- FDA Inspections to Protect the Food Supply: https://www.fda.gov/food/compliance-enforcement-food/inspections-protect-food-supply

## Business Context

Multi-outlet F&B operators need consistent food safety and operational standards across locations. Inspection results can highlight issues such as sanitation gaps, food handling problems, temperature control issues, pest evidence, equipment problems, or documentation gaps.

For the business, the inspection record is only the starting point. The value comes from making sure each important finding becomes a clear follow-up action.

## Business Problem

Inspection records include results and violation notes, but they do not provide an internal corrective action workflow.

| Missing Element | Business Risk |
|---|---|
| PIC / owner assignment | Accountability is unclear. |
| Due date / SLA | Follow-up can be delayed. |
| Evidence submission | QA cannot verify the correction clearly. |
| QA review | Closure may happen without proper validation. |
| Status tracking | Management cannot see what is open, overdue, or closed. |
| Repeat issue monitoring | Recurring operational risk can be missed. |

## Proposed System

The system converts inspection findings into structured corrective action tickets.

```text
Inspection finding
→ Corrective action ticket
→ Person in Charge (PIC) assignment
→ Due date
→ Evidence submission
→ QA review
→ Closure / rework
→ Monitoring
```

## Stakeholders

| Stakeholder | Need |
|---|---|
| Outlet Manager | Understand what must be fixed and submit correction evidence. |
| QA / Food Safety Team | Review violations, define follow-up actions, and approve closure. |
| Area Manager | Monitor high-risk outlets, overdue actions, and repeated issues. |
| Management | See compliance status, risk trends, and unresolved issues. |
| Developer Team | Receive clear requirements, workflow, ERD, business rules, and UAT scenarios. |

## Scope

In scope:

- Import public inspection records.
- Identify failed or conditional inspection results.
- Review violation notes.
- Create corrective action tickets.
- Assign owner and due date.
- Upload correction evidence.
- Review evidence through QA.
- Track ticket status.
- Monitor open, overdue, closed, and repeated issues.

Out of scope:

- POS system.
- Inventory management.
- Purchasing system.
- Full ERP.
- Machine learning prediction.
- Production application build.

## Assumptions

- Public inspection data is used as a realistic reference for F&B compliance workflow analysis.
- The design focuses on the corrective action process after inspection results are available.
- Severity and due-date rules are simplified for MVP planning and should be refined with real stakeholders.
- Local sample data is anonymized for repository readability.

## Expected System Outcome

| Before | After |
|---|---|
| Violation exists only as an inspection record. | Violation becomes a corrective action ticket. |
| Ownership is unclear. | Each ticket has an assigned owner. |
| No standard due date. | Each ticket has a due date based on risk or priority. |
| No centralized correction evidence. | Evidence is uploaded and linked to the ticket. |
| Closure is not clearly validated. | QA approves or rejects the correction. |
| Repeat issues are hard to monitor. | Management can monitor recurring risks. |

## System Analysis Deliverables

| Area | Output |
|---|---|
| Business process analysis | As-Is gap and To-Be corrective action workflow. |
| Workflow / SOP | SOP for violation review, ticket assignment, evidence submission, and QA approval. |
| Data modelling | ERD and data dictionary for corrective action tracking. |
| Requirements | Functional requirements, non-functional requirements, and business rules. |
| Testing | Acceptance criteria, UAT scenarios, and traceability matrix. |
| Development handoff | API discussion points, validation rules, edge cases, and timeline. |

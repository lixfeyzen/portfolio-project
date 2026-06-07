# Project Plan and Timeline

## Purpose

This document outlines a practical implementation plan for the **F&B Customer Complaint & Service Recovery Management System**.

The plan is written as a System Analyst handoff view: it shows how the work can move from source validation and business analysis into workflow design, data model preparation, UAT, and development-ready documentation.

## MVP delivery approach

The MVP focuses on one workflow:

```text
Complaint received
-> triage
-> SLA and severity
-> service recovery ticket
-> owner assignment
-> investigation
-> recovery action
-> review
-> closure or rework
-> repeat issue monitoring
```

## Timeline summary

| Day | Main work | Output |
|---:|---|---|
| 1 | Validate case, data source, and scope | Case brief and source notes |
| 2 | Prepare complaint data sample | Clean working sample and staging structure |
| 3 | Explore complaint patterns | Data exploration summary and design implications |
| 4 | Map current gaps and business needs | Gap analysis |
| 5 | Design workflow, SOP, and requirements | Target workflow, SOP, FR/NFR, business rules |
| 6 | Design ERD and data dictionary | ERD, core tables, data dictionary |
| 7 | Prepare SQL schema and developer notes | Service recovery schema and handoff notes |
| 8 | Build UAT scenarios and traceability | UAT scenarios, acceptance criteria, traceability matrix |
| 9 | Review dependencies, risks, and timeline | Project plan, backlog, risk notes |
| 10 | Final documentation review | Clean repository, diagrams, and final README |

## Work breakdown

| Workstream | Task | Owner | Duration | Main deliverable |
|---|---|---|---:|---|
| Case analysis | Validate source, scope, and business question | System Analyst | 1 day | Case brief |
| Data preparation | Prepare anonymized complaint sample | Analyst | 1 day | Sample CSV and staging SQL |
| Data analysis | Review category, SLA, severity, channel, and closure patterns | Analyst | 1 day | Data exploration summary |
| Business analysis | Convert findings into current gaps and system needs | Business/System Analyst | 1 day | Gap analysis |
| Process design | Define target workflow, SOP, status lifecycle, and roles | System Analyst | 1 day | Workflow and SOP |
| Requirements | Write user stories, FR/NFR, and business rules | System Analyst | 1 day | Requirements document |
| Data modelling | Design ERD, data dictionary, and relationships | System Analyst | 1 day | ERD and data dictionary |
| Testing | Prepare acceptance criteria, UAT, and traceability | QA + System Analyst | 1 day | UAT and traceability |
| Handoff | Prepare API outline, validation rules, and edge cases | System Analyst + Developer | 1 day | Developer handoff notes |
| Review | Clean file structure and finalize README | System Analyst | 1 day | Final repository |

## MVP backlog

| ID | Backlog item | Priority | Owner | Estimate |
|---|---|---|---|---|
| BL-01 | Import complaint record sample | Must Have | Developer | S |
| BL-02 | Identify ticket candidate complaint | Must Have | Developer | S |
| BL-03 | Map complaint category and severity | Must Have | System Analyst + Developer | M |
| BL-04 | Generate SLA due date | Must Have | Developer | M |
| BL-05 | Create service recovery ticket | Must Have | Developer | M |
| BL-06 | Assign ticket owner/PIC | Must Have | Developer | S |
| BL-07 | Submit investigation note | Must Have | Outlet Manager | S |
| BL-08 | Submit recovery action | Must Have | Outlet Manager | S |
| BL-09 | Review and approve or reject closure | Must Have | Manager / QA | M |
| BL-10 | Track status history | Must Have | Developer | M |
| BL-11 | Monitor overdue tickets | Should Have | Manager / QA | M |
| BL-12 | Flag repeat issue by outlet and category | Should Have | Manager / QA | M |
| BL-13 | Add dashboard summary | Could Have | Analyst / BI | M |

## Key risks and controls

| Risk | Impact | Control |
|---|---|---|
| Complaint descriptors are text-heavy | Category mapping can be inconsistent | Use simple category rules for MVP and refine with user feedback |
| SLA rules vary by complaint severity | Due date logic can be disputed | Document severity assumptions clearly |
| Ownership is unclear between outlet and QA | Tickets may be delayed | Define default owner routing by complaint category |
| Closure is approved without evidence | Recovery action may not be verifiable | Require review notes or evidence reference for closure |
| Repeat issues are not escalated | Root cause can recur | Add repeat issue monitoring rule |

## Planning artifact

A Gantt-style workbook is included in the repository:

```text
project-timeline-gantt.xlsx
```

The workbook contains:

- project timeline,
- MVP backlog,
- risks and controls,
- source references.

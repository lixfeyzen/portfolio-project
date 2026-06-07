# Gap Analysis

## Purpose

This document converts the initial complaint data findings into business gaps and system needs for the **F&B Customer Complaint & Service Recovery Management System**.

The goal is to keep the analysis practical: the system should not become a full CRM. It should focus on turning food-related customer complaints into accountable service recovery work.

## Input used

This gap analysis is based on:

- public 311 complaint data structure;
- NYC311 food safety complaint context;
- ISO 10002 complaint-handling guidance;
- the local anonymized working sample in `data/sample-311-food-complaints.csv`;
- the initial findings in `docs/data-exploration-summary.md`.

## Main gap statement

The complaint record captures the customer issue, but it does not fully manage the business recovery process.

A multi-outlet F&B operator needs an internal workflow that answers:

- What is the complaint category?
- How severe is it?
- Who owns the follow-up?
- What is the SLA?
- What investigation was done?
- What recovery action was taken?
- Who approved the closure?
- Is this a repeated issue?

## As-Is process

```text
Complaint received
→ Complaint recorded
→ Agency/status updated
→ Resolution note added
→ Case closed
```

This is useful as a public service request record, but it is not enough for internal F&B service recovery because it does not enforce outlet ownership, investigation detail, manager/QA review, or repeat-issue escalation.

## To-Be need

```text
Complaint received
→ Complaint categorized
→ Severity and SLA assigned
→ Service recovery ticket created
→ Outlet/PIC assigned
→ Investigation started
→ Recovery action submitted
→ Manager/QA review
→ Closed or reworked
→ Repeat issue monitored
```

## Gap matrix

| Current condition | Business pain | System need | Priority |
|---|---|---|---|
| Complaints are stored as records | Follow-up can depend on manual handling | Create a service recovery ticket for relevant complaints | Must have |
| Complaint descriptors are text-heavy | Different users may interpret the issue differently | Standardize internal complaint category and severity | Must have |
| SLA exists in the source data | SLA may not be translated into internal action ownership | Track due date, SLA status, and overdue flag | Must have |
| Owner is not always explicit for outlet-level action | Outlet accountability can be unclear | Assign PIC, owner team, and escalation owner | Must have |
| Closed status may only show external case closure | Internal recovery quality may not be verified | Require investigation note and recovery action before closure | Must have |
| Resolution note is not structured | Hard to compare recovery quality across outlets | Store recovery action type, evidence note, and review decision | Should have |
| Repeat issues are not immediately visible | Recurring outlet problems can be missed | Monitor repeat complaints by outlet, category, and severity | Should have |
| Complaints arrive from multiple channels | Channel-level service patterns can be ignored | Preserve complaint intake channel for monitoring | Should have |
| Critical/high issues may need faster action | Delayed response increases service and safety risk | Severity-based SLA and escalation rule | Must have |
| Manual updates can be inconsistent | Management cannot easily audit progress | Status history and audit trail | Should have |

## Business impact of the gaps

| Gap area | Possible impact |
|---|---|
| No clear owner | Complaint recovery becomes slow or inconsistent |
| No severity rule | Critical hygiene or food safety issues may be treated like normal service complaints |
| No SLA monitoring | Open overdue complaints may not be escalated early |
| No review step | Tickets can be closed without enough evidence or manager validation |
| No repeat monitoring | Management may miss outlets with recurring issues |
| No structured recovery data | Hard to measure service recovery effectiveness |

## Prioritization logic

The MVP should prioritize gaps that directly affect accountability and follow-up speed.

| Priority | Included in MVP | Reason |
|---|---|---|
| P1 | Ticket creation from complaint | Core workflow object |
| P1 | Category and severity mapping | Needed for triage and routing |
| P1 | SLA and overdue tracking | Needed for service recovery control |
| P1 | PIC / owner assignment | Needed for accountability |
| P1 | Status lifecycle | Needed for progress visibility |
| P1 | Investigation and recovery action | Needed before closure |
| P2 | Manager / QA review | Needed for high-risk or food-safety complaints |
| P2 | Repeat complaint monitoring | Needed for outlet risk visibility |
| P3 | Dashboard and trend analysis | Useful after stable workflow data exists |
| P3 | Customer notification message formats | Useful future enhancement, not core analysis scope |

## User need mapping

| User / role | Need | System response |
|---|---|---|
| Customer Service | Know which complaints need follow-up | Triage queue and ticket creation |
| Outlet Manager | Understand assigned complaint and required action | Assigned ticket view with due date and investigation fields |
| Area Manager | See overdue and repeated outlet issues | Escalation list and repeat issue monitoring |
| QA / Operations | Review hygiene, food safety, and high-severity complaints | Review queue and approval decision |
| Management | Track complaint recovery performance | SLA, closure, overdue, and repeat issue summary |
| Developer Team | Understand data objects and workflow logic | Requirements, ERD, validation rules, and UAT scenarios |

## System capability direction

The gap analysis leads to the following system capabilities:

| Capability | Description |
|---|---|
| Complaint intake | Import or register complaint records from source channels |
| Triage | Map complaint type and descriptor into internal category and severity |
| SLA control | Assign due date and track open, overdue, closed on time, or closed late status |
| Ticket workflow | Convert relevant complaints into service recovery tickets |
| Assignment | Assign owner role, outlet/PIC, and escalation owner if needed |
| Investigation | Capture root cause notes, outlet finding, and recovery action |
| Review | Allow manager/QA to approve or reject ticket closure |
| Status history | Store every status movement for auditability |
| Repeat monitoring | Flag repeated outlet/category issues for management review |

## MVP boundary

The MVP should stop at service recovery workflow management.

### Included

- complaint record import/sample;
- triage category and severity;
- ticket creation;
- SLA and overdue tracking;
- PIC assignment;
- investigation and recovery action;
- manager/QA review;
- repeat issue monitoring.

### Not included

- full CRM;
- POS integration;
- loyalty integration;
- refund engine;
- chatbot;
- social media scraping;
- production mobile app.

## Requirement direction

The next document should translate these gaps into:

- workflow and SOP;
- user stories;
- functional requirements;
- non-functional requirements;
- business rules;
- monitoring needs.

## Key takeaway

The strongest system need is not more complaint data. The need is a controlled workflow that turns complaints into accountable recovery work.

**Complaint data shows the issue. Service recovery workflow makes the issue owned, tracked, reviewed, and closed properly.**

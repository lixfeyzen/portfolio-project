# Case Brief and Sources

## Project title

**F&B Customer Complaint & Service Recovery Management System**

## Project overview

This project is a System Analyst case study based on official public complaint data and complaint-handling references.

The goal is to design a workflow system that helps a multi-outlet F&B operator convert customer complaints into accountable service recovery tickets with category, severity, SLA, PIC assignment, investigation, resolution, approval, and repeat-issue monitoring.

This is not an internal project of any specific company. It is a realistic case study using public data as a reference for system analysis.

## Case question

How can a multi-outlet F&B operator turn customer complaints into structured service recovery actions that are assigned, tracked, resolved, reviewed, and monitored?

## Core tension

Complaint data can show customer pain, but data alone does not guarantee recovery.

A business still needs a workflow that answers:

- What type of complaint is this?
- How severe is it?
- Who owns the follow-up?
- What is the response deadline?
- What investigation or recovery action was taken?
- Who validates closure?
- Is this a repeated issue at the same outlet or category?

**Simple principle:** complaint data shows the pain; workflow ensures the business responds.

## Real-world sources

| Source | Role in this project |
|---|---|
| NYC Open Data — 311 Service Requests from 2020 to Present | Primary public dataset reference for complaint records, complaint type, status, due date, resolution notes, location grouping, and channel. |
| NYC311 — Food Safety Complaint | Business context for food service complaints, including restaurants, bakeries, bars, cafeterias, and catering services. |
| ISO 10002:2018 | Complaint-handling reference for planning, operation, maintenance, improvement, analysis, and review of complaint processes. |

## Source notes

### NYC Open Data — 311 Service Requests

The 311 dataset contains service request records that can be directed to specific agencies. Each row includes information about a service request such as complaint type, responding agency, geographic location, and status. The dataset also includes useful workflow fields such as created date, closed date, due date, resolution description, and channel type.

Source link:  
https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9

Useful fields for this project:

| Field | Use in system design |
|---|---|
| `unique_key` | Source complaint ID |
| `created_date` | Complaint received time |
| `closed_date` | Complaint closure time |
| `agency` / `agency_name` | Responding agency reference |
| `complaint_type` | Main complaint category |
| `descriptor` | Complaint detail |
| `location_type` | Place type |
| `status` | Current request status |
| `due_date` | SLA reference |
| `resolution_description` | Resolution or response note |
| `borough` | Location grouping |
| `open_data_channel_type` | Submission channel |

### NYC311 — Food Safety Complaint

NYC311 provides a public reference for food safety complaints. The page explains that complaints can be made about unsafe food practices in food establishments such as restaurants, bakeries, bars, cafeterias, and catering services. It also lists examples such as unsanitary conditions, improper food temperature, sick food workers, pests, and other unsafe practices.

Source link:  
https://portal.311.nyc.gov/article/?kanumber=KA-01111

### ISO 10002:2018

ISO 10002:2018 gives guidelines for complaints handling related to products and services. It covers planning, design, development, operation, maintenance, improvement, complaint analysis, and review of process effectiveness.

Source link:  
https://www.iso.org/standard/71580.html

## Business context

Multi-outlet F&B operators must keep service quality consistent across outlets. Customer complaints can reveal issues in food safety, hygiene, staff behavior, product quality, order accuracy, speed of service, or outlet condition.

However, complaints often come from different channels and may be handled inconsistently if there is no structured workflow. A complaint can be acknowledged, but not properly assigned, investigated, resolved, approved, or monitored for recurrence.

## Business problem

The raw complaint record is not enough for internal recovery management.

Key gaps:

| Current condition | Business risk | System need |
|---|---|---|
| Complaints are recorded as individual cases | Follow-up can become inconsistent | Service recovery ticket |
| Complaint type is broad | Hard to prioritize | Category and severity mapping |
| SLA exists but may not be operationalized internally | Response can be late | SLA and overdue tracking |
| Ownership is not always clear | Outlet/team accountability is weak | PIC assignment |
| Resolution note may be text-only | Hard to verify quality of recovery | Investigation and recovery action log |
| Closure can happen without internal review | Root issue may remain | Manager/QA approval |
| Repeat issues are hard to spot | Recurring outlet problems may be missed | Repeat issue monitoring |

## Proposed system

The proposed system converts customer complaints into structured service recovery tickets.

Main workflow:

```text
Complaint Received
→ Complaint Categorized
→ Severity and SLA Assigned
→ Service Recovery Ticket Created
→ Outlet / PIC Assigned
→ Investigation Started
→ Recovery Action Submitted
→ Manager / QA Review
→ Approved / Rejected
→ Ticket Closed / Rework
→ Repeat Issue Monitoring
```

## Stakeholders

| Stakeholder | Main need |
|---|---|
| Customer Service Team | Log complaints, classify issue, and monitor response status |
| Outlet Manager | Investigate outlet-level issue and submit recovery action |
| Area Manager | Monitor overdue, repeated, and high-severity complaints |
| QA / Operations Team | Review complaints related to food safety, hygiene, and service standards |
| Management | Track trends, repeated complaints, and service recovery effectiveness |
| Developer Team | Receive clear requirements, workflow, ERD, validation rules, and UAT scenarios |

## In scope

- Import a public complaint data sample.
- Filter food/service-related complaint records.
- Categorize complaint type and descriptor.
- Define severity and SLA rules.
- Create service recovery ticket.
- Assign outlet/PIC/team.
- Track investigation and recovery action.
- Review and approve/reject closure.
- Monitor overdue and repeated complaints.

## Out of scope

- Full CRM platform.
- POS integration.
- Loyalty system.
- Refund payment processing.
- Social media scraping.
- AI chatbot.
- Full production application development.

## Assumptions

- Public 311 data is used as a realistic proxy for complaint workflow analysis.
- The project focuses on System Analyst documentation and workflow design, not production engineering.
- Some fields will be anonymized or generalized in the public working sample.
- Severity and SLA rules are simplified for MVP design and should be refined with real stakeholder input in a real implementation.

## Expected system outcome

| Before | After |
|---|---|
| Complaint exists as a record | Complaint becomes a service recovery ticket |
| Issue priority is unclear | Complaint has category, severity, and SLA |
| Ownership is unclear | Ticket has assigned PIC/team |
| Follow-up is not visible | Status lifecycle is tracked |
| Resolution note is not enough | Investigation and recovery action are documented |
| Closure may not be validated | Manager/QA reviews closure |
| Repeat complaints are hard to see | Repeat issue monitoring supports escalation |

## Fit to IT Business & System Analyst role

| System Analyst need | Evidence in this project |
|---|---|
| Business process analysis | Complaint-to-recovery workflow |
| Workflow/SOP documentation | Complaint handling SOP and status lifecycle |
| Requirements documentation | Functional requirements, business rules, and user stories |
| Gap analysis | Raw complaint data gaps to internal system needs |
| ERD/data modelling | Complaint, ticket, assignment, SLA, investigation, approval, and status entities |
| Developer coordination | Handoff notes, API notes, validation rules, and backlog |
| UAT/test scenarios | Acceptance criteria, UAT cases, and traceability matrix |
| Monitoring effectiveness | SLA, overdue, closure, and repeat issue monitoring |

## Quality guardrail

This project must stay focused on one workflow:

**Complaint → triage → SLA → assignment → investigation → recovery action → approval → closure → repeat monitoring.**

Do not expand this project into full CRM, POS, loyalty, refund engine, chatbot, or social listening unless clearly separated as future improvements.

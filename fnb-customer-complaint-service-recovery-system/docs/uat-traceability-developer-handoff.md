# UAT, Traceability, and Developer Handoff

## Purpose

This document defines how the **F&B Customer Complaint & Service Recovery Management System** should be validated before development handoff.

The goal is to make the workflow testable and build-ready: each key requirement should have acceptance criteria, UAT scenarios, validation rules, and a clear link back to the business problem.

## UAT scope

The UAT focuses on the MVP workflow:

```text
Complaint intake
-> triage
-> severity and SLA
-> service recovery ticket
-> owner assignment
-> investigation
-> recovery action
-> review decision
-> closure or rework
-> monitoring
```

### In scope

- Complaint record import or registration
- Ticket candidate identification
- Category and severity assignment
- SLA due date and overdue flag
- Service recovery ticket creation
- Owner/PIC assignment
- Investigation note submission
- Recovery action submission
- Manager/QA approval or rejection
- Status history tracking
- Repeat issue flagging
- Summary monitoring

### Out of scope

- Customer refund processing
- Loyalty compensation
- POS integration
- Chatbot automation
- Social media scraping
- Production notification engine

## Acceptance criteria

| ID | Requirement | Acceptance criteria |
|---|---|---|
| AC-01 | Import complaint record | Given a valid complaint record, when the record is imported, then the system stores the complaint with source request code, created date, complaint type, descriptor, channel, outlet code, and ticket candidate flag. |
| AC-02 | Identify ticket candidate | Given a complaint has `ticket_candidate = Yes`, when the system processes the complaint, then it is eligible to create a service recovery ticket. |
| AC-03 | Map category | Given a complaint descriptor such as hygiene, temperature, pest, sanitation, or food handling issue, when triage is performed, then the complaint receives an internal category. |
| AC-04 | Assign severity | Given a mapped complaint category and descriptor, when severity logic is applied, then the system assigns Medium, High, or Critical severity. |
| AC-05 | Calculate SLA | Given severity is assigned, when a ticket is created, then the due date is calculated from the severity SLA rule. |
| AC-06 | Create service recovery ticket | Given a complaint is a ticket candidate, when ticket creation is triggered, then one service recovery ticket is created and linked to the complaint record. |
| AC-07 | Assign owner | Given a ticket is created, when Customer Service or Area Manager assigns an owner, then the assigned owner is saved and assignment history is recorded. |
| AC-08 | Submit investigation note | Given a ticket is assigned, when the Outlet Manager submits a root cause note, then the investigation note is stored and linked to the ticket. |
| AC-09 | Submit recovery action | Given investigation has been submitted, when the owner submits a recovery action, then the action note and optional evidence reference are stored. |
| AC-10 | Review closure | Given a recovery action is submitted, when Manager/QA reviews the ticket, then the review decision is saved as Approved or Rejected. |
| AC-11 | Close approved ticket | Given a review decision is Approved, when the system updates the ticket, then the ticket status becomes Closed and closed timestamp is recorded. |
| AC-12 | Rework rejected ticket | Given a review decision is Rejected, when the system updates the ticket, then the ticket status becomes Rework Required. |
| AC-13 | Track status history | Given any ticket status changes, when the change occurs, then a status history record is created. |
| AC-14 | Flag overdue ticket | Given due date has passed and ticket is not Closed, when SLA check runs, then ticket is flagged as Overdue. |
| AC-15 | Flag repeat issue | Given the same outlet and complaint category appear repeatedly within the monitoring window, when repeat check runs, then the ticket is flagged for Area Manager review. |
| AC-16 | Show monitoring summary | Given tickets exist, when management opens summary view, then the system shows counts for open, overdue, closed, closed late, critical/high, and repeat issues. |

## UAT scenarios

| Test ID | Scenario | Input / precondition | Expected result | Related requirement |
|---|---|---|---|---|
| TS-01 | Import valid complaint record | Valid row from `data/sample-311-food-complaints.csv` | Complaint record is stored in staging or complaint table | FR-01 |
| TS-02 | Create ticket from candidate complaint | `ticket_candidate = Yes` | Service recovery ticket is created | FR-02, FR-06 |
| TS-03 | Do not create ticket from monitor-only complaint | `ticket_candidate = Monitor` | No active recovery ticket is created; record remains available for monitoring | FR-02 |
| TS-04 | Assign category from descriptor | Descriptor contains hygiene, pest, sanitation, temperature, food handling, or related issue | Internal category is assigned | FR-03 |
| TS-05 | Assign severity and SLA | Severity = Critical | Due date follows Critical SLA rule | FR-04, FR-05 |
| TS-06 | Assign owner team | Suggested owner = Outlet Manager + QA | Ticket owner or owner team is assigned | FR-07 |
| TS-07 | Start investigation | Assigned ticket exists | Investigation note is submitted and stored | FR-08 |
| TS-08 | Submit recovery action | Investigation note exists | Recovery action and optional evidence reference are stored | FR-09 |
| TS-09 | Approve ticket closure | Recovery action submitted; reviewer selects Approved | Ticket status becomes Closed | FR-10, FR-11 |
| TS-10 | Reject ticket closure | Recovery action submitted; reviewer selects Rejected with note | Ticket status becomes Rework Required | FR-10, FR-11 |
| TS-11 | Create status history | Ticket changes from Assigned to In Investigation | Status history record is created | FR-11 |
| TS-12 | Flag overdue ticket | Due date is past and ticket is not Closed | Ticket is marked Overdue | FR-12 |
| TS-13 | Flag repeated complaint | Same outlet and category occurs at least twice | Repeat issue flag is set | FR-13 |
| TS-14 | Show management summary | Ticket data exists across statuses and categories | Summary metrics display open, overdue, closed, and repeat counts | FR-14 |
| TS-15 | Prevent invalid closure | Ticket has no investigation or recovery action | Ticket cannot be closed | BR-05 |
| TS-16 | Escalate overdue high issue | High severity ticket is overdue | Ticket is visible for Area Manager escalation | BR-03, BR-07 |

## Traceability matrix

| Business need | Gap reference | Requirement | Business rule | Test scenario |
|---|---|---|---|---|
| Convert relevant complaints into actionable work | Complaints stored only as records | FR-02, FR-06 | BR-01 | TS-02, TS-03 |
| Standardize complaint interpretation | Text-heavy complaint descriptors | FR-03, FR-04 | BR-02, BR-03, BR-04 | TS-04, TS-05 |
| Control response time | SLA not translated into internal ownership | FR-05, FR-12 | BR-07, BR-09 | TS-05, TS-12, TS-16 |
| Create accountability | Owner is unclear | FR-07 | BR-02, BR-03, BR-04 | TS-06 |
| Verify recovery before closure | Closed status may not prove recovery quality | FR-08, FR-09, FR-10 | BR-05, BR-06 | TS-07, TS-08, TS-09, TS-10, TS-15 |
| Keep workflow auditable | Manual updates can be inconsistent | FR-11 | BR-10 | TS-11 |
| Detect recurring outlet issues | Repeat issues are not immediately visible | FR-13 | BR-08 | TS-13 |
| Support management monitoring | Recovery performance is hard to see | FR-14 | BR-09 | TS-14 |

## Suggested API outline

These endpoints are not production API specifications. They describe the minimum handoff direction for developers.

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `/complaints/import` | Import complaint records from source or working sample. |
| `GET` | `/complaints` | List complaint records with filters such as category, status, outlet, channel, and date range. |
| `POST` | `/tickets` | Create service recovery ticket from a complaint record. |
| `GET` | `/tickets` | List tickets by status, owner, severity, category, SLA status, and outlet. |
| `GET` | `/tickets/{ticket_id}` | View ticket detail, investigation notes, actions, review decisions, and status history. |
| `PATCH` | `/tickets/{ticket_id}/assign` | Assign or reassign ticket owner. |
| `POST` | `/tickets/{ticket_id}/investigation-notes` | Submit investigation/root cause note. |
| `POST` | `/tickets/{ticket_id}/recovery-actions` | Submit recovery action and optional evidence reference. |
| `POST` | `/tickets/{ticket_id}/reviews` | Approve or reject ticket closure. |
| `PATCH` | `/tickets/{ticket_id}/status` | Update ticket status according to valid status transition. |
| `GET` | `/monitoring/service-recovery` | Show summary metrics for open, overdue, closed, repeat, and high-severity tickets. |

## Sample payloads

### Create service recovery ticket

```json
{
  "complaint_id": 101,
  "category_id": 2,
  "severity_id": 1,
  "assigned_owner_id": 12,
  "due_at": "2026-06-07T23:59:00",
  "is_repeat_issue": false
}
```

### Submit recovery action

```json
{
  "ticket_id": 501,
  "submitted_by_user_id": 12,
  "action_note": "Outlet team cleaned the affected preparation area and retrained staff on handling procedure.",
  "evidence_reference": "evidence/ticket-501-cleaning-proof.jpg"
}
```

### Review decision

```json
{
  "ticket_id": 501,
  "reviewed_by_user_id": 8,
  "decision": "Approved",
  "review_note": "Action is sufficient. Ticket can be closed."
}
```

## Validation rules

| Rule ID | Validation rule | Error / handling |
|---|---|---|
| VR-01 | `created_at` is required for complaint record. | Reject import row or mark as invalid. |
| VR-02 | `ticket_candidate = Yes` is required before ticket creation. | Do not create ticket from monitor-only complaint. |
| VR-03 | Category and severity are required before ticket assignment. | Keep ticket in Triaged queue. |
| VR-04 | Due date must be generated from severity SLA rule. | Block ticket creation until SLA rule exists. |
| VR-05 | Assigned owner is required before investigation starts. | Block status move to In Investigation. |
| VR-06 | Investigation note is required before recovery action review. | Block review submission. |
| VR-07 | Recovery action note is required before closure review. | Block approval decision. |
| VR-08 | Review decision must be Approved or Rejected. | Reject invalid decision value. |
| VR-09 | Closed status requires Approved review decision. | Block manual closure without approval. |
| VR-10 | Overdue flag applies when due date has passed and ticket is not Closed. | Show in overdue queue and escalation monitoring. |

## Status transition rules

| From status | Allowed next status |
|---|---|
| New | Triaged, Escalated |
| Triaged | Assigned, Escalated |
| Assigned | In Investigation, Overdue, Escalated |
| In Investigation | Pending Review, Overdue, Escalated |
| Pending Review | Closed, Rework Required, Escalated |
| Rework Required | In Investigation, Pending Review, Overdue, Escalated |
| Overdue | In Investigation, Pending Review, Closed, Escalated |
| Escalated | Assigned, In Investigation, Pending Review, Closed |
| Closed | No further status change, except administrative reopen if approved by management. |

## Edge cases

| Case | Handling |
|---|---|
| Duplicate complaint from same outlet and same category | Mark as potential repeat issue and link to existing open ticket if still active. |
| Complaint has missing source due date | Generate internal due date from severity SLA rule. |
| Complaint is closed in source data but internally unresolved | Keep internal ticket open until recovery action is reviewed. |
| Complaint is monitor-only | Do not create active ticket, but keep record for trend monitoring. |
| Evidence file is missing | Allow recovery note submission, but block closure if reviewer requires evidence. |
| Owner leaves or is inactive | Require reassignment before further workflow update. |
| Review rejected without note | Require reviewer rejection reason. |
| Overdue critical issue | Escalate to QA / Operations and Area Manager. |

## Developer handoff summary

### Main build object

The main workflow object is:

```text
service_recovery_tickets
```

All other objects support ticket accountability, audit trail, and monitoring.

### Minimum screens

| Screen | Main function |
|---|---|
| Complaint Intake | Import or view complaint records. |
| Triage Queue | Review ticket candidates, category, severity, and SLA. |
| Ticket Detail | View owner, due date, investigation, recovery action, review decision, and status history. |
| Owner Worklist | Show assigned tickets for Outlet Manager or owner team. |
| Review Queue | Show pending review tickets for Manager / QA / Operations. |
| Escalation Queue | Show overdue, repeated, and high-severity tickets. |
| Management Summary | Show SLA, closure, overdue, repeat, and category performance. |

### Minimum data objects

- `complaint_records`
- `complaint_categories`
- `severity_rules`
- `service_recovery_tickets`
- `ticket_assignments`
- `investigation_notes`
- `recovery_actions`
- `review_decisions`
- `ticket_status_history`
- `ticket_escalations`

### Open questions for stakeholders

| Area | Question |
|---|---|
| SLA | Should SLA be based on complaint severity, complaint category, channel, or outlet risk level? |
| Routing | Which complaints must always include QA / Operations review? |
| Evidence | Which complaint categories require photo/document evidence before closure? |
| Repeat issue | What time window should define a repeated complaint: 7 days, 30 days, or 90 days? |
| Escalation | Who should receive overdue critical issue escalation? |
| Closure | Can Area Manager close tickets, or must QA approve food-safety categories? |
| Privacy | What customer information should never be stored in the internal system? |

## Definition of Done

The MVP documentation is ready for development discussion when:

- business problem is clear;
- workflow is defined from complaint intake to closure;
- requirements are mapped to UAT scenarios;
- ERD and SQL schema define the main objects;
- status lifecycle and validation rules are clear;
- monitoring needs are identified;
- out-of-scope items are separated from the MVP.

## Handoff checklist

| Item | Status |
|---|---|
| Case brief and sources | Ready |
| Data exploration summary | Ready |
| Gap analysis | Ready |
| Workflow, SOP, and requirements | Ready |
| ERD, business rules, and data dictionary | Ready |
| SQL staging and analysis queries | Ready |
| SQL service recovery schema | Ready |
| UAT scenarios and traceability matrix | Ready |
| Developer handoff notes | Ready |

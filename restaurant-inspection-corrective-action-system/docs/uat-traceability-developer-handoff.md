# UAT, Traceability, and Developer Handoff

## Purpose

This document translates the corrective action workflow into testable acceptance criteria, UAT scenarios, traceability matrix, and developer handoff notes.

The goal is to make the MVP build clear for both business users and developers.

Core workflow:

```text
Inspection finding → corrective action ticket → Person in Charge (PIC) assignment → due date → evidence → QA review → closure / rework → monitoring
```

## MVP Testing Scope

| Area | Included in UAT? | Notes |
|---|---:|---|
| Import inspection records | Yes | Based on public inspection data sample. |
| Detect actionable records | Yes | Fail and Pass w/ Conditions records. |
| Create corrective action ticket | Yes | Ticket must link to violation and inspection. |
| Assign PIC and due date | Yes | QA or Area Manager action. |
| Submit evidence | Yes | Outlet Manager action. |
| QA approval / rejection | Yes | Controls ticket closure or rework. |
| Overdue flag | Yes | Based on due date and open status. |
| Repeat issue monitoring | Yes | Based on establishment and violation category history. |
| POS / Inventory / Purchasing | No | Out of scope. |

## UAT Actors

| Actor | UAT Responsibility |
|---|---|
| QA / Food Safety Team | Validate violation review, ticket creation, approval, and rejection flow. |
| Outlet Manager | Validate evidence submission flow. |
| Area Manager | Validate assignment, overdue, and escalation visibility. |
| Management | Validate monitoring summary. |
| Developer Team | Confirm build feasibility and implementation logic. |

## Acceptance Criteria

### AC-01 — Import Inspection Data

**Related requirement:** FR-01

```text
Given a valid inspection data file or API response is available,
When the system imports the records,
Then inspection data is stored with inspection ID, establishment code, inspection date, result, risk level, and violation notes.
```

### AC-02 — Identify Actionable Inspection Records

**Related requirement:** FR-02

```text
Given imported inspection data contains result = Fail or Pass w/ Conditions,
When the system processes the record,
Then the record is marked as actionable or pending QA review.
```

### AC-03 — Create Corrective Action Ticket

**Related requirement:** FR-03, FR-04

```text
Given an actionable violation has been confirmed by QA,
When QA creates or confirms a corrective action,
Then the system creates a ticket linked to the inspection and violation record,
And the system prevents a duplicate ticket for the same violation.
```

### AC-04 — Assign Person in Charge (PIC) and Due Date

**Related requirement:** FR-05, FR-06

```text
Given a corrective action ticket is open,
When QA or Area Manager assigns a PIC and due date,
Then the ticket status becomes Assigned and the assigned user can see the ticket.
```

### AC-05 — Submit Evidence

**Related requirement:** FR-07

```text
Given an Outlet Manager has an assigned ticket,
When evidence is submitted,
Then the system stores the evidence and changes the ticket status to Pending Review.
```

### AC-06 — Approve Evidence

**Related requirement:** FR-08, FR-09

```text
Given a ticket is Pending Review with submitted evidence,
When QA approves the evidence,
Then the ticket status becomes Closed and the closure timestamp is recorded.
```

### AC-07 — Reject Evidence

**Related requirement:** FR-08, FR-09

```text
Given a ticket is Pending Review with submitted evidence,
When QA rejects the evidence and provides a review note,
Then the ticket status becomes Rework and the Outlet Manager receives the rework request.
```

### AC-08 — Flag Overdue Tickets

**Related requirement:** FR-10

```text
Given a ticket is not Closed and its due date has passed,
When the system runs the overdue check,
Then the ticket is flagged as Overdue or appears in the overdue monitoring list.
```

### AC-09 — Monitor Repeat Issues

**Related requirement:** FR-11

```text
Given the same establishment has multiple violations in the same category,
When the system prepares monitoring data,
Then the establishment is flagged for repeat issue review.
```

### AC-10 — Show Management Summary

**Related requirement:** FR-12

```text
Given corrective action tickets exist in multiple statuses,
When management opens the monitoring summary,
Then the system displays ticket counts by status, priority, risk level, and repeated issue flag.
```

## UAT Test Scenarios

| ID | Scenario | Actor | Input / Condition | Expected Result | Priority |
|---|---|---|---|---|---|
| TS-01 | Import inspection data | System / QA | Valid sample inspection file | Records are stored successfully | High |
| TS-02 | Detect failed inspection | System | Result = Fail | Record becomes actionable | High |
| TS-03 | Detect conditional inspection | System / QA | Result = Pass w/ Conditions | Record requires QA review | High |
| TS-04 | Create ticket from violation | QA | Actionable violation confirmed | Ticket is created and linked to violation | High |
| TS-05 | Assign PIC and due date | QA / Area Manager | Open ticket | Ticket becomes Assigned | High |
| TS-06 | Submit evidence | Outlet Manager | Assigned ticket | Evidence stored; status becomes Pending Review | High |
| TS-07 | Approve evidence | QA | Pending Review ticket with evidence | Ticket becomes Closed | High |
| TS-08 | Reject evidence | QA | Evidence is insufficient | Ticket becomes Rework with review note | High |
| TS-09 | Flag overdue ticket | System | Due date passed and ticket not closed | Ticket appears as Overdue | High |
| TS-10 | Monitor repeat issue | Area Manager | Same establishment + same category repeated | Repeat issue flag appears | Medium |
| TS-11 | Prevent duplicate ticket | System / QA | Same violation already has ticket | System prevents duplicate ticket | Medium |
| TS-12 | View management summary | Management | Existing ticket data | Summary shows open, overdue, closed, rework, and repeated issues | Medium |

## Traceability Matrix

| Business Need | Requirement | Acceptance Criteria | Test Scenario |
|---|---|---|---|
| Convert inspection findings into action | FR-01, FR-02, FR-03, FR-04 | AC-01, AC-02, AC-03 | TS-01, TS-02, TS-03, TS-04 |
| Make ownership clear | FR-05 | AC-04 | TS-05 |
| Set follow-up deadline | FR-05, FR-06, FR-10 | AC-04, AC-08 | TS-05, TS-09 |
| Verify correction evidence | FR-07, FR-08 | AC-05, AC-06, AC-07 | TS-06, TS-07, TS-08 |
| Prevent weak closure | FR-08, FR-09 | AC-06, AC-07 | TS-07, TS-08 |
| Monitor unresolved risk | FR-10, FR-12 | AC-08, AC-10 | TS-09, TS-12 |
| Detect repeated operational issues | FR-11, FR-12 | AC-09, AC-10 | TS-10, TS-12 |
| Reduce duplicate workflow items | BR-04 | AC-03 | TS-11 |

## Developer Handoff Summary

### Recommended MVP Modules

| Module | Main Function | Build Priority |
|---|---|---:|
| Inspection Import | Store inspection source records | 1 |
| Violation Review | Identify actionable violations | 2 |
| Corrective Action Ticket | Create and manage tickets | 3 |
| Assignment & SLA | Assign PIC, priority, due date | 4 |
| Evidence Submission | Allow outlet users to submit proof | 5 |
| QA Review | Approve or reject evidence | 6 |
| Monitoring Summary | Show open, overdue, closed, repeated issues | 7 |

### Suggested API Endpoints

These endpoints are proposed for development discussion and can be refined during technical design.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/api/inspections/actionable` | Get Fail / Pass w/ Conditions records that need review. |
| `POST` | `/api/tickets` | Create corrective action ticket from violation. |
| `GET` | `/api/tickets` | List tickets with filters by status, priority, due date, PIC, establishment. |
| `GET` | `/api/tickets/{ticket_id}` | Get ticket detail, evidence, approval log, and status history. |
| `PATCH` | `/api/tickets/{ticket_id}/assign` | Assign PIC, priority, and due date. |
| `POST` | `/api/tickets/{ticket_id}/evidence` | Submit evidence for ticket. |
| `PATCH` | `/api/tickets/{ticket_id}/review` | QA approves or rejects evidence. |
| `GET` | `/api/monitoring/summary` | Get summary of open, overdue, closed, rework, and repeat issues. |

### Example Request — Create Ticket

```json
{
  "violation_id": 105,
  "priority": "High",
  "created_by_user_id": 2,
  "note": "Ticket created after QA review of failed inspection."
}
```

### Example Request — Assign Ticket

```json
{
  "assigned_to_user_id": 8,
  "assigned_by_user_id": 2,
  "due_date": "2026-06-15",
  "priority": "High"
}
```

### Example Request — Review Evidence

```json
{
  "reviewed_by_user_id": 2,
  "review_decision": "Approved",
  "review_note": "Evidence accepted. Corrective action can be closed."
}
```

## Validation Rules

| Rule | Validation |
|---|---|
| Ticket must link to violation | `violation_id` is required. |
| Duplicate ticket is not allowed for the same violation in MVP | `violation_id` should be unique in ticket table. |
| Assigned ticket requires PIC and due date | `assigned_to_user_id` and `due_date` are required before status = Assigned. |
| Evidence requires ticket and submitter | `ticket_id` and `submitted_by_user_id` are required. |
| Closed ticket requires approved evidence | At least one evidence record and one approved approval log must exist. |
| Rejected evidence requires review note | `review_note` is required when decision = Rejected. |
| Overdue status is derived | due date < current date and ticket not Closed. |

## Edge Cases to Discuss with Developers

| Edge Case | Proposed Handling |
|---|---|
| One inspection has multiple violations | Create one ticket per actionable violation. |
| Violation text is unclear | Mark as Manual Review before ticket creation. |
| Same violation appears again in later inspection | Create new ticket, but flag as repeat issue. |
| Evidence is uploaded multiple times | Keep all evidence records and latest status. |
| PIC is inactive or transferred | Allow reassignment with status history. |
| Ticket is overdue but evidence was submitted | Keep Pending Review but show overdue indicator until QA decision. |

## Open Questions for Stakeholder Review

| Question | Why It Matters |
|---|---|
| Who has final authority to close a corrective action ticket? | Defines approval rule. |
| How many SLA days should be used for High, Medium, and Low priority? | Defines due-date rule. |
| Should Pass w/ Conditions always create a ticket or only after QA review? | Defines ticket creation logic. |
| What evidence types are acceptable? | Defines upload validation. |
| When should repeat issues be escalated to Area Manager? | Defines escalation threshold. |

## Definition of Done

The MVP is considered ready when:

- actionable inspection records can be identified,
- corrective action tickets can be created,
- PIC and due date can be assigned,
- evidence can be submitted,
- QA can approve or reject evidence,
- ticket status history is recorded,
- overdue tickets can be monitored,
- repeated issues can be flagged,
- UAT scenarios pass for the core workflow.

## Scope Boundary

This document supports the corrective action workflow only. POS, inventory, purchasing, full ERP, machine learning, and production app development stay outside the MVP boundary.

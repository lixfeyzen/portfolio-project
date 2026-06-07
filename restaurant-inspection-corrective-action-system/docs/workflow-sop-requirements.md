# Workflow, SOP, and Requirements

## Purpose

This document defines the target workflow, SOP, user stories, functional requirements, non-functional requirements, and business rules for the **Restaurant Inspection Corrective Action Management System**.

The system is designed to convert inspection findings into accountable corrective actions.

> Data shows the issue. The workflow ensures the issue gets fixed, reviewed, and monitored.

## Design Scope

This MVP focuses on one workflow only:

```text
Inspection violation → corrective action ticket → Person in Charge (PIC) assignment → due date → evidence → QA review → monitoring
```

The MVP does not cover POS, inventory, purchasing, ERP, or machine learning.

## Main Actors

| Actor | Main Responsibility |
|---|---|
| System | Imports inspection data, detects actionable records, creates tickets, updates status. |
| QA / Food Safety Team | Reviews violations, confirms severity, assigns PIC, reviews evidence. |
| Outlet Manager | Fixes the issue and submits evidence. |
| Area Manager | Monitors overdue and repeated issues, supports escalation. |
| Management | Reviews compliance status and operational risk. |
| Developer Team | Builds the workflow based on requirements, ERD, and UAT scenarios. |

## To-Be Workflow

![Corrective Action Workflow](../assets/workflow-diagram.png)

Editable diagram source: `../assets/editable-source/workflow-diagram.drawio`  
PDF export: `../assets/pdf/workflow-diagram.pdf`

```text
1. Inspection data is imported.
2. System detects Fail or Pass w/ Conditions records.
3. QA reviews the violation details.
4. System creates corrective action ticket.
5. QA / Area Manager assigns PIC and due date.
6. Outlet Manager completes correction and submits evidence.
7. QA reviews evidence.
8. If approved, ticket is closed.
9. If rejected, ticket returns to In Progress / Rework.
10. Management monitors open, overdue, closed, and repeated issues.
```

## Ticket Status Lifecycle

| Status | Meaning | Owner |
|---|---|---|
| Open | Ticket has been created and needs assignment. | System / QA |
| Assigned | PIC and due date are set. | QA / Area Manager |
| In Progress | Outlet is working on the correction. | Outlet Manager |
| Pending Review | Evidence has been submitted and waits for QA review. | QA |
| Rework | QA rejected the evidence and requested correction. | Outlet Manager |
| Closed | QA approved the correction. | QA |
| Overdue | Ticket passed due date before closure. | System / Area Manager |

## SOP Summary

| Step | Actor | Action | Output |
|---|---|---|---|
| 1 | System | Import inspection data from the approved source. | Inspection records stored. |
| 2 | System | Detect records with Fail or Pass w/ Conditions. | Actionable inspection list. |
| 3 | QA | Review violation details and confirm follow-up need. | Confirmed violation priority. |
| 4 | System | Create corrective action ticket. | Ticket with linked inspection record. |
| 5 | QA / Area Manager | Assign a Person in Charge (PIC) and due date. | Ticket assigned to responsible outlet user. |
| 6 | Outlet Manager | Complete corrective action and upload evidence. | Evidence submitted. |
| 7 | QA | Approve or reject submitted evidence. | Ticket closed or sent to rework. |
| 8 | Area Manager | Monitor overdue and repeated issues. | Escalation when needed. |
| 9 | Management | Review compliance summary. | Operational risk visibility. |

## User Stories

| ID | User Story | Business Value |
|---|---|---|
| US-01 | As a QA user, I want the system to identify failed or conditional inspections so I can focus on records that need follow-up. | Reduces manual review effort. |
| US-02 | As a QA user, I want to create or confirm corrective action tickets from violations so each issue becomes trackable. | Converts findings into accountable work. |
| US-03 | As an Area Manager, I want to assign PIC and due date so each action has ownership and timeline. | Improves follow-up discipline. |
| US-04 | As an Outlet Manager, I want to submit evidence so QA can verify that the issue has been fixed. | Creates proof of correction. |
| US-05 | As a QA user, I want to approve or reject evidence so closure is validated. | Prevents weak closure. |
| US-06 | As Management, I want to monitor open, overdue, closed, and repeated issues so I can see operational risk. | Improves compliance visibility. |

## Functional Requirements

| ID | Requirement | Priority |
|---|---|---|
| FR-01 | System shall import inspection records from the approved dataset/source. | Must Have |
| FR-02 | System shall identify inspection records with result = Fail or Pass w/ Conditions. | Must Have |
| FR-03 | System shall allow QA to review violation details before ticket confirmation. | Must Have |
| FR-04 | System shall create a corrective action ticket linked to the inspection record. | Must Have |
| FR-05 | System shall allow QA or Area Manager to assign PIC and due date. | Must Have |
| FR-06 | System shall assign initial priority based on inspection result and risk level. | Must Have |
| FR-07 | System shall allow Outlet Manager to submit evidence for the assigned ticket. | Must Have |
| FR-08 | System shall allow QA to approve or reject submitted evidence. | Must Have |
| FR-09 | System shall update ticket status based on workflow actions. | Must Have |
| FR-10 | System shall flag overdue tickets based on due date and ticket status. | Must Have |
| FR-11 | System shall identify repeated issue patterns by establishment and violation category. | Should Have |
| FR-12 | System shall provide monitoring summary for open, overdue, closed, and repeated issues. | Should Have |

## Non-Functional Requirements

| ID | Requirement | Rationale |
|---|---|---|
| NFR-01 | System should support role-based access control. | Different users need different permissions. |
| NFR-02 | Ticket status changes should be auditable. | QA and management need traceability. |
| NFR-03 | Evidence files should be linked to the related ticket. | Proof must be easy to verify. |
| NFR-04 | Monitoring summary should load within a reasonable response time for filtered data. | Management needs quick visibility. |
| NFR-05 | The system should keep historical status changes. | Required for review and escalation. |

## Business Rules

| ID | Business Rule |
|---|---|
| BR-01 | Inspection records with result = Fail must create or propose at least one corrective action ticket. |
| BR-02 | Inspection records with result = Pass w/ Conditions must be reviewed by QA before closure. |
| BR-03 | Risk 1 / High records should receive higher priority and shorter due date. |
| BR-04 | One actionable violation should not create duplicate tickets. |
| BR-05 | A ticket cannot be closed without submitted evidence. |
| BR-06 | A ticket can only become Closed after QA approval. |
| BR-07 | If QA rejects evidence, ticket status returns to Rework. |
| BR-08 | Every ticket status change should be auditable. |
| BR-09 | If the due date passes before closure, ticket becomes Overdue. |
| BR-10 | Repeated violations for the same establishment and category should trigger escalation review. |

## Monitoring Needs

| Metric | Purpose |
|---|---|
| Open tickets | See unresolved corrective actions. |
| Overdue tickets | Identify delayed follow-up. |
| Closed tickets | Track completed corrective actions. |
| Rework tickets | Identify weak or rejected corrections. |
| Repeat issues | Detect recurring outlet risk. |
| Tickets by risk level | Prioritize high-risk compliance issues. |
| Tickets by violation category | Identify common operational weaknesses. |

## Developer Handoff Notes

The development team should receive the following from this document:

- workflow steps and actor responsibility,
- ticket status lifecycle,
- functional requirements,
- non-functional requirements,
- business rules,
- monitoring needs.

The next technical documents will refine:

- ERD and data dictionary,
- UAT scenarios,
- traceability matrix,
- API discussion points,
- backlog and timeline.

## Scope Boundary

The MVP stays focused on:

> inspection findings → corrective action workflow → verified closure → management monitoring.

# Workflow, SOP, and Requirements

## Purpose

This document defines the target workflow, operating procedure, and MVP requirements for the **F&B Customer Complaint & Service Recovery Management System**.

The design keeps the system focused on one problem: turning food-related customer complaints into accountable service recovery work.

## Design principle

A complaint should not stop at being recorded. For operational use, each relevant complaint needs a clear path from intake to closure.

```text
Complaint received
-> triage
-> severity and SLA
-> ticket creation
-> owner assignment
-> investigation
-> recovery action
-> review
-> closure or rework
-> repeat issue monitoring
```

## Main actors

| Actor | Role in the workflow |
|---|---|
| Customer Service | Receives or imports complaint records, checks initial information, and triggers triage. |
| System | Maps category, severity, SLA, status, overdue condition, and routing suggestions. |
| Outlet Manager | Investigates outlet-level issue and submits recovery action. |
| QA / Operations | Reviews food safety, hygiene, sanitation, and high-severity complaints. |
| Area Manager | Handles escalation, overdue cases, repeated issues, and outlet-level pattern review. |
| Management | Monitors service recovery performance, repeat issues, and SLA health. |

## To-Be workflow

```text
1. Complaint is received or imported.
2. System checks whether the complaint is relevant for service recovery.
3. Complaint is categorized by issue type.
4. Severity and SLA are assigned.
5. Service recovery ticket is created.
6. Ticket is assigned to the correct owner or team.
7. Outlet Manager or assigned PIC investigates the issue.
8. Recovery action is submitted.
9. Manager, QA, or Operations reviews the action.
10. Ticket is closed if approved, or returned for rework if rejected.
11. System monitors overdue tickets and repeated complaints.
```

## Status lifecycle

| Status | Meaning | Main owner |
|---|---|---|
| New | Complaint record is received but not yet reviewed. | Customer Service |
| Triaged | Category, severity, and SLA have been assigned. | Customer Service / System |
| Assigned | PIC or owner team has been assigned. | Customer Service / Area Manager |
| In Investigation | Assigned owner is checking root cause and outlet condition. | Outlet Manager |
| Pending Review | Recovery action has been submitted and needs review. | QA / Operations / Manager |
| Rework Required | Reviewer rejects closure and asks for additional action. | Outlet Manager |
| Closed | Recovery action is accepted and closure is approved. | Reviewer |
| Overdue | SLA has passed while the ticket is not closed. | System / Area Manager |
| Escalated | Ticket needs higher-level attention because of severity, overdue status, or repeat issue. | Area Manager / Management |

## SOP summary

| Step | Actor | Action | Output |
|---|---|---|---|
| 1 | Customer Service | Receive or import complaint record. | Complaint record available in system. |
| 2 | Customer Service / System | Check relevance for service recovery. | Ticket candidate flag. |
| 3 | System | Map descriptor into category and severity. | Category and severity assigned. |
| 4 | System | Calculate SLA based on severity. | Due date and SLA status. |
| 5 | System | Create service recovery ticket. | Ticket with status `New` or `Triaged`. |
| 6 | Customer Service / Area Manager | Assign PIC or owner team. | Ticket status becomes `Assigned`. |
| 7 | Outlet Manager | Investigate root cause and document findings. | Investigation note. |
| 8 | Outlet Manager | Submit recovery action. | Recovery action note and optional evidence. |
| 9 | QA / Operations / Manager | Review the recovery action. | Approval or rejection decision. |
| 10 | System | Close, rework, overdue, or escalate ticket based on decision and SLA. | Updated ticket status. |
| 11 | Management | Monitor SLA, overdue, closure, and repeat issue patterns. | Management monitoring view. |

## User stories

| ID | User story |
|---|---|
| US-01 | As Customer Service, I want to import or register complaint records so that service recovery cases can be tracked. |
| US-02 | As Customer Service, I want the system to suggest complaint category and severity so that triage is consistent. |
| US-03 | As an Outlet Manager, I want to see assigned tickets with due dates so that I know what to investigate first. |
| US-04 | As an Outlet Manager, I want to submit investigation and recovery action notes so that the business can verify follow-up. |
| US-05 | As QA / Operations, I want to review high-severity complaints before closure so that risky issues are not closed too early. |
| US-06 | As an Area Manager, I want to see overdue and repeated complaints so that I can escalate outlet-level problems. |
| US-07 | As Management, I want to monitor SLA performance, repeat categories, and closure status so that service recovery effectiveness is visible. |

## Functional requirements

| ID | Requirement | Priority |
|---|---|---|
| FR-01 | The system shall store imported complaint records from the working sample or source channel. | Must have |
| FR-02 | The system shall identify whether a complaint is a service recovery ticket candidate. | Must have |
| FR-03 | The system shall map complaint descriptor into an internal complaint category. | Must have |
| FR-04 | The system shall assign severity level: Medium, High, or Critical. | Must have |
| FR-05 | The system shall calculate SLA due date based on severity. | Must have |
| FR-06 | The system shall create a service recovery ticket for relevant complaints. | Must have |
| FR-07 | The system shall assign ticket owner, PIC, or owner team. | Must have |
| FR-08 | The system shall allow assigned owner to submit investigation notes. | Must have |
| FR-09 | The system shall allow assigned owner to submit recovery action notes and optional evidence reference. | Must have |
| FR-10 | The system shall allow manager, QA, or Operations reviewer to approve or reject closure. | Must have |
| FR-11 | The system shall track ticket status history. | Must have |
| FR-12 | The system shall flag overdue tickets based on SLA and current status. | Must have |
| FR-13 | The system shall flag repeated complaints by outlet and category. | Should have |
| FR-14 | The system shall provide summary metrics for open, overdue, closed, closed late, and repeated complaints. | Should have |

## Non-functional requirements

| ID | Requirement |
|---|---|
| NFR-01 | The system should use role-based access for Customer Service, Outlet Manager, QA / Operations, Area Manager, and Management. |
| NFR-02 | Ticket status changes should be auditable through status history. |
| NFR-03 | SLA calculation should be consistent and visible to all relevant owners. |
| NFR-04 | Complaint data should avoid storing unnecessary personal customer information. |
| NFR-05 | Management summary should be filterable by outlet, category, severity, SLA status, and period. |
| NFR-06 | The workflow should be simple enough for outlet teams to update without heavy training. |

## Business rules

| ID | Rule |
|---|---|
| BR-01 | A complaint with `ticket_candidate = Yes` must create a service recovery ticket. |
| BR-02 | Critical complaints must be routed to Outlet Manager and QA / Operations. |
| BR-03 | High complaints must be routed to Outlet Manager and may be escalated to Area Manager when overdue. |
| BR-04 | Medium complaints may be handled by Outlet Manager unless repeated or overdue. |
| BR-05 | A ticket cannot be closed without investigation note and recovery action note. |
| BR-06 | A ticket with rejected review must move to `Rework Required`. |
| BR-07 | A ticket past due date and not closed must be flagged as `Overdue`. |
| BR-08 | A repeated complaint at the same outlet and category should be flagged for Area Manager review. |
| BR-09 | Closed late tickets should remain visible in SLA performance monitoring. |
| BR-10 | Status changes must create a status history record. |

## SLA logic for MVP

| Severity | Target response / action window | Escalation rule |
|---|---|---|
| Critical | 24 hours | Escalate to QA / Operations immediately if not assigned. |
| High | 48 hours | Escalate to Area Manager if overdue. |
| Medium | 72 hours | Escalate if repeated or overdue. |

These SLA values are simplified for MVP analysis. In a real implementation, the final SLA should be validated with Customer Service, Operations, QA, and Area Managers.

## Monitoring needs

| Metric | Why it matters |
|---|---|
| Open tickets | Shows unresolved workload. |
| Overdue tickets | Shows SLA risk. |
| Closed late tickets | Shows recovery speed issue. |
| Critical / High tickets | Shows operational risk. |
| Repeated complaints by outlet/category | Shows recurring outlet problems. |
| Average response time | Shows recovery performance. |
| Tickets by owner team | Shows workload distribution. |
| Review rejection rate | Shows recovery action quality. |


## Workflow diagram

Visual workflow files are available in:

- `assets/service-recovery-workflow.png`
- `assets/pdf/service-recovery-workflow.pdf`
- `assets/editable-source/service-recovery-workflow.drawio`
- `assets/editable-source/service-recovery-workflow.mmd`

## Developer handoff notes

The MVP should be designed around the service recovery ticket as the main workflow object.

Minimum objects needed:

- complaint record;
- service recovery ticket;
- ticket assignment;
- investigation note;
- recovery action;
- review decision;
- status history;
- SLA / severity rule;
- repeat issue flag.

The next technical document should define the ERD, data dictionary, and SQL schema for these objects.

## MVP boundary

The system should stop at complaint recovery workflow management.

It should not include customer refund processing, loyalty compensation, POS integration, chatbot automation, or social media scraping in the MVP.

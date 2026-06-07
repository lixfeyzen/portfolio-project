# ERD, Business Rules, and Data Dictionary

## Purpose

This document defines the core data model for the **F&B Customer Complaint & Service Recovery Management System**.

The model supports one workflow:

```text
Complaint record -> service recovery ticket -> assignment -> investigation -> recovery action -> review -> status history -> escalation/monitoring
```

The design stays within the MVP boundary. It does not model a full CRM, POS, refund engine, loyalty system, chatbot, or social media platform.

## ERD preview

![Service recovery ERD](../assets/service-recovery-erd.png)

Editable and exportable versions are available in:

- `assets/service-recovery-erd.png`
- `assets/pdf/service-recovery-erd.pdf`
- `assets/editable-source/service-recovery-erd.drawio`
- `assets/editable-source/service-recovery-erd.dbml`

## Core entity overview

| Entity | Purpose |
|---|---|
| `outlets` | Stores anonymized outlet references for routing and monitoring. |
| `complaint_records` | Stores imported or registered complaint records from the working sample/source channel. |
| `complaint_categories` | Standardizes internal complaint categories such as Hygiene, Temperature Control, Pest Control, Sanitation, Service Quality, and Product Quality. |
| `severity_rules` | Defines severity level, SLA hours, and escalation behavior. |
| `users` | Stores internal users or role accounts involved in assignment, investigation, review, and escalation. |
| `service_recovery_tickets` | Main workflow object created from relevant complaint records. |
| `ticket_assignments` | Tracks owner assignment and reassignment history. |
| `investigation_notes` | Stores root cause and investigation notes. |
| `recovery_actions` | Stores recovery action notes and optional evidence references. |
| `review_decisions` | Stores approval or rejection decisions from manager, QA, or Operations. |
| `ticket_status_history` | Stores ticket status movement for auditability. |
| `ticket_escalations` | Stores escalation events for overdue, repeated, or high-risk tickets. |

## Relationship summary

| Relationship | Meaning |
|---|---|
| One outlet has many complaint records. | Multiple complaints can be linked to the same outlet. |
| One complaint record can create one service recovery ticket. | Not every complaint becomes a ticket, but every ticket links back to one source record. |
| One category can be used by many tickets. | Category standardization supports routing and reporting. |
| One severity rule can be used by many tickets. | Severity drives SLA and escalation logic. |
| One user can own many tickets. | Assignment creates accountability. |
| One ticket can have many assignments, investigation notes, recovery actions, review decisions, status history records, and escalations. | The workflow remains auditable from intake to closure. |

## Data dictionary

### `outlets`

| Column | Type | Description |
|---|---|---|
| `outlet_id` | INT, PK | Internal outlet identifier. |
| `outlet_code` | VARCHAR(20), unique | Anonymized outlet code, for example `OUT-001`. |
| `borough` | VARCHAR(50) | General location grouping from the working sample. |
| `is_active` | BIT | Active outlet flag. |

### `complaint_records`

| Column | Type | Description |
|---|---|---|
| `complaint_id` | INT, PK | Internal complaint record identifier. |
| `source_request_code` | VARCHAR(50) | Generalized source request code. |
| `outlet_id` | INT, FK | Linked outlet. |
| `created_at` | DATETIME2 | Complaint created timestamp. |
| `closed_at` | DATETIME2, nullable | Source complaint closure timestamp. |
| `agency` | VARCHAR(20) | Source agency or responding organization. |
| `complaint_type` | VARCHAR(100) | Source complaint type. |
| `descriptor` | VARCHAR(255) | Complaint detail. |
| `location_type` | VARCHAR(120) | Generalized location type. |
| `source_status` | VARCHAR(30) | Source status such as Open, In Progress, or Closed. |
| `source_due_at` | DATETIME2, nullable | Source due date, if available. |
| `channel_type` | VARCHAR(30) | Complaint channel such as Online, Phone, or Mobile. |
| `ticket_candidate` | BIT | Indicates whether the complaint should create a service recovery ticket. |

### `complaint_categories`

| Column | Type | Description |
|---|---|---|
| `category_id` | INT, PK | Category identifier. |
| `category_name` | VARCHAR(100), unique | Internal complaint category. |
| `default_owner_team` | VARCHAR(100) | Suggested owner team for routing. |

### `severity_rules`

| Column | Type | Description |
|---|---|---|
| `severity_id` | INT, PK | Severity identifier. |
| `severity_name` | VARCHAR(20), unique | Severity level: Medium, High, or Critical. |
| `sla_hours` | INT | Target handling window in hours. |
| `escalation_rule` | VARCHAR(255) | Default escalation behavior. |

### `users`

| Column | Type | Description |
|---|---|---|
| `user_id` | INT, PK | Internal user identifier. |
| `full_name` | VARCHAR(120) | Internal user or role account name. |
| `role_name` | VARCHAR(80) | Customer Service, Outlet Manager, QA, Area Manager, or Management. |
| `outlet_id` | INT, FK, nullable | Outlet assignment if relevant. |
| `is_active` | BIT | Active user flag. |

### `service_recovery_tickets`

| Column | Type | Description |
|---|---|---|
| `ticket_id` | INT, PK | Service recovery ticket identifier. |
| `complaint_id` | INT, FK, unique | Complaint record linked to the ticket. |
| `category_id` | INT, FK | Standard complaint category. |
| `severity_id` | INT, FK | Severity and SLA rule. |
| `current_status` | VARCHAR(40) | Current workflow status. |
| `assigned_owner_id` | INT, FK, nullable | Current ticket owner/PIC. |
| `due_at` | DATETIME2 | Internal SLA due date. |
| `is_repeat_issue` | BIT | Repeat outlet/category flag. |
| `is_overdue` | BIT | SLA overdue flag. |
| `created_at` | DATETIME2 | Ticket creation timestamp. |
| `closed_at` | DATETIME2, nullable | Ticket closure timestamp. |

### Workflow child tables

| Table | Key columns | Purpose |
|---|---|---|
| `ticket_assignments` | `assignment_id`, `ticket_id`, `assigned_to_user_id`, `assigned_by_user_id`, `assigned_at` | Tracks assignment and reassignment history. |
| `investigation_notes` | `investigation_id`, `ticket_id`, `created_by_user_id`, `root_cause_note`, `created_at` | Stores investigation/root cause notes. |
| `recovery_actions` | `action_id`, `ticket_id`, `submitted_by_user_id`, `action_note`, `evidence_reference`, `submitted_at` | Stores recovery action and optional evidence reference. |
| `review_decisions` | `review_id`, `ticket_id`, `reviewed_by_user_id`, `decision`, `review_note`, `reviewed_at` | Stores approval or rejection decisions. |
| `ticket_status_history` | `status_history_id`, `ticket_id`, `status_name`, `changed_by_user_id`, `changed_at`, `status_note` | Stores status movement history. |
| `ticket_escalations` | `escalation_id`, `ticket_id`, `escalation_reason`, `escalated_to_user_id`, `escalated_at`, `resolution_note` | Stores escalation events. |

## Business rules mapped to the data model

| Rule | Data model support |
|---|---|
| Relevant complaints should create service recovery tickets. | `complaint_records.ticket_candidate`, `service_recovery_tickets.complaint_id` |
| Category and severity must be assigned before ticket work starts. | `category_id`, `severity_id` in `service_recovery_tickets` |
| SLA due date should be generated from severity. | `severity_rules.sla_hours`, `service_recovery_tickets.due_at` |
| A ticket must have an assigned owner before investigation. | `assigned_owner_id`, `ticket_assignments` |
| A ticket cannot be closed without investigation and recovery action notes. | `investigation_notes`, `recovery_actions` |
| Closure must be approved or rejected by reviewer. | `review_decisions` |
| Rejected review returns the ticket to rework. | `review_decisions.decision`, `ticket_status_history` |
| Overdue tickets must remain visible. | `is_overdue`, `due_at`, `ticket_status_history` |
| Repeated complaints should be flagged for escalation review. | `is_repeat_issue`, `ticket_escalations` |
| Every status movement must be auditable. | `ticket_status_history` |

## SQL schema

The SQL Server-style schema is available in:

- `sql/service-recovery-schema.sql`

The staging table and analysis queries remain available in:

- `sql/create-staging-table.sql`
- `sql/analysis-queries.sql`

## Developer handoff notes

For MVP development, the main build object is `service_recovery_tickets`.

Minimum API/screen areas should support:

- complaint intake/import;
- ticket creation;
- category and severity assignment;
- owner assignment;
- investigation note submission;
- recovery action submission;
- review approval/rejection;
- status history;
- overdue and repeat issue monitoring.

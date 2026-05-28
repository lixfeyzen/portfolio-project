# Requirements Traceability Matrix

## Purpose

This matrix connects actual business requirements to functional requirements,
use cases, acceptance criteria, and test scenarios.

| Business Requirement ID | Functional Requirement ID | Use Case ID | Acceptance Criteria ID | Test Scenario ID | Traceability Notes |
| --- | --- | --- | --- | --- | --- |
| BR-001 | FR-MEM-001 | UC-001 | AC-MEM-001 | TS-001 | New member registration supports structured member records. |
| BR-001 | FR-MEM-003 | UC-001 | AC-MEM-002 | TS-002 | Member search supports easier record lookup. |
| BR-002 | FR-SUB-004 | UC-010 | AC-SUB-002 | TS-004 | Subscription status calculation supports member status clarity. |
| BR-002 | FR-SUB-005 | UC-010 | AC-SUB-002 | TS-020 | Expiring soon logic supports renewal follow-up. |
| BR-003 | FR-PAY-004 | UC-004 | AC-PAY-002 | TS-006 | Unpaid member list supports payment follow-up. |
| BR-003 | FR-PAY-005 | UC-004 | AC-PAY-003 | TS-007 | Overdue payment list supports overdue follow-up. |
| BR-004 | FR-DASH-004 | UC-009 | AC-DASH-002 | TS-015 | Monthly revenue uses paid payments and excludes invalid statuses. |
| BR-004 | FR-DASH-004 | UC-009 | AC-DASH-002 | TS-016 | Owner can review revenue summary. |
| BR-005 | FR-CLS-003 | UC-006 | AC-CLS-002 | TS-009 | Class capacity must be enforced before booking. |
| BR-005 | FR-CLS-008 | UC-006 | AC-CLS-002 | TS-009 | Booking must be rejected when capacity is full. |
| BR-006 | FR-CLS-007 | UC-005 | AC-CLS-003 | TS-010 | Trainer overlapping schedule must be rejected. |
| BR-007 | FR-DASH-001 | UC-009 | AC-DASH-001 | TS-014 | Owner dashboard gives operational summary. |
| BR-007 | FR-DASH-004 | UC-009 | AC-DASH-002 | TS-016 | Owner dashboard includes revenue visibility. |
| BR-008 | FR-DASH-001 | UC-009 | AC-DASH-001 | TS-014 | Dashboard reduces manual spreadsheet consolidation. |
| BR-009 | FR-PAY-002 | UC-003 | AC-PAY-001 | TS-005 | Payment records must store amount, method, status, date, and staff user. |
| BR-009 | FR-PAY-006 | UC-011 | AC-MEM-003 | TS-021 | Member detail should show payment history and related records. |
| BR-010 | FR-RBAC-001 | UC-012 | AC-RBAC-001 | TS-017 | Restricted owner features must block unauthorized access. |
| BR-010 | FR-RBAC-001 | UC-012 | AC-RBAC-001 | TS-018 | Trainer cannot edit payment records. |
| BR-011 | FR-MEM-004 | UC-011 | AC-MEM-003 | TS-021 | Member detail should show subscription, payment, and booking history. |
| BR-012 | FR-AUD-001 | UC-012 | AC-AUD-001 | TS-022 | Operational records should store audit details for accountability. |

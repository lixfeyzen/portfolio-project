# ProfitHub System Analysis Case Study

## 1. Project Overview

ProfitHub is a System Analyst case study for a gym operations and membership
management system.

The project documents the analysis artifacts needed before implementation:
requirements, scope, roles, use cases, process flows, data model, API
specification, acceptance criteria, test scenarios, wireframe notes, and
Mermaid diagrams.

## 2. Business Context

Small and medium gyms often operate with spreadsheets, chat messages,
handwritten notes, and separate payment records.

These tools may work at a very small scale, but they become difficult to control
when the gym has recurring memberships, multiple plans, scheduled classes,
trainer availability, and owner reporting needs.

## 3. Problem Statement

The business needs a structured internal system to reduce unclear member status,
missed payment follow-ups, inconsistent subscription records, schedule conflicts,
and manual revenue tracking.

The system must support daily operations without expanding the MVP into a full
customer-facing mobile app.

## 4. Target Users

- Owner / Manager: reviews business visibility, revenue, member trends, and staff access.
- Admin / Receptionist: manages operational data, payments, subscriptions, and bookings.
- Trainer: views assigned classes and marks attendance.
- Member: represented as a managed record and booking participant only.

## 5. MVP Scope

The MVP includes:

1. Member Management
2. Membership Plan & Subscription
3. Payment Tracking
4. Class Schedule & Booking
5. Owner Dashboard

The MVP excludes:

- Member mobile app
- Payment gateway integration
- Trainer payroll
- Inventory management
- Multi-branch management
- Complex accounting
- Advanced CRM
- Loyalty features
- AI recommendations
- Facial recognition attendance

## 6. Requirement Analysis Approach

The analysis starts from operational pain points, then translates them into
business requirements, functional requirements, validation rules, user roles, and
acceptance criteria.

The scope is intentionally limited to internal workflows that can be delivered
first and expanded later.

The requirements are traceable from business needs to functional requirements,
use cases, acceptance criteria, and test scenarios. Business rules and status
definitions were added to reduce ambiguity for developers and testers.

The MVP scope is intentionally constrained to internal gym operations and
excludes member mobile app, payment gateway integration, and multi-branch
management.

## Evidence Basis

This case study is evidence-based, not client-based.

The MVP modules were selected based on common gym management software features
and realistic operational pain points for small-to-medium gyms. Public benchmark
sources show that membership management, billing/payment tracking, class
scheduling, attendance, and reporting are common gym software capabilities.

No real gym transaction data or confidential client data was used. Primary
validation through gym owner/admin interviews is listed as a future improvement.

## 7. Core Business Flows

- Member Registration Flow: admin creates a member record and confirms required contact information.
- Membership Subscription Flow: admin assigns a membership plan and system calculates the subscription period.
- Payment Tracking Flow: admin records payment details and unpaid or overdue records become visible.
- Class Booking Flow: admin creates class schedules, assigns trainers, checks capacity, and books eligible members.
- Attendance Flow: trainer reviews booking list and marks member attendance.
- Dashboard Reporting Flow: owner reviews member, payment, class, and trainer
  load summaries.

## 8. System Design Summary

ProfitHub is designed as an internal role-based system.

Admins handle day-to-day operations, trainers handle class attendance, and owners
monitor performance and access summaries. The MVP focuses on structured records
and operational control rather than automation-heavy or customer-facing features.

## 9. Data Model Summary

The data model centers on members, membership plans, subscriptions, payments,
class schedules, class bookings, and attendance.

Users and trainers are separated so system access can be managed independently
from trainer scheduling.

## 10. API Design Summary

The draft API specification defines endpoints for members, subscriptions,
payments, classes, bookings, attendance, and dashboard summary data.

The endpoints are planning-level contracts intended to guide future
implementation.

## 11. Testing and Acceptance Criteria

Acceptance criteria and test scenarios focus on high-risk operational rules:

- Subscription status calculation
- Unpaid tracking
- Expired member booking prevention
- Trainer conflict prevention
- Class capacity checks
- Role permission control

## 12. Assumptions and Limitations

This is a portfolio case study using a hypothetical gym context.

No real client data is used. The diagrams are conceptual, and the API
specification is draft-level. The project does not claim that a working
application has been built or deployed.

## 13. Skills Demonstrated

- Business analysis and scope control
- Requirement documentation
- Use case design
- Process modeling
- ERD and data model planning
- API documentation
- Acceptance criteria writing
- Test scenario planning
- Wireframe annotation

## 14. Project Deliverables

- Portfolio README
- Project brief
- System analysis case study
- MVP scope document
- BRD-style business requirements
- Functional and non-functional requirements
- Role and permission matrix
- Use cases
- Business process flows
- System Requirements Specification
- Data model and ERD notes
- Draft API specification
- Acceptance criteria and test scenarios
- Wireframe notes
- Mermaid diagram source files

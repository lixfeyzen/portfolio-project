# Project Brief

## Project Background

ProfitHub is a proposed internal operations system for small and medium gym
businesses.

The project responds to common operational problems in gyms that rely on Excel,
WhatsApp, paper notes, and disconnected tools to manage members, subscriptions,
payments, classes, trainers, and reporting.

## Assumed Client Context

The assumed client is a single-location or small gym operator with an owner, one
or more admins or receptionists, and several trainers.

The gym needs better control over daily operations but does not need a full
member-facing mobile application during the MVP phase.

No real gym client data is used in this project.

## Business Pain Points

- Member status is unclear across active, expired, unpaid, and expiring records.
- Payment follow-ups are easy to miss because payment records are tracked manually.
- Revenue reporting requires manual calculation and reconciliation.
- Class schedules can overlap or exceed capacity.
- Trainers can be assigned to conflicting class times.
- Member, subscription, and payment histories are inconsistent.
- Owners lack a simple operational dashboard.
- Operational changes have limited auditability.

## MVP Objective

Create a documented system design for an internal gym operations system covering:

- Member management
- Subscriptions
- Payments
- Class bookings
- Attendance
- Owner dashboard reporting

## Target Users

- Owner / Manager: monitors business performance, member status, revenue, and operational reports.
- Admin / Receptionist: manages members, subscriptions, payments, and class bookings.
- Trainer: views assigned classes and marks attendance.
- Member: represented only as a data record and class booking participant in the MVP.

## Core Workflows

1. Register a new member.
2. Assign a membership plan and subscription period.
3. Record payment and track unpaid or overdue members.
4. Create class schedules and assign trainers.
5. Book eligible members into classes.
6. Mark attendance.
7. Review owner dashboard summaries.

## Success Criteria

- Admin can manage member records and membership status from one system.
- Subscriptions have clear start dates, end dates, and status.
- Payment records can be searched and reviewed by member.
- Unpaid and overdue members are visible for follow-up.
- Expired members cannot be booked into classes.
- Trainer schedule conflicts are blocked.
- Owner can view key operational summaries without manual spreadsheet consolidation.

## System Scope

The MVP includes five modules:

1. Member Management
2. Membership Plan & Subscription
3. Payment Tracking
4. Class Schedule & Booking
5. Owner Dashboard

## Assumptions

- The MVP is designed for internal gym staff.
- A member mobile app is intentionally excluded.
- Payment gateway integration is excluded; payments are recorded manually by staff.
- Multi-branch management is excluded.
- The API specification is a planning artifact, not a production implementation.

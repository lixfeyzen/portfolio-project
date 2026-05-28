# System Requirements Specification

## 1. Introduction

This document describes the draft system requirements for ProfitHub, an internal
gym operations and membership management system.

The document is intended for portfolio review and future implementation
planning.

## 2. System Purpose

ProfitHub helps small and medium gyms manage member records, membership plans,
subscriptions, payments, class schedules, bookings, attendance, and owner
reporting in one structured system.

## 3. Users

- Owner / Manager
- Admin / Receptionist
- Trainer
- Member as a managed data entity, not a full MVP application user

## 4. System Scope

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
- Complex accounting
- Loyalty points
- AI recommendations
- Facial recognition attendance
- Multi-branch management
- Advanced CRM
- Marketing automation

## 5. Functional Requirements Summary

- Manage member records.
- Assign membership plans and calculate subscription dates.
- Track active, expired, unpaid, overdue, and expiring member conditions.
- Record manual payments and payment history.
- Create class schedules and assign trainers.
- Prevent trainer schedule conflicts.
- Book eligible members into classes.
- Prevent booking when members are expired or classes are full.
- Mark attendance.
- Display owner dashboard summaries.

## 6. Non-Functional Requirements Summary

- Role-based access must protect sensitive operational data.
- Forms must validate required fields and controlled status values.
- Dashboard and search views should perform well for small-to-medium gym data.
- Payment and operational records should support auditability.
- The system should be maintainable and ready for future module expansion.
- Data should be included in backup and recovery planning before production use.

## 7. Supporting Analysis Artifacts

The SRS is supported by these detailed analysis documents:

- Business Rules and Status Definitions
- Requirements Traceability Matrix
- Dashboard Metric Definitions
- Data Dictionary
- System Risk and Controls
- Change Request and Impact Analysis
- Product Backlog

These artifacts clarify logic, traceability, dashboard calculations, risk
controls, future-change impact, and MVP prioritization.

## 8. System Constraints

- The system is designed for internal staff workflows only.
- The MVP does not include online payment processing.
- The MVP does not include member self-service.
- The MVP does not include multi-branch business logic.
- The API specification is draft-level and not a production implementation.

## 9. Assumptions

- Gym staff will manually record offline payments.
- Admin users are responsible for member and booking data accuracy.
- Owners need operational summaries, not complex accounting reports.
- Trainers only need access to assigned class and attendance workflows.

## 10. Future Enhancements

- Member portal or mobile app.
- Online payment integration.
- Automated renewal reminders.
- Advanced reporting and retention analytics.
- Payroll and trainer commission.
- Multi-branch support.
- CRM and marketing automation.

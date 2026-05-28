# Business Rules and Status Definitions

## Purpose

This document defines operational rules for member status, subscription status,
payment status, booking status, attendance status, and dashboard calculations.

The goal is to reduce ambiguity for developers, testers, and business reviewers
before implementation.

## Member Status Rules

| Status | Definition | Source Logic | Business Meaning |
| --- | --- | --- | --- |
| Active | Has active subscription and no blocking payment issue. | Active subscription and not overdue. | Member can use services. |
| Expiring Soon | Active subscription ends within 7 days. | end_date between today and today + 7. | Needs renewal follow-up. |
| Expired | Latest subscription ended before current date. | latest end_date < current_date. | Not service-eligible. |
| Unpaid | Current subscription has unpaid or overdue payment. | payment_status is Unpaid or Overdue. | Payment follow-up is required. |
| Inactive | No active subscription or current participation. | No active subscription. | Not currently served. |

Note: `Member.status` is an operational summary status derived from
subscription and payment conditions.

## Subscription Status Rules

| Status | Rule | Notes |
| --- | --- | --- |
| Active | current_date is between start_date and end_date. | Member can be service-eligible. |
| Expiring Soon | end_date is within 7 days from current_date. | Used for renewal follow-up. |
| Expired | current_date is greater than end_date. | Blocks new class booking. |
| Cancelled | Subscription is manually cancelled by authorized staff. | Requires audit trail. |
| Pending Payment | Subscription exists but related payment is not confirmed. | May block service depending on policy. |

## Payment Status Rules

| Status | Rule | Business Impact |
| --- | --- | --- |
| Paid | Payment has been recorded and confirmed. | Counts toward revenue. |
| Unpaid | Payment is expected but has not been recorded. | Appears in unpaid list. |
| Overdue | current_date is greater than due_date and status is Unpaid. | Requires follow-up. |
| Cancelled | Payment record was cancelled due to wrong entry. | Must not count as revenue. |
| Refunded | Payment was returned to member. | Must not count as revenue. |

Cancelled and refunded payments must not count toward Monthly Revenue.

## Class Booking Status Rules

| Status | Rule | Notes |
| --- | --- | --- |
| Active Booking | Member is successfully booked into class. | Counts toward class capacity. |
| Cancelled Booking | Booking is cancelled before class starts. | Does not count as active booking. |
| Rejected Booking | Booking is rejected by business rules. | Used for validation feedback. |

Rules:

- A member with expired subscription cannot be booked.
- Booking count cannot exceed class capacity.
- A class cannot accept booking if class status is Cancelled.

## Attendance Status Rules

| Status | Rule | Notes |
| --- | --- | --- |
| Present | Member attended class. | Counts as attended. |
| Absent | Member had active booking but did not attend. | Useful for attendance review. |
| Late | Member attended after allowed check-in time. | Still counts as attended with warning. |
| Cancelled | Attendance is not recorded when booking is cancelled. | Keeps attendance clean. |

## Dashboard Calculation Rules

| Metric | Rule |
| --- | --- |
| Active Members | Count members with Active operational status. |
| Expired Members | Count members with Expired operational status. |
| Expiring Soon Members | Count members whose subscription ends within 7 days. |
| Unpaid Members | Count members with unpaid or overdue payment. |
| Monthly Revenue | Sum Paid payment amount in selected month, excluding cancelled/refunded. |
| New Members This Month | Count members whose join_date is within selected month. |
| Popular Classes | Sort classes by active booking count or attendance count. |
| Trainer Schedule Load | Count assigned classes per trainer within selected period. |

## Business Rule Summary Table

| Rule ID | Rule | Area |
| --- | --- | --- |
| BRULE-001 | Expired members cannot be booked into class. | Class Booking |
| BRULE-002 | Class booking cannot exceed class capacity. | Class Booking |
| BRULE-003 | Trainer cannot be assigned to overlapping schedules. | Class Schedule |
| BRULE-004 | Cancelled payments are excluded from revenue. | Payment |
| BRULE-005 | Refunded payments are excluded from revenue. | Payment |
| BRULE-006 | Expiring Soon means end_date is within 7 days. | Subscription |
| BRULE-007 | Unpaid members must appear in payment follow-up views. | Payment |
| BRULE-008 | Only assigned trainers can mark attendance. | Attendance |
| BRULE-009 | Cancelled bookings do not count toward capacity. | Class Booking |
| BRULE-010 | Owner dashboard metrics must use defined status logic. | Dashboard |

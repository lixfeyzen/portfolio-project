# Acceptance Criteria

## Member Management

- AC-MEM-001: Admin can register a new member with required profile information.
- AC-MEM-002: System prevents saving a member record when required fields are missing.
- AC-MEM-003: Admin can search members by name, phone number, email, and status.
- AC-MEM-004: Admin can view member profile, subscription history, payment history, and class booking history.

## Membership Plan & Subscription

- AC-SUB-001: Admin can create an active membership plan with duration and price.
- AC-SUB-002: Admin can assign a selected plan to a member.
- AC-SUB-003: System calculates subscription end date based on selected plan duration.
- AC-SUB-004: System marks member as expired after subscription end date according to business rules.
- AC-SUB-005: Admin can view expiring soon members.

## Payment Tracking

- AC-PAY-001: Admin can record a member payment with amount, method, status, payment date, and due date.
- AC-PAY-002: System prevents payment record creation when amount is zero or negative.
- AC-PAY-003: Admin can view unpaid members.
- AC-PAY-004: Admin can view overdue payments when due date has passed and status remains unpaid.
- AC-PAY-005: Member payment history is visible from the member profile.

## Class Schedule & Booking

- AC-CLS-001: Admin can create a class schedule with trainer, date, time, and capacity.
- AC-CLS-002: Trainer cannot be assigned to overlapping class schedules.
- AC-CLS-003: Admin can book an active member into a class with available capacity.
- AC-CLS-004: Expired member cannot be booked into a class.
- AC-CLS-005: System prevents booking when class capacity has been reached.
- AC-CLS-006: Admin can cancel a class booking.
- AC-CLS-007: Trainer can mark attendance for assigned class participants.

## Owner Dashboard

- AC-DASH-001: Owner can view active member count.
- AC-DASH-002: Owner can view expired member count.
- AC-DASH-003: Owner can view unpaid member count.
- AC-DASH-004: Owner can view monthly revenue summary based on paid payments.
- AC-DASH-005: Owner can view popular classes and trainer schedule load.

## Role Permissions

- AC-ROLE-001: Trainer cannot access revenue summary.
- AC-ROLE-002: Member is not allowed to log in as an MVP application user.
- AC-ROLE-003: Only authorized roles can manage staff access.

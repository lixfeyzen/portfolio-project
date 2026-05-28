# Acceptance Criteria

## Member Management

- AC-MEM-001: Admin can register a new member using required member information.
- AC-MEM-002: Admin can search and view existing member records.
- AC-MEM-003: Owner or admin can view a member's subscription, payment,
  booking, and attendance history.

## Membership Plan & Subscription

- AC-SUB-001: Admin can assign a membership plan to a member.
- AC-SUB-002: System calculates subscription status from start_date and end_date.

## Payment Tracking

- AC-PAY-001: Admin can record a payment for a member subscription.
- AC-PAY-002: Admin can view unpaid members.
- AC-PAY-003: System identifies overdue payments.

## Class Schedule & Booking

- AC-CLS-001: Admin can create a class schedule.
- AC-CLS-002: System enforces class capacity.
- AC-CLS-003: System rejects trainer schedule conflict.
- AC-CLS-004: Admin can book an eligible member into a class.
- AC-CLS-005: System rejects booking for expired member.

## Attendance

- AC-ATT-001: Trainer can mark attendance for assigned class.

## Owner Dashboard

- AC-DASH-001: Owner can view dashboard summary.
- AC-DASH-002: Owner can view monthly revenue summary.

## Role-Based Access

- AC-RBAC-001: Unauthorized users cannot access restricted dashboard or staff
  features.

## Audit and Operational Records

- AC-AUD-001: Operational records store relevant audit details such as
  created_at, updated_at, created_by, and updated_by where applicable.

## Additional Acceptance Notes

- Cancelled and refunded payments are excluded from monthly revenue.
- Cancelled bookings are not counted as active bookings.
- Member mobile app access is excluded from MVP acceptance scope.

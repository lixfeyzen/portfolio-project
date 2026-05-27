# Functional Requirements

## Member Management

| ID | Requirement |
| --- | --- |
| FR-MEM-001 | Allow an admin to add a member with profile, contact, join date, and status. |
| FR-MEM-002 | Allow an admin to edit member profile information. |
| FR-MEM-003 | Allow users with access to search members by name, phone, email, and status. |
| FR-MEM-004 | Show member profile, current status, subscription history, payment history, and bookings. |
| FR-MEM-005 | Display membership history for a selected member. |
| FR-MEM-006 | Allow an admin to update member status when operationally required. |

## Membership Plan & Subscription

| ID | Requirement |
| --- | --- |
| FR-SUB-001 | Allow authorized users to create plans with name, duration, price, and status. |
| FR-SUB-002 | Allow an admin to assign a membership plan to a member. |
| FR-SUB-003 | Require a start date and calculate end date from selected plan duration. |
| FR-SUB-004 | Calculate subscription status from date and payment condition. |
| FR-SUB-005 | Show members whose subscriptions are expiring soon. |
| FR-SUB-006 | Show expired subscriptions. |

## Payment Tracking

| ID | Requirement |
| --- | --- |
| FR-PAY-001 | Allow an admin to record a payment for a member. |
| FR-PAY-002 | Capture amount, method, status, payment date, due date, subscription, and staff user. |
| FR-PAY-003 | Support paid, unpaid, overdue, cancelled, and refunded payment statuses. |
| FR-PAY-004 | Provide an unpaid member list. |
| FR-PAY-005 | Provide an overdue list based on due date and payment status. |
| FR-PAY-006 | Display payment history for a selected member. |

## Class Schedule & Booking

| ID | Requirement |
| --- | --- |
| FR-CLS-001 | Allow an admin to create a class with trainer, date, time, capacity, and status. |
| FR-CLS-002 | Allow an admin to assign an active trainer to a class. |
| FR-CLS-003 | Require class capacity before opening bookings. |
| FR-CLS-004 | Allow an admin to book an eligible member into a class. |
| FR-CLS-005 | Allow an admin to cancel a class booking. |
| FR-CLS-006 | Prevent expired members from being booked into classes. |
| FR-CLS-007 | Prevent trainer schedule conflicts for overlapping class times. |
| FR-CLS-008 | Prevent bookings when class capacity has been reached. |
| FR-CLS-009 | Allow trainers to mark attendance for booked members. |

## Owner Dashboard

| ID | Requirement |
| --- | --- |
| FR-DASH-001 | Show active member count. |
| FR-DASH-002 | Show expired member count. |
| FR-DASH-003 | Show unpaid members. |
| FR-DASH-004 | Show monthly revenue based on paid payments. |
| FR-DASH-005 | Show new members this month. |
| FR-DASH-006 | Show popular classes based on bookings or attendance. |
| FR-DASH-007 | Show trainer schedule load. |

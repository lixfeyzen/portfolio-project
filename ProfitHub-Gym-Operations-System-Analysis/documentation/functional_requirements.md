# Functional Requirements

## Member Management

| ID | Requirement |
| --- | --- |
| FR-MEM-001 | The system shall allow an admin to add a new member with full name, phone number, email, date of birth, join date, and status. |
| FR-MEM-002 | The system shall allow an admin to edit member profile information. |
| FR-MEM-003 | The system shall allow users with access to search members by name, phone number, email, and status. |
| FR-MEM-004 | The system shall display a member profile with contact details, current membership status, subscription history, payment history, and class booking history. |
| FR-MEM-005 | The system shall display membership history for a selected member. |
| FR-MEM-006 | The system shall allow an admin to update member status when operationally required. |

## Membership Plan & Subscription

| ID | Requirement |
| --- | --- |
| FR-SUB-001 | The system shall allow an authorized user to create a membership plan with plan name, duration days, price, description, and active status. |
| FR-SUB-002 | The system shall allow an admin to assign a membership plan to a member. |
| FR-SUB-003 | The system shall require a subscription start date and calculate the end date based on selected plan duration. |
| FR-SUB-004 | The system shall calculate subscription status based on date and payment condition. |
| FR-SUB-005 | The system shall show members whose subscriptions are expiring soon. |
| FR-SUB-006 | The system shall show expired subscriptions. |

## Payment Tracking

| ID | Requirement |
| --- | --- |
| FR-PAY-001 | The system shall allow an admin to record a payment for a member. |
| FR-PAY-002 | The payment form shall capture amount, payment method, payment status, payment date, due date, subscription reference, and staff user who recorded it. |
| FR-PAY-003 | The system shall support payment statuses such as paid, unpaid, overdue, cancelled, and refunded. |
| FR-PAY-004 | The system shall provide an unpaid member list. |
| FR-PAY-005 | The system shall provide an overdue payment list based on due date and payment status. |
| FR-PAY-006 | The system shall display payment history for a selected member. |

## Class Schedule & Booking

| ID | Requirement |
| --- | --- |
| FR-CLS-001 | The system shall allow an admin to create a class schedule with class name, trainer, date, start time, end time, capacity, and status. |
| FR-CLS-002 | The system shall allow an admin to assign an active trainer to a class. |
| FR-CLS-003 | The system shall require class capacity before the class is opened for bookings. |
| FR-CLS-004 | The system shall allow an admin to book an eligible member into a class. |
| FR-CLS-005 | The system shall allow an admin to cancel a class booking. |
| FR-CLS-006 | The system shall prevent expired members from being booked into classes. |
| FR-CLS-007 | The system shall prevent trainer schedule conflicts for overlapping class times. |
| FR-CLS-008 | The system shall prevent bookings when class capacity has been reached. |
| FR-CLS-009 | The system shall allow trainers to mark attendance for booked members. |

## Owner Dashboard

| ID | Requirement |
| --- | --- |
| FR-DASH-001 | The dashboard shall show the number of active members. |
| FR-DASH-002 | The dashboard shall show the number of expired members. |
| FR-DASH-003 | The dashboard shall show unpaid members. |
| FR-DASH-004 | The dashboard shall show monthly revenue based on recorded paid payments. |
| FR-DASH-005 | The dashboard shall show new members this month. |
| FR-DASH-006 | The dashboard shall show popular classes based on bookings or attendance. |
| FR-DASH-007 | The dashboard shall show trainer schedule load. |

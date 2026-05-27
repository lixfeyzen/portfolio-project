# Data Model and ERD Notes

## Entity Definitions

### User

- user_id
- full_name
- email
- role
- password_hash
- is_active
- created_at
- updated_at

### Member

- member_id
- full_name
- phone_number
- email
- date_of_birth
- join_date
- status
- created_at
- updated_at

### Trainer

- trainer_id
- full_name
- phone_number
- specialization
- is_active
- created_at

### MembershipPlan

- plan_id
- plan_name
- duration_days
- price
- description
- is_active

### Subscription

- subscription_id
- member_id
- plan_id
- start_date
- end_date
- status
- created_at

### Payment

- payment_id
- member_id
- subscription_id
- amount
- payment_method
- payment_status
- payment_date
- due_date
- created_by

### ClassSchedule

- class_id
- class_name
- trainer_id
- class_date
- start_time
- end_time
- capacity
- status

### ClassBooking

- booking_id
- class_id
- member_id
- booking_status
- booking_date

### Attendance

- attendance_id
- booking_id
- attendance_status
- checked_in_at

## Relationships

- Member has many Subscriptions.
- Subscription belongs to MembershipPlan.
- Member has many Payments.
- Payment may belong to one Subscription.
- Payment is recorded by a User through created_by.
- ClassSchedule belongs to Trainer.
- ClassSchedule has many ClassBookings.
- ClassBooking belongs to Member.
- Attendance belongs to ClassBooking.

## Data Modeling Notes

- `Member.status` supports operational filtering such as active, inactive, expired, and unpaid.
- `Subscription.status` should be calculated or updated based on date and business rules.
- `Payment.payment_status` supports paid, unpaid, overdue, cancelled, and refunded.
- `ClassSchedule.status` supports scheduled, cancelled, and completed.
- `ClassBooking.booking_status` supports booked and cancelled.
- `Attendance.attendance_status` supports present, absent, and late.

See `diagrams/erd.mmd` for the Mermaid ER diagram source.

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
- user_id optional
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

- User is used for system access and role-based permissions.
- Member is not a full app user in the MVP.
- Member has many Subscriptions.
- Subscription belongs to MembershipPlan.
- Member has many Payments.
- Payment is linked to both Member and Subscription.
- Payment is recorded by a User through created_by.
- Trainer may optionally link to User through user_id when trainer login access
  is required.
- ClassSchedule belongs to Trainer.
- ClassSchedule has many ClassBookings.
- ClassBooking belongs to Member.
- Attendance belongs to ClassBooking, not directly to ClassSchedule.

## Data Modeling Notes

- `Member.status` is an operational summary status derived from subscription
  and payment conditions.
- `Subscription.status` and `Payment.payment_status` are source-level status
  records.
- `Subscription.status` should be calculated or updated based on date and
  business rules.
- `Payment.payment_status` supports paid, unpaid, overdue, cancelled, and
  refunded.
- `ClassSchedule.status` supports scheduled, cancelled, and completed.
- `ClassBooking.booking_status` supports Active, Cancelled, and Rejected.
- `Attendance.attendance_status` supports present, absent, and late.

See `diagrams/erd.mmd` for the Mermaid ER diagram source.

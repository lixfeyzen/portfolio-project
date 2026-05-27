# Draft API Specification

This API specification is a planning-level document for future implementation. It does not represent a deployed production API.

## Member Endpoints

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| POST | `/members` | Create a new member. | full_name, phone_number, email, date_of_birth, join_date, status | member_id, full_name, phone_number, email, join_date, status, created_at | full_name, phone_number, and join_date are required. Email must be valid when provided. |
| GET | `/members` | List and search members. | query, status, page, limit | members[], total_count | Status filter must use allowed member status values. |
| GET | `/members/{member_id}` | View member profile. | member_id path parameter | member profile, subscription_history, payment_history, booking_history | member_id must exist. |
| PUT | `/members/{member_id}` | Update member profile. | full_name, phone_number, email, date_of_birth, status | updated member fields | Email must be valid when provided. |

## Subscription Endpoints

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| POST | `/subscriptions` | Assign membership plan to member. | member_id, plan_id, start_date | subscription_id, member_id, plan_id, start_date, end_date, status | Member and active plan must exist. End date is calculated from plan duration. |
| GET | `/subscriptions/expiring` | List expiring subscriptions. | days_threshold, page, limit | subscriptions[], member_summary | days_threshold must be a positive number. |
| GET | `/subscriptions/expired` | List expired subscriptions. | page, limit | subscriptions[], member_summary | Uses end_date and subscription status. |

## Payment Endpoints

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| POST | `/payments` | Record member payment. | member_id, subscription_id, amount, payment_method, payment_status, payment_date, due_date | payment_id, member_id, subscription_id, amount, payment_status, created_by | Amount must be greater than zero. Member must exist. |
| GET | `/payments/unpaid` | List unpaid and overdue payments. | status, page, limit | payments[], total_count | Status filter must support unpaid and overdue. |
| GET | `/payments/member/{member_id}` | View payment history for a member. | member_id path parameter | payments[] | member_id must exist. |

## Class Endpoints

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| POST | `/classes` | Create class schedule. | class_name, trainer_id, class_date, start_time, end_time, capacity, status | class_id, class_name, trainer_id, schedule details | Trainer must be active. Time range must be valid. Overlapping trainer schedules are not allowed. |
| GET | `/classes` | List class schedules. | date_from, date_to, trainer_id, status | classes[] | Date filters must be valid. |
| PUT | `/classes/{class_id}` | Update class schedule. | class_name, trainer_id, class_date, start_time, end_time, capacity, status | updated class fields | Cannot reduce capacity below current active booking count. |

## Booking Endpoints

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| POST | `/class-bookings` | Book member into class. | class_id, member_id | booking_id, class_id, member_id, booking_status, booking_date | Member must have active subscription. Class capacity must be available. |
| DELETE | `/class-bookings/{booking_id}` | Cancel class booking. | booking_id path parameter | booking_id, booking_status | Booking must exist and not already cancelled. |

## Attendance Endpoint

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| POST | `/attendance` | Record attendance for a booking. | booking_id, attendance_status, checked_in_at | attendance_id, booking_id, attendance_status, checked_in_at | Booking must exist. Attendance status must use allowed values. |

## Dashboard Endpoint

| Method | Endpoint | Purpose | Request Fields | Response Fields | Validation Notes |
| --- | --- | --- | --- | --- | --- |
| GET | `/dashboard/summary` | Provide owner dashboard summary. | month, year | active_members, expired_members, unpaid_members, monthly_revenue, new_members_this_month, popular_classes, trainer_schedule_load | User must have dashboard permission. Month and year must be valid when provided. |

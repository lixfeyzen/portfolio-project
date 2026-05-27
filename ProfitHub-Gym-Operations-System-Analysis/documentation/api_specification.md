# Draft API Specification

This API specification is a planning-level document for future implementation.
It does not represent a deployed production API.

## Member Endpoints

### POST `/members`

| Item | Detail |
| --- | --- |
| Purpose | Create a new member. |
| Request fields | full_name, phone_number, email, date_of_birth, join_date, status |
| Response fields | member_id, full_name, phone_number, email, join_date, status, created_at |
| Validation notes | full_name, phone_number, and join_date are required. Email must be valid when provided. |

### GET `/members`

| Item | Detail |
| --- | --- |
| Purpose | List and search members. |
| Request fields | query, status, page, limit |
| Response fields | members[], total_count |
| Validation notes | Status filter must use allowed member status values. |

### GET `/members/{member_id}`

| Item | Detail |
| --- | --- |
| Purpose | View member profile. |
| Request fields | member_id path parameter |
| Response fields | member profile, subscription_history, payment_history, booking_history |
| Validation notes | member_id must exist. |

### PUT `/members/{member_id}`

| Item | Detail |
| --- | --- |
| Purpose | Update member profile. |
| Request fields | full_name, phone_number, email, date_of_birth, status |
| Response fields | updated member fields |
| Validation notes | Email must be valid when provided. |

## Subscription Endpoints

### POST `/subscriptions`

| Item | Detail |
| --- | --- |
| Purpose | Assign membership plan to member. |
| Request fields | member_id, plan_id, start_date |
| Response fields | subscription_id, member_id, plan_id, start_date, end_date, status |
| Validation notes | Member and active plan must exist. End date is calculated from plan duration. |

### GET `/subscriptions/expiring`

| Item | Detail |
| --- | --- |
| Purpose | List expiring subscriptions. |
| Request fields | days_threshold, page, limit |
| Response fields | subscriptions[], member_summary |
| Validation notes | days_threshold must be a positive number. |

### GET `/subscriptions/expired`

| Item | Detail |
| --- | --- |
| Purpose | List expired subscriptions. |
| Request fields | page, limit |
| Response fields | subscriptions[], member_summary |
| Validation notes | Uses end_date and subscription status. |

## Payment Endpoints

### POST `/payments`

| Item | Detail |
| --- | --- |
| Purpose | Record member payment. |
| Request fields | member_id, subscription_id, amount, payment_method, payment_status, payment_date, due_date |
| Response fields | payment_id, member_id, subscription_id, amount, payment_status, created_by |
| Validation notes | Amount must be greater than zero. Member must exist. |

### GET `/payments/unpaid`

| Item | Detail |
| --- | --- |
| Purpose | List unpaid and overdue payments. |
| Request fields | status, page, limit |
| Response fields | payments[], total_count |
| Validation notes | Status filter must support unpaid and overdue. |

### GET `/payments/member/{member_id}`

| Item | Detail |
| --- | --- |
| Purpose | View payment history for a member. |
| Request fields | member_id path parameter |
| Response fields | payments[] |
| Validation notes | member_id must exist. |

## Class Endpoints

### POST `/classes`

| Item | Detail |
| --- | --- |
| Purpose | Create class schedule. |
| Request fields | class_name, trainer_id, class_date, start_time, end_time, capacity, status |
| Response fields | class_id, class_name, trainer_id, class_date, start_time, end_time, capacity |
| Validation notes | Trainer must be active. Time range must be valid. Overlaps are not allowed. |

### GET `/classes`

| Item | Detail |
| --- | --- |
| Purpose | List class schedules. |
| Request fields | date_from, date_to, trainer_id, status |
| Response fields | classes[] |
| Validation notes | Date filters must be valid. |

### PUT `/classes/{class_id}`

| Item | Detail |
| --- | --- |
| Purpose | Update class schedule. |
| Request fields | class_name, trainer_id, class_date, start_time, end_time, capacity, status |
| Response fields | updated class fields |
| Validation notes | Capacity cannot be reduced below current active booking count. |

## Booking Endpoints

### POST `/class-bookings`

| Item | Detail |
| --- | --- |
| Purpose | Book member into class. |
| Request fields | class_id, member_id |
| Response fields | booking_id, class_id, member_id, booking_status, booking_date |
| Validation notes | Member must be active and class capacity must be available. |

### DELETE `/class-bookings/{booking_id}`

| Item | Detail |
| --- | --- |
| Purpose | Cancel class booking. |
| Request fields | booking_id path parameter |
| Response fields | booking_id, booking_status |
| Validation notes | Booking must exist and not already be cancelled. |

## Attendance Endpoint

### POST `/attendance`

| Item | Detail |
| --- | --- |
| Purpose | Record attendance for a booking. |
| Request fields | booking_id, attendance_status, checked_in_at |
| Response fields | attendance_id, booking_id, attendance_status, checked_in_at |
| Validation notes | Booking must exist. Attendance status must use allowed values. |

## Dashboard Endpoint

### GET `/dashboard/summary`

| Item | Detail |
| --- | --- |
| Purpose | Provide owner dashboard summary. |
| Request fields | month, year |
| Response fields | active_members, expired_members, unpaid_members, monthly_revenue |
| Response fields | new_members_this_month, popular_classes, trainer_schedule_load |
| Validation notes | User must have dashboard permission. Month and year must be valid when provided. |

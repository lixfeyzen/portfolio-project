# Draft API Specification

This API specification is a planning-level document for future implementation.
It does not represent a deployed production API.

## User / Staff Access Endpoints

### List Users

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/users` |
| Purpose | List staff users for access review. |
| Request Fields | role, is_active, page, limit |
| Response Fields | users[], total_count |
| Validation Notes | Owner / Manager permission required. |
| Related Module | User / Staff Access |

### Create User

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/users` |
| Purpose | Create staff access account. |
| Request Fields | full_name, email, role, password |
| Response Fields | user_id, full_name, email, role, is_active |
| Validation Notes | Email must be unique and role must be allowed. |
| Related Module | User / Staff Access |

### Get User Detail

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/users/{user_id}` |
| Purpose | View one staff user account. |
| Request Fields | user_id path parameter |
| Response Fields | user_id, full_name, email, role, is_active |
| Validation Notes | user_id must exist. |
| Related Module | User / Staff Access |

### Update User

| Field | Details |
| --- | --- |
| Method | PUT |
| Endpoint | `/users/{user_id}` |
| Purpose | Update staff access account. |
| Request Fields | full_name, role, is_active |
| Response Fields | updated user fields |
| Validation Notes | Owner / Manager permission required. |
| Related Module | User / Staff Access |

## Member Endpoints

### Create Member

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/members` |
| Purpose | Create a new member. |
| Request Fields | full_name, phone_number, email, date_of_birth, join_date, status |
| Response Fields | member_id, full_name, phone_number, email, join_date, status |
| Validation Notes | full_name, phone_number, and join_date are required. |
| Related Module | Member Management |

### List Members

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/members` |
| Purpose | List and search members. |
| Request Fields | query, status, page, limit |
| Response Fields | members[], total_count |
| Validation Notes | Status filter must use allowed member statuses. |
| Related Module | Member Management |

### Get Member Detail

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/members/{member_id}` |
| Purpose | View member profile and history. |
| Request Fields | member_id path parameter |
| Response Fields | member, subscriptions, payments, bookings |
| Validation Notes | member_id must exist. |
| Related Module | Member Management |

### Update Member

| Field | Details |
| --- | --- |
| Method | PUT |
| Endpoint | `/members/{member_id}` |
| Purpose | Update member profile. |
| Request Fields | full_name, phone_number, email, date_of_birth, status |
| Response Fields | updated member fields |
| Validation Notes | Email must be valid when provided. |
| Related Module | Member Management |

## Trainer Endpoints

### List Trainers

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/trainers` |
| Purpose | List active and inactive trainers. |
| Request Fields | is_active, specialization, page, limit |
| Response Fields | trainers[], total_count |
| Validation Notes | Only authorized staff can view trainer records. |
| Related Module | Class Schedule & Booking |

### Create Trainer

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/trainers` |
| Purpose | Create trainer profile. |
| Request Fields | user_id, full_name, phone_number, specialization, is_active |
| Response Fields | trainer_id, user_id, full_name, is_active |
| Validation Notes | user_id is optional and must exist if provided. |
| Related Module | Class Schedule & Booking |

### Get Trainer Detail

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/trainers/{trainer_id}` |
| Purpose | View trainer profile and assigned classes. |
| Request Fields | trainer_id path parameter |
| Response Fields | trainer, assigned_classes |
| Validation Notes | trainer_id must exist. |
| Related Module | Class Schedule & Booking |

### Update Trainer

| Field | Details |
| --- | --- |
| Method | PUT |
| Endpoint | `/trainers/{trainer_id}` |
| Purpose | Update trainer profile or active status. |
| Request Fields | user_id, full_name, phone_number, specialization, is_active |
| Response Fields | updated trainer fields |
| Validation Notes | user_id must exist if provided. |
| Related Module | Class Schedule & Booking |

## Membership Plan Endpoints

### Create Membership Plan

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/membership-plans` |
| Purpose | Create a membership plan. |
| Request Fields | plan_name, duration_days, price, description, is_active |
| Response Fields | plan_id, plan_name, duration_days, price, is_active |
| Validation Notes | duration_days and price must be greater than zero. |
| Related Module | Membership Plan & Subscription |

### List Membership Plans

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/membership-plans` |
| Purpose | List membership plans. |
| Request Fields | is_active, page, limit |
| Response Fields | plans[], total_count |
| Validation Notes | Only active plans can be assigned to members. |
| Related Module | Membership Plan & Subscription |

### Get Membership Plan Detail

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/membership-plans/{plan_id}` |
| Purpose | View one membership plan. |
| Request Fields | plan_id path parameter |
| Response Fields | plan_id, plan_name, duration_days, price, description, is_active |
| Validation Notes | plan_id must exist. |
| Related Module | Membership Plan & Subscription |

### Update Membership Plan

| Field | Details |
| --- | --- |
| Method | PUT |
| Endpoint | `/membership-plans/{plan_id}` |
| Purpose | Update membership plan details. |
| Request Fields | plan_name, duration_days, price, description, is_active |
| Response Fields | updated plan fields |
| Validation Notes | Do not alter active subscriptions retroactively. |
| Related Module | Membership Plan & Subscription |

## Subscription Endpoints

### Create Subscription

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/subscriptions` |
| Purpose | Assign membership plan to member. |
| Request Fields | member_id, plan_id, start_date |
| Response Fields | subscription_id, member_id, plan_id, start_date, end_date, status |
| Validation Notes | Member and active plan must exist. |
| Related Module | Membership Plan & Subscription |

### List Expiring Subscriptions

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/subscriptions/expiring` |
| Purpose | List expiring subscriptions. |
| Request Fields | days_threshold, page, limit |
| Response Fields | subscriptions[], member_summary |
| Validation Notes | days_threshold must be a positive number. |
| Related Module | Membership Plan & Subscription |

### List Expired Subscriptions

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/subscriptions/expired` |
| Purpose | List expired subscriptions. |
| Request Fields | page, limit |
| Response Fields | subscriptions[], member_summary |
| Validation Notes | Uses end_date and subscription status. |
| Related Module | Membership Plan & Subscription |

## Payment Endpoints

### Record Payment

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/payments` |
| Purpose | Record member payment. |
| Request Fields | member_id, subscription_id, amount, method, status, payment_date, due_date |
| Response Fields | payment_id, member_id, subscription_id, amount, payment_status |
| Validation Notes | Amount must be greater than zero. Member must exist. |
| Related Module | Payment Tracking |

### List Unpaid Payments

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/payments/unpaid` |
| Purpose | List unpaid and overdue payments. |
| Request Fields | status, page, limit |
| Response Fields | payments[], total_count |
| Validation Notes | Status filter must support unpaid and overdue. |
| Related Module | Payment Tracking |

### Get Member Payments

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/payments/member/{member_id}` |
| Purpose | View payment history for a member. |
| Request Fields | member_id path parameter |
| Response Fields | payments[] |
| Validation Notes | member_id must exist. |
| Related Module | Payment Tracking |

## Class Endpoints

### Create Class

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/classes` |
| Purpose | Create class schedule. |
| Request Fields | class_name, trainer_id, class_date, start_time, end_time, capacity, status |
| Response Fields | class_id, class_name, trainer_id, class_date, capacity, status |
| Validation Notes | Trainer overlap and valid time range must be checked. |
| Related Module | Class Schedule & Booking |

### List Classes

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/classes` |
| Purpose | List class schedules. |
| Request Fields | date_from, date_to, trainer_id, status |
| Response Fields | classes[] |
| Validation Notes | Date filters must be valid. |
| Related Module | Class Schedule & Booking |

### Update Class

| Field | Details |
| --- | --- |
| Method | PUT |
| Endpoint | `/classes/{class_id}` |
| Purpose | Update class schedule. |
| Request Fields | class_name, trainer_id, class_date, start_time, end_time, capacity, status |
| Response Fields | updated class fields |
| Validation Notes | Capacity cannot be reduced below active booking count. |
| Related Module | Class Schedule & Booking |

## Booking Endpoints

### Create Class Booking

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/class-bookings` |
| Purpose | Book member into class. |
| Request Fields | class_id, member_id |
| Response Fields | booking_id, class_id, member_id, booking_status, booking_date |
| Validation Notes | Member must be active and class capacity must be available. |
| Related Module | Class Schedule & Booking |

### Cancel Class Booking

| Field | Details |
| --- | --- |
| Method | DELETE |
| Endpoint | `/class-bookings/{booking_id}` |
| Purpose | Cancel class booking. |
| Request Fields | booking_id path parameter |
| Response Fields | booking_id, booking_status |
| Validation Notes | Booking must exist and not already be cancelled. |
| Related Module | Class Schedule & Booking |

## Attendance Endpoint

### Record Attendance

| Field | Details |
| --- | --- |
| Method | POST |
| Endpoint | `/attendance` |
| Purpose | Record attendance for a booking. |
| Request Fields | booking_id, attendance_status, checked_in_at |
| Response Fields | attendance_id, booking_id, attendance_status, checked_in_at |
| Validation Notes | Booking must exist and trainer must be authorized. |
| Related Module | Class Schedule & Booking |

## Dashboard Endpoint

### Get Dashboard Summary

| Field | Details |
| --- | --- |
| Method | GET |
| Endpoint | `/dashboard/summary` |
| Purpose | Provide owner dashboard summary. |
| Request Fields | month, year |
| Response Fields | active_members, expired_members, unpaid_members, monthly_revenue, new_members_this_month, popular_classes, trainer_schedule_load |
| Validation Notes | User must have dashboard permission. |
| Related Module | Owner Dashboard |

## API-Level Validation Rules

- Required fields cannot be empty.
- Class capacity cannot be exceeded.
- Expired members cannot be booked.
- Overlapping trainer schedules must be rejected.
- Cancelled/refunded payments must not count toward revenue.
- Only authorized roles can access role-specific endpoints.

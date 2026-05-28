# Data Dictionary

## Purpose

This data dictionary makes the conceptual data model clearer for implementation
planning. Example values are neutral placeholders and do not represent real
client data.

## User

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| user_id | string | Yes | Unique system user ID. | USR-0001 | Primary key. |
| full_name | string | Yes | User full name. | Staff User | Staff identity. |
| email | string | Yes | Login email. | staff@example.com | Must be unique. |
| role | enum | Yes | Access role. | Admin | Owner, Admin, Trainer. |
| password_hash | string | Yes | Hashed password. | hash_value | Never expose in API. |
| is_active | boolean | Yes | User access status. | true | Blocks disabled accounts. |
| created_at | datetime | Yes | Record creation time. | 2026-01-01T09:00:00 | Audit field. |
| updated_at | datetime | Yes | Last update time. | 2026-01-02T09:00:00 | Audit field. |

## Member

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| member_id | string | Yes | Unique member ID. | MEM-0001 | Primary key. |
| full_name | string | Yes | Member full name. | Sample Member | Neutral sample. |
| phone_number | string | Yes | Member phone number. | 080000000001 | Used for contact. |
| email | string | No | Member email. | member@example.com | Optional in MVP. |
| date_of_birth | date | No | Member birth date. | 1995-01-01 | Optional profile data. |
| join_date | date | Yes | First join date. | 2026-01-01 | Used for new member metric. |
| status | enum | Yes | Operational member status. | Active | Derived summary status. |
| created_at | datetime | Yes | Record creation time. | 2026-01-01T09:00:00 | Audit field. |
| updated_at | datetime | Yes | Last update time. | 2026-01-02T09:00:00 | Audit field. |

## Trainer

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| trainer_id | string | Yes | Unique trainer ID. | TRN-0001 | Primary key. |
| user_id | string | No | Linked system user ID. | USR-0003 | Optional login link. |
| full_name | string | Yes | Trainer full name. | Sample Trainer | Neutral sample. |
| phone_number | string | No | Trainer phone number. | 080000000002 | Staff contact. |
| specialization | string | No | Trainer specialty. | Strength | Optional. |
| is_active | boolean | Yes | Trainer availability status. | true | Used for scheduling. |
| created_at | datetime | Yes | Record creation time. | 2026-01-01T09:00:00 | Audit field. |

## MembershipPlan

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| plan_id | string | Yes | Unique plan ID. | PLAN-MONTHLY | Primary key. |
| plan_name | string | Yes | Plan display name. | Monthly Plan | Internal plan name. |
| duration_days | integer | Yes | Subscription length in days. | 30 | Used for end_date. |
| price | decimal | Yes | Plan price. | 250000 | Currency handled later. |
| description | string | No | Plan description. | One-month access | Optional. |
| is_active | boolean | Yes | Plan availability. | true | Inactive plans not assignable. |

## Subscription

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| subscription_id | string | Yes | Unique subscription ID. | SUB-0001 | Primary key. |
| member_id | string | Yes | Linked member. | MEM-0001 | Foreign key. |
| plan_id | string | Yes | Linked membership plan. | PLAN-MONTHLY | Foreign key. |
| start_date | date | Yes | Subscription start date. | 2026-01-01 | Required. |
| end_date | date | Yes | Subscription end date. | 2026-01-31 | Calculated from plan. |
| status | enum | Yes | Subscription status. | Active | Source-level status. |
| created_at | datetime | Yes | Record creation time. | 2026-01-01T09:00:00 | Audit field. |

## Payment

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| payment_id | string | Yes | Unique payment ID. | PAY-0001 | Primary key. |
| member_id | string | Yes | Linked member. | MEM-0001 | Foreign key. |
| subscription_id | string | Yes | Linked subscription. | SUB-0001 | Connects payment to subscription. |
| amount | decimal | Yes | Payment amount. | 250000 | Must be positive. |
| payment_method | enum | Yes | Payment method. | Cash | Manual record in MVP. |
| payment_status | enum | Yes | Payment status. | Paid | Source-level status. |
| payment_date | date | No | Date payment was made. | 2026-01-01 | Required when Paid. |
| due_date | date | No | Expected payment date. | 2026-01-03 | Used for overdue. |
| created_by | string | Yes | Staff user who recorded it. | USR-0002 | Audit reference. |

## ClassSchedule

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| class_id | string | Yes | Unique class ID. | CLS-0001 | Primary key. |
| class_name | string | Yes | Class display name. | Strength Class | Class title. |
| trainer_id | string | Yes | Assigned trainer. | TRN-0001 | Foreign key. |
| class_date | date | Yes | Scheduled class date. | 2026-01-10 | Required. |
| start_time | time | Yes | Class start time. | 18:00 | Required. |
| end_time | time | Yes | Class end time. | 19:00 | Must be after start. |
| capacity | integer | Yes | Max active bookings. | 15 | Must be positive. |
| status | enum | Yes | Class status. | Scheduled | Scheduled, Cancelled, Completed. |

## ClassBooking

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| booking_id | string | Yes | Unique booking ID. | BKG-0001 | Primary key. |
| class_id | string | Yes | Linked class schedule. | CLS-0001 | Foreign key. |
| member_id | string | Yes | Linked member. | MEM-0001 | Foreign key. |
| booking_status | enum | Yes | Booking status. | Active | Active, Cancelled, Rejected. |
| booking_date | datetime | Yes | Booking creation time. | 2026-01-09T10:00:00 | Audit field. |

## Attendance

| Field Name | Data Type | Required | Description | Example Value | Notes |
| --- | --- | --- | --- | --- | --- |
| attendance_id | string | Yes | Unique attendance ID. | ATT-0001 | Primary key. |
| booking_id | string | Yes | Linked booking. | BKG-0001 | Foreign key. |
| attendance_status | enum | Yes | Attendance result. | Present | Present, Absent, Late. |
| checked_in_at | datetime | No | Actual check-in time. | 2026-01-10T18:05:00 | Required if Present/Late. |

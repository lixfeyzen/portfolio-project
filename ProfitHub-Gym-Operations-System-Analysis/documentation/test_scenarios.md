# Test Scenarios

| Test ID | Scenario | Precondition | Steps | Expected Result |
| --- | --- | --- | --- | --- |
| TS-001 | Register member with valid data | Admin is logged in | Open member form, enter valid data, save | Member record is created |
| TS-002 | Register member without phone number | Admin is logged in | Open member form, leave phone number blank, save | System shows validation error |
| TS-003 | Search member by name | Member exists | Enter member name in search field | Matching member appears |
| TS-004 | Update member status | Member exists | Open member profile, change status, save | Member status is updated |
| TS-005 | Create membership plan | Authorized user is logged in | Enter plan name, duration, price, save | Plan is created |
| TS-006 | Assign membership plan | Member and active plan exist | Select member, choose plan, set start date, save | Subscription is created with calculated end date |
| TS-007 | Assign inactive plan | Member and inactive plan exist | Select inactive plan and save | System blocks assignment |
| TS-008 | Calculate expired subscription | Subscription end date has passed | Open member profile or expired list | Subscription appears as expired |
| TS-009 | View expiring soon subscriptions | Subscriptions exist near end date | Open expiring soon filter | Expiring members are listed |
| TS-010 | Record valid payment | Member exists | Enter amount, method, status, payment date, save | Payment record is created |
| TS-011 | Record payment with negative amount | Member exists | Enter negative amount and save | System rejects payment |
| TS-012 | View unpaid members | Unpaid payment records exist | Open unpaid payment list | Unpaid records are displayed |
| TS-013 | View overdue payment | Unpaid payment due date has passed | Open overdue payment list | Overdue payment is displayed |
| TS-014 | Create valid class schedule | Active trainer exists | Enter class details with valid time and capacity | Class schedule is created |
| TS-015 | Create class with invalid time range | Active trainer exists | Enter end time earlier than start time | System rejects schedule |
| TS-016 | Prevent trainer conflict | Trainer already has overlapping class | Create another overlapping class for same trainer | System blocks schedule |
| TS-017 | Book active member into class | Class has capacity and member is active | Select member and confirm booking | Booking is created |
| TS-018 | Prevent expired member booking | Member subscription is expired | Attempt to book member into class | System blocks booking |
| TS-019 | Prevent over-capacity booking | Class capacity is full | Attempt to add another member | System blocks booking |
| TS-020 | Cancel class booking | Active booking exists | Select booking and cancel | Booking status becomes cancelled |
| TS-021 | Mark attendance | Trainer has assigned class with bookings | Open class list, mark attendance, save | Attendance records are saved |
| TS-022 | Trainer attempts revenue access | Trainer is logged in | Open revenue summary route | Access is denied |
| TS-023 | Owner views dashboard summary | Owner is logged in and records exist | Open dashboard | Dashboard displays member, payment, class, and trainer summaries |
| TS-024 | Admin attempts staff access management | Admin is logged in | Open staff access management | Access is denied |

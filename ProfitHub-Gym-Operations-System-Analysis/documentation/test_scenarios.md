# Test Scenarios

| Test ID | Scenario | Precondition | Steps | Expected Result |
| --- | --- | --- | --- | --- |
| TS-001 | Register valid member | Admin is logged in | Enter valid member data and save | Member record is created |
| TS-002 | Register without phone | Admin is logged in | Leave phone blank and save | System shows error |
| TS-003 | Search member by name | Member exists | Search by member name | Matching member appears |
| TS-004 | Update member status | Member exists | Change status from member profile | Member status is updated |
| TS-005 | Create plan | Authorized user is logged in | Enter name, duration, and price | Plan is created |
| TS-006 | Assign plan | Member and active plan exist | Choose plan and start date | End date is calculated |
| TS-007 | Assign inactive plan | Member and inactive plan exist | Select inactive plan | System blocks assignment |
| TS-008 | Calculate expired status | End date has passed | Open expired list | Subscription appears as expired |
| TS-009 | View expiring soon list | End date is near | Open expiring soon filter | Expiring members are listed |
| TS-010 | Record valid payment | Member exists | Enter payment details and save | Payment record is created |
| TS-011 | Record negative payment | Member exists | Enter negative amount and save | System rejects payment |
| TS-012 | View unpaid members | Unpaid records exist | Open unpaid payment list | Unpaid records are displayed |
| TS-013 | View overdue payment | Due date has passed | Open overdue list | Overdue payment is displayed |
| TS-014 | Create valid class | Active trainer exists | Enter valid class details | Class schedule is created |
| TS-015 | Invalid time range | Active trainer exists | End time is before start time | System rejects schedule |
| TS-016 | Prevent trainer conflict | Trainer has overlap | Create overlapping class | System blocks schedule |
| TS-017 | Book active member | Class has capacity | Select active member and confirm | Booking is created |
| TS-018 | Prevent expired booking | Member is expired | Try to book member | System blocks booking |
| TS-019 | Prevent over-capacity | Class capacity is full | Try to add another member | System blocks booking |
| TS-020 | Cancel class booking | Active booking exists | Select booking and cancel | Booking becomes cancelled |
| TS-021 | Mark attendance | Trainer has assigned class | Mark attendance and save | Attendance records are saved |
| TS-022 | Block trainer revenue access | Trainer is logged in | Open revenue summary route | Access is denied |
| TS-023 | View dashboard summary | Owner is logged in | Open dashboard | Summary metrics are displayed |
| TS-024 | Block admin staff access | Admin is logged in | Open staff access management | Access is denied |

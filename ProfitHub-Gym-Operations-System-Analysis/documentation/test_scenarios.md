# Test Scenarios

| Test ID | Scenario | Precondition | Steps | Expected Result |
| --- | --- | --- | --- | --- |
| TS-001 | New member registration succeeds. | Admin is logged in. | Enter required member data and save. | Member record is created. |
| TS-002 | Admin can search member by name or phone number. | Member exists. | Search by name or phone. | Matching member is shown. |
| TS-003 | Plan can be assigned to member. | Member and active plan exist. | Select plan and start date. | Subscription is created. |
| TS-004 | Subscription status is calculated. | Subscription dates exist. | Compare dates. | Correct status is shown. |
| TS-005 | Payment can be recorded. | Member subscription exists. | Enter payment details and save. | Payment record is created. |
| TS-006 | Unpaid member appears in unpaid list. | Unpaid payment exists. | Open unpaid payment view. | Member appears in list. |
| TS-007 | Overdue payment is identified. | Unpaid due date has passed. | Open overdue view. | Payment is marked overdue. |
| TS-008 | Class schedule can be created. | Active trainer exists. | Enter class details and save. | Class schedule is created. |
| TS-009 | Class capacity limit is enforced. | Class is at capacity. | Try to book another member. | Booking is rejected. |
| TS-010 | Trainer conflict is rejected. | Trainer has overlapping class. | Create overlapping schedule. | System rejects schedule. |
| TS-011 | Eligible member can be booked. | Member active; class has capacity. | Book member into class. | Booking is created. |
| TS-012 | Expired member booking is rejected. | Member subscription is expired. | Try to book member. | Booking is rejected. |
| TS-013 | Trainer can mark attendance. | Trainer has assigned class. | Mark member attendance. | Attendance is saved. |
| TS-014 | Owner can view dashboard summary. | Owner is logged in. | Open dashboard. | Summary is displayed. |
| TS-015 | Revenue excludes cancelled/refunded payment. | Mixed statuses exist. | Calculate revenue. | Only Paid is included. |
| TS-016 | Owner can access revenue dashboard. | Owner is logged in. | Open revenue summary. | Revenue summary is visible. |
| TS-017 | Admin cannot access restricted revenue setting. | Admin is logged in. | Open setting. | Access is denied. |
| TS-018 | Trainer cannot edit payment records. | Trainer is logged in. | Try to edit payment. | Access is denied. |
| TS-019 | Cancelled booking is not active. | Cancelled booking exists. | Review capacity count. | Booking is excluded. |
| TS-020 | Expiring soon member appears within 7 days. | End date within 7 days. | Open expiring list. | Member appears. |
| TS-021 | Member detail shows operational history. | Member has history. | Open member detail page. | Available history sections display. |
| TS-022 | Audit details are stored. | Staff performs create/update action. | Save operational record. | User and timestamp metadata are stored. |

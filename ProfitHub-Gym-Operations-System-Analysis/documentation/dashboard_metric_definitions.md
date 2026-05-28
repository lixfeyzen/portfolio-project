# Dashboard Metric Definitions

## Purpose

These metrics define how the Owner Dashboard should calculate operational
visibility for member status, payments, classes, and trainer load.

| Metric | Business Purpose | Calculation Logic | Source Entities | Filter Notes | Interpretation Notes |
| --- | --- | --- | --- | --- | --- |
| Active Members | Show eligible members. | Count status Active. | Member, Subscription, Payment | Period optional. | Derived status. |
| Expired Members | Show non-eligible members. | Count expired latest sub. | Member, Subscription | Current date. | Renewal review. |
| Expiring Soon Members | Support renewal. | Count end_date within 7 days. | Member, Subscription | Today + 7. | Admin follow-up. |
| Unpaid Members | Find payment follow-ups. | Count unpaid/overdue members. | Member, Payment | Status based. | May block booking. |
| Monthly Revenue | Show paid revenue. | Sum paid amount in month. | Payment | Exclude Cancelled/Refunded. | Manual payments. |
| New Members This Month | Track new joiners. | Count join_date in month. | Member | Selected month. | Acquisition signal. |
| Popular Classes | Find high-demand classes. | Rank by bookings/attendance. | Class, Booking, Attendance | Period. | Scheduling input. |
| Trainer Schedule Load | Monitor trainer load. | Count assigned classes. | Trainer, Class | Date range. | Prevents overload. |

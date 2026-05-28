# System Risk and Controls

## Purpose

This risk register identifies practical operational risks and controls for the
ProfitHub MVP.

| Risk ID | Risk Description | Impact | Likelihood | Mitigation / Control | Related Module |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Incorrect member status calculation. | High | Medium | Define status rules and test date/payment cases. | Member Management |
| RISK-002 | Duplicate payment record. | High | Medium | Require payment review and show member payment history. | Payment Tracking |
| RISK-003 | Expired member booked into class. | High | Medium | Validate active subscription before booking. | Class Schedule & Booking |
| RISK-004 | Trainer assigned to overlapping classes. | High | Medium | Reject time overlaps. | Class Schedule & Booking |
| RISK-005 | Class booking exceeds capacity. | Medium | Medium | Count active bookings before confirmation. | Class Schedule & Booking |
| RISK-006 | Unauthorized user views revenue dashboard. | High | Low | Apply role-based dashboard permission checks. | Owner Dashboard |
| RISK-007 | Payment revenue mismatch in dashboard. | High | Medium | Use paid-only payment status and period filters. | Owner Dashboard |
| RISK-008 | Missing or invalid member contact data. | Medium | Medium | Require phone and validate email. | Member Management |
| RISK-009 | Attendance marked by unauthorized user. | Medium | Low | Restrict to assigned trainer/admin. | Class Schedule & Booking |
| RISK-010 | Admin forgets unpaid member follow-up. | Medium | Medium | Provide unpaid and overdue payment lists. | Payment Tracking |
| RISK-011 | Cancelled/refunded payment counted as revenue. | High | Medium | Exclude from revenue. | Payment Tracking |
| RISK-012 | No audit trail for manual data change. | Medium | Medium | Store audit fields. | System Control |

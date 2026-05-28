# Use Cases

## UC-001 Register New Member

- Actor: Admin / Receptionist
- Goal: Create a structured member record.
- Precondition: Admin is logged in and has member management access.
- Main Flow:
  1. Admin opens member management.
  2. Admin selects add member.
  3. Admin enters required member details.
  4. System validates required fields and duplicate contact indicators.
  5. Admin saves the member record.
- Alternative Flow: If required information is missing, the system shows
  validation messages and does not save the record.
- Postcondition: New member record is available for subscription assignment.

## UC-002 Assign Membership Plan

- Actor: Admin / Receptionist
- Goal: Assign a plan and subscription period to a member.
- Precondition: Member record and active membership plan exist.
- Main Flow:
  1. Admin opens the member profile.
  2. Admin selects assign membership plan.
  3. Admin chooses plan and start date.
  4. System calculates end date.
  5. Admin confirms subscription.
- Alternative Flow: If selected plan is inactive, the system blocks assignment.
- Postcondition: Member has a subscription record with start date, end date, and
  status.

## UC-003 Record Member Payment

- Actor: Admin / Receptionist
- Goal: Record payment against a member and optional subscription.
- Precondition: Member exists.
- Main Flow:
  1. Admin opens payment tracking.
  2. Admin selects member.
  3. Admin enters amount, payment method, payment status, payment date, and due date.
  4. System validates amount and required fields.
  5. Admin saves payment.
- Alternative Flow: If payment amount is invalid, the system rejects the record.
- Postcondition: Payment history is updated.

## UC-004 View Unpaid Members

- Actor: Owner / Manager or Admin / Receptionist
- Goal: Review members with unpaid or overdue payment records.
- Precondition: Payment records exist.
- Main Flow:
  1. User opens payment tracking.
  2. User selects unpaid or overdue filter.
  3. System displays matching records with member, due date, amount, and status.
- Alternative Flow: If no records match, the system shows an empty state.
- Postcondition: User can identify follow-up targets.

## UC-005 Create Class Schedule

- Actor: Admin / Receptionist
- Goal: Create a class with trainer assignment and capacity.
- Precondition: Active trainer exists.
- Main Flow:
  1. Admin opens class schedule.
  2. Admin enters class name, date, time, trainer, capacity, and status.
  3. System checks trainer availability.
  4. System validates capacity and time range.
  5. Admin saves class schedule.
- Alternative Flow: If trainer has an overlapping class, the system blocks creation.
- Postcondition: Class schedule is available for booking.

## UC-006 Book Member into Class

- Actor: Admin / Receptionist
- Goal: Add an eligible member to a class.
- Precondition: Class exists and member has an active subscription.
- Main Flow:
  1. Admin opens class detail.
  2. Admin selects book member.
  3. System checks subscription status and available capacity.
  4. Admin confirms booking.
- Alternative Flow: If member is expired or class is full, the system blocks booking.
- Postcondition: Member appears in class booking list.

## UC-007 Cancel Class Booking

- Actor: Admin / Receptionist
- Goal: Cancel a member booking.
- Precondition: Booking exists.
- Main Flow:
  1. Admin opens class booking list.
  2. Admin selects a booking.
  3. Admin confirms cancellation.
  4. System updates booking status.
- Alternative Flow: If booking is already cancelled, the system shows current status.
- Postcondition: Booking is marked cancelled and class capacity is released.

## UC-008 Mark Attendance

- Actor: Trainer
- Goal: Record attendance for booked members.
- Precondition: Trainer has an assigned class and booking list exists.
- Main Flow:
  1. Trainer opens assigned class.
  2. Trainer views booked members.
  3. Trainer marks present, absent, or late.
  4. System saves attendance records.
- Alternative Flow: If trainer is not assigned to the class, the system denies access.
- Postcondition: Attendance records are available for reporting.

## UC-009 View Owner Dashboard

- Actor: Owner / Manager
- Goal: Review operational summary.
- Precondition: Owner is logged in.
- Main Flow:
  1. Owner opens dashboard.
  2. System displays member, payment, class, and trainer load summaries.
  3. Owner reviews summary.
- Alternative Flow: If no data exists, dashboard shows empty states.
- Postcondition: Owner has current operational visibility.

## UC-010 Track Expiring Memberships

- Actor: Admin / Receptionist
- Goal: Identify members whose subscriptions are close to end date.
- Precondition: Subscription records exist.
- Main Flow:
  1. Admin opens subscription list.
  2. Admin selects expiring soon filter.
  3. System displays members with subscriptions nearing end date.
- Alternative Flow: If no subscriptions are expiring soon, the system shows an empty state.
- Postcondition: Admin can prepare follow-up or renewal action.

## UC-011 View Member Operational History

- Actor: Owner / Manager or Admin / Receptionist
- Goal: Review a member's subscription, payment, booking, and attendance history.
- Precondition: Member record exists.
- Main Flow:
  1. User opens member detail.
  2. System displays member profile.
  3. System displays subscription history.
  4. System displays payment history.
  5. System displays class booking and attendance history.
- Alternative Flow: If no history exists, the system shows an empty state.
- Postcondition: User can review member history for service and operational decisions.

## UC-012 Review Role-Based Access and Audit Records

- Actor: Owner / Manager
- Goal: Review staff access and audit-related operational records.
- Precondition: Owner is logged in.
- Main Flow:
  1. Owner opens staff access or operational record review.
  2. System displays users, roles, and relevant audit details.
  3. Owner reviews access and record accountability.
- Alternative Flow: If user does not have permission, access is denied.
- Postcondition: Owner can review staff access and audit accountability.

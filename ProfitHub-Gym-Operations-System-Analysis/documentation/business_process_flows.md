# Business Process Flows

## 1. Member Registration Flow

- Trigger: A new customer wants to become a gym member.
- Steps:
  1. Admin opens member management.
  2. Admin enters member profile details.
  3. System validates required fields.
  4. System checks for possible duplicate contact information.
  5. Admin saves the member record.
- Validation Rules:
  - Full name and phone number are required.
  - Email must use a valid format when provided.
  - Join date cannot be blank.
- Output: New member record ready for subscription assignment.

## 2. Membership Subscription Flow

- Trigger: A member purchases or renews a membership plan.
- Steps:
  1. Admin opens the member profile.
  2. Admin selects an active membership plan.
  3. Admin sets subscription start date.
  4. System calculates subscription end date.
  5. System sets subscription status.
- Validation Rules:
  - Selected plan must be active.
  - Start date is required.
  - End date must be calculated from plan duration.
- Output: Subscription record linked to member and plan.

## 3. Payment Tracking Flow

- Trigger: A member pays or has an outstanding payment.
- Steps:
  1. Admin opens payment tracking.
  2. Admin selects member and subscription reference if applicable.
  3. Admin enters amount, payment method, payment status, payment date, and due date.
  4. System validates payment data.
  5. System stores payment record and updates unpaid or overdue views.
- Validation Rules:
  - Amount must be greater than zero.
  - Payment method and status are required.
  - Overdue status is based on due date and unpaid condition.
- Output: Payment history and follow-up lists are updated.

## 4. Class Booking Flow

- Trigger: Admin schedules a class or books a member into a class.
- Steps:
  1. Admin creates class schedule.
  2. System validates trainer availability and class time.
  3. Admin adds member to class booking.
  4. System checks member subscription status.
  5. System checks class capacity.
  6. System confirms booking.
- Validation Rules:
  - Trainer cannot have overlapping class schedules.
  - Class capacity must be greater than zero.
  - Expired members cannot be booked.
  - Booking cannot exceed class capacity.
- Output: Confirmed booking list for the class.

## 5. Attendance Flow

- Trigger: Class session is ready to start or has finished.
- Steps:
  1. Trainer opens assigned class.
  2. Trainer reviews booking list.
  3. Trainer marks each member as present, absent, or late.
  4. System stores attendance records.
- Validation Rules:
  - Only booked members can have attendance recorded.
  - Trainer must be assigned to the class or have authorized access.
- Output: Attendance records linked to class bookings.

## 6. Dashboard Reporting Flow

- Trigger: Owner or authorized user opens dashboard.
- Steps:
  1. System collects member, subscription, payment, booking, and attendance data.
  2. System calculates dashboard summaries.
  3. System displays member, payment, class, and trainer load summaries.
- Validation Rules:
  - Revenue summary uses paid payment records.
  - Expired member summary uses subscription end date and status.
  - Trainer load uses class schedules assigned to trainers.
- Output: Owner dashboard with current operational summary.

# User Roles and Permissions

## Role Definitions

### Owner / Manager

The Owner / Manager monitors operational performance and controls staff access.

Permissions:

- View dashboard.
- View revenue summary.
- View operational reports.
- View member, payment, subscription, class, booking, and attendance records.
- Manage staff access.

### Admin / Receptionist

The Admin / Receptionist manages front-desk operations.

Permissions:

- Manage members.
- Manage subscriptions.
- Record payments.
- Manage class schedules and bookings.
- View payment history and unpaid lists.

### Trainer

The Trainer uses the system for assigned class operations.

Permissions:

- View assigned classes.
- View class attendance list.
- Mark attendance.

### Member

Member is not a full application user in the MVP. A member is represented only as a data entity and booking participant managed by staff.

## Permission Matrix

| Feature / Action | Owner / Manager | Admin / Receptionist | Trainer | Member |
| --- | --- | --- | --- | --- |
| View owner dashboard | Yes | Limited | No | No |
| View revenue summary | Yes | No | No | No |
| View operational reports | Yes | Limited | No | No |
| Manage staff access | Yes | No | No | No |
| Add or edit member records | Yes | Yes | No | No |
| View member profile | Yes | Yes | Limited class context only | No |
| Create membership plan | Yes | Yes | No | No |
| Assign membership plan | Yes | Yes | No | No |
| Record payment | Yes | Yes | No | No |
| View unpaid or overdue list | Yes | Yes | No | No |
| Create class schedule | Yes | Yes | No | No |
| Book member into class | Yes | Yes | No | No |
| Cancel class booking | Yes | Yes | No | No |
| View assigned classes | Yes | Yes | Yes | No |
| Mark attendance | Yes | Limited | Yes | No |

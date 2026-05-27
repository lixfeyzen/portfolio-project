# Non-Functional Requirements

| ID | Category | Requirement |
| --- | --- | --- |
| NFR-001 | Usability | The system should allow admins to complete common workflows such as member registration, payment recording, and class booking with clear forms and validation messages. |
| NFR-002 | Security | The system must protect user credentials using secure password hashing and must not expose password values in API responses. |
| NFR-003 | Role-Based Access | The system must restrict dashboard, payment, member, subscription, class, and attendance actions based on assigned user role. |
| NFR-004 | Data Validation | Required fields, valid dates, valid payment amounts, valid email format, and valid status values must be validated before records are saved. |
| NFR-005 | Performance | Member search, unpaid member list, and dashboard summary should respond quickly for a small-to-medium single-branch gym dataset. |
| NFR-006 | Auditability | Operational records should store created date, updated date, and the user responsible where relevant, especially for payment records. |
| NFR-007 | Availability | The system should be available during gym operating hours with a recovery plan for service interruption. |
| NFR-008 | Maintainability | Requirements, API contracts, and data model definitions should be documented clearly enough for future implementation and maintenance. |
| NFR-009 | Scalability | The MVP data model should support future additions such as member portal, online payment, and multi-branch support without redesigning core member and subscription entities. |
| NFR-010 | Backup and Recovery | Member, payment, subscription, class, booking, and attendance data should be included in scheduled backups before production use. |
| NFR-011 | Privacy | Member contact information should be visible only to authorized staff. |
| NFR-012 | Consistency | Subscription, payment, and booking status values should use controlled lists to avoid inconsistent operational reporting. |

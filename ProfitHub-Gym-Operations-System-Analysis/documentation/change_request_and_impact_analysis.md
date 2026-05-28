# Change Request and Impact Analysis

## Purpose

This document shows how future enhancement requests would be assessed without
expanding the current MVP scope.

These change requests are future enhancements, not MVP scope.

## CR-001 Add Member Mobile App

- Request Summary: Add a member-facing mobile app for self-service profile,
  subscription, and class booking access.
- Business Reason: Reduce front-desk workload and improve member convenience.
- Impacted Modules: Member Management, Subscription, Booking, Attendance.
- Data Model Impact: Requires member login identity, device/session data, and
  self-service permissions.
- API Impact: Requires authentication, member-facing endpoints, and stronger
  privacy controls.
- Process Flow Impact: Booking and renewal flows become self-service.
- Testing Impact: Requires mobile UX, auth, permission, and booking tests.
- Complexity Estimate: High.
- Recommendation: Future phase after internal operations stabilize.

## CR-002 Add Payment Gateway Integration

- Request Summary: Integrate online payment collection and payment callbacks.
- Business Reason: Reduce manual payment recording and improve payment tracking.
- Impacted Modules: Payment Tracking, Subscription, Owner Dashboard.
- Data Model Impact: Requires transaction reference, gateway status, and callback
  log fields.
- API Impact: Requires gateway webhook endpoint and reconciliation logic.
- Process Flow Impact: Payment status can be updated automatically.
- Testing Impact: Requires callback, duplicate payment, failed payment, and
  reconciliation scenarios.
- Complexity Estimate: Medium.
- Recommendation: Future phase after manual payment workflow is validated.

## CR-003 Add Multi-Branch Management

- Request Summary: Support multiple gym branches with separate staff, classes,
  members, and reporting.
- Business Reason: Enable gym expansion and branch-level performance tracking.
- Impacted Modules: All MVP modules.
- Data Model Impact: Requires Branch entity and branch references across core
  operational records.
- API Impact: Requires branch-scoped filters, access control, and reporting.
- Process Flow Impact: Staff actions and dashboard metrics become branch-aware.
- Testing Impact: Requires branch permission, reporting, and data isolation tests.
- Complexity Estimate: High.
- Recommendation: High complexity and should not be included in the MVP.

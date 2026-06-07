# Gap Analysis

## Purpose

This document translates the data exploration findings into business gaps and system needs.

The goal is to show why the proposed system is needed:

> inspection data identifies the issue, but a corrective action workflow ensures the issue is assigned, fixed, reviewed, and monitored.

## Evidence from Data Exploration

The working sample shows that inspection records can contain results such as **Pass**, **Pass w/ Conditions**, and **Fail**. Records with **Fail** or **Pass w/ Conditions** are direct candidates for corrective action or review.

| Data Signal | System Analysis Meaning |
|---|---|
| Fail inspection result | Needs immediate corrective action workflow. |
| Pass w/ Conditions result | Needs review, follow-up, and conditional action tracking. |
| Risk 1 / High records | Should receive higher priority and shorter due date. |
| Violation notes are text-heavy | Need category, severity, and structured ticket information. |
| Repeat issue possibility | Need repeat-violation monitoring and escalation logic. |

## Current Condition

The public inspection dataset provides useful records for analysis, such as:

- inspection result,
- facility type,
- risk level,
- inspection date,
- inspection type,
- violation notes.

However, raw inspection data does not provide the internal business workflow required to follow up violations.

## Main Business Gap

A restaurant operator does not only need to know that a violation happened.

The business needs to know:

- who owns the correction,
- when it must be completed,
- what evidence proves the correction,
- who reviews and approves closure,
- whether the same issue keeps repeating,
- and which outlets have unresolved risk.

## Gap Matrix

| Current Condition | Pain Point | System Need |
|---|---|---|
| Inspection result exists as raw data. | A violation can remain only as a record, not an action. | Corrective action ticket. |
| Fail / conditional records are mixed with normal records. | QA team must manually identify which records need follow-up. | Result-based ticket trigger. |
| Violation notes are long text. | Hard to prioritize and group issues. | Violation category and severity tagging. |
| Risk level exists but is not linked to SLA. | High-risk issues may not get faster handling. | Priority and due-date rules based on risk. |
| No PIC field in raw data. | Ownership is unclear. | Person in Charge (PIC) assignment workflow. |
| No evidence field. | QA cannot verify whether the issue was fixed. | Evidence upload linked to ticket. |
| No approval status. | Closure may happen without validation. | QA review and approval/rejection flow. |
| No status lifecycle. | Management cannot monitor open, overdue, or closed actions. | Ticket status tracking. |
| Repeat issues are not highlighted by workflow. | Recurring operational risk can be missed. | Repeat-violation monitoring and escalation. |

## Root Cause Summary

The root issue is not lack of data.

The root issue is lack of **workflow accountability**.

| Root Cause | Impact |
|---|---|
| No structured follow-up process | Violations are not consistently converted into actions. |
| No owner and deadline | Corrective action can be delayed or ignored. |
| No evidence and approval trail | QA cannot verify closure quality. |
| No repeat-issue visibility | Management cannot see recurring outlet risk early. |

## MVP System Need

The MVP should focus only on converting inspection findings into trackable corrective actions.

| MVP Capability | Why It Matters |
|---|---|
| Import inspection records | Source data enters the system. |
| Detect Fail / Pass w/ Conditions | System identifies records needing action. |
| Create corrective action ticket | Violation becomes trackable work. |
| Assign PIC and due date | Clear ownership and timeline. |
| Upload evidence | Outlet can prove correction. |
| QA approve / reject | Closure is validated. |
| Track status | Management can monitor progress. |
| Flag repeat issue | Recurring risk can be escalated. |

## As-Is vs To-Be Summary

| Area | As-Is | To-Be |
|---|---|---|
| Violation handling | Violation exists in inspection records. | Violation becomes a corrective action ticket. |
| Ownership | Not defined in raw data. | Ticket has assigned PIC. |
| Timeline | No standard due date. | Due date calculated based on risk/priority. |
| Proof | No centralized evidence. | Evidence is uploaded to the ticket. |
| Validation | No approval workflow. | QA approves or rejects closure. |
| Monitoring | Limited to inspection records. | Dashboard shows open, overdue, closed, and repeat issues. |

## Requirement Direction

This gap analysis supports the next document: workflow, SOP, and requirements.

| Requirement Area | Direction |
|---|---|
| Workflow | Define corrective action lifecycle from import to closure. |
| SOP | Define actor responsibility for QA, outlet manager, area manager, and management. |
| Functional Requirements | Define ticket creation, assignment, evidence, approval, status tracking, and monitoring. |
| Business Rules | Define priority, due date, closure, rejection, and escalation rules. |
| ERD | Define entities for inspection, violation, ticket, user, evidence, approval, and status history. |
| UAT | Validate that failed/conditional records create and complete corrective action workflow correctly. |

## Scope Boundary

This project stays focused on one restaurant compliance workflow.

The MVP stays focused on one workflow:

> inspection violation → corrective action ticket → PIC → due date → evidence → QA approval → monitoring.

POS, inventory, purchasing, ERP, and machine learning are outside the MVP scope.

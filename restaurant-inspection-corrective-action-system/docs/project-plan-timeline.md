# Project Plan and Timeline

## Purpose

This document shows how the analysis work for the MVP can be planned, reviewed, and handed off to developers.

Core workflow:

```text
Inspection finding → corrective action ticket → Person in Charge (PIC) assignment → due date → evidence → QA review → closure / rework → monitoring
```

## Planning Approach

This is a 10-working-day MVP analysis and handoff plan.

The plan covers the work needed before development starts:

- validate the public source and business case,
- review the inspection data sample,
- identify process gaps,
- design the To-Be workflow,
- write requirements and business rules,
- prepare ERD and data dictionary,
- prepare UAT scenarios,
- align technical handoff with developers.

## Timeline Summary

| Workstream | Duration | Main Output |
|---|---:|---|
| Case and source validation | 1 day | Case brief and source list |
| Data exploration | 2 days | Data findings and ticket candidate logic |
| Gap analysis | 1 day | Current condition, pain point, system need |
| Workflow, SOP, and requirements | 2 days | To-Be workflow, SOP, FR/NFR |
| ERD and data model | 1 day | ERD, data dictionary, business rules |
| UAT and traceability | 1 day | Acceptance criteria, UAT scenarios, traceability matrix |
| Developer handoff | 1 day | API discussion points, validation rules, edge cases |
| Final documentation review | 1 day | README, diagrams, timeline, and source notes checked |

## Gantt-Style Plan

| Workstream | Day 1 | Day 2 | Day 3 | Day 4 | Day 5 | Day 6 | Day 7 | Day 8 | Day 9 | Day 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| Case and source validation | ■ |  |  |  |  |  |  |  |  |  |
| Data exploration |  | ■ | ■ |  |  |  |  |  |  |  |
| Gap analysis |  |  |  | ■ |  |  |  |  |  |  |
| Workflow, SOP, and requirements |  |  |  |  | ■ | ■ |  |  |  |  |
| ERD and data model |  |  |  |  |  |  | ■ |  |  |  |
| UAT and traceability |  |  |  |  |  |  |  | ■ |  |  |
| Developer handoff |  |  |  |  |  |  |  |  | ■ |  |
| Final documentation review |  |  |  |  |  |  |  |  |  | ■ |

## Roles and Responsibilities

| Role | Responsibility |
|---|---|
| System Analyst | Owns case framing, gap analysis, requirements, workflow, ERD, UAT, and handoff. |
| QA / Food Safety Team | Validates violation review, corrective action workflow, approval rules, and evidence logic. |
| Outlet Manager | Validates Person in Charge (PIC) assignment and evidence submission flow. |
| Area Manager | Validates escalation, overdue monitoring, and repeated issue monitoring. |
| Developer Team | Reviews feasibility, data model, validation rules, API discussion points, and build timeline. |
| Management | Reviews high-level monitoring needs and MVP value. |

## Milestones

| Milestone | Success Criteria |
|---|---|
| Case validated | Data source, business problem, stakeholders, and scope are clear. |
| Problem validated | Data findings support the need for corrective action workflow. |
| Workflow approved | Stakeholders can understand the To-Be flow in under one minute. |
| Requirements ready | FR/NFR and business rules are clear enough for development discussion. |
| Technical handoff ready | ERD, UAT, traceability, validation rules, and API discussion points are prepared. |
| Documentation ready | README, diagrams, source notes, and timeline are checked for consistency. |

## Key Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Scope expands into POS, inventory, or ERP | Project becomes too broad | Keep the MVP limited to corrective action workflow. |
| Violation notes are unstructured | Issue categorization may be inconsistent | Use simplified MVP categories and refine later with stakeholders. |
| Due-date rules are too generic | SLA may not reflect real policy | Define simple severity-based due dates and mark them as assumptions. |
| Evidence approval flow is unclear | Ticket closure can become weak | Require QA approval before Closed status. |
| Technical details are hard to follow | Decisions may be missed | Use summary tables, diagrams, and clear handoff notes. |

## Developer Coordination Notes

Before development starts, the System Analyst should confirm:

1. Can the dataset import be handled as CSV upload, API sync, or manual input?
2. Should ticket creation be automatic or QA-confirmed?
3. What roles are required for MVP access control?
4. What evidence file types and size limits are acceptable?
5. What due-date rules should be applied for each risk level?
6. What dashboard metrics are required for management monitoring?

## Final Scope

The project remains focused on:

**Inspection violation → corrective action ticket → PIC → due date → evidence → QA approval → monitoring.**

Out of scope for this MVP:

- POS,
- inventory,
- purchasing,
- full ERP,
- machine learning prediction,
- production application development.

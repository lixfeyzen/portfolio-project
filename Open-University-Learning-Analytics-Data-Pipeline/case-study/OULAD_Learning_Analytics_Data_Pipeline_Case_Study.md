# OULAD Learning Analytics Data Pipeline Case Study

## 1. Project Overview

This project is a data engineering portfolio project built with the real public Open University Learning Analytics Dataset (OULAD). It turns raw learning platform CSV files into cleaned, validated, SQLite-loaded, SQL-modeled, and reporting-ready datasets.

The project is designed to show practical data engineering skills: ingestion checks, chunk processing, data quality validation, database loading, SQL modeling, and BI-ready exports.

The business framing is learning analytics reporting: course teams and analysts need trusted registration, assessment, activity, outcome, and student review data before they can build reliable reports.

## 2. Business Problem

Online learning teams need clean and trusted data to monitor course registrations, student engagement, assessment performance, withdrawals, and completion outcomes.

The raw OULAD files are useful but not immediately reporting-ready. They are split across several CSV files, contain relative day offsets, include missing values, and require relationship checks before analysts can trust the outputs.

## 3. Dataset

The pipeline uses these OULAD source files:

- `courses`
- `assessments`
- `studentAssessment`
- `studentInfo`
- `studentRegistration`
- `vle`
- `studentVle`

`studentVle` contains `10,655,280` rows in the local run and is processed with chunks to avoid loading the full clickstream file into memory.

## 4. Pipeline Design

The pipeline follows this flow:

```text
Extract -> Clean -> Validate -> Load SQLite -> Create SQL Views -> Export Reporting Tables
```

Each step is implemented as a separate script so the workflow is readable, repeatable, and easy to review.

## 5. Engineering Decisions

- SQLite is used for local portfolio simplicity.
- Raw CSV files are excluded from Git.
- `studentVle` is processed with chunks to avoid memory issues.
- SQLite primary keys, foreign keys, and check constraints are used for core integrity controls.
- OULAD date fields are relative day offsets, not calendar dates.
- The at-risk indicator is rule-based reporting, not predictive machine learning.

## 6. Data Quality Validation

The real pipeline run produced `0` blocking validation issues.

Non-blocking issues are documented so analysts can interpret the reporting layer correctly:

- missing assessment scores
- missing registration dates
- missing `imd_band` values

The validation summary separates blocking issues from non-blocking interpretation notes.

## 7. Reporting Outputs

The pipeline exports these reporting tables:

- `course_registration_summary`
- `student_engagement_summary`
- `assessment_performance_summary`
- `vle_activity_summary`
- `student_outcome_summary`
- `at_risk_student_indicators`

These outputs can support BI dashboards, spreadsheet review, or further analytical modeling.

## 8. Business Value

The pipeline supports course monitoring by summarizing registrations, withdrawals, pass rates, and outcomes by course presentation.

It supports engagement reporting by aggregating VLE clicks, active days, unique sites visited, and engagement buckets.

It supports assessment monitoring by exposing score summaries, missing score counts, late submission counts, and late submission rates.

It supports student support prioritization through rule-based review indicators for low engagement, low score, and missing assessment activity.

## 9. Data Engineering Value

This project maps to practical data engineering work because it includes:

- raw file intake checks
- chunk-based processing for a large clickstream table
- repeatable cleaning and standardization
- validation before database loading
- SQL reporting views and analyst-ready exports
- documentation for source owners and BI users

The runnable proof is the local Python, Pandas, SQLite, and SQL pipeline.

## 10. Limitations

- OULAD does not include payment or revenue data.
- OULAD does not include lead data.
- This project does not claim production deployment.
- SQLite is used locally and is not a production database platform.

## 11. Skills Demonstrated

- Python ETL
- chunk processing
- SQL reporting views
- data validation
- data quality documentation
- pipeline documentation
- reporting-ready data modeling
- analyst handoff documentation

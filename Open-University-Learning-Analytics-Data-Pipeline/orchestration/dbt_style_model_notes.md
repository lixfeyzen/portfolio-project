# dbt-Style Model Notes

This project is implemented with Python, Pandas, SQLite, and SQL files. It could be converted into a dbt-style project by separating the pipeline into staged models, intermediate models, marts, tests, and documentation.

## Staging Models

Staging models would clean and type each raw OULAD source:

- `stg_courses`
- `stg_assessments`
- `stg_student_assessment`
- `stg_student_info`
- `stg_student_registration`
- `stg_vle`
- `stg_student_vle`

Staging responsibilities:

- rename fields consistently
- cast relative day fields to integers
- trim strings
- normalize categories
- preserve source identifiers

## Intermediate Models

Intermediate models would join and aggregate reusable business entities:

- `int_student_course_context`
- `int_assessment_submissions_with_course`
- `int_vle_activity_with_site`
- `int_student_engagement`
- `int_student_assessment_rollup`

## Marts

Mart models would match BI-facing reporting outputs:

- `mart_course_registration_summary`
- `mart_student_engagement_summary`
- `mart_assessment_performance_summary`
- `mart_vle_activity_summary`
- `mart_student_outcome_summary`
- `mart_at_risk_student_indicators`

## Data Tests

dbt tests could cover:

- unique keys
- non-null critical IDs
- accepted values for `final_result`
- accepted values for `assessment_type`
- score range between 0 and 100
- non-negative `sum_click`
- relationship tests between assessment, student, course, and VLE tables

## Documentation

dbt docs could document:

- table descriptions
- field definitions
- model lineage
- test coverage
- business metric definitions

## Lineage

Lineage would flow from raw OULAD CSV tables to staging models, intermediate relationship models, and reporting marts. The large `student_vle` source should remain carefully partitioned or incrementally processed in warehouse implementations.


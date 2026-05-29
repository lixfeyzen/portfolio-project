# Data Quality Rules

## Primary Key Uniqueness

Expected unique keys:

- `courses`: `code_module`, `code_presentation`
- `assessments`: `id_assessment`
- `student_assessment`: `id_assessment`, `id_student`
- `student_info`: `code_module`, `code_presentation`, `id_student`
- `student_registration`: `code_module`, `code_presentation`, `id_student`
- `vle`: `id_site`

`student_vle` stores activity rows and is not forced into a unique event key.

## Foreign Key Consistency

Checks:

- assessments must link to valid courses
- student assessment rows must link to valid assessments
- student assessment rows must link to a valid student-course record after assessment course context is applied
- student registration rows must link to valid student-course records
- student VLE rows must link to valid VLE sites
- student VLE rows must link to valid student-course records

## Valid Score Range

Assessment scores should be between `0` and `100` when present.

## Non-Negative Clicks

`student_vle.sum_click` should be zero or positive.

## Valid Final Result Categories

Expected values:

- `Pass`
- `Fail`
- `Withdrawn`
- `Distinction`

## Valid Assessment Type Categories

Expected values:

- `TMA`
- `CMA`
- `Exam`

## Required IDs

Critical identifiers should not be missing:

- course module and presentation keys
- assessment IDs
- student IDs
- VLE site IDs

## Registration Logic

Registration checks include:

- missing `date_registration`
- unregistration date earlier than registration date
- withdrawn students without an unregistration date
- unregistration date present when final result is not `Withdrawn`

Some registration anomalies may be non-blocking, but they should be visible in the validation summary.

## Reporting Readiness Checks

The project also records:

- missing `imd_band` count
- missing assessment score count
- row counts by table
- blocking versus non-blocking validation interpretation


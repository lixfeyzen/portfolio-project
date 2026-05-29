# Data Dictionary

OULAD date fields are relative day offsets, not calendar dates. They are stored as nullable integers.

## courses

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| code_module | TEXT | Yes | Course module code | Part of course key |
| code_presentation | TEXT | Yes | Course presentation code | Part of course key |
| module_presentation_length | INTEGER | Yes | Presentation length in relative days | OULAD day count |

## assessments

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| code_module | TEXT | Yes | Course module code | Links to courses |
| code_presentation | TEXT | Yes | Course presentation code | Links to courses |
| id_assessment | INTEGER | Yes | Assessment identifier | Primary key |
| assessment_type | TEXT | Yes | Assessment category | Expected values: TMA, CMA, Exam |
| date | INTEGER | No | Assessment due day offset | Relative day, not calendar date |
| weight | REAL | No | Assessment weight | Percentage-like value |

## student_assessment

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| id_assessment | INTEGER | Yes | Assessment identifier | Links to assessments |
| id_student | INTEGER | Yes | Student identifier | Links to student records through assessment course |
| date_submitted | INTEGER | No | Submission day offset | Relative day, not calendar date |
| is_banked | INTEGER | No | Banked assessment flag | OULAD source field |
| score | REAL | No | Student assessment score | Expected range 0 to 100 |

## student_info

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| code_module | TEXT | Yes | Course module code | Part of student-course key |
| code_presentation | TEXT | Yes | Course presentation code | Part of student-course key |
| id_student | INTEGER | Yes | Student identifier | Part of student-course key |
| gender | TEXT | No | Student gender category | Anonymized category |
| region | TEXT | No | Student region | Anonymized public dataset field |
| highest_education | TEXT | No | Highest education category | Source category |
| imd_band | TEXT | No | Index of Multiple Deprivation band | May be missing |
| age_band | TEXT | No | Student age band | Source category |
| num_of_prev_attempts | INTEGER | No | Previous attempts count | Numeric |
| studied_credits | INTEGER | No | Credits studied | Numeric |
| disability | TEXT | No | Disability category | Source category |
| final_result | TEXT | Yes | Final outcome | Pass, Fail, Withdrawn, Distinction |

## student_registration

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| code_module | TEXT | Yes | Course module code | Part of student-course key |
| code_presentation | TEXT | Yes | Course presentation code | Part of student-course key |
| id_student | INTEGER | Yes | Student identifier | Part of student-course key |
| date_registration | INTEGER | No | Registration day offset | Relative day, not calendar date |
| date_unregistration | INTEGER | No | Withdrawal day offset | Present for unregistered students |

## vle

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| id_site | INTEGER | Yes | VLE site identifier | Primary key |
| code_module | TEXT | Yes | Course module code | Links VLE site to course |
| code_presentation | TEXT | Yes | Course presentation code | Links VLE site to presentation |
| activity_type | TEXT | No | Type of VLE resource or activity | Source category |
| week_from | INTEGER | No | Starting week offset | Source field |
| week_to | INTEGER | No | Ending week offset | Source field |

## student_vle

| Field | Expected Type | Required | Description | Notes |
|---|---:|---|---|---|
| code_module | TEXT | Yes | Course module code | Links to student and VLE context |
| code_presentation | TEXT | Yes | Course presentation code | Links to student and VLE context |
| id_student | INTEGER | Yes | Student identifier | Links to student_info |
| id_site | INTEGER | Yes | VLE site identifier | Links to vle |
| date | INTEGER | No | Activity day offset | Relative day, not calendar date |
| sum_click | INTEGER | No | Number of clicks for the activity row | Expected non-negative |

## Reporting View Additions

These fields are generated in the SQL reporting layer and are not raw OULAD source columns.

| Field | Expected Type | Description | Notes |
|---|---:|---|---|
| late_submission_count | INTEGER | Count of submitted assessments where `date_submitted` is after the assessment due day offset | Used in `vw_assessment_performance_summary` |
| late_submission_rate | REAL | Late submissions divided by total submissions | Used in `vw_assessment_performance_summary` |
| missing_assessment_count | INTEGER | Count of expected non-Exam assessment opportunities with no submission record or missing score | Exam assessments without `studentAssessment` records are excluded |
| risk_reason_count | INTEGER | Number of risk/review rules triggered | Used in `vw_at_risk_student_indicators` |
| risk_reason_summary | TEXT | Human-readable explanation of triggered rules | Values include `Low Engagement`, `Low Score`, `Missing Assessment`, or `No Flag` |

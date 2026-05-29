# Dashboard Requirements

## 1. Course Registration Overview

Purpose: monitor registration and outcome distribution.

Metrics:

- `total_students`
- `withdrawn_students`
- `pass_rate`
- `withdrawal_rate`

Visuals:

- bar chart by course and presentation
- outcome distribution
- withdrawal rate by course and presentation

Source:

- `vw_course_registration_summary`
- `vw_student_outcome_summary`

## 2. Student Engagement Monitoring

Purpose: monitor student VLE engagement.

Metrics:

- `total_clicks`
- `active_days`
- `unique_sites_visited`
- `engagement_bucket`

Visuals:

- engagement distribution
- click trend
- engagement bucket summary

Source:

- `vw_student_engagement_summary`
- `vw_vle_activity_summary`

## 3. Assessment Performance

Purpose: monitor assessment score and submission behavior.

Metrics:

- `avg_score`
- `missing_score_count`
- `late_submission_count`
- `late_submission_rate`

Visuals:

- score distribution
- average score by assessment type
- submission timing

Source:

- `vw_assessment_performance_summary`

## 4. Student Outcome and Risk Indicators

Purpose: identify students with rule-based review/risk indicators for low engagement, low score, or missing assessments. These indicators are reporting rules, not predictive machine learning.

Metrics:

- `low_engagement_flag`
- `low_score_flag`
- `missing_assessment_flag`
- `at_risk_indicator`
- `risk_reason_count`
- `risk_reason_summary`

Visuals:

- risk indicator table
- risk count by course
- risk reason summary
- final result comparison

Source:

- `vw_at_risk_student_indicators`

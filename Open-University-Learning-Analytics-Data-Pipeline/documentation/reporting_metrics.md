# Reporting Metrics

## Total Registrations

Count of student-course records in `student_info`.

## Registered Students

Count of student-course records where `date_registration` is available.

## Withdrawn Students

Count of student-course records where `final_result = 'Withdrawn'`.

## Withdrawal Rate

Withdrawn students divided by total students for a course presentation.

## Pass Rate

Students with `Pass` or `Distinction` divided by total students for a course presentation.

## Fail Students

Count of student-course records where `final_result = 'Fail'`.

## Distinction Students

Count of student-course records where `final_result = 'Distinction'`.

## Average Assessment Score

Average `student_assessment.score` for submitted assessments.

## Late Submission Count

Count of submitted assessment records where `date_submitted` is later than the assessment due day offset.

## Late Submission Rate

Late submission count divided by total submitted assessment records for the course, presentation, and assessment type.

## Total VLE Clicks

Sum of `student_vle.sum_click`.

## Active Days

Count of distinct relative activity day offsets in `student_vle`.

## Unique Sites Visited

Count of distinct `id_site` values visited by a student.

## Missing Assessment Count

Count of expected non-Exam assessment opportunities where a student has no matching submission record or has a missing score. Exam assessments are not counted as missing when no `studentAssessment` record exists.

## At-Risk Indicator

Rule-based review flag set when one or more of the following is true:

- low engagement flag is true
- low score flag is true
- missing assessment flag is true

This metric is intended for reporting triage only. It is not predictive machine learning.

## Risk Reason Count

Number of rule-based reasons triggered for a student-course record.

## Risk Reason Summary

Readable label that explains why a record is flagged. Expected values include combinations of:

- `Low Engagement`
- `Low Score`
- `Missing Assessment`
- `No Flag`

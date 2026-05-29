# Validation Summary

Validation timestamp: `2026-05-29T11:32:12+00:00`

## Row Counts

| Table | Rows |
|---|---:|
| courses | 22 |
| assessments | 206 |
| student_assessment | 173912 |
| student_info | 32593 |
| student_registration | 32593 |
| vle | 6364 |
| student_vle | 10655280 |

## Issue Counts

| Check | Count | Severity | Interpretation |
|---|---:|---|---|
| courses missing critical ID/key fields | 0 | blocking | Critical IDs are required for loading and relationship checks. |
| courses duplicate key combinations | 0 | blocking | Duplicate business keys can create double-counted reporting rows. |
| assessments missing critical ID/key fields | 0 | blocking | Critical IDs are required for loading and relationship checks. |
| assessments duplicate key combinations | 0 | blocking | Duplicate business keys can create double-counted reporting rows. |
| student_assessment missing critical ID/key fields | 0 | blocking | Critical IDs are required for loading and relationship checks. |
| student_assessment duplicate key combinations | 0 | blocking | Duplicate business keys can create double-counted reporting rows. |
| student_info missing critical ID/key fields | 0 | blocking | Critical IDs are required for loading and relationship checks. |
| student_info duplicate key combinations | 0 | blocking | Duplicate business keys can create double-counted reporting rows. |
| student_registration missing critical ID/key fields | 0 | blocking | Critical IDs are required for loading and relationship checks. |
| student_registration duplicate key combinations | 0 | blocking | Duplicate business keys can create double-counted reporting rows. |
| vle missing critical ID/key fields | 0 | blocking | Critical IDs are required for loading and relationship checks. |
| vle duplicate key combinations | 0 | blocking | Duplicate business keys can create double-counted reporting rows. |
| assessments without valid course | 0 | blocking | Assessments should map to a course presentation. |
| student_assessment without valid assessment_id | 0 | blocking | Student assessment rows should map to an assessment. |
| student_assessment without matching student_info | 0 | blocking | Assessment submissions should map to a student-course record. |
| student_registration without matching student_info | 0 | blocking | Registration records should map to a student-course record. |
| score outside 0-100 | 0 | blocking | Assessment scores should stay within the expected OULAD range. |
| missing assessment score | 173 | non-blocking | Missing scores affect assessment reporting and should remain visible. |
| invalid final_result categories | 0 | blocking | Final result categories should match the documented OULAD values. |
| invalid assessment_type categories | 0 | blocking | Assessment type categories should match the documented OULAD values. |
| missing date_registration | 45 | non-blocking | Registration day offsets can be missing in the public dataset and should be reported. |
| missing imd_band | 1111 | non-blocking | Missing demographic bands should be tracked for reporting interpretation. |
| date_unregistration before date_registration | 0 | blocking | Unregistration should not occur before registration. |
| withdrawn students without date_unregistration | 93 | non-blocking | Withdrawal outcome should usually have an unregistration day offset. |
| date_unregistration present but final_result is not Withdrawn | 9 | non-blocking | This pattern may need business interpretation before reporting. |
| student_vle missing critical ID fields | 0 | blocking | Student VLE activity requires course, presentation, student, and site identifiers. |
| student_vle without valid id_site | 0 | blocking | Student VLE rows should map to valid VLE sites. |
| student_vle without matching student_info | 0 | blocking | Student VLE rows should map to a student-course record. |
| negative sum_click | 0 | blocking | Click counts should not be negative. |

## Interpretation Notes

- Total blocking issue count: `0`.
- Blocking issues indicate problems that can break trusted joins, table keys, or core reporting logic.
- Non-blocking issues can still affect interpretation and should be visible to BI users.
- OULAD day fields are relative offsets and are not converted to calendar dates.
- The risk indicator reporting is rule-based and is not predictive machine learning.
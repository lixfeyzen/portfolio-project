# Transformation Summary

Generated at: `2026-05-29T11:32:03+00:00`

| Table | Input Rows | Output Rows | Duplicate Key Rows Removed |
|---|---:|---:|---:|
| courses | 22 | 22 | 0 |
| assessments | 206 | 206 | 0 |
| student_assessment | 173912 | 173912 | 0 |
| student_info | 32593 | 32593 | 0 |
| student_registration | 32593 | 32593 | 0 |
| vle | 6364 | 6364 | 0 |
| student_vle | 10655280 | 10655280 | 0 |

Notes:

- OULAD relative date fields are preserved as nullable integer day offsets.
- `student_vle` is processed in chunks and repeated activity rows are preserved.
- Duplicate key removal is applied only to tables with defined business keys.
# Extraction Summary

Generated at: `2026-05-29T11:31:32+00:00`

Raw data folder:

```text
data/raw/
```

Raw OULAD files are stored locally in data/raw/ and are excluded from Git.

| Table | File | Rows | Columns | Size MB | Column Count Matches |
|---|---|---:|---:|---:|---|
| courses | courses.csv | 22 | 3 | 0.0 | True |
| assessments | assessments.csv | 206 | 6 | 0.01 | True |
| student_assessment | studentAssessment.csv | 173912 | 5 | 5.43 | True |
| student_info | studentInfo.csv | 32593 | 12 | 3.3 | True |
| student_registration | studentRegistration.csv | 32593 | 5 | 1.06 | True |
| vle | vle.csv | 6364 | 6 | 0.25 | True |
| student_vle | studentVle.csv | 10655280 | 6 | 432.81 | True |

## Column Details

### courses.csv

Columns:

- `code_module`
- `code_presentation`
- `module_presentation_length`

### assessments.csv

Columns:

- `code_module`
- `code_presentation`
- `id_assessment`
- `assessment_type`
- `date`
- `weight`

### studentAssessment.csv

Columns:

- `id_assessment`
- `id_student`
- `date_submitted`
- `is_banked`
- `score`

### studentInfo.csv

Columns:

- `code_module`
- `code_presentation`
- `id_student`
- `gender`
- `region`
- `highest_education`
- `imd_band`
- `age_band`
- `num_of_prev_attempts`
- `studied_credits`
- `disability`
- `final_result`

### studentRegistration.csv

Columns:

- `code_module`
- `code_presentation`
- `id_student`
- `date_registration`
- `date_unregistration`

### vle.csv

Columns:

- `id_site`
- `code_module`
- `code_presentation`
- `activity_type`
- `week_from`
- `week_to`

### studentVle.csv

Columns:

- `code_module`
- `code_presentation`
- `id_student`
- `id_site`
- `date`
- `sum_click`

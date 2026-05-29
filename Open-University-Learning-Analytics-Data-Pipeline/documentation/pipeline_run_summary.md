# Pipeline Run Summary

## Purpose

This file summarizes the final local execution of the Open University Learning Analytics Data Pipeline.

It is included as execution proof for the portfolio project. The goal is to show that the pipeline was not only documented, but also run against the real OULAD public dataset.

## Dataset

The project uses the Open University Learning Analytics Dataset (OULAD), a real public learning analytics dataset.

Raw OULAD CSV files are stored locally in `data/raw/` and are excluded from Git.

## Pipeline Steps Executed

1. Extract raw OULAD CSV files.
2. Clean and transform source tables.
3. Validate data quality and relationship consistency.
4. Load cleaned tables into SQLite.
5. Create SQL reporting views.
6. Export reporting-ready CSV tables.

## Key Processing Results

| Item | Result |
|---|---:|
| courses rows | 22 |
| assessments rows | 206 |
| studentAssessment rows | 173,912 |
| studentInfo rows | 32,593 |
| studentRegistration rows | 32,593 |
| vle rows | 6,364 |
| studentVle rows | 10,655,280 |
| studentVle chunk size | 100,000 |
| blocking validation issues | 0 |

## Generated Reporting Outputs

The pipeline generated the following reporting-ready tables:

- `course_registration_summary.csv`
- `student_engagement_summary.csv`
- `assessment_performance_summary.csv`
- `vle_activity_summary.csv`
- `student_outcome_summary.csv`
- `at_risk_student_indicators.csv`

These outputs are stored in:

```text
outputs/reporting_tables/
```

## Data Quality Result

The pipeline found no blocking validation issues.

Non-blocking issues such as missing assessment scores, missing registration dates, and missing `imd_band` values are documented in:

```text
documentation/validation_summary.md
```

## Reproducibility Notes

The pipeline can be rerun locally with:

```bash
pip install -r requirements.txt
python scripts/run_pipeline.py
```

Before running the pipeline, the seven OULAD raw CSV files must be placed in:

```text
data/raw/
```

The raw CSV files, processed CSV files, and SQLite database are excluded from Git to keep the repository lightweight.

## Important Interpretation Note

The student review indicator is rule-based reporting, not predictive machine learning.

It is designed to help prioritize records for further analysis based on learning engagement, score, and assessment completion signals.

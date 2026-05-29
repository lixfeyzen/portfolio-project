# Running The Pipeline

This file contains technical reproduction steps for reviewers who want to rerun the project locally.

## Dataset

Download the Open University Learning Analytics Dataset (OULAD) from the official source:

```text
https://analyse.kmi.open.ac.uk/open-dataset
```

Expected raw files:

```text
courses.csv
assessments.csv
studentAssessment.csv
studentInfo.csv
studentRegistration.csv
studentVle.csv
vle.csv
```

Place all seven files in:

```text
data/raw/
```

## Install Dependencies

```bash
python -m pip install -r requirements.txt
```

## Verify Included Portfolio Outputs

This can be run without downloading the raw dataset:

```bash
python scripts/verify_project.py
python scripts/07_validate_reporting_outputs.py --check-only
```

## Run Full Pipeline

```bash
python scripts/run_pipeline.py
```

This runs:

```text
01_extract_sources.py
02_clean_transform.py
03_validate_data.py
04_load_to_sqlite.py
05_export_reporting_tables.py
```

## Validate Reporting Outputs

```bash
python scripts/07_validate_reporting_outputs.py
```

The validation output is written to:

```text
documentation/reporting_output_quality_summary.md
```

## Notes

- Raw CSV files are excluded from Git.
- Generated SQLite database files are excluded from Git.
- Exported reporting CSV files are included for portfolio review.
- A standalone GitHub Actions workflow is included for this project if it is used as its own repository.

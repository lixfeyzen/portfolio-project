# Verify This Project

This project can be reviewed in two levels: package verification and full pipeline reproduction.

## Quick Package Verification

Use this when reviewing the GitHub-ready repository without downloading the raw OULAD dataset.

```bash
python scripts/verify_project.py
python scripts/07_validate_reporting_outputs.py --check-only
```

This checks:

- required project files
- Python script syntax
- reporting CSV row counts
- required reporting columns
- README screenshot asset links
- PNG validity
- documented quality results

## Full Pipeline Reproduction

Use this when you want to rerun the ETL workflow from the raw dataset.

1. Download the Open University Learning Analytics Dataset from:

```text
https://analyse.kmi.open.ac.uk/open-dataset
```

2. Place these files in `data/raw/`:

```text
courses.csv
assessments.csv
studentAssessment.csv
studentInfo.csv
studentRegistration.csv
studentVle.csv
vle.csv
```

3. Install dependencies:

```bash
python -m pip install -r requirements.txt
```

4. Run the pipeline:

```bash
python scripts/run_pipeline.py
python scripts/07_validate_reporting_outputs.py
```

## Why Raw Data And SQLite Are Not Included

Raw source CSV files and generated SQLite database files are excluded from the repository to keep the portfolio package lightweight and reproducible from the official public dataset.

The repository includes documented run summaries, SQL models, validation logic, reporting outputs, and a DB Browser for SQLite preview image as review evidence.

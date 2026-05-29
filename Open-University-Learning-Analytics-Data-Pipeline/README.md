# Open University Learning Analytics Data Pipeline & Reporting

## Project Summary

This portfolio project builds a local data engineering pipeline for the Open University Learning Analytics Dataset (OULAD). It transforms raw public CSV files into cleaned CSV outputs, validates key data quality rules, loads the data into SQLite, creates SQL reporting views, and exports reporting-ready tables.

The project uses a real public learning analytics dataset, not dummy data. Raw OULAD CSV files are not included in this repository and must be downloaded separately.

This is a portfolio project for demonstrating data engineering and reporting skills. It is not a real client project and does not claim production deployment.

## Case Study

Read the recruiter-facing case study:

[OULAD Learning Analytics Data Pipeline Case Study](case-study/OULAD_Learning_Analytics_Data_Pipeline_Case_Study.md)

## Engineering Decisions

- Real public OULAD data is used instead of dummy data.
- `studentVle.csv` is processed in chunks to avoid loading the full clickstream file into memory.
- SQLite is used as a local analytical warehouse for portfolio simplicity.
- Raw CSV files and generated database files are excluded from Git.
- The at-risk output is a rule-based review indicator, not predictive machine learning.
- Reporting tables are exported as CSV files for BI or spreadsheet use.

## Pipeline Run Proof

The final local pipeline run processed the full OULAD dataset, including `10,655,280` `studentVle` interaction rows using chunk processing.

The run summary, row counts, validation result, and reporting outputs are documented in:

[Pipeline Run Summary](documentation/pipeline_run_summary.md)

## Dataset Source

Dataset: Open University Learning Analytics Dataset (OULAD)

Source: https://analyse.kmi.open.ac.uk/open_dataset

Expected raw files:

- `courses.csv`
- `assessments.csv`
- `studentAssessment.csv`
- `studentInfo.csv`
- `studentRegistration.csv`
- `studentVle.csv`
- `vle.csv`

The large `studentVle.csv` file is required for full student engagement and VLE activity reporting. If this file is missing, the pipeline fails clearly and explains how to place it in `data/raw/`.

## Business Problem

An online learning provider needs trusted reporting outputs for course registrations, student demographics, assessment outcomes, VLE engagement, withdrawals, and course-level performance. Raw platform data is split across multiple CSV files and includes relative day offsets, missing values, categorical fields, and a large clickstream table.

The business needs a repeatable pipeline that makes this data reliable for reporting and analysis.

## Pipeline Objective

The pipeline converts OULAD raw CSV files into reporting-ready assets:

1. Check that required raw files exist.
2. Profile row counts, columns, and file sizes.
3. Clean and standardize source tables.
4. Validate primary keys, foreign keys, score ranges, click values, and reporting readiness.
5. Load cleaned data into SQLite.
6. Build SQL reporting views.
7. Export reporting tables for BI or spreadsheet analysis.

## Tools Used

- Python
- Pandas
- SQLite
- SQL
- Markdown documentation
- Documentation-level Airflow and dbt-style artifacts

## Folder Structure

```text
Open-University-Learning-Analytics-Data-Pipeline/
|-- README.md
|-- project_brief.md
|-- .gitignore
|-- case-study/
|   `-- OULAD_Learning_Analytics_Data_Pipeline_Case_Study.md
|-- data/
|   |-- raw/
|   |   `-- README.md
|   `-- processed/
|       `-- README.md
|-- scripts/
|   |-- 00_config.py
|   |-- 01_extract_sources.py
|   |-- 02_clean_transform.py
|   |-- 03_validate_data.py
|   |-- 04_load_to_sqlite.py
|   |-- 05_export_reporting_tables.py
|   `-- run_pipeline.py
|-- sql/
|   |-- create_tables.sql
|   |-- reporting_views.sql
|   `-- validation_queries.sql
|-- orchestration/
|   |-- airflow_dag_mock.py
|   `-- dbt_style_model_notes.md
|-- documentation/
|-- dashboard/
|-- outputs/
|-- requirements.txt
`-- assets/
```

## Pipeline Workflow

### 1. Extract Sources

`scripts/01_extract_sources.py` checks that all expected OULAD CSV files are available in `data/raw/`. It reports file names, row counts, column names, and file sizes, then writes an extraction summary.

### 2. Clean and Transform

`scripts/02_clean_transform.py` standardizes column names, trims string fields, converts relative date/day fields to nullable integers, normalizes key categorical values, and removes duplicate key records where appropriate.

`studentVle.csv` is processed in chunks of 100,000 rows so the large clickstream file is not loaded fully into memory.

### 3. Validate Data

`scripts/03_validate_data.py` checks missing critical IDs, duplicate key combinations, foreign key consistency, score ranges, negative clicks, valid categories, missing registration dates, missing IMD bands, and missing assessment scores.

### 4. Load to SQLite

`scripts/04_load_to_sqlite.py` creates `outputs/oulad_pipeline.db`, loads cleaned tables, and creates indexes for reporting joins.

### 5. Export Reporting Tables

`scripts/05_export_reporting_tables.py` creates SQL reporting views and exports CSV outputs into `outputs/reporting_tables/`.

## Reporting Outputs

The project creates these reporting exports:

- `course_registration_summary.csv`
- `student_engagement_summary.csv`
- `assessment_performance_summary.csv`
- `vle_activity_summary.csv`
- `student_outcome_summary.csv`
- `at_risk_student_indicators.csv`

Main reporting views:

- `vw_course_registration_summary`
- `vw_student_engagement_summary`
- `vw_assessment_performance_summary`
- `vw_vle_activity_summary`
- `vw_student_outcome_summary`
- `vw_at_risk_student_indicators`

The risk indicator view is rule-based reporting, not predictive machine learning.

## Data Quality Checks

The validation step checks:

- Required source files
- Missing critical identifiers
- Duplicate primary key combinations
- Cross-table relationship consistency
- Assessment scores outside `0` to `100`
- Negative VLE click values
- Invalid `final_result` categories
- Invalid `assessment_type` categories
- Missing registration dates
- Missing `imd_band`
- Missing assessment scores

Validation results are written to:

```text
documentation/validation_summary.md
```

## How to Run the Project

1. Download OULAD from:

```text
https://analyse.kmi.open.ac.uk/open_dataset
```

2. Place the seven expected CSV files in:

```text
data/raw/
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Run the full pipeline:

```bash
python scripts/run_pipeline.py
```

The OULAD date fields are relative day offsets, not calendar dates. The pipeline preserves them as nullable integer day values.

## Skills Demonstrated

- Raw data ingestion checks
- Chunk-based processing for a large CSV file
- Data cleaning with Pandas
- Data quality validation
- SQLite table loading
- SQL data modeling
- SQL reporting view creation
- BI-ready reporting exports
- Data documentation
- Local pipeline orchestration thinking

## Project Status

Portfolio-ready local data engineering project with runnable pipeline scripts and generated reporting outputs. Raw OULAD CSV files and generated databases are intentionally excluded from Git.

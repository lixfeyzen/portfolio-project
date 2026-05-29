# Dataset Source

## Source

This project uses the Open University Learning Analytics Dataset (OULAD).

Official source:

```text
https://analyse.kmi.open.ac.uk/open-dataset
```

## Dataset Purpose

OULAD is a public anonymized learning analytics dataset that supports research and analysis around online learning behavior, student demographics, assessment activity, course registration, VLE activity, and final outcomes.

This project uses OULAD to demonstrate a local data engineering pipeline for reporting-ready learning analytics data.

## Expected Files

- `courses.csv`
- `assessments.csv`
- `studentAssessment.csv`
- `studentInfo.csv`
- `studentRegistration.csv`
- `studentVle.csv`
- `vle.csv`

`studentVle.csv` is required for engagement reporting and VLE activity metrics.

## Raw Data Handling

Raw CSV files should be placed locally in:

```text
data/raw/
```

Raw files are excluded from Git. This is intentional because the dataset should be downloaded from the official source and the largest source file, `studentVle.csv`, is processed locally in chunks.

The generated SQLite database is also excluded from Git:

```text
outputs/oulad_pipeline.db
```

It can be recreated by running the pipeline after the raw CSV files are placed in `data/raw/`.

## Attribution Note

The dataset belongs to the Open University Learning Analytics Dataset project. This repository uses it as a public educational dataset for portfolio demonstration.

## Privacy and Data Authenticity

- No private client data is used.
- The main dataset is the public OULAD release.
- No synthetic replacement rows are used in the main dataset.
- The dataset is anonymized and public.

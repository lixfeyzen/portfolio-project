# Dataset Source

## Source

This project uses the Open University Learning Analytics Dataset (OULAD).

Official source:

```text
https://analyse.kmi.open.ac.uk/open_dataset
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

Raw files are excluded from Git. The repository keeps only the instructions needed to download and place the data.

## Attribution Note

The dataset belongs to the Open University Learning Analytics Dataset project. This repository uses it as a public educational dataset for portfolio demonstration.

## Privacy and Data Authenticity

- No private client data is used.
- No dummy data is used as the main dataset.
- No fake rows are invented.
- The dataset is anonymized and public.


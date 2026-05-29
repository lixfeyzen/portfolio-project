# Assumptions and Limitations

## Assumptions

- OULAD raw CSV files are downloaded separately from the official public dataset page.
- Raw CSV files are placed locally in `data/raw/`.
- The expected source filenames are unchanged.
- OULAD date fields are relative day offsets and should not be converted into calendar dates.
- `studentVle.csv` is available when engagement reporting is required.
- The local environment has Python and Pandas installed.

## Limitations

- OULAD is anonymized public data.
- No payment or revenue data exists in this dataset.
- No lead data exists in this dataset.
- No private client data is used.
- SQLite is used for local portfolio simplicity.
- Airflow and dbt artifacts are documentation-level examples only.
- BigQuery and Snowflake notes are future enhancement guidance only.
- `studentVle.csv` is large and should be processed with chunks.
- Raw data must be downloaded separately and is not committed to Git.
- Generated database files are not committed to Git.
- No fake screenshots are included.
- This project does not claim deployment.


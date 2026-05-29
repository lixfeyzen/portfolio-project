# Pipeline Workflow

## Extract

The extraction step checks that all expected raw OULAD CSV files exist in `data/raw/`.

It records:

- file name
- row count
- column names
- file size

The output is written to:

```text
documentation/extraction_summary.md
```

## Clean and Transform

The cleaning step standardizes source tables for downstream validation and SQLite loading.

Main actions:

- normalize column names to snake case
- trim string fields
- standardize key categorical values
- convert relative date/day fields to nullable integers
- convert score and weight fields to numeric values
- remove duplicate primary key records for dimension-like and assessment tables
- preserve repeated clickstream event rows in `student_vle`

## Handling Large `studentVle.csv`

`studentVle.csv` is large, so it is processed with chunked reads using a default chunksize of 100,000 rows.

This avoids loading the full clickstream file into memory during cleaning and SQLite loading.

## Validate

The validation step checks data quality rules across cleaned files.

Checks include:

- missing critical identifiers
- duplicate business keys
- foreign key consistency
- invalid score ranges
- negative click counts
- invalid categories
- missing registration dates
- missing IMD bands
- missing assessment scores

The validation output is written to:

```text
documentation/validation_summary.md
```

## Load to SQLite

The loading step creates a local SQLite database:

```text
outputs/oulad_pipeline.db
```

It creates tables, loads cleaned CSV files, and builds indexes used by reporting queries.

## Create Reporting Views

SQL views are created from:

```text
sql/reporting_views.sql
```

The views model course registrations, student engagement, assessment performance, VLE activity, student outcomes, and rule-based risk indicators.

## Export Reporting Tables

Reporting views are exported to:

```text
outputs/reporting_tables/
```

The exports can be used by BI tools, spreadsheets, or dashboard prototypes.

## Monitoring Considerations

In a production-like environment, the pipeline would include:

- scheduled execution
- source file arrival checks
- row count drift alerts
- validation failure alerts
- processing duration logging
- load success checks
- historical validation logs


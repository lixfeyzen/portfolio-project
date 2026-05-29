# Cloud Warehouse Notes

This local SQLite project can be adapted to BigQuery or Snowflake with the same broad layers.

## Raw Layer

Store unmodified OULAD CSV extracts in cloud object storage:

- Google Cloud Storage for BigQuery
- Amazon S3 or internal stage for Snowflake

Raw files should be loaded into raw tables with minimal transformation.

## Staging Layer

Create staging tables or views that:

- normalize column names
- cast fields to expected types
- preserve source identifiers
- expose source row counts
- keep relative date fields as integer day offsets

## Transformation Layer

Build intermediate models for:

- student-course enrollment context
- assessment submissions with course context
- VLE activity with site metadata
- student engagement aggregation
- assessment completion aggregation

## Marts

Create BI-facing marts for:

- course registration summary
- student engagement summary
- assessment performance
- VLE activity
- student outcomes
- rule-based risk indicators

## Data Quality Tests

Warehouse tests should cover:

- primary key uniqueness
- non-null critical IDs
- valid score range
- non-negative clicks
- valid categories
- foreign key relationships
- row count freshness

## Scheduled Refresh

In a production-style design, refresh could be scheduled through:

- Airflow
- dbt Cloud
- BigQuery scheduled queries
- Snowflake tasks
- managed orchestration in the cloud platform

## Access Control

Access should separate:

- raw data maintainers
- transformation owners
- BI consumers
- dashboard viewers

Even though OULAD is anonymized, role-based access is still a good data governance habit.

## Cost and Performance Considerations

- Partition large clickstream data where supported.
- Cluster or sort by course, presentation, student, and site identifiers.
- Avoid repeatedly scanning the full clickstream table for dashboard queries.
- Materialize frequently used marts when query cost or latency becomes high.


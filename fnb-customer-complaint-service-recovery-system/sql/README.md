# SQL Notes

The SQL scripts are written in SQL Server style because the portfolio is focused on business/system analysis and developer handoff.

Recommended order:

1. Run `create-staging-table.sql` to create the staging table for the working sample.
2. Run `load-sample-data.sql` if the CSV import wizard is not used.
3. Run `analysis-queries.sql` to reproduce the data exploration outputs.
4. Run `service-recovery-schema.sql` to create the proposed internal workflow schema.

The staging scripts support the anonymized sample file in `data/sample-311-food-complaints.csv`.

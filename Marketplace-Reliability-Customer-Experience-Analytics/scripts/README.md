# Scripts

This folder can hold optional profiling or utility scripts for the project.

Current script:

- `profile_data.py`: profiles the expected Olist CSV files and writes `documentation/data_profile_summary.md`.
- `check_environment.ps1`: checks required files, available tools, SQL Server services, and connection attempts.
- `import_csv_to_sqlserver.ps1`: imports the Olist CSV files into raw SQL Server tables using .NET `SqlBulkCopy`.
- `run_sql_workflow.ps1`: creates tables, imports CSV files, creates views, and exports SQL result sets when SQL Server is reachable.
- `export_sql_validation_outputs.ps1`: runs selected SQL check scripts and saves result sets to CSV.
- `auto_setup_sql_workflow.ps1`: runs profiling, environment checks, SQL import, view creation, and validation output export in one command.

Possible future scripts:

- SQL validation export
- dashboard metadata checks

Add utility scripts only when they are useful, safe, and do not require credentials or package installation.

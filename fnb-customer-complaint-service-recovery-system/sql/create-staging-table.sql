-- create-staging-table.sql
-- SQL Server-style staging table for the anonymized 311 food complaint working sample.

IF OBJECT_ID('dbo.stg_311_food_complaints', 'U') IS NOT NULL
    DROP TABLE dbo.stg_311_food_complaints;
GO

CREATE TABLE dbo.stg_311_food_complaints (
    sample_record_id          VARCHAR(20)   NOT NULL PRIMARY KEY,
    source_request_code       VARCHAR(50)   NULL,
    created_date              DATETIME2     NOT NULL,
    closed_date               DATETIME2     NULL,
    agency                    VARCHAR(20)   NULL,
    complaint_type            VARCHAR(100)  NULL,
    descriptor                VARCHAR(255)  NULL,
    location_type             VARCHAR(120)  NULL,
    status                    VARCHAR(30)   NULL,
    due_date                  DATETIME2     NULL,
    borough                   VARCHAR(50)   NULL,
    open_data_channel_type    VARCHAR(30)   NULL,
    outlet_code               VARCHAR(20)   NULL,
    complaint_category        VARCHAR(100)  NULL,
    proposed_severity         VARCHAR(20)   NULL,
    sla_status                VARCHAR(50)   NULL,
    response_hours            DECIMAL(10,2) NULL,
    ticket_candidate          VARCHAR(20)   NULL,
    suggested_owner           VARCHAR(120)  NULL
);
GO

-- Import note:
-- Use the CSV file: data/sample-311-food-complaints.csv
-- In SQL Server Management Studio, use Import Flat File or run sql/load-sample-data.sql for the included working sample.

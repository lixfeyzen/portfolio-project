-- create-staging-table.sql
-- Project: Restaurant Inspection Corrective Action Management System
-- Purpose: Create a staging table and clean analysis view for the anonymized working sample.
-- SQL dialect: SQL Server style
-- Input file: ../data/sample-food-inspections.csv

IF OBJECT_ID('dbo.vw_food_inspections_clean', 'V') IS NOT NULL
    DROP VIEW dbo.vw_food_inspections_clean;
GO

IF OBJECT_ID('dbo.sample_food_inspections', 'U') IS NOT NULL
    DROP TABLE dbo.sample_food_inspections;
GO

CREATE TABLE dbo.sample_food_inspections (
    sample_record_id NVARCHAR(20) NOT NULL PRIMARY KEY,
    establishment_code NVARCHAR(50) NOT NULL,
    facility_type NVARCHAR(150) NULL,
    risk NVARCHAR(100) NULL,
    inspection_date DATE NULL,
    inspection_type NVARCHAR(255) NULL,
    results NVARCHAR(100) NULL,
    violation_summary NVARCHAR(MAX) NULL,
    violation_category NVARCHAR(255) NULL,
    ticket_candidate NVARCHAR(50) NULL,
    proposed_priority NVARCHAR(50) NULL
);
GO

-- Clean analysis view.
-- Import ../data/sample-food-inspections.csv into dbo.sample_food_inspections before running analysis-queries.sql.
-- For the full official dataset, map the original fields into this same view structure.
CREATE VIEW dbo.vw_food_inspections_clean AS
SELECT
    sample_record_id AS source_record_id,
    establishment_code,
    UPPER(LTRIM(RTRIM(facility_type))) AS facility_type,
    risk AS risk_level,
    inspection_date,
    inspection_type,
    UPPER(LTRIM(RTRIM(results))) AS inspection_result,
    violation_summary,
    violation_category,
    UPPER(LTRIM(RTRIM(ticket_candidate))) AS ticket_candidate,
    UPPER(LTRIM(RTRIM(proposed_priority))) AS proposed_priority
FROM dbo.sample_food_inspections;
GO

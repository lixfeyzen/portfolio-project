-- analysis-queries.sql
-- Project: Restaurant Inspection Corrective Action Management System
-- Purpose: Explore inspection data and translate findings into system requirements.
-- SQL dialect: SQL Server style
-- Prerequisite: Import ../data/sample-food-inspections.csv into dbo.sample_food_inspections,
-- then run create-staging-table.sql to create dbo.vw_food_inspections_clean.

-- 1. Inspection result distribution
SELECT
    inspection_result,
    COUNT(*) AS inspection_count
FROM dbo.vw_food_inspections_clean
GROUP BY inspection_result
ORDER BY inspection_count DESC;

-- 2. Corrective action candidate records
SELECT
    source_record_id,
    establishment_code,
    facility_type,
    risk_level,
    inspection_date,
    inspection_type,
    inspection_result,
    ticket_candidate,
    proposed_priority,
    violation_category,
    violation_summary
FROM dbo.vw_food_inspections_clean
WHERE ticket_candidate IN ('YES', 'MONITOR')
ORDER BY inspection_date DESC, source_record_id;

-- 3. Risk distribution for failed / conditional records
SELECT
    risk_level,
    COUNT(*) AS inspection_count
FROM dbo.vw_food_inspections_clean
WHERE inspection_result IN ('FAIL', 'PASS W/ CONDITIONS')
GROUP BY risk_level
ORDER BY inspection_count DESC;

-- 4. Facility types with failed / conditional records
SELECT
    facility_type,
    COUNT(*) AS inspection_count
FROM dbo.vw_food_inspections_clean
WHERE inspection_result IN ('FAIL', 'PASS W/ CONDITIONS')
GROUP BY facility_type
ORDER BY inspection_count DESC;

-- 5. Repeat failed / conditional issues by establishment and violation category
SELECT
    establishment_code,
    violation_category,
    COUNT(*) AS failed_or_conditional_count,
    MIN(inspection_date) AS first_issue_date,
    MAX(inspection_date) AS latest_issue_date
FROM dbo.vw_food_inspections_clean
WHERE inspection_result IN ('FAIL', 'PASS W/ CONDITIONS')
GROUP BY establishment_code, violation_category
HAVING COUNT(*) >= 2
ORDER BY failed_or_conditional_count DESC, latest_issue_date DESC;

-- 6. Violation category distribution for failed / conditional records
SELECT
    violation_category,
    COUNT(*) AS record_count
FROM dbo.vw_food_inspections_clean
WHERE inspection_result IN ('FAIL', 'PASS W/ CONDITIONS')
  AND violation_category IS NOT NULL
GROUP BY violation_category
ORDER BY record_count DESC;

-- 7. MVP ticket creation dataset
SELECT
    source_record_id,
    establishment_code,
    risk_level,
    inspection_date,
    inspection_result,
    violation_category,
    proposed_priority,
    CASE
        WHEN proposed_priority = 'HIGH' THEN DATEADD(day, 3, inspection_date)
        WHEN proposed_priority = 'MEDIUM' THEN DATEADD(day, 7, inspection_date)
        WHEN proposed_priority = 'LOW' THEN DATEADD(day, 14, inspection_date)
        ELSE DATEADD(day, 7, inspection_date)
    END AS proposed_due_date,
    violation_summary AS violation_notes
FROM dbo.vw_food_inspections_clean
WHERE inspection_result IN ('FAIL', 'PASS W/ CONDITIONS')
ORDER BY inspection_date DESC, source_record_id;

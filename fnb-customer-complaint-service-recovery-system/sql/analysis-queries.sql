-- analysis-queries.sql
-- Purpose: Explore complaint patterns and translate data findings into workflow requirements.
-- SQL Server style.

-- 1. Total records
SELECT COUNT(*) AS total_records
FROM dbo.stg_311_food_complaints;

-- 2. Status distribution
SELECT
    status,
    COUNT(*) AS records
FROM dbo.stg_311_food_complaints
GROUP BY status
ORDER BY records DESC;

-- 3. Complaint category distribution
SELECT
    complaint_category,
    COUNT(*) AS records
FROM dbo.stg_311_food_complaints
GROUP BY complaint_category
ORDER BY records DESC;

-- 4. Severity distribution
SELECT
    proposed_severity,
    COUNT(*) AS records
FROM dbo.stg_311_food_complaints
GROUP BY proposed_severity
ORDER BY
    CASE proposed_severity
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
        ELSE 5
    END;

-- 5. SLA status distribution
SELECT
    sla_status,
    COUNT(*) AS records
FROM dbo.stg_311_food_complaints
GROUP BY sla_status
ORDER BY records DESC;

-- 6. Channel distribution
SELECT
    open_data_channel_type,
    COUNT(*) AS records
FROM dbo.stg_311_food_complaints
GROUP BY open_data_channel_type
ORDER BY records DESC;

-- 7. Suggested owner distribution
SELECT
    suggested_owner,
    COUNT(*) AS records
FROM dbo.stg_311_food_complaints
GROUP BY suggested_owner
ORDER BY records DESC;

-- 8. Average response time for closed records
SELECT
    COUNT(*) AS closed_records,
    AVG(response_hours) AS avg_response_hours,
    MIN(response_hours) AS min_response_hours,
    MAX(response_hours) AS max_response_hours
FROM dbo.stg_311_food_complaints
WHERE closed_date IS NOT NULL
  AND response_hours IS NOT NULL;

-- 9. Open overdue cases requiring escalation
SELECT
    sample_record_id,
    created_date,
    due_date,
    borough,
    outlet_code,
    complaint_category,
    proposed_severity,
    sla_status,
    suggested_owner
FROM dbo.stg_311_food_complaints
WHERE sla_status = 'Open overdue'
ORDER BY due_date ASC;

-- 10. Closed late cases for process review
SELECT
    sample_record_id,
    created_date,
    closed_date,
    due_date,
    response_hours,
    outlet_code,
    complaint_category,
    proposed_severity,
    suggested_owner
FROM dbo.stg_311_food_complaints
WHERE sla_status = 'Closed late'
ORDER BY response_hours DESC;

-- 11. Service recovery ticket candidates by owner
SELECT
    suggested_owner,
    proposed_severity,
    COUNT(*) AS ticket_count
FROM dbo.stg_311_food_complaints
WHERE ticket_candidate = 'Yes'
GROUP BY suggested_owner, proposed_severity
ORDER BY ticket_count DESC;

-- 12. Repeat issue signal by outlet and complaint category
SELECT
    outlet_code,
    complaint_category,
    COUNT(*) AS complaint_count
FROM dbo.stg_311_food_complaints
GROUP BY outlet_code, complaint_category
HAVING COUNT(*) >= 2
ORDER BY complaint_count DESC;

-- 13. Suggested internal due date rule preview
-- Matches the MVP SLA rule in docs/workflow-sop-requirements.md:
-- Critical = 24 hours, High = 48 hours, Medium = 72 hours.
SELECT
    sample_record_id,
    created_date,
    proposed_severity,
    CASE
        WHEN proposed_severity = 'Critical' THEN DATEADD(HOUR, 24, created_date)
        WHEN proposed_severity = 'High' THEN DATEADD(HOUR, 48, created_date)
        WHEN proposed_severity = 'Medium' THEN DATEADD(HOUR, 72, created_date)
        ELSE DATEADD(DAY, 7, created_date)
    END AS suggested_internal_due_date
FROM dbo.stg_311_food_complaints
WHERE ticket_candidate = 'Yes'
ORDER BY created_date DESC;

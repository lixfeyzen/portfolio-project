-- load-sample-data.sql
-- Optional SQL Server-style seed script for the anonymized working sample.
-- Run this after sql/create-staging-table.sql if the CSV import wizard is not used.

TRUNCATE TABLE dbo.stg_311_food_complaints;
GO

INSERT INTO dbo.stg_311_food_complaints (
    sample_record_id,
    source_request_code,
    created_date,
    closed_date,
    agency,
    complaint_type,
    descriptor,
    location_type,
    status,
    due_date,
    borough,
    open_data_channel_type,
    outlet_code,
    complaint_category,
    proposed_severity,
    sla_status,
    response_hours,
    ticket_candidate,
    suggested_owner
)
VALUES
    ('SR-001', 'NYC311-001', '2026-06-05 01:50:04', NULL, 'DOHMH', 'Food Establishment', 'Handwashing - no handwashing facility', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-06-07 23:59:00', 'Manhattan', 'Online', 'OUT-002', 'Hygiene', 'Critical', 'Open within SLA', NULL, 'Yes', 'Outlet Manager + QA'),
    ('SR-002', 'NYC311-002', '2026-06-04 14:12:00', '2026-06-05 10:18:00', 'DOHMH', 'Food Establishment', 'Food not held at proper temperature', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-06 23:59:00', 'Queens', 'Phone', 'OUT-003', 'Temperature Control', 'Critical', 'Closed on time', 20.1, 'Yes', 'Outlet Manager + QA'),
    ('SR-003', 'NYC311-003', '2026-06-04 09:35:00', NULL, 'DOHMH', 'Food Establishment', 'Roaches observed inside facility', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-06-05 23:59:00', 'Brooklyn', 'Online', 'OUT-004', 'Pest Control', 'High', 'Open overdue', NULL, 'Yes', 'Outlet Manager + Area Manager'),
    ('SR-004', 'NYC311-004', '2026-06-03 17:05:00', '2026-06-07 11:42:00', 'DOHMH', 'Food Establishment', 'Dirty cutting boards and counters', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-06 17:05:00', 'Manhattan', 'Mobile', 'OUT-005', 'Sanitation', 'High', 'Closed late', 90.6, 'Yes', 'Outlet Manager'),
    ('SR-005', 'NYC311-005', '2026-06-03 12:30:00', NULL, 'DOHMH', 'Food Establishment', 'Sick food worker reported', 'Restaurant/Bar/Deli/Bakery', 'Open', '2026-06-04 23:59:00', 'Bronx', 'Phone', 'OUT-006', 'Employee Health', 'Critical', 'Open overdue', NULL, 'Yes', 'Outlet Manager + QA'),
    ('SR-006', 'NYC311-006', '2026-06-02 19:20:00', '2026-06-03 16:02:00', 'DOHMH', 'Food Establishment', 'Garbage or sewage issue near food area', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-04 23:59:00', 'Queens', 'Online', 'OUT-007', 'Waste / Sewage', 'High', 'Closed on time', 20.7, 'Yes', 'Outlet Manager'),
    ('SR-007', 'NYC311-007', '2026-06-02 08:48:00', NULL, 'DOHMH', 'Food Establishment', 'Operating without visible permit', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-06-05 23:59:00', 'Staten Island', 'Online', 'OUT-001', 'Permit / Documentation', 'High', 'Open overdue', NULL, 'Yes', 'Area Manager + QA'),
    ('SR-008', 'NYC311-008', '2026-06-01 21:15:00', '2026-06-02 19:10:00', 'DOHMH', 'Food Establishment', 'Bare hand contact with ready-to-eat food', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-03 23:59:00', 'Brooklyn', 'Mobile', 'OUT-002', 'Food Handling', 'Critical', 'Closed on time', 21.9, 'Yes', 'Outlet Manager + QA'),
    ('SR-009', 'NYC311-009', '2026-06-01 10:25:00', '2026-06-04 13:40:00', 'DOHMH', 'Food Establishment', 'Poorly maintained bathroom', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-04 23:59:00', 'Manhattan', 'Online', 'OUT-003', 'Facility Maintenance', 'Medium', 'Closed on time', 75.2, 'Monitor', 'Outlet Manager'),
    ('SR-010', 'NYC311-010', '2026-05-31 16:11:00', NULL, 'DOHMH', 'Food Establishment', 'Rats or mice evidence near storage', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-06-02 23:59:00', 'Bronx', 'Phone', 'OUT-004', 'Pest Control', 'High', 'Open overdue', NULL, 'Yes', 'Outlet Manager + Area Manager'),
    ('SR-011', 'NYC311-011', '2026-05-31 11:05:00', '2026-06-01 09:22:00', 'DOHMH', 'Food Establishment', 'Food contaminated or spoiled', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-02 23:59:00', 'Queens', 'Online', 'OUT-005', 'Food Quality', 'Critical', 'Closed on time', 22.3, 'Yes', 'Outlet Manager + QA'),
    ('SR-012', 'NYC311-012', '2026-05-30 20:45:00', NULL, 'DOHMH', 'Food Establishment', 'Pets or live animals inside facility', 'Restaurant/Bar/Deli/Bakery', 'Open', '2026-06-02 23:59:00', 'Brooklyn', 'Mobile', 'OUT-006', 'Facility Control', 'Medium', 'Open overdue', NULL, 'Yes', 'Outlet Manager'),
    ('SR-013', 'NYC311-013', '2026-05-30 13:15:00', '2026-06-05 08:30:00', 'DOHMH', 'Food Establishment', 'Dirty counters and food preparation area', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-03 23:59:00', 'Manhattan', 'Online', 'OUT-007', 'Sanitation', 'High', 'Closed late', 139.2, 'Yes', 'Outlet Manager'),
    ('SR-014', 'NYC311-014', '2026-05-29 18:50:00', NULL, 'DOHMH', 'Food Establishment', 'Food not stored at proper temperature', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-05-31 23:59:00', 'Queens', 'Phone', 'OUT-001', 'Temperature Control', 'Critical', 'Open overdue', NULL, 'Yes', 'Outlet Manager + QA'),
    ('SR-015', 'NYC311-015', '2026-05-29 07:40:00', '2026-05-30 15:25:00', 'DOHMH', 'Food Establishment', 'Roaches observed inside facility', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-01 23:59:00', 'Brooklyn', 'Online', 'OUT-002', 'Pest Control', 'High', 'Closed on time', 31.8, 'Yes', 'Outlet Manager + Area Manager'),
    ('SR-016', 'NYC311-016', '2026-05-28 22:10:00', '2026-06-01 12:15:00', 'DOHMH', 'Food Establishment', 'Garbage issue behind food preparation area', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-06-01 23:59:00', 'Bronx', 'Mobile', 'OUT-003', 'Waste / Sewage', 'High', 'Closed on time', 86.1, 'Yes', 'Outlet Manager'),
    ('SR-017', 'NYC311-017', '2026-05-28 10:05:00', NULL, 'DOHMH', 'Food Establishment', 'Handwashing procedure not followed', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-05-30 23:59:00', 'Manhattan', 'Online', 'OUT-004', 'Hygiene', 'Critical', 'Open overdue', NULL, 'Yes', 'Outlet Manager + QA'),
    ('SR-018', 'NYC311-018', '2026-05-27 15:33:00', '2026-05-29 09:50:00', 'DOHMH', 'Food Establishment', 'Storage practice issue', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-05-30 23:59:00', 'Staten Island', 'Phone', 'OUT-005', 'Storage Practice', 'Medium', 'Closed on time', 42.3, 'Monitor', 'Outlet Manager'),
    ('SR-019', 'NYC311-019', '2026-05-27 09:18:00', NULL, 'DOHMH', 'Food Establishment', 'Unsafe food handling practice', 'Restaurant/Bar/Deli/Bakery', 'Open', '2026-05-29 23:59:00', 'Queens', 'Mobile', 'OUT-006', 'Food Handling', 'Critical', 'Open overdue', NULL, 'Yes', 'Outlet Manager + QA'),
    ('SR-020', 'NYC311-020', '2026-05-26 19:05:00', '2026-05-31 14:20:00', 'DOHMH', 'Food Establishment', 'Dirty cutting boards and counters', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-05-29 23:59:00', 'Manhattan', 'Online', 'OUT-007', 'Sanitation', 'High', 'Closed late', 115.2, 'Yes', 'Outlet Manager'),
    ('SR-021', 'NYC311-021', '2026-05-26 11:12:00', '2026-05-27 11:30:00', 'DOHMH', 'Food Establishment', 'Food preparation odor complaint', 'Food Market/Processor', 'Closed', '2026-05-29 23:59:00', 'Brooklyn', 'Online', 'OUT-001', 'Odor / Spoilage', 'Medium', 'Closed on time', 24.3, 'Monitor', 'Outlet Manager'),
    ('SR-022', 'NYC311-022', '2026-05-25 20:30:00', NULL, 'DOHMH', 'Food Establishment', 'Rats or mice evidence near storage', 'Restaurant/Bar/Deli/Bakery', 'In Progress', '2026-05-27 23:59:00', 'Bronx', 'Phone', 'OUT-002', 'Pest Control', 'High', 'Open overdue', NULL, 'Yes', 'Outlet Manager + Area Manager'),
    ('SR-023', 'NYC311-023', '2026-05-25 13:22:00', '2026-05-26 18:00:00', 'DOHMH', 'Food Establishment', 'Bare hand contact with ready-to-eat food', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-05-27 23:59:00', 'Queens', 'Online', 'OUT-003', 'Food Handling', 'Critical', 'Closed on time', 28.6, 'Yes', 'Outlet Manager + QA'),
    ('SR-024', 'NYC311-024', '2026-05-24 08:10:00', '2026-05-25 10:45:00', 'DOHMH', 'Food Establishment', 'Poorly maintained bathroom', 'Restaurant/Bar/Deli/Bakery', 'Closed', '2026-05-27 23:59:00', 'Manhattan', 'Mobile', 'OUT-004', 'Facility Maintenance', 'Medium', 'Closed on time', 26.6, 'Monitor', 'Outlet Manager');
GO
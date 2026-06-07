-- corrective-action-schema.sql
-- Project: Restaurant Inspection Corrective Action Management System
-- Purpose: Proposed normalized schema for the corrective action workflow system.
-- SQL dialect: SQL Server style

-- Re-run safety: drop dependent tables first.
DROP TABLE IF EXISTS dbo.status_history;
DROP TABLE IF EXISTS dbo.approval_logs;
DROP TABLE IF EXISTS dbo.evidence_files;
DROP TABLE IF EXISTS dbo.corrective_action_tickets;
DROP TABLE IF EXISTS dbo.ticket_statuses;
DROP TABLE IF EXISTS dbo.users;
DROP TABLE IF EXISTS dbo.roles;
DROP TABLE IF EXISTS dbo.violations;
DROP TABLE IF EXISTS dbo.violation_categories;
DROP TABLE IF EXISTS dbo.inspections;
DROP TABLE IF EXISTS dbo.establishments;
GO

CREATE TABLE dbo.establishments (
    establishment_id INT IDENTITY(1,1) PRIMARY KEY,
    establishment_code NVARCHAR(50) NOT NULL UNIQUE,
    facility_type NVARCHAR(150) NULL,
    risk_level NVARCHAR(100) NULL,
    area_zip NVARCHAR(20) NULL,
    status NVARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE dbo.inspections (
    inspection_id BIGINT PRIMARY KEY,
    establishment_id INT NOT NULL,
    inspection_date DATE NOT NULL,
    inspection_type NVARCHAR(255) NULL,
    inspection_result NVARCHAR(100) NOT NULL,
    source_system NVARCHAR(150) NOT NULL DEFAULT 'City of Chicago Food Inspections',
    imported_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_inspections_establishments FOREIGN KEY (establishment_id) REFERENCES dbo.establishments(establishment_id)
);
GO

CREATE TABLE dbo.violation_categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(150) NOT NULL UNIQUE,
    default_severity NVARCHAR(50) NULL,
    default_due_days INT NULL
);
GO

CREATE TABLE dbo.violations (
    violation_id INT IDENTITY(1,1) PRIMARY KEY,
    inspection_id BIGINT NOT NULL,
    category_id INT NULL,
    source_violation_code NVARCHAR(50) NULL,
    violation_summary NVARCHAR(MAX) NULL,
    severity NVARCHAR(50) NULL,
    is_actionable BIT NOT NULL DEFAULT 0,
    CONSTRAINT fk_violations_inspections FOREIGN KEY (inspection_id) REFERENCES dbo.inspections(inspection_id),
    CONSTRAINT fk_violations_categories FOREIGN KEY (category_id) REFERENCES dbo.violation_categories(category_id)
);
GO

CREATE TABLE dbo.roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);
GO

CREATE TABLE dbo.users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    role_id INT NOT NULL,
    establishment_id INT NULL,
    full_name NVARCHAR(150) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    status NVARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_users_roles FOREIGN KEY (role_id) REFERENCES dbo.roles(role_id),
    CONSTRAINT fk_users_establishments FOREIGN KEY (establishment_id) REFERENCES dbo.establishments(establishment_id)
);
GO

CREATE TABLE dbo.ticket_statuses (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_name NVARCHAR(50) NOT NULL UNIQUE,
    status_sequence INT NOT NULL,
    is_terminal BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE dbo.corrective_action_tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    violation_id INT NOT NULL UNIQUE,
    status_id INT NOT NULL,
    assigned_to_user_id INT NULL,
    assigned_by_user_id INT NULL,
    ticket_number NVARCHAR(50) NOT NULL UNIQUE,
    priority NVARCHAR(50) NOT NULL,
    due_date DATE NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    closed_at DATETIME2 NULL,
    escalation_flag BIT NOT NULL DEFAULT 0,
    CONSTRAINT fk_tickets_violations FOREIGN KEY (violation_id) REFERENCES dbo.violations(violation_id),
    CONSTRAINT fk_tickets_statuses FOREIGN KEY (status_id) REFERENCES dbo.ticket_statuses(status_id),
    CONSTRAINT fk_tickets_assigned_to FOREIGN KEY (assigned_to_user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT fk_tickets_assigned_by FOREIGN KEY (assigned_by_user_id) REFERENCES dbo.users(user_id)
);
GO

CREATE TABLE dbo.evidence_files (
    evidence_id INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id INT NOT NULL,
    submitted_by_user_id INT NOT NULL,
    evidence_type NVARCHAR(50) NULL,
    file_url NVARCHAR(500) NOT NULL,
    evidence_note NVARCHAR(MAX) NULL,
    submitted_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_evidence_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.corrective_action_tickets(ticket_id),
    CONSTRAINT fk_evidence_users FOREIGN KEY (submitted_by_user_id) REFERENCES dbo.users(user_id)
);
GO

CREATE TABLE dbo.approval_logs (
    approval_log_id INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id INT NOT NULL,
    reviewed_by_user_id INT NOT NULL,
    review_decision NVARCHAR(50) NOT NULL,
    review_note NVARCHAR(MAX) NULL,
    reviewed_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_approval_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.corrective_action_tickets(ticket_id),
    CONSTRAINT fk_approval_users FOREIGN KEY (reviewed_by_user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT chk_review_decision CHECK (review_decision IN ('Approved', 'Rejected', 'Rework Requested'))
);
GO

CREATE TABLE dbo.status_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id INT NOT NULL,
    from_status_id INT NULL,
    to_status_id INT NOT NULL,
    changed_by_user_id INT NULL,
    change_note NVARCHAR(MAX) NULL,
    changed_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_status_history_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.corrective_action_tickets(ticket_id),
    CONSTRAINT fk_status_history_from_status FOREIGN KEY (from_status_id) REFERENCES dbo.ticket_statuses(status_id),
    CONSTRAINT fk_status_history_to_status FOREIGN KEY (to_status_id) REFERENCES dbo.ticket_statuses(status_id),
    CONSTRAINT fk_status_history_users FOREIGN KEY (changed_by_user_id) REFERENCES dbo.users(user_id)
);
GO

-- Seed ticket statuses.
INSERT INTO dbo.ticket_statuses (status_name, status_sequence, is_terminal)
VALUES
('Open', 1, 0),
('Assigned', 2, 0),
('In Progress', 3, 0),
('Pending Review', 4, 0),
('Rework', 5, 0),
('Overdue', 6, 0),
('Closed', 7, 1);
GO

-- Suggested indexes for monitoring.
CREATE INDEX ix_inspections_establishment_date ON dbo.inspections(establishment_id, inspection_date);
CREATE INDEX ix_violations_category_severity ON dbo.violations(category_id, severity, is_actionable);
CREATE INDEX ix_tickets_status_due_date ON dbo.corrective_action_tickets(status_id, due_date);
CREATE INDEX ix_tickets_assigned_user ON dbo.corrective_action_tickets(assigned_to_user_id);
CREATE INDEX ix_status_history_ticket_date ON dbo.status_history(ticket_id, changed_at);
GO

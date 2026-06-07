-- service-recovery-schema.sql
-- SQL Server-style schema for the F&B Customer Complaint & Service Recovery Management System.
-- Scope: complaint intake, ticket creation, SLA, assignment, investigation,
-- recovery action, review decision, status history, and escalation monitoring.

IF OBJECT_ID('dbo.ticket_escalations', 'U') IS NOT NULL DROP TABLE dbo.ticket_escalations;
IF OBJECT_ID('dbo.ticket_status_history', 'U') IS NOT NULL DROP TABLE dbo.ticket_status_history;
IF OBJECT_ID('dbo.review_decisions', 'U') IS NOT NULL DROP TABLE dbo.review_decisions;
IF OBJECT_ID('dbo.recovery_actions', 'U') IS NOT NULL DROP TABLE dbo.recovery_actions;
IF OBJECT_ID('dbo.investigation_notes', 'U') IS NOT NULL DROP TABLE dbo.investigation_notes;
IF OBJECT_ID('dbo.ticket_assignments', 'U') IS NOT NULL DROP TABLE dbo.ticket_assignments;
IF OBJECT_ID('dbo.service_recovery_tickets', 'U') IS NOT NULL DROP TABLE dbo.service_recovery_tickets;
IF OBJECT_ID('dbo.complaint_records', 'U') IS NOT NULL DROP TABLE dbo.complaint_records;
IF OBJECT_ID('dbo.users', 'U') IS NOT NULL DROP TABLE dbo.users;
IF OBJECT_ID('dbo.severity_rules', 'U') IS NOT NULL DROP TABLE dbo.severity_rules;
IF OBJECT_ID('dbo.complaint_categories', 'U') IS NOT NULL DROP TABLE dbo.complaint_categories;
IF OBJECT_ID('dbo.outlets', 'U') IS NOT NULL DROP TABLE dbo.outlets;
GO

CREATE TABLE dbo.outlets (
    outlet_id       INT IDENTITY(1,1) PRIMARY KEY,
    outlet_code     VARCHAR(20) NOT NULL UNIQUE,
    borough         VARCHAR(50) NULL,
    is_active       BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.complaint_categories (
    category_id         INT IDENTITY(1,1) PRIMARY KEY,
    category_name       VARCHAR(100) NOT NULL UNIQUE,
    default_owner_team  VARCHAR(100) NULL
);
GO

CREATE TABLE dbo.severity_rules (
    severity_id      INT IDENTITY(1,1) PRIMARY KEY,
    severity_name    VARCHAR(20) NOT NULL UNIQUE,
    sla_hours        INT NOT NULL,
    escalation_rule  VARCHAR(255) NULL,
    CONSTRAINT CK_severity_rules_name CHECK (severity_name IN ('Medium', 'High', 'Critical')),
    CONSTRAINT CK_severity_rules_sla CHECK (sla_hours > 0)
);
GO

CREATE TABLE dbo.users (
    user_id      INT IDENTITY(1,1) PRIMARY KEY,
    full_name    VARCHAR(120) NOT NULL,
    role_name    VARCHAR(80) NOT NULL,
    outlet_id    INT NULL,
    is_active    BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_users_outlets FOREIGN KEY (outlet_id) REFERENCES dbo.outlets(outlet_id)
);
GO

CREATE TABLE dbo.complaint_records (
    complaint_id          INT IDENTITY(1,1) PRIMARY KEY,
    source_request_code   VARCHAR(50) NULL,
    outlet_id             INT NULL,
    created_at            DATETIME2 NOT NULL,
    closed_at             DATETIME2 NULL,
    agency                VARCHAR(20) NULL,
    complaint_type        VARCHAR(100) NULL,
    descriptor            VARCHAR(255) NULL,
    location_type         VARCHAR(120) NULL,
    source_status         VARCHAR(30) NULL,
    source_due_at         DATETIME2 NULL,
    channel_type          VARCHAR(30) NULL,
    ticket_candidate      BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_complaint_records_outlets FOREIGN KEY (outlet_id) REFERENCES dbo.outlets(outlet_id)
);
GO

CREATE TABLE dbo.service_recovery_tickets (
    ticket_id           INT IDENTITY(1,1) PRIMARY KEY,
    complaint_id        INT NOT NULL UNIQUE,
    category_id         INT NOT NULL,
    severity_id         INT NOT NULL,
    current_status      VARCHAR(40) NOT NULL DEFAULT 'New',
    assigned_owner_id   INT NULL,
    due_at              DATETIME2 NOT NULL,
    is_repeat_issue     BIT NOT NULL DEFAULT 0,
    is_overdue          BIT NOT NULL DEFAULT 0,
    created_at          DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    closed_at           DATETIME2 NULL,
    CONSTRAINT FK_tickets_complaint_records FOREIGN KEY (complaint_id) REFERENCES dbo.complaint_records(complaint_id),
    CONSTRAINT FK_tickets_categories FOREIGN KEY (category_id) REFERENCES dbo.complaint_categories(category_id),
    CONSTRAINT FK_tickets_severity_rules FOREIGN KEY (severity_id) REFERENCES dbo.severity_rules(severity_id),
    CONSTRAINT FK_tickets_users FOREIGN KEY (assigned_owner_id) REFERENCES dbo.users(user_id),
    CONSTRAINT CK_tickets_status CHECK (current_status IN (
        'New', 'Triaged', 'Assigned', 'In Investigation', 'Pending Review',
        'Rework Required', 'Closed', 'Overdue', 'Escalated'
    ))
);
GO

CREATE TABLE dbo.ticket_assignments (
    assignment_id        INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id            INT NOT NULL,
    assigned_to_user_id  INT NOT NULL,
    assigned_by_user_id  INT NULL,
    assigned_at          DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    assignment_note      VARCHAR(255) NULL,
    CONSTRAINT FK_assignments_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.service_recovery_tickets(ticket_id),
    CONSTRAINT FK_assignments_assigned_to FOREIGN KEY (assigned_to_user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT FK_assignments_assigned_by FOREIGN KEY (assigned_by_user_id) REFERENCES dbo.users(user_id)
);
GO

CREATE TABLE dbo.investigation_notes (
    investigation_id     INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id            INT NOT NULL,
    created_by_user_id   INT NOT NULL,
    root_cause_note      VARCHAR(1000) NOT NULL,
    created_at           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_investigations_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.service_recovery_tickets(ticket_id),
    CONSTRAINT FK_investigations_users FOREIGN KEY (created_by_user_id) REFERENCES dbo.users(user_id)
);
GO

CREATE TABLE dbo.recovery_actions (
    action_id             INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id             INT NOT NULL,
    submitted_by_user_id  INT NOT NULL,
    action_note           VARCHAR(1000) NOT NULL,
    evidence_reference    VARCHAR(255) NULL,
    submitted_at          DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_actions_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.service_recovery_tickets(ticket_id),
    CONSTRAINT FK_actions_users FOREIGN KEY (submitted_by_user_id) REFERENCES dbo.users(user_id)
);
GO

CREATE TABLE dbo.review_decisions (
    review_id             INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id             INT NOT NULL,
    reviewed_by_user_id   INT NOT NULL,
    decision              VARCHAR(20) NOT NULL,
    review_note           VARCHAR(1000) NULL,
    reviewed_at           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_reviews_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.service_recovery_tickets(ticket_id),
    CONSTRAINT FK_reviews_users FOREIGN KEY (reviewed_by_user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT CK_reviews_decision CHECK (decision IN ('Approved', 'Rejected'))
);
GO

CREATE TABLE dbo.ticket_status_history (
    status_history_id     INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id             INT NOT NULL,
    status_name           VARCHAR(40) NOT NULL,
    changed_by_user_id    INT NULL,
    changed_at            DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    status_note           VARCHAR(255) NULL,
    CONSTRAINT FK_status_history_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.service_recovery_tickets(ticket_id),
    CONSTRAINT FK_status_history_users FOREIGN KEY (changed_by_user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT CK_status_history_status CHECK (status_name IN (
        'New', 'Triaged', 'Assigned', 'In Investigation', 'Pending Review',
        'Rework Required', 'Closed', 'Overdue', 'Escalated'
    ))
);
GO

CREATE TABLE dbo.ticket_escalations (
    escalation_id          INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id              INT NOT NULL,
    escalation_reason      VARCHAR(100) NOT NULL,
    escalated_to_user_id   INT NULL,
    escalated_at           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    resolution_note        VARCHAR(1000) NULL,
    CONSTRAINT FK_escalations_tickets FOREIGN KEY (ticket_id) REFERENCES dbo.service_recovery_tickets(ticket_id),
    CONSTRAINT FK_escalations_users FOREIGN KEY (escalated_to_user_id) REFERENCES dbo.users(user_id)
);
GO

CREATE INDEX IX_complaint_records_outlet_created ON dbo.complaint_records(outlet_id, created_at);
CREATE INDEX IX_tickets_status_due ON dbo.service_recovery_tickets(current_status, due_at);
CREATE INDEX IX_tickets_category_severity ON dbo.service_recovery_tickets(category_id, severity_id);
CREATE INDEX IX_status_history_ticket_changed ON dbo.ticket_status_history(ticket_id, changed_at);
GO

INSERT INTO dbo.complaint_categories (category_name, default_owner_team) VALUES
('Employee Health', 'Outlet Manager + QA'),
('Facility Control', 'Outlet Manager'),
('Facility Maintenance', 'Outlet Manager'),
('Food Handling', 'Outlet Manager + QA'),
('Food Quality', 'Outlet Manager + QA'),
('Hygiene', 'Outlet Manager + QA'),
('Odor / Spoilage', 'Outlet Manager + QA'),
('Permit / Documentation', 'Area Manager + QA'),
('Pest Control', 'Outlet Manager + Area Manager'),
('Sanitation', 'Outlet Manager'),
('Service Quality', 'Outlet Manager'),
('Storage Practice', 'Outlet Manager + QA'),
('Temperature Control', 'Outlet Manager + QA'),
('Waste / Sewage', 'Outlet Manager + Area Manager');
GO

INSERT INTO dbo.severity_rules (severity_name, sla_hours, escalation_rule) VALUES
('Critical', 24, 'Escalate to QA / Operations immediately if not assigned.'),
('High', 48, 'Escalate to Area Manager if overdue.'),
('Medium', 72, 'Escalate if repeated or overdue.');
GO

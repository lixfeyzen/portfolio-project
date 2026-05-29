PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS vw_at_risk_student_indicators;
DROP VIEW IF EXISTS vw_student_outcome_summary;
DROP VIEW IF EXISTS vw_vle_activity_summary;
DROP VIEW IF EXISTS vw_assessment_performance_summary;
DROP VIEW IF EXISTS vw_student_engagement_summary;
DROP VIEW IF EXISTS vw_course_registration_summary;

DROP TABLE IF EXISTS student_vle;
DROP TABLE IF EXISTS vle;
DROP TABLE IF EXISTS student_registration;
DROP TABLE IF EXISTS student_info;
DROP TABLE IF EXISTS student_assessment;
DROP TABLE IF EXISTS assessments;
DROP TABLE IF EXISTS courses;

CREATE TABLE courses (
    code_module TEXT NOT NULL,
    code_presentation TEXT NOT NULL,
    module_presentation_length INTEGER,
    PRIMARY KEY (code_module, code_presentation)
);

CREATE TABLE assessments (
    code_module TEXT NOT NULL,
    code_presentation TEXT NOT NULL,
    id_assessment INTEGER NOT NULL,
    assessment_type TEXT NOT NULL CHECK (assessment_type IN ('TMA', 'CMA', 'Exam')),
    date INTEGER,
    weight REAL,
    PRIMARY KEY (id_assessment),
    FOREIGN KEY (code_module, code_presentation)
        REFERENCES courses(code_module, code_presentation)
);

CREATE TABLE student_assessment (
    id_assessment INTEGER NOT NULL,
    id_student INTEGER NOT NULL,
    date_submitted INTEGER,
    is_banked INTEGER,
    score REAL CHECK (score IS NULL OR (score >= 0 AND score <= 100)),
    PRIMARY KEY (id_assessment, id_student),
    FOREIGN KEY (id_assessment)
        REFERENCES assessments(id_assessment)
);

CREATE TABLE student_info (
    code_module TEXT NOT NULL,
    code_presentation TEXT NOT NULL,
    id_student INTEGER NOT NULL,
    gender TEXT,
    region TEXT,
    highest_education TEXT,
    imd_band TEXT,
    age_band TEXT,
    num_of_prev_attempts INTEGER,
    studied_credits INTEGER,
    disability TEXT,
    final_result TEXT NOT NULL CHECK (final_result IN ('Pass', 'Fail', 'Withdrawn', 'Distinction')),
    PRIMARY KEY (code_module, code_presentation, id_student),
    FOREIGN KEY (code_module, code_presentation)
        REFERENCES courses(code_module, code_presentation)
);

CREATE TABLE student_registration (
    code_module TEXT NOT NULL,
    code_presentation TEXT NOT NULL,
    id_student INTEGER NOT NULL,
    date_registration INTEGER,
    date_unregistration INTEGER,
    PRIMARY KEY (code_module, code_presentation, id_student),
    FOREIGN KEY (code_module, code_presentation, id_student)
        REFERENCES student_info(code_module, code_presentation, id_student)
);

CREATE TABLE vle (
    id_site INTEGER NOT NULL,
    code_module TEXT NOT NULL,
    code_presentation TEXT NOT NULL,
    activity_type TEXT,
    week_from INTEGER,
    week_to INTEGER,
    PRIMARY KEY (id_site),
    FOREIGN KEY (code_module, code_presentation)
        REFERENCES courses(code_module, code_presentation)
);

CREATE TABLE student_vle (
    code_module TEXT NOT NULL,
    code_presentation TEXT NOT NULL,
    id_student INTEGER NOT NULL,
    id_site INTEGER NOT NULL,
    date INTEGER,
    sum_click INTEGER NOT NULL CHECK (sum_click >= 0),
    FOREIGN KEY (code_module, code_presentation, id_student)
        REFERENCES student_info(code_module, code_presentation, id_student),
    FOREIGN KEY (id_site)
        REFERENCES vle(id_site)
);

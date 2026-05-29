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
    code_module TEXT,
    code_presentation TEXT,
    module_presentation_length INTEGER
);

CREATE TABLE assessments (
    code_module TEXT,
    code_presentation TEXT,
    id_assessment INTEGER,
    assessment_type TEXT,
    date INTEGER,
    weight REAL
);

CREATE TABLE student_assessment (
    id_assessment INTEGER,
    id_student INTEGER,
    date_submitted INTEGER,
    is_banked INTEGER,
    score REAL
);

CREATE TABLE student_info (
    code_module TEXT,
    code_presentation TEXT,
    id_student INTEGER,
    gender TEXT,
    region TEXT,
    highest_education TEXT,
    imd_band TEXT,
    age_band TEXT,
    num_of_prev_attempts INTEGER,
    studied_credits INTEGER,
    disability TEXT,
    final_result TEXT
);

CREATE TABLE student_registration (
    code_module TEXT,
    code_presentation TEXT,
    id_student INTEGER,
    date_registration INTEGER,
    date_unregistration INTEGER
);

CREATE TABLE vle (
    id_site INTEGER,
    code_module TEXT,
    code_presentation TEXT,
    activity_type TEXT,
    week_from INTEGER,
    week_to INTEGER
);

CREATE TABLE student_vle (
    code_module TEXT,
    code_presentation TEXT,
    id_student INTEGER,
    id_site INTEGER,
    date INTEGER,
    sum_click INTEGER
);


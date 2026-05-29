DROP VIEW IF EXISTS vw_at_risk_student_indicators;
DROP VIEW IF EXISTS vw_student_outcome_summary;
DROP VIEW IF EXISTS vw_vle_activity_summary;
DROP VIEW IF EXISTS vw_assessment_performance_summary;
DROP VIEW IF EXISTS vw_student_engagement_summary;
DROP VIEW IF EXISTS vw_course_registration_summary;

CREATE VIEW vw_course_registration_summary AS
WITH base AS (
    SELECT
        si.code_module,
        si.code_presentation,
        COUNT(DISTINCT si.id_student) AS total_students,
        COUNT(DISTINCT CASE WHEN sr.date_registration IS NOT NULL THEN si.id_student END) AS registered_students,
        COUNT(DISTINCT CASE WHEN si.final_result = 'Withdrawn' THEN si.id_student END) AS withdrawn_students,
        COUNT(DISTINCT CASE WHEN si.final_result = 'Pass' THEN si.id_student END) AS pass_students,
        COUNT(DISTINCT CASE WHEN si.final_result = 'Fail' THEN si.id_student END) AS fail_students,
        COUNT(DISTINCT CASE WHEN si.final_result = 'Distinction' THEN si.id_student END) AS distinction_students
    FROM student_info si
    LEFT JOIN student_registration sr
        ON si.code_module = sr.code_module
        AND si.code_presentation = sr.code_presentation
        AND si.id_student = sr.id_student
    GROUP BY
        si.code_module,
        si.code_presentation
)
SELECT
    code_module,
    code_presentation,
    total_students,
    registered_students,
    withdrawn_students,
    pass_students,
    fail_students,
    distinction_students,
    ROUND(CAST(withdrawn_students AS REAL) / NULLIF(total_students, 0), 4) AS withdrawal_rate,
    ROUND(CAST(pass_students + distinction_students AS REAL) / NULLIF(total_students, 0), 4) AS pass_rate
FROM base;

CREATE VIEW vw_student_engagement_summary AS
WITH engagement AS (
    SELECT
        si.code_module,
        si.code_presentation,
        si.id_student,
        COALESCE(SUM(sv.sum_click), 0) AS total_clicks,
        COUNT(DISTINCT sv.date) AS active_days,
        COUNT(DISTINCT sv.id_site) AS unique_sites_visited
    FROM student_info si
    LEFT JOIN student_vle sv
        ON si.code_module = sv.code_module
        AND si.code_presentation = sv.code_presentation
        AND si.id_student = sv.id_student
    GROUP BY
        si.code_module,
        si.code_presentation,
        si.id_student
),
ranked AS (
    SELECT
        engagement.*,
        ROW_NUMBER() OVER (
            PARTITION BY code_module, code_presentation
            ORDER BY total_clicks
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY code_module, code_presentation
        ) AS cnt
    FROM engagement
),
medians AS (
    SELECT
        code_module,
        code_presentation,
        AVG(CAST(total_clicks AS REAL)) AS median_clicks
    FROM ranked
    WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
    GROUP BY
        code_module,
        code_presentation
)
SELECT
    e.code_module,
    e.code_presentation,
    e.id_student,
    e.total_clicks,
    e.active_days,
    e.unique_sites_visited,
    CASE
        WHEN e.active_days = 0 THEN 0
        ELSE ROUND(CAST(e.total_clicks AS REAL) / e.active_days, 2)
    END AS avg_clicks_per_active_day,
    CASE
        WHEN e.total_clicks = 0 THEN 'No Activity'
        WHEN e.total_clicks < COALESCE(m.median_clicks, 0) THEN 'Low'
        WHEN e.total_clicks < COALESCE(m.median_clicks, 0) * 2 THEN 'Medium'
        ELSE 'High'
    END AS engagement_bucket
FROM engagement e
LEFT JOIN medians m
    ON e.code_module = m.code_module
    AND e.code_presentation = m.code_presentation;

CREATE VIEW vw_assessment_performance_summary AS
WITH assessment_metrics AS (
SELECT
    a.code_module,
    a.code_presentation,
    a.assessment_type,
    COUNT(DISTINCT a.id_assessment) AS assessment_count,
    COUNT(sa.id_student) AS submission_count,
    ROUND(AVG(sa.score), 2) AS avg_score,
    MIN(sa.score) AS min_score,
    MAX(sa.score) AS max_score,
    SUM(CASE WHEN sa.id_student IS NOT NULL AND sa.score IS NULL THEN 1 ELSE 0 END) AS missing_score_count,
    SUM(
        CASE
            WHEN sa.id_student IS NOT NULL
                AND sa.date_submitted IS NOT NULL
                AND a.date IS NOT NULL
                AND sa.date_submitted > a.date
            THEN 1
            ELSE 0
        END
    ) AS late_submission_count,
    ROUND(
        AVG(
            CASE
                WHEN sa.date_submitted IS NOT NULL AND a.date IS NOT NULL
                THEN sa.date_submitted - a.date
            END
        ),
        2
    ) AS avg_days_submitted_before_or_after_due
FROM assessments a
LEFT JOIN student_assessment sa
    ON a.id_assessment = sa.id_assessment
GROUP BY
    a.code_module,
    a.code_presentation,
    a.assessment_type
)
SELECT
    code_module,
    code_presentation,
    assessment_type,
    assessment_count,
    submission_count,
    avg_score,
    min_score,
    max_score,
    missing_score_count,
    late_submission_count,
    ROUND(CAST(late_submission_count AS REAL) / NULLIF(submission_count, 0), 4) AS late_submission_rate,
    avg_days_submitted_before_or_after_due
FROM assessment_metrics;

CREATE VIEW vw_vle_activity_summary AS
SELECT
    sv.code_module,
    sv.code_presentation,
    COALESCE(v.activity_type, 'Unknown') AS activity_type,
    COALESCE(SUM(sv.sum_click), 0) AS total_clicks,
    COUNT(DISTINCT sv.id_student) AS unique_students,
    COUNT(DISTINCT sv.id_site) AS unique_sites,
    CASE
        WHEN COUNT(DISTINCT sv.id_student) = 0 THEN 0
        ELSE ROUND(CAST(COALESCE(SUM(sv.sum_click), 0) AS REAL) / COUNT(DISTINCT sv.id_student), 2)
    END AS avg_clicks_per_student
FROM student_vle sv
LEFT JOIN vle v
    ON sv.id_site = v.id_site
GROUP BY
    sv.code_module,
    sv.code_presentation,
    COALESCE(v.activity_type, 'Unknown');

CREATE VIEW vw_student_outcome_summary AS
WITH outcome_counts AS (
    SELECT
        code_module,
        code_presentation,
        final_result,
        COUNT(DISTINCT id_student) AS student_count
    FROM student_info
    GROUP BY
        code_module,
        code_presentation,
        final_result
),
presentation_totals AS (
    SELECT
        code_module,
        code_presentation,
        SUM(student_count) AS total_students
    FROM outcome_counts
    GROUP BY
        code_module,
        code_presentation
)
SELECT
    oc.code_module,
    oc.code_presentation,
    oc.final_result,
    oc.student_count,
    ROUND(CAST(oc.student_count AS REAL) / NULLIF(pt.total_students, 0), 4) AS percentage_of_presentation
FROM outcome_counts oc
JOIN presentation_totals pt
    ON oc.code_module = pt.code_module
    AND oc.code_presentation = pt.code_presentation;

CREATE VIEW vw_at_risk_student_indicators AS
WITH engagement AS (
    SELECT
        si.code_module,
        si.code_presentation,
        si.id_student,
        si.final_result,
        COALESCE(SUM(sv.sum_click), 0) AS total_clicks
    FROM student_info si
    LEFT JOIN student_vle sv
        ON si.code_module = sv.code_module
        AND si.code_presentation = sv.code_presentation
        AND si.id_student = sv.id_student
    GROUP BY
        si.code_module,
        si.code_presentation,
        si.id_student,
        si.final_result
),
ranked_engagement AS (
    SELECT
        engagement.*,
        ROW_NUMBER() OVER (
            PARTITION BY code_module, code_presentation
            ORDER BY total_clicks
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY code_module, code_presentation
        ) AS cnt
    FROM engagement
),
course_medians AS (
    SELECT
        code_module,
        code_presentation,
        AVG(CAST(total_clicks AS REAL)) AS median_clicks
    FROM ranked_engagement
    WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
    GROUP BY
        code_module,
        code_presentation
),
assessment_rollup AS (
    SELECT
        si.code_module,
        si.code_presentation,
        si.id_student,
        AVG(sa.score) AS avg_score,
        SUM(
            CASE
                WHEN a.id_assessment IS NULL THEN 0
                WHEN a.assessment_type = 'Exam'
                    AND sa.id_student IS NULL THEN 0
                WHEN sa.id_student IS NULL
                    OR sa.score IS NULL
                THEN 1
                ELSE 0
            END
        ) AS missing_assessment_count,
        SUM(
            CASE
                WHEN sa.date_submitted IS NOT NULL
                    AND a.date IS NOT NULL
                    AND sa.date_submitted > a.date
                THEN 1
                ELSE 0
            END
        ) AS late_submission_count
    FROM student_info si
    LEFT JOIN assessments a
        ON si.code_module = a.code_module
        AND si.code_presentation = a.code_presentation
    LEFT JOIN student_assessment sa
        ON a.id_assessment = sa.id_assessment
        AND si.id_student = sa.id_student
    GROUP BY
        si.code_module,
        si.code_presentation,
        si.id_student
),
flagged AS (
    SELECT
        e.code_module,
        e.code_presentation,
        e.id_student,
        e.final_result,
        e.total_clicks,
        ROUND(ar.avg_score, 2) AS avg_score,
        COALESCE(ar.missing_assessment_count, 0) AS missing_assessment_count,
        COALESCE(ar.late_submission_count, 0) AS late_submission_count,
        CASE
            WHEN e.total_clicks = 0
                OR e.total_clicks < COALESCE(cm.median_clicks, 0)
            THEN 1
            ELSE 0
        END AS low_engagement_flag,
        CASE
            WHEN ar.avg_score < 60 THEN 1
            ELSE 0
        END AS low_score_flag,
        CASE
            WHEN COALESCE(ar.missing_assessment_count, 0) > 0 THEN 1
            ELSE 0
        END AS missing_assessment_flag
    FROM engagement e
    LEFT JOIN course_medians cm
        ON e.code_module = cm.code_module
        AND e.code_presentation = cm.code_presentation
    LEFT JOIN assessment_rollup ar
        ON e.code_module = ar.code_module
        AND e.code_presentation = ar.code_presentation
        AND e.id_student = ar.id_student
)
SELECT
    code_module,
    code_presentation,
    id_student,
    final_result,
    total_clicks,
    avg_score,
    missing_assessment_count,
    late_submission_count,
    low_engagement_flag,
    low_score_flag,
    missing_assessment_flag,
    CASE
        WHEN low_engagement_flag = 1
            OR low_score_flag = 1
            OR missing_assessment_flag = 1
        THEN 1
        ELSE 0
    END AS at_risk_indicator,
    (
        low_engagement_flag
        + low_score_flag
        + missing_assessment_flag
    ) AS risk_reason_count,
    CASE
        WHEN low_engagement_flag
            + low_score_flag
            + missing_assessment_flag = 0
        THEN 'No Flag'
        ELSE
            CASE WHEN low_engagement_flag = 1 THEN 'Low Engagement' ELSE '' END
            || CASE
                WHEN low_score_flag = 1
                    AND low_engagement_flag = 1
                THEN '; Low Score'
                WHEN low_score_flag = 1
                THEN 'Low Score'
                ELSE ''
            END
            || CASE
                WHEN missing_assessment_flag = 1
                    AND (low_engagement_flag = 1 OR low_score_flag = 1)
                THEN '; Missing Assessment'
                WHEN missing_assessment_flag = 1
                THEN 'Missing Assessment'
                ELSE ''
            END
    END AS risk_reason_summary
FROM flagged;

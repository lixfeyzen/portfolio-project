-- Duplicate course keys
SELECT
    code_module,
    code_presentation,
    COUNT(*) AS row_count
FROM courses
GROUP BY code_module, code_presentation
HAVING COUNT(*) > 1;

-- Duplicate assessment IDs
SELECT
    id_assessment,
    COUNT(*) AS row_count
FROM assessments
GROUP BY id_assessment
HAVING COUNT(*) > 1;

-- Duplicate studentInfo keys
SELECT
    code_module,
    code_presentation,
    id_student,
    COUNT(*) AS row_count
FROM student_info
GROUP BY code_module, code_presentation, id_student
HAVING COUNT(*) > 1;

-- Duplicate studentRegistration keys
SELECT
    code_module,
    code_presentation,
    id_student,
    COUNT(*) AS row_count
FROM student_registration
GROUP BY code_module, code_presentation, id_student
HAVING COUNT(*) > 1;

-- Invalid assessment scores
SELECT *
FROM student_assessment
WHERE score < 0 OR score > 100;

-- Negative sum_click
SELECT *
FROM student_vle
WHERE sum_click < 0;

-- Missing registration dates
SELECT *
FROM student_registration
WHERE date_registration IS NULL;

-- studentAssessment foreign key issues: missing assessment
SELECT sa.*
FROM student_assessment sa
LEFT JOIN assessments a
    ON sa.id_assessment = a.id_assessment
WHERE a.id_assessment IS NULL;

-- studentAssessment foreign key issues: missing student-course record
SELECT sa.*
FROM student_assessment sa
JOIN assessments a
    ON sa.id_assessment = a.id_assessment
LEFT JOIN student_info si
    ON a.code_module = si.code_module
    AND a.code_presentation = si.code_presentation
    AND sa.id_student = si.id_student
WHERE si.id_student IS NULL;

-- studentVle foreign key issues: missing VLE site
SELECT sv.*
FROM student_vle sv
LEFT JOIN vle v
    ON sv.id_site = v.id_site
WHERE v.id_site IS NULL;

-- studentVle foreign key issues: missing student-course record
SELECT sv.*
FROM student_vle sv
LEFT JOIN student_info si
    ON sv.code_module = si.code_module
    AND sv.code_presentation = si.code_presentation
    AND sv.id_student = si.id_student
WHERE si.id_student IS NULL;

-- Invalid final_result
SELECT *
FROM student_info
WHERE final_result NOT IN ('Pass', 'Fail', 'Withdrawn', 'Distinction');

-- Invalid assessment_type
SELECT *
FROM assessments
WHERE assessment_type NOT IN ('TMA', 'CMA', 'Exam');


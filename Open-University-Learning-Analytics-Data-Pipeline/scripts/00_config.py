from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = PROJECT_ROOT / "data" / "raw"
PROCESSED_DIR = PROJECT_ROOT / "data" / "processed"
OUTPUT_DIR = PROJECT_ROOT / "outputs"
REPORTING_DIR = OUTPUT_DIR / "reporting_tables"
DOCUMENTATION_DIR = PROJECT_ROOT / "documentation"
SQL_DIR = PROJECT_ROOT / "sql"
DB_PATH = OUTPUT_DIR / "oulad_pipeline.db"

STUDENT_VLE_CHUNKSIZE = 100_000

NA_VALUES = ["", "?", "NA", "N/A", "NULL", "null", "None", "none"]

EXPECTED_FILES = {
    "courses": {
        "raw": "courses.csv",
        "processed": "courses.csv",
        "columns": ["code_module", "code_presentation", "module_presentation_length"],
        "key": ["code_module", "code_presentation"],
    },
    "assessments": {
        "raw": "assessments.csv",
        "processed": "assessments.csv",
        "columns": [
            "code_module",
            "code_presentation",
            "id_assessment",
            "assessment_type",
            "date",
            "weight",
        ],
        "key": ["id_assessment"],
    },
    "student_assessment": {
        "raw": "studentAssessment.csv",
        "processed": "student_assessment.csv",
        "columns": ["id_assessment", "id_student", "date_submitted", "is_banked", "score"],
        "key": ["id_assessment", "id_student"],
    },
    "student_info": {
        "raw": "studentInfo.csv",
        "processed": "student_info.csv",
        "columns": [
            "code_module",
            "code_presentation",
            "id_student",
            "gender",
            "region",
            "highest_education",
            "imd_band",
            "age_band",
            "num_of_prev_attempts",
            "studied_credits",
            "disability",
            "final_result",
        ],
        "key": ["code_module", "code_presentation", "id_student"],
    },
    "student_registration": {
        "raw": "studentRegistration.csv",
        "processed": "student_registration.csv",
        "columns": [
            "code_module",
            "code_presentation",
            "id_student",
            "date_registration",
            "date_unregistration",
        ],
        "key": ["code_module", "code_presentation", "id_student"],
    },
    "vle": {
        "raw": "vle.csv",
        "processed": "vle.csv",
        "columns": [
            "id_site",
            "code_module",
            "code_presentation",
            "activity_type",
            "week_from",
            "week_to",
        ],
        "key": ["id_site"],
    },
    "student_vle": {
        "raw": "studentVle.csv",
        "processed": "student_vle.csv",
        "columns": [
            "code_module",
            "code_presentation",
            "id_student",
            "id_site",
            "date",
            "sum_click",
        ],
        "key": [],
    },
}

SMALL_TABLES = [
    "courses",
    "assessments",
    "student_assessment",
    "student_info",
    "student_registration",
    "vle",
]

INTEGER_COLUMNS = {
    "courses": ["module_presentation_length"],
    "assessments": ["id_assessment", "date"],
    "student_assessment": ["id_assessment", "id_student", "date_submitted", "is_banked"],
    "student_info": ["id_student", "num_of_prev_attempts", "studied_credits"],
    "student_registration": ["id_student", "date_registration", "date_unregistration"],
    "vle": ["id_site", "week_from", "week_to"],
    "student_vle": ["id_student", "id_site", "date", "sum_click"],
}

REAL_COLUMNS = {
    "assessments": ["weight"],
    "student_assessment": ["score"],
}

VALID_FINAL_RESULTS = {"Pass", "Fail", "Withdrawn", "Distinction"}
VALID_ASSESSMENT_TYPES = {"TMA", "CMA", "Exam"}


def ensure_directories() -> None:
    for directory in [RAW_DIR, PROCESSED_DIR, OUTPUT_DIR, REPORTING_DIR, DOCUMENTATION_DIR]:
        directory.mkdir(parents=True, exist_ok=True)


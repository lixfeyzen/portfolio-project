from __future__ import annotations

import ast
import csv
import re
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]


REQUIRED_PATHS = [
    "README.md",
    "RUNNING.md",
    "VERIFY_PROJECT.md",
    "project_brief.md",
    "requirements.txt",
    ".gitignore",
    ".github/workflows/validate-reporting-outputs.yml",
    "assets/sqlite_database_preview.png",
    "documentation/pipeline_run_summary.md",
    "documentation/validation_summary.md",
    "documentation/reporting_output_quality_summary.md",
    "documentation/data_model.md",
    "documentation/dataset_source.md",
    "scripts/00_config.py",
    "scripts/01_extract_sources.py",
    "scripts/02_clean_transform.py",
    "scripts/03_validate_data.py",
    "scripts/04_load_to_sqlite.py",
    "scripts/05_export_reporting_tables.py",
    "scripts/07_validate_reporting_outputs.py",
    "scripts/run_pipeline.py",
    "sql/create_tables.sql",
    "sql/reporting_views.sql",
    "sql/validation_queries.sql",
]


EXPECTED_OUTPUTS = {
    "course_registration_summary.csv": (
        22,
        {"code_module", "code_presentation", "total_students", "withdrawal_rate", "pass_rate"},
    ),
    "student_engagement_summary.csv": (
        32593,
        {"code_module", "code_presentation", "id_student", "total_clicks", "engagement_bucket"},
    ),
    "assessment_performance_summary.csv": (
        57,
        {"code_module", "code_presentation", "assessment_type", "submission_count", "late_submission_rate"},
    ),
    "vle_activity_summary.csv": (
        232,
        {"code_module", "code_presentation", "activity_type", "total_clicks"},
    ),
    "student_outcome_summary.csv": (
        88,
        {"code_module", "code_presentation", "final_result", "student_count"},
    ),
    "at_risk_student_indicators.csv": (
        32593,
        {"code_module", "code_presentation", "id_student", "at_risk_indicator", "risk_reason_summary"},
    ),
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def check_required_paths() -> None:
    for relative_path in REQUIRED_PATHS:
        path = PROJECT_ROOT / relative_path
        require(path.exists(), f"Missing required path: {relative_path}")


def check_python_syntax() -> None:
    for path in sorted((PROJECT_ROOT / "scripts").glob("*.py")):
        ast.parse(path.read_text(encoding="utf-8"), filename=str(path))


def check_reporting_outputs() -> None:
    reporting_dir = PROJECT_ROOT / "outputs" / "reporting_tables"

    for file_name, (expected_rows, required_columns) in EXPECTED_OUTPUTS.items():
        path = reporting_dir / file_name
        require(path.exists(), f"Missing reporting output: {file_name}")

        with path.open(newline="", encoding="utf-8") as file:
            reader = csv.reader(file)
            header = next(reader)
            row_count = sum(1 for _ in reader)

        missing_columns = sorted(required_columns - set(header))
        require(not missing_columns, f"{file_name} missing columns: {missing_columns}")
        require(
            row_count == expected_rows,
            f"{file_name} row count mismatch: expected {expected_rows}, found {row_count}",
        )


def check_readme_asset_links() -> None:
    readme = (PROJECT_ROOT / "README.md").read_text(encoding="utf-8")
    links = []
    links.extend(match.group(1) for match in re.finditer(r'(?:src|href)="([^"]+)"', readme))
    links.extend(match.group(1) for match in re.finditer(r"\]\((assets/[^)]+)\)", readme))

    preview_links = [link for link in links if "sqlite_database_preview.png" in link]
    require(preview_links, "README does not reference sqlite_database_preview.png")

    for link in preview_links:
        path = PROJECT_ROOT / link
        require(path.exists(), f"README references missing asset: {link}")


def check_png_signature() -> None:
    path = PROJECT_ROOT / "assets" / "sqlite_database_preview.png"
    signature = path.read_bytes()[:8]
    require(signature == b"\x89PNG\r\n\x1a\n", "sqlite_database_preview.png is not a valid PNG file")


def check_documented_quality_results() -> None:
    reporting_summary = (PROJECT_ROOT / "documentation" / "reporting_output_quality_summary.md").read_text(
        encoding="utf-8"
    )
    validation_summary = (PROJECT_ROOT / "documentation" / "validation_summary.md").read_text(encoding="utf-8")

    require("Failed checks: `0`" in reporting_summary, "Reporting output quality summary has failed checks")
    require("Total blocking issue count: `0`" in validation_summary, "Validation summary has blocking issues")


def main() -> None:
    check_required_paths()
    check_python_syntax()
    check_reporting_outputs()
    check_readme_asset_links()
    check_png_signature()
    check_documented_quality_results()
    print("Project verification passed.")


if __name__ == "__main__":
    main()

from __future__ import annotations

import argparse
import importlib.util
from datetime import datetime, timezone
from pathlib import Path

import pandas as pd


def load_config():
    config_path = Path(__file__).with_name("00_config.py")
    spec = importlib.util.spec_from_file_location("pipeline_config", config_path)
    config = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(config)
    return config


config = load_config()

REQUIRED_OUTPUTS = {
    "course_registration_summary.csv": {
        "required_columns": ["code_module", "code_presentation", "total_students", "withdrawal_rate", "pass_rate"],
        "min_rows": 1,
    },
    "student_engagement_summary.csv": {
        "required_columns": ["code_module", "code_presentation", "id_student", "total_clicks", "engagement_bucket"],
        "min_rows": 1,
    },
    "assessment_performance_summary.csv": {
        "required_columns": ["code_module", "code_presentation", "assessment_type", "submission_count", "late_submission_rate"],
        "min_rows": 1,
    },
    "vle_activity_summary.csv": {
        "required_columns": ["code_module", "code_presentation", "activity_type", "total_clicks"],
        "min_rows": 1,
    },
    "student_outcome_summary.csv": {
        "required_columns": ["code_module", "code_presentation", "final_result", "student_count"],
        "min_rows": 1,
    },
    "at_risk_student_indicators.csv": {
        "required_columns": ["code_module", "code_presentation", "id_student", "at_risk_indicator", "risk_reason_summary"],
        "min_rows": 1,
    },
}


def add_result(results: list[dict[str, str | int]], check: str, status: str, detail: str) -> None:
    results.append({"check": check, "status": status, "detail": detail})


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate included reporting output CSV files.")
    parser.add_argument(
        "--check-only",
        action="store_true",
        help="Run checks without rewriting documentation/reporting_output_quality_summary.md.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    config.ensure_directories()
    results: list[dict[str, str | int]] = []

    loaded_outputs: dict[str, pd.DataFrame] = {}
    for file_name, rules in REQUIRED_OUTPUTS.items():
        path = config.REPORTING_DIR / file_name
        if not path.exists():
            add_result(results, f"{file_name} exists", "fail", "Missing reporting output.")
            continue

        df = pd.read_csv(path)
        loaded_outputs[file_name] = df
        add_result(results, f"{file_name} exists", "pass", f"{len(df):,} rows found.")

        if len(df) >= int(rules["min_rows"]):
            add_result(results, f"{file_name} row count", "pass", f"{len(df):,} rows.")
        else:
            add_result(results, f"{file_name} row count", "fail", "Output is empty.")

        missing_columns = [column for column in rules["required_columns"] if column not in df.columns]
        if missing_columns:
            add_result(results, f"{file_name} required columns", "fail", f"Missing columns: {missing_columns}")
        else:
            add_result(results, f"{file_name} required columns", "pass", "All required columns are present.")

    course = loaded_outputs.get("course_registration_summary.csv")
    if course is not None:
        for metric in ["withdrawal_rate", "pass_rate"]:
            values = pd.to_numeric(course[metric], errors="coerce")
            invalid_count = int(((values < 0) | (values > 1)).sum())
            status = "pass" if invalid_count == 0 else "fail"
            add_result(results, f"{metric} between 0 and 1", status, f"{invalid_count} invalid rows.")

    risk = loaded_outputs.get("at_risk_student_indicators.csv")
    if risk is not None:
        values = {
            int(value)
            for value in pd.to_numeric(risk["at_risk_indicator"], errors="coerce")
            .dropna()
            .astype(int)
            .unique()
        }
        status = "pass" if values.issubset({0, 1}) else "fail"
        add_result(results, "at_risk_indicator binary", status, f"Observed values: {sorted(values)}")

    generated_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    fail_count = sum(1 for result in results if result["status"] == "fail")

    lines = [
        "# Reporting Output Quality Summary",
        "",
        f"Generated at: `{generated_at}`",
        "",
        f"Failed checks: `{fail_count}`",
        "",
        "| Check | Status | Detail |",
        "|---|---|---|",
    ]
    for result in results:
        lines.append(f"| {result['check']} | {result['status']} | {result['detail']} |")

    output_path = config.DOCUMENTATION_DIR / "reporting_output_quality_summary.md"
    if not args.check_only:
        output_path.write_text("\n".join(lines), encoding="utf-8")

    if fail_count:
        raise SystemExit(f"Reporting output quality gate failed with {fail_count} failed check(s).")

    print(f"Reporting output quality gate passed with {len(results):,} checks.")
    if args.check_only:
        print("Check-only mode used; summary file was not rewritten.")
    else:
        print(f"Summary written to: {output_path}")


if __name__ == "__main__":
    main()

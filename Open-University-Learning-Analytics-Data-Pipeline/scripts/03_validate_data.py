from __future__ import annotations

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


def read_processed(table_name: str) -> pd.DataFrame:
    path = config.PROCESSED_DIR / config.EXPECTED_FILES[table_name]["processed"]
    if not path.exists():
        raise FileNotFoundError(f"Processed file not found: {path}. Run 02_clean_transform.py first.")
    return pd.read_csv(path, na_values=config.NA_VALUES, keep_default_na=True, low_memory=False)


def duplicate_count(df: pd.DataFrame, columns: list[str]) -> int:
    if not columns:
        return 0
    return int(df.duplicated(subset=columns, keep=False).sum())


def missing_critical_id_count(df: pd.DataFrame, columns: list[str]) -> int:
    if not columns:
        return 0
    return int(df[columns].isna().any(axis=1).sum())


def anti_join_row_count(left: pd.DataFrame, right: pd.DataFrame, on: list[str]) -> int:
    merged = left.merge(right[on].drop_duplicates(), on=on, how="left", indicator=True)
    return int((merged["_merge"] == "left_only").sum())


def add_issue(issues: list[dict[str, str | int]], check: str, count: int, severity: str, note: str) -> None:
    issues.append({"check": check, "count": int(count), "severity": severity, "note": note})


def validate_student_vle(
    student_info: pd.DataFrame,
    vle: pd.DataFrame,
) -> dict[str, int]:
    path = config.PROCESSED_DIR / config.EXPECTED_FILES["student_vle"]["processed"]
    if not path.exists():
        raise FileNotFoundError(f"Processed student_vle file not found: {path}")

    valid_site_ids = set(vle["id_site"].dropna().astype(int).tolist())
    valid_student_keys = set(
        student_info[["code_module", "code_presentation", "id_student"]]
        .dropna()
        .itertuples(index=False, name=None)
    )

    metrics = {
        "rows": 0,
        "missing_critical_ids": 0,
        "invalid_site_id": 0,
        "missing_student_info_match": 0,
        "negative_sum_click": 0,
    }

    for chunk in pd.read_csv(
        path,
        na_values=config.NA_VALUES,
        keep_default_na=True,
        chunksize=config.STUDENT_VLE_CHUNKSIZE,
        low_memory=False,
    ):
        metrics["rows"] += len(chunk)
        critical = ["code_module", "code_presentation", "id_student", "id_site"]
        metrics["missing_critical_ids"] += missing_critical_id_count(chunk, critical)
        metrics["invalid_site_id"] += int((~chunk["id_site"].isin(valid_site_ids)).sum())
        chunk_keys = chunk[["code_module", "code_presentation", "id_student"]].itertuples(
            index=False, name=None
        )
        metrics["missing_student_info_match"] += sum(
            1 for key in chunk_keys if key not in valid_student_keys
        )
        metrics["negative_sum_click"] += int((pd.to_numeric(chunk["sum_click"], errors="coerce") < 0).sum())

    return metrics


def main() -> None:
    config.ensure_directories()

    courses = read_processed("courses")
    assessments = read_processed("assessments")
    student_assessment = read_processed("student_assessment")
    student_info = read_processed("student_info")
    student_registration = read_processed("student_registration")
    vle = read_processed("vle")

    row_counts = {
        "courses": len(courses),
        "assessments": len(assessments),
        "student_assessment": len(student_assessment),
        "student_info": len(student_info),
        "student_registration": len(student_registration),
        "vle": len(vle),
    }

    issues: list[dict[str, str | int]] = []

    for table_name, df in [
        ("courses", courses),
        ("assessments", assessments),
        ("student_assessment", student_assessment),
        ("student_info", student_info),
        ("student_registration", student_registration),
        ("vle", vle),
    ]:
        key_columns = config.EXPECTED_FILES[table_name]["key"]
        add_issue(
            issues,
            f"{table_name} missing critical ID/key fields",
            missing_critical_id_count(df, key_columns),
            "blocking",
            "Critical IDs are required for loading and relationship checks.",
        )
        add_issue(
            issues,
            f"{table_name} duplicate key combinations",
            duplicate_count(df, key_columns),
            "blocking",
            "Duplicate business keys can create double-counted reporting rows.",
        )

    add_issue(
        issues,
        "assessments without valid course",
        anti_join_row_count(assessments, courses, ["code_module", "code_presentation"]),
        "blocking",
        "Assessments should map to a course presentation.",
    )

    add_issue(
        issues,
        "student_assessment without valid assessment_id",
        anti_join_row_count(student_assessment, assessments, ["id_assessment"]),
        "blocking",
        "Student assessment rows should map to an assessment.",
    )

    assessment_context = assessments[["id_assessment", "code_module", "code_presentation"]]
    student_assessment_context = student_assessment.merge(
        assessment_context, on="id_assessment", how="left"
    )
    add_issue(
        issues,
        "student_assessment without matching student_info",
        anti_join_row_count(
            student_assessment_context.dropna(subset=["code_module", "code_presentation"]),
            student_info,
            ["code_module", "code_presentation", "id_student"],
        ),
        "blocking",
        "Assessment submissions should map to a student-course record.",
    )

    add_issue(
        issues,
        "student_registration without matching student_info",
        anti_join_row_count(
            student_registration,
            student_info,
            ["code_module", "code_presentation", "id_student"],
        ),
        "blocking",
        "Registration records should map to a student-course record.",
    )

    score = pd.to_numeric(student_assessment["score"], errors="coerce")
    add_issue(
        issues,
        "score outside 0-100",
        int(((score < 0) | (score > 100)).sum()),
        "blocking",
        "Assessment scores should stay within the expected OULAD range.",
    )
    add_issue(
        issues,
        "missing assessment score",
        int(score.isna().sum()),
        "non-blocking",
        "Missing scores affect assessment reporting and should remain visible.",
    )

    invalid_final_result = ~student_info["final_result"].isin(config.VALID_FINAL_RESULTS)
    add_issue(
        issues,
        "invalid final_result categories",
        int(invalid_final_result.sum()),
        "blocking",
        "Final result categories should match the documented OULAD values.",
    )

    invalid_assessment_type = ~assessments["assessment_type"].isin(config.VALID_ASSESSMENT_TYPES)
    add_issue(
        issues,
        "invalid assessment_type categories",
        int(invalid_assessment_type.sum()),
        "blocking",
        "Assessment type categories should match the documented OULAD values.",
    )

    add_issue(
        issues,
        "missing date_registration",
        int(student_registration["date_registration"].isna().sum()),
        "non-blocking",
        "Registration day offsets can be missing in the public dataset and should be reported.",
    )

    add_issue(
        issues,
        "missing imd_band",
        int(student_info["imd_band"].isna().sum()),
        "non-blocking",
        "Missing demographic bands should be tracked for reporting interpretation.",
    )

    registration_context = student_registration.merge(
        student_info[["code_module", "code_presentation", "id_student", "final_result"]],
        on=["code_module", "code_presentation", "id_student"],
        how="left",
    )
    date_registration = pd.to_numeric(registration_context["date_registration"], errors="coerce")
    date_unregistration = pd.to_numeric(registration_context["date_unregistration"], errors="coerce")
    add_issue(
        issues,
        "date_unregistration before date_registration",
        int(((date_unregistration.notna()) & (date_registration.notna()) & (date_unregistration < date_registration)).sum()),
        "blocking",
        "Unregistration should not occur before registration.",
    )
    add_issue(
        issues,
        "withdrawn students without date_unregistration",
        int(((registration_context["final_result"] == "Withdrawn") & (date_unregistration.isna())).sum()),
        "non-blocking",
        "Withdrawal outcome should usually have an unregistration day offset.",
    )
    add_issue(
        issues,
        "date_unregistration present but final_result is not Withdrawn",
        int(((registration_context["final_result"] != "Withdrawn") & (date_unregistration.notna())).sum()),
        "non-blocking",
        "This pattern may need business interpretation before reporting.",
    )

    student_vle_metrics = validate_student_vle(student_info, vle)
    row_counts["student_vle"] = student_vle_metrics["rows"]
    add_issue(
        issues,
        "student_vle missing critical ID fields",
        student_vle_metrics["missing_critical_ids"],
        "blocking",
        "Student VLE activity requires course, presentation, student, and site identifiers.",
    )
    add_issue(
        issues,
        "student_vle without valid id_site",
        student_vle_metrics["invalid_site_id"],
        "blocking",
        "Student VLE rows should map to valid VLE sites.",
    )
    add_issue(
        issues,
        "student_vle without matching student_info",
        student_vle_metrics["missing_student_info_match"],
        "blocking",
        "Student VLE rows should map to a student-course record.",
    )
    add_issue(
        issues,
        "negative sum_click",
        student_vle_metrics["negative_sum_click"],
        "blocking",
        "Click counts should not be negative.",
    )

    generated_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    blocking_issue_count = sum(
        int(issue["count"]) for issue in issues if issue["severity"] == "blocking"
    )

    lines = [
        "# Validation Summary",
        "",
        f"Validation timestamp: `{generated_at}`",
        "",
        "## Row Counts",
        "",
        "| Table | Rows |",
        "|---|---:|",
    ]
    for table_name, count in row_counts.items():
        lines.append(f"| {table_name} | {count} |")

    lines.extend(
        [
            "",
            "## Issue Counts",
            "",
            "| Check | Count | Severity | Interpretation |",
            "|---|---:|---|---|",
        ]
    )
    for issue in issues:
        lines.append(
            f"| {issue['check']} | {issue['count']} | {issue['severity']} | {issue['note']} |"
        )

    lines.extend(
        [
            "",
            "## Interpretation Notes",
            "",
            f"- Total blocking issue count: `{blocking_issue_count}`.",
            "- Blocking issues indicate problems that can break trusted joins, table keys, or core reporting logic.",
            "- Non-blocking issues can still affect interpretation and should be visible to BI users.",
            "- OULAD day fields are relative offsets and are not converted to calendar dates.",
            "- The risk indicator reporting is rule-based and is not predictive machine learning.",
        ]
    )

    output_path = config.DOCUMENTATION_DIR / "validation_summary.md"
    output_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Validation summary written to: {output_path}")


if __name__ == "__main__":
    main()

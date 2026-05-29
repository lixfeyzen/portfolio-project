from __future__ import annotations

import importlib.util
import re
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


def normalize_column_name(column: str) -> str:
    name = column.strip()
    name = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", name)
    name = name.replace(" ", "_").replace("-", "_")
    name = re.sub(r"_+", "_", name)
    return name.lower()


def standardize_category(series: pd.Series, mapping: dict[str, str]) -> pd.Series:
    def convert(value):
        if pd.isna(value):
            return pd.NA
        normalized = str(value).strip().lower()
        return mapping.get(normalized, str(value).strip())

    return series.map(convert).astype("string")


def trim_string_columns(df: pd.DataFrame) -> pd.DataFrame:
    for column in df.select_dtypes(include=["object", "string"]).columns:
        df[column] = df[column].astype("string").str.strip()
        df[column] = df[column].replace({"": pd.NA})
    return df


def apply_type_conversions(df: pd.DataFrame, table_name: str) -> pd.DataFrame:
    for column in config.INTEGER_COLUMNS.get(table_name, []):
        if column in df.columns:
            df[column] = pd.to_numeric(df[column], errors="coerce").astype("Int64")

    for column in config.REAL_COLUMNS.get(table_name, []):
        if column in df.columns:
            df[column] = pd.to_numeric(df[column], errors="coerce")

    return df


def standardize_categoricals(df: pd.DataFrame) -> pd.DataFrame:
    if "code_module" in df.columns:
        df["code_module"] = df["code_module"].astype("string").str.strip().str.upper()
    if "code_presentation" in df.columns:
        df["code_presentation"] = df["code_presentation"].astype("string").str.strip().str.upper()
    if "gender" in df.columns:
        df["gender"] = df["gender"].astype("string").str.strip().str.upper()
    if "disability" in df.columns:
        df["disability"] = df["disability"].astype("string").str.strip().str.upper()
    if "final_result" in df.columns:
        df["final_result"] = standardize_category(
            df["final_result"],
            {
                "pass": "Pass",
                "fail": "Fail",
                "withdrawn": "Withdrawn",
                "distinction": "Distinction",
            },
        )
    if "assessment_type" in df.columns:
        df["assessment_type"] = standardize_category(
            df["assessment_type"],
            {
                "tma": "TMA",
                "cma": "CMA",
                "exam": "Exam",
            },
        )
    return df


def clean_dataframe(df: pd.DataFrame, table_name: str, drop_key_duplicates: bool) -> tuple[pd.DataFrame, int]:
    expected_columns = config.EXPECTED_FILES[table_name]["columns"]
    key_columns = config.EXPECTED_FILES[table_name]["key"]

    df = df.copy()
    df.columns = [normalize_column_name(column) for column in df.columns]

    missing_columns = [column for column in expected_columns if column not in df.columns]
    if missing_columns:
        raise ValueError(
            f"{table_name} is missing expected column(s) after normalization: {missing_columns}"
        )

    df = df[expected_columns]
    df = trim_string_columns(df)
    df = standardize_categoricals(df)
    df = apply_type_conversions(df, table_name)

    duplicates_removed = 0
    if drop_key_duplicates and key_columns:
        before = len(df)
        df = df.drop_duplicates(subset=key_columns, keep="first")
        duplicates_removed = before - len(df)

    return df, duplicates_removed


def clean_small_tables() -> list[dict[str, int | str]]:
    summary = []
    for table_name in config.SMALL_TABLES:
        details = config.EXPECTED_FILES[table_name]
        raw_path = config.RAW_DIR / details["raw"]
        processed_path = config.PROCESSED_DIR / details["processed"]

        df = pd.read_csv(
            raw_path,
            na_values=config.NA_VALUES,
            keep_default_na=True,
            low_memory=False,
        )
        cleaned, duplicates_removed = clean_dataframe(df, table_name, drop_key_duplicates=True)
        cleaned.to_csv(processed_path, index=False)

        summary.append(
            {
                "table": table_name,
                "input_rows": len(df),
                "output_rows": len(cleaned),
                "duplicates_removed": duplicates_removed,
            }
        )
        print(
            f"{table_name}: {len(df):,} input rows, {len(cleaned):,} output rows, "
            f"{duplicates_removed:,} duplicate key rows removed"
        )

    return summary


def clean_student_vle() -> dict[str, int | str]:
    table_name = "student_vle"
    details = config.EXPECTED_FILES[table_name]
    raw_path = config.RAW_DIR / details["raw"]
    processed_path = config.PROCESSED_DIR / details["processed"]

    input_rows = 0
    output_rows = 0
    first_chunk = True

    for chunk_number, chunk in enumerate(
        pd.read_csv(
            raw_path,
            na_values=config.NA_VALUES,
            keep_default_na=True,
            chunksize=config.STUDENT_VLE_CHUNKSIZE,
            low_memory=False,
        ),
        start=1,
    ):
        input_rows += len(chunk)
        cleaned_chunk, _ = clean_dataframe(chunk, table_name, drop_key_duplicates=False)
        output_rows += len(cleaned_chunk)
        cleaned_chunk.to_csv(
            processed_path,
            index=False,
            mode="w" if first_chunk else "a",
            header=first_chunk,
        )
        first_chunk = False

        if chunk_number == 1 or chunk_number % 25 == 0:
            print(f"student_vle chunk {chunk_number}: processed {input_rows:,} rows")

    print(f"student_vle: {input_rows:,} input rows, {output_rows:,} output rows")
    return {
        "table": table_name,
        "input_rows": input_rows,
        "output_rows": output_rows,
        "duplicates_removed": 0,
    }


def write_transformation_summary(summary: list[dict[str, int | str]]) -> None:
    generated_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    lines = [
        "# Transformation Summary",
        "",
        f"Generated at: `{generated_at}`",
        "",
        "| Table | Input Rows | Output Rows | Duplicate Key Rows Removed |",
        "|---|---:|---:|---:|",
    ]
    for row in summary:
        lines.append(
            f"| {row['table']} | {row['input_rows']} | {row['output_rows']} | "
            f"{row['duplicates_removed']} |"
        )
    lines.extend(
        [
            "",
            "Notes:",
            "",
            "- OULAD relative date fields are preserved as nullable integer day offsets.",
            "- `student_vle` is processed in chunks and repeated activity rows are preserved.",
            "- Duplicate key removal is applied only to tables with defined business keys.",
        ]
    )
    (config.DOCUMENTATION_DIR / "transformation_summary.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )


def main() -> None:
    config.ensure_directories()
    summary = clean_small_tables()
    summary.append(clean_student_vle())
    write_transformation_summary(summary)
    print("Transformation summary written.")


if __name__ == "__main__":
    main()


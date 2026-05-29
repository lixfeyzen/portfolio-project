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


def project_relative_display(path: Path) -> str:
    relative = path.relative_to(config.PROJECT_ROOT).as_posix()
    return f"{relative}/" if path.is_dir() else relative


def count_csv_rows(path: Path) -> int:
    with path.open("rb") as file:
        line_count = sum(1 for _ in file)
    return max(line_count - 1, 0)


def file_size_mb(path: Path) -> float:
    return round(path.stat().st_size / (1024 * 1024), 2)


def main() -> None:
    config.ensure_directories()
    raw_dir_display = project_relative_display(config.RAW_DIR)

    missing = []
    for table_name, details in config.EXPECTED_FILES.items():
        raw_path = config.RAW_DIR / details["raw"]
        if not raw_path.exists():
            missing.append(details["raw"])

    if missing:
        message_lines = [
            "Missing required OULAD raw CSV file(s):",
            *[f"- {file_name}" for file_name in missing],
            "",
            f"Place all expected OULAD CSV files in: {raw_dir_display}",
            "Download source: https://analyse.kmi.open.ac.uk/open_dataset",
        ]
        if "studentVle.csv" in missing:
            message_lines.append(
                "studentVle.csv is required for full student engagement and VLE activity reporting."
            )
        raise FileNotFoundError("\n".join(message_lines))

    summary_rows = []
    for table_name, details in config.EXPECTED_FILES.items():
        raw_path = config.RAW_DIR / details["raw"]
        columns = list(pd.read_csv(raw_path, nrows=0).columns)
        row_count = count_csv_rows(raw_path)
        size_mb = file_size_mb(raw_path)

        expected_columns = details["columns"]
        normalized_columns = [column.strip() for column in columns]

        summary_rows.append(
            {
                "table": table_name,
                "file": details["raw"],
                "rows": row_count,
                "columns": columns,
                "size_mb": size_mb,
                "expected_columns": expected_columns,
                "column_count_matches": len(normalized_columns) == len(expected_columns),
            }
        )

        print(f"{details['raw']}: {row_count:,} rows, {len(columns)} columns, {size_mb} MB")
        print(f"  columns: {', '.join(columns)}")

    summary_path = config.DOCUMENTATION_DIR / "extraction_summary.md"
    generated_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    lines = [
        "# Extraction Summary",
        "",
        f"Generated at: `{generated_at}`",
        "",
        "Raw data folder:",
        "",
        f"```text\n{raw_dir_display}\n```",
        "",
        "Raw OULAD files are stored locally in data/raw/ and are excluded from Git.",
        "",
        "| Table | File | Rows | Columns | Size MB | Column Count Matches |",
        "|---|---|---:|---:|---:|---|",
    ]
    for row in summary_rows:
        lines.append(
            f"| {row['table']} | {row['file']} | {row['rows']} | "
            f"{len(row['columns'])} | {row['size_mb']} | {row['column_count_matches']} |"
        )

    lines.extend(["", "## Column Details", ""])
    for row in summary_rows:
        lines.extend(
            [
                f"### {row['file']}",
                "",
                "Columns:",
                "",
                *[f"- `{column}`" for column in row["columns"]],
                "",
            ]
        )

    summary_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Extraction summary written to: {project_relative_display(summary_path)}")


if __name__ == "__main__":
    main()

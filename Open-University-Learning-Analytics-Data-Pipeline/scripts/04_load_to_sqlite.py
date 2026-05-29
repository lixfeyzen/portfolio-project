from __future__ import annotations

import importlib.util
import sqlite3
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


INDEX_SQL = """
CREATE INDEX IF NOT EXISTS idx_student_info_course_student
ON student_info(code_module, code_presentation, id_student);

CREATE INDEX IF NOT EXISTS idx_student_registration_course_student
ON student_registration(code_module, code_presentation, id_student);

CREATE INDEX IF NOT EXISTS idx_assessments_id
ON assessments(id_assessment);

CREATE INDEX IF NOT EXISTS idx_student_assessment_assessment_student
ON student_assessment(id_assessment, id_student);

CREATE INDEX IF NOT EXISTS idx_vle_site
ON vle(id_site);

CREATE INDEX IF NOT EXISTS idx_student_vle_course_student
ON student_vle(code_module, code_presentation, id_student);

CREATE INDEX IF NOT EXISTS idx_student_vle_site
ON student_vle(id_site);
"""


def load_small_table(conn: sqlite3.Connection, table_name: str) -> int:
    path = config.PROCESSED_DIR / config.EXPECTED_FILES[table_name]["processed"]
    if not path.exists():
        raise FileNotFoundError(f"Processed file not found: {path}. Run 02_clean_transform.py first.")
    df = pd.read_csv(path, na_values=config.NA_VALUES, keep_default_na=True, low_memory=False)
    df.to_sql(table_name, conn, if_exists="append", index=False)
    return len(df)


def load_student_vle(conn: sqlite3.Connection) -> int:
    table_name = "student_vle"
    path = config.PROCESSED_DIR / config.EXPECTED_FILES[table_name]["processed"]
    if not path.exists():
        raise FileNotFoundError(f"Processed file not found: {path}. Run 02_clean_transform.py first.")

    total_rows = 0
    for chunk_number, chunk in enumerate(
        pd.read_csv(
            path,
            na_values=config.NA_VALUES,
            keep_default_na=True,
            chunksize=config.STUDENT_VLE_CHUNKSIZE,
            low_memory=False,
        ),
        start=1,
    ):
        chunk.to_sql(table_name, conn, if_exists="append", index=False)
        total_rows += len(chunk)
        if chunk_number == 1 or chunk_number % 25 == 0:
            print(f"student_vle load chunk {chunk_number}: loaded {total_rows:,} rows")
    return total_rows


def assert_foreign_key_integrity(conn: sqlite3.Connection) -> None:
    violations = conn.execute("PRAGMA foreign_key_check").fetchall()
    if violations:
        raise RuntimeError(f"SQLite foreign key check failed: {violations[:10]}")
    print("SQLite foreign key check passed.")


def main() -> None:
    config.ensure_directories()
    create_tables_sql = (config.SQL_DIR / "create_tables.sql").read_text(encoding="utf-8")

    with sqlite3.connect(config.DB_PATH) as conn:
        conn.execute("PRAGMA foreign_keys = ON;")
        conn.executescript(create_tables_sql)
        conn.commit()

        loaded_counts = {}
        for table_name in config.SMALL_TABLES:
            loaded_counts[table_name] = load_small_table(conn, table_name)
            print(f"{table_name}: loaded {loaded_counts[table_name]:,} rows")

        loaded_counts["student_vle"] = load_student_vle(conn)
        print(f"student_vle: loaded {loaded_counts['student_vle']:,} rows")

        assert_foreign_key_integrity(conn)

        conn.executescript(INDEX_SQL)
        conn.commit()

        print("SQLite database created at:", config.DB_PATH)
        print("Loaded row counts:")
        for table_name, count in loaded_counts.items():
            print(f"- {table_name}: {count:,}")


if __name__ == "__main__":
    main()

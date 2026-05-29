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


REPORTING_EXPORTS = {
    "vw_course_registration_summary": "course_registration_summary.csv",
    "vw_student_engagement_summary": "student_engagement_summary.csv",
    "vw_assessment_performance_summary": "assessment_performance_summary.csv",
    "vw_vle_activity_summary": "vle_activity_summary.csv",
    "vw_student_outcome_summary": "student_outcome_summary.csv",
    "vw_at_risk_student_indicators": "at_risk_student_indicators.csv",
}


def main() -> None:
    config.ensure_directories()
    if not config.DB_PATH.exists():
        raise FileNotFoundError(f"SQLite database not found: {config.DB_PATH}. Run 04_load_to_sqlite.py first.")

    reporting_sql = (config.SQL_DIR / "reporting_views.sql").read_text(encoding="utf-8")

    with sqlite3.connect(config.DB_PATH) as conn:
        conn.executescript(reporting_sql)
        conn.commit()

        for view_name, file_name in REPORTING_EXPORTS.items():
            output_path = config.REPORTING_DIR / file_name
            df = pd.read_sql_query(f"SELECT * FROM {view_name}", conn)
            df.to_csv(output_path, index=False)
            size_mb = output_path.stat().st_size / (1024 * 1024)
            print(f"{file_name}: exported {len(df):,} rows ({size_mb:.2f} MB)")


if __name__ == "__main__":
    main()


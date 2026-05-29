"""
Documentation-level Airflow DAG mock for the OULAD pipeline.

This file intentionally does not import Airflow. It shows the intended task
order for portfolio documentation without requiring Airflow to run locally.
"""

from dataclasses import dataclass


@dataclass(frozen=True)
class MockTask:
    task_id: str
    script: str


TASK_ORDER = [
    MockTask("extract_sources", "scripts/01_extract_sources.py"),
    MockTask("clean_transform", "scripts/02_clean_transform.py"),
    MockTask("validate_data", "scripts/03_validate_data.py"),
    MockTask("load_to_sqlite", "scripts/04_load_to_sqlite.py"),
    MockTask("export_reporting_tables", "scripts/05_export_reporting_tables.py"),
]


def describe_dag() -> str:
    lines = ["OULAD learning analytics pipeline task order:"]
    for index, task in enumerate(TASK_ORDER, start=1):
        lines.append(f"{index}. {task.task_id} -> {task.script}")
    return "\n".join(lines)


if __name__ == "__main__":
    print(describe_dag())


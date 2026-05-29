from __future__ import annotations

import subprocess
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent

PIPELINE_STEPS = [
    "01_extract_sources.py",
    "02_clean_transform.py",
    "03_validate_data.py",
    "04_load_to_sqlite.py",
    "05_export_reporting_tables.py",
]


def main() -> None:
    print("Starting OULAD data pipeline...")
    for step in PIPELINE_STEPS:
        script_path = SCRIPT_DIR / step
        print(f"\n=== Running {step} ===")
        subprocess.run([sys.executable, str(script_path)], check=True)
    print("\nOULAD data pipeline completed successfully.")


if __name__ == "__main__":
    main()


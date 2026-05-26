"""
Profile the Olist CSV files for the marketplace reliability project.

The script uses only Python standard library modules. It reads the expected CSV
files, validates headers, counts rows, profiles missing values, captures basic
date ranges, and writes documentation/data_profile_summary.md.
"""

from __future__ import annotations

import argparse
import csv
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Iterable


EXPECTED_SCHEMAS = {
    "olist_customers_dataset.csv": [
        "customer_id",
        "customer_unique_id",
        "customer_zip_code_prefix",
        "customer_city",
        "customer_state",
    ],
    "olist_geolocation_dataset.csv": [
        "geolocation_zip_code_prefix",
        "geolocation_lat",
        "geolocation_lng",
        "geolocation_city",
        "geolocation_state",
    ],
    "olist_orders_dataset.csv": [
        "order_id",
        "customer_id",
        "order_status",
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "olist_order_items_dataset.csv": [
        "order_id",
        "order_item_id",
        "product_id",
        "seller_id",
        "shipping_limit_date",
        "price",
        "freight_value",
    ],
    "olist_order_payments_dataset.csv": [
        "order_id",
        "payment_sequential",
        "payment_type",
        "payment_installments",
        "payment_value",
    ],
    "olist_order_reviews_dataset.csv": [
        "review_id",
        "order_id",
        "review_score",
        "review_comment_title",
        "review_comment_message",
        "review_creation_date",
        "review_answer_timestamp",
    ],
    "olist_products_dataset.csv": [
        "product_id",
        "product_category_name",
        "product_name_lenght",
        "product_description_lenght",
        "product_photos_qty",
        "product_weight_g",
        "product_length_cm",
        "product_height_cm",
        "product_width_cm",
    ],
    "olist_sellers_dataset.csv": [
        "seller_id",
        "seller_zip_code_prefix",
        "seller_city",
        "seller_state",
    ],
    "product_category_name_translation.csv": [
        "product_category_name",
        "product_category_name_english",
    ],
}

DATE_COLUMNS = {
    "olist_orders_dataset.csv": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "olist_order_items_dataset.csv": ["shipping_limit_date"],
    "olist_order_reviews_dataset.csv": [
        "review_creation_date",
        "review_answer_timestamp",
    ],
}

DOMAIN_COLUMNS = {
    "order_status": ("olist_orders_dataset.csv", "order_status"),
    "payment_type": ("olist_order_payments_dataset.csv", "payment_type"),
    "review_score": ("olist_order_reviews_dataset.csv", "review_score"),
    "customer_state": ("olist_customers_dataset.csv", "customer_state"),
    "seller_state": ("olist_sellers_dataset.csv", "seller_state"),
}


def is_missing(value: str | None) -> bool:
    return value is None or value.strip() == ""


def parse_dt(value: str) -> datetime | None:
    if is_missing(value):
        return None
    text = value.strip()
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d"):
        try:
            return datetime.strptime(text, fmt)
        except ValueError:
            continue
    try:
        return datetime.fromisoformat(text)
    except ValueError:
        return None


def pct(part: int, total: int) -> str:
    if total == 0:
        return "0.00%"
    return f"{part / total:.2%}"


def markdown_table(headers: list[str], rows: Iterable[Iterable[object]]) -> list[str]:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join(["---"] * len(headers)) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(item) for item in row) + " |")
    return lines


def profile_file(path: Path, expected_columns: list[str]) -> dict:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        columns = reader.fieldnames or []
        missing = Counter()
        domains = {name: Counter() for name in columns}
        date_ranges = {
            col: {"min": None, "max": None, "invalid": 0}
            for col in DATE_COLUMNS.get(path.name, [])
        }
        row_count = 0

        for row in reader:
            row_count += 1
            for col in columns:
                value = row.get(col)
                if is_missing(value):
                    missing[col] += 1
                if col in ("order_status", "payment_type", "review_score", "customer_state", "seller_state"):
                    domains[col][value.strip() if value else ""] += 1
            for col, stats in date_ranges.items():
                value = row.get(col)
                if is_missing(value):
                    continue
                parsed = parse_dt(value)
                if parsed is None:
                    stats["invalid"] += 1
                    continue
                if stats["min"] is None or parsed < stats["min"]:
                    stats["min"] = parsed
                if stats["max"] is None or parsed > stats["max"]:
                    stats["max"] = parsed

    return {
        "file_name": path.name,
        "row_count": row_count,
        "columns": columns,
        "expected_columns": expected_columns,
        "schema_match": columns == expected_columns,
        "missing": missing,
        "domains": domains,
        "date_ranges": date_ranges,
    }


def read_csv_rows(path: Path) -> Iterable[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield row


def to_decimal(value: str | None) -> float | None:
    if is_missing(value):
        return None
    try:
        return float(str(value).strip())
    except ValueError:
        return None


def build_quality_prechecks(input_dir: Path) -> list[list[object]]:
    checks: list[list[object]] = []

    orders_path = input_dir / "olist_orders_dataset.csv"
    payments_path = input_dir / "olist_order_payments_dataset.csv"
    reviews_path = input_dir / "olist_order_reviews_dataset.csv"
    items_path = input_dir / "olist_order_items_dataset.csv"
    products_path = input_dir / "olist_products_dataset.csv"
    translations_path = input_dir / "product_category_name_translation.csv"

    order_ids: set[str] = set()
    payment_order_ids: set[str] = set()
    review_order_ids: set[str] = set()
    order_id_counts = Counter()

    delivered_missing_customer_date = 0
    missing_estimated_date = 0
    missing_approved_date = 0
    cancelled_orders = 0
    unavailable_orders = 0
    delivered_before_purchase = 0
    carrier_before_approval = 0
    customer_before_carrier = 0

    if orders_path.exists():
        for row in read_csv_rows(orders_path):
            order_id = row.get("order_id", "")
            if order_id:
                order_ids.add(order_id)
                order_id_counts[order_id] += 1
            status = row.get("order_status", "")
            purchase_dt = parse_dt(row.get("order_purchase_timestamp", ""))
            approved_dt = parse_dt(row.get("order_approved_at", ""))
            carrier_dt = parse_dt(row.get("order_delivered_carrier_date", ""))
            customer_dt = parse_dt(row.get("order_delivered_customer_date", ""))

            if status == "delivered" and is_missing(row.get("order_delivered_customer_date")):
                delivered_missing_customer_date += 1
            if is_missing(row.get("order_estimated_delivery_date")):
                missing_estimated_date += 1
            if is_missing(row.get("order_approved_at")):
                missing_approved_date += 1
            if status == "canceled":
                cancelled_orders += 1
            if status == "unavailable":
                unavailable_orders += 1
            if purchase_dt and customer_dt and customer_dt < purchase_dt:
                delivered_before_purchase += 1
            if approved_dt and carrier_dt and carrier_dt < approved_dt:
                carrier_before_approval += 1
            if carrier_dt and customer_dt and customer_dt < carrier_dt:
                customer_before_carrier += 1

    if payments_path.exists():
        for row in read_csv_rows(payments_path):
            order_id = row.get("order_id", "")
            if order_id:
                payment_order_ids.add(order_id)

    if reviews_path.exists():
        for row in read_csv_rows(reviews_path):
            order_id = row.get("order_id", "")
            if order_id:
                review_order_ids.add(order_id)

    duplicate_orders = sum(1 for count in order_id_counts.values() if count > 1)
    checks.extend(
        [
            ["Delivered orders missing customer delivery date", delivered_missing_customer_date, "Excluded from delivery reliability until reviewed."],
            ["Orders missing estimated delivery date", missing_estimated_date, "Late or on-time status requires an estimated delivery date."],
            ["Orders missing approved date", missing_approved_date, "Useful for fulfillment sequence validation."],
            ["Cancelled orders", cancelled_orders, "Tracked separately from delivered-order reliability."],
            ["Unavailable orders", unavailable_orders, "Tracked separately from delivered-order reliability."],
            ["Orders without payment", len(order_ids - payment_order_ids), "Affects payment coverage and reconciliation."],
            ["Orders without review", len(order_ids - review_order_ids), "Reduces review-score coverage."],
            ["Duplicate order_id values in orders", duplicate_orders, "raw_orders is expected to be one row per order."],
            ["Delivered date before purchase date", delivered_before_purchase, "Invalid delivery sequence."],
            ["Carrier date before approved date", carrier_before_approval, "Invalid fulfillment sequence."],
            ["Customer delivered date before carrier date", customer_before_carrier, "Invalid delivery sequence."],
        ]
    )

    zero_or_negative_price = 0
    negative_freight = 0
    zero_freight = 0
    if items_path.exists():
        for row in read_csv_rows(items_path):
            price = to_decimal(row.get("price"))
            freight = to_decimal(row.get("freight_value"))
            if price is not None and price <= 0:
                zero_or_negative_price += 1
            if freight is not None and freight < 0:
                negative_freight += 1
            if freight is not None and freight == 0:
                zero_freight += 1
    checks.extend(
        [
            ["Zero or negative price rows", zero_or_negative_price, "Product revenue expects positive item price values."],
            ["Negative freight rows", negative_freight, "Negative freight is invalid and should be investigated."],
            ["Zero freight rows", zero_freight, "Zero freight may represent free shipping or no freight charged; requires review and is not automatically invalid."],
        ]
    )

    negative_payment = 0
    zero_payment = 0
    if payments_path.exists():
        for row in read_csv_rows(payments_path):
            payment_value = to_decimal(row.get("payment_value"))
            if payment_value is not None and payment_value < 0:
                negative_payment += 1
            if payment_value is not None and payment_value == 0:
                zero_payment += 1
    checks.append(["Negative payment value rows", negative_payment, "Negative payment values are invalid and should be investigated."])
    checks.append(["Zero payment value rows", zero_payment, "Zero payment requires review and is not automatically invalid unless later validation confirms an issue."])

    invalid_review_scores = 0
    if reviews_path.exists():
        for row in read_csv_rows(reviews_path):
            score = to_decimal(row.get("review_score"))
            if score is not None and not (1 <= score <= 5):
                invalid_review_scores += 1
    checks.append(["Review score outside 1 to 5", invalid_review_scores, "Review analysis expects the standard 1 to 5 scale."])

    product_categories: set[str] = set()
    products_without_category = 0
    if products_path.exists():
        for row in read_csv_rows(products_path):
            category = row.get("product_category_name", "")
            if is_missing(category):
                products_without_category += 1
            else:
                product_categories.add(category.strip())

    translated_categories: set[str] = set()
    if translations_path.exists():
        for row in read_csv_rows(translations_path):
            category = row.get("product_category_name", "")
            if not is_missing(category):
                translated_categories.add(category.strip())

    checks.extend(
        [
            ["Products without category", products_without_category, "Category analysis should group these as Unknown."],
            ["Product categories missing translation", len(product_categories - translated_categories), "Untranslated categories should fall back to original names."],
        ]
    )

    return checks


def format_dt(value: datetime | None) -> str:
    if value is None:
        return ""
    return value.strftime("%Y-%m-%d %H:%M:%S")


def build_json_payload(profiles: dict[str, dict], source_label: str, quality_checks: list[list[object]]) -> dict:
    file_payload = {}
    for file_name, profile in profiles.items():
        file_payload[file_name] = {
            "row_count": profile["row_count"],
            "columns": profile["columns"],
            "expected_columns": profile["expected_columns"],
            "schema_match": profile["schema_match"],
            "missing": dict(profile["missing"]),
            "date_ranges": {
                column: {
                    "minimum": format_dt(stats["min"]),
                    "maximum": format_dt(stats["max"]),
                    "invalid_nonblank_values": stats["invalid"],
                }
                for column, stats in profile["date_ranges"].items()
            },
            "domains": {
                column: dict(counter)
                for column, counter in profile["domains"].items()
                if counter
            },
        }

    return {
        "profile_source": source_label,
        "files": file_payload,
        "quality_prechecks": [
            {"metric": row[0], "value": row[1], "notes": row[2]}
            for row in quality_checks
        ],
    }


def build_markdown(profiles: dict[str, dict], source_label: str, quality_checks: list[list[object]]) -> str:
    lines: list[str] = [
        "# Data Profile Summary",
        "",
        "This profile was generated from local Olist CSV files. Raw CSV files are excluded from GitHub.",
        "",
        f"Profile source: {source_label}",
        "",
        "## Schema Validation",
        "",
    ]

    schema_rows = []
    for file_name, expected in EXPECTED_SCHEMAS.items():
        profile = profiles.get(file_name)
        if profile is None:
            schema_rows.append([file_name, "Missing", "", "No"])
            continue
        schema_rows.append([
            file_name,
            f"{profile['row_count']:,}",
            len(profile["columns"]),
            "Yes" if profile["schema_match"] else "No",
        ])
    lines.extend(markdown_table(["File", "Rows", "Columns", "Header matched expected schema"], schema_rows))

    lines.extend(["", "## Columns", ""])
    for file_name, profile in profiles.items():
        lines.append(f"### {file_name}")
        lines.append("")
        lines.append(", ".join(f"`{col}`" for col in profile["columns"]))
        lines.append("")

    lines.extend(["## Important Missing Values", ""])
    missing_rows = []
    for file_name, profile in profiles.items():
        row_count = profile["row_count"]
        for col, count in profile["missing"].most_common():
            if count > 0:
                missing_rows.append([file_name, col, f"{count:,}", pct(count, row_count)])
    if missing_rows:
        lines.extend(markdown_table(["File", "Column", "Missing rows", "Missing share"], missing_rows))
    else:
        lines.append("No missing values were detected in profiled columns.")

    lines.extend(["", "## Date Ranges", ""])
    date_rows = []
    for file_name, profile in profiles.items():
        for col, stats in profile["date_ranges"].items():
            date_rows.append([
                file_name,
                col,
                format_dt(stats["min"]),
                format_dt(stats["max"]),
                stats["invalid"],
            ])
    lines.extend(markdown_table(["File", "Date column", "Minimum", "Maximum", "Invalid nonblank values"], date_rows))

    lines.extend(["", "## Domain Summaries", ""])
    for label, (file_name, column) in DOMAIN_COLUMNS.items():
        profile = profiles.get(file_name)
        if profile is None:
            continue
        counter = profile["domains"].get(column, Counter())
        lines.append(f"### {label}")
        lines.append("")
        rows = [[value if value else "(blank)", f"{count:,}"] for value, count in sorted(counter.items())]
        lines.extend(markdown_table(["Value", "Rows"], rows))
        lines.append("")

    lines.extend(["## SQL Data Quality Pre-Checks", ""])
    lines.extend(markdown_table(["Metric", "Value", "Notes"], quality_checks))
    lines.append("")

    lines.extend([
        "## Key Notes for Analysis",
        "",
        "- All final business findings should wait until the SQL views and Power BI totals are validated.",
        "- Review score is a customer experience proxy and should not be treated as a complete satisfaction measure.",
        "- Late delivery can be evaluated as associated with review score, but this profile does not establish causality.",
        "- Optional review comment fields have high missingness and should not be required for review score analysis.",
        "- Delivery reliability should use delivered orders with valid customer delivery timestamps.",
        "- Payment values, product revenue, and freight values should stay separate unless explicitly reconciled.",
        "",
    ])

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Profile Olist CSV files.")
    parser.add_argument("--input-dir", default="data/raw", help="Directory containing Olist CSV files.")
    parser.add_argument("--output", default="documentation/data_profile_summary.md", help="Markdown output path.")
    parser.add_argument("--json-output", default="", help="Optional machine-readable JSON output path.")
    parser.add_argument(
        "--source-label",
        default="project data/raw directory",
        help="Non-sensitive source label written to the markdown summary.",
    )
    args = parser.parse_args()

    input_dir = Path(args.input_dir)
    output_path = Path(args.output)
    profiles: dict[str, dict] = {}

    for file_name, expected_columns in EXPECTED_SCHEMAS.items():
        path = input_dir / file_name
        if path.exists():
            profiles[file_name] = profile_file(path, expected_columns)

    if not profiles:
        raise SystemExit(f"No expected Olist CSV files found in {input_dir}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    quality_checks = build_quality_prechecks(input_dir)
    output_path.write_text(build_markdown(profiles, args.source_label, quality_checks), encoding="utf-8")
    if args.json_output:
        import json

        json_path = Path(args.json_output)
        json_path.parent.mkdir(parents=True, exist_ok=True)
        json_path.write_text(
            json.dumps(build_json_payload(profiles, args.source_label, quality_checks), indent=2),
            encoding="utf-8",
        )
    print(f"Profiled {len(profiles)} CSV files.")
    print(f"Wrote {output_path}")
    if args.json_output:
        print(f"Wrote {args.json_output}")


if __name__ == "__main__":
    main()

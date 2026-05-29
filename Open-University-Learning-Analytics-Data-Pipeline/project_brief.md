# Project Brief: OULAD Learning Analytics Data Pipeline

## Business Context

An online learning provider needs reliable reporting on learner registration, engagement, assessments, withdrawals, and course outcomes. The raw learning platform data is available as CSV extracts, but the files are separated by business area and need to be cleaned, validated, modeled, and exported before they can support decision-making.

This project uses the Open University Learning Analytics Dataset (OULAD), a real public anonymized dataset, to demonstrate a practical data engineering workflow for learning analytics reporting.

The project is positioned as a focused local data engineering case study for learning analytics reporting.

## Why Learning Analytics Needs Data Engineering

Learning analytics data often comes from several operational systems: course catalogs, assessment systems, registration systems, virtual learning environments, and student information records. Without a data pipeline, analysts may work with inconsistent fields, missing values, duplicate records, and unclear relationships.

A data engineering layer helps turn these raw files into trusted reporting tables that can support course teams, student support teams, academic operations, and BI users.

## Raw Data Challenges

- Multiple CSV files must be joined through course, presentation, assessment, site, and student identifiers.
- OULAD date fields are relative day offsets, not calendar dates.
- `studentVle.csv` is large and must be processed in chunks.
- Some fields can be missing, including demographic bands and assessment scores.
- Reporting requires consistent categories, valid score ranges, non-negative click counts, and relationship checks.

## Pipeline Goal

The goal is to transform raw OULAD CSV files into:

- cleaned CSV files
- validation summary documentation
- a SQLite analytical database
- SQL reporting views
- BI-ready reporting CSV outputs

## Engineering Decisions

- `studentVle.csv` is processed in chunks to avoid memory-heavy clickstream processing.
- Raw CSV files are ignored by Git so the repository stays lightweight and reproducible.
- SQLite is used as a local analytical warehouse for portfolio simplicity.
- OULAD date fields are treated as relative day offsets, not calendar dates.
- The risk indicator is rule-based reporting for review and prioritization, not predictive machine learning.

## Reporting Users

Potential users include:

- BI and reporting analysts
- academic operations teams
- course managers
- student support analysts
- data engineering reviewers evaluating pipeline design

## Success Criteria

- All expected OULAD files are checked before processing.
- The pipeline fails clearly if `studentVle.csv` is missing.
- The large clickstream file is handled with chunk processing.
- Cleaned tables preserve OULAD identifiers.
- Validation checks are documented and reproducible.
- SQLite reporting views answer registration, engagement, assessment, activity, outcome, and risk-indicator questions.
- Raw CSV files and generated database files are excluded from Git.

## Limitations

- This is a local portfolio project, not a deployed production system.
- SQLite is used for simplicity as a local analytical database for portfolio review.
- The risk indicator output is rule-based reporting, not predictive machine learning.
- OULAD is anonymized and does not include revenue, payment, lead, or private client data.

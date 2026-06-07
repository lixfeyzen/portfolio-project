# Data Notes

This folder contains a small working sample prepared from the City of Chicago Food Inspections public dataset.

The sample is intentionally anonymized for the repository. Business names and street addresses from the public source are not included in the local CSV. Establishments are represented as `EST-001`, `EST-002`, and so on.

Source dataset:

- https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5

The sample supports system analysis, not full-scale statistical reporting. For full analysis, download the official dataset directly from the source.

The local CSV uses `sample_record_id` as the working sample identifier. The proposed normalized system schema uses `inspection_id` for production-style inspection records.

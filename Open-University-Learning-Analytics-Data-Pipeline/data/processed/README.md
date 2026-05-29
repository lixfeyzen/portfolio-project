# Processed Data Folder

Cleaned CSV files may be generated locally in this folder by the pipeline.

Processed CSV files are excluded from Git because they can be regenerated from the raw OULAD files.

Run:

```bash
python scripts/run_pipeline.py
```

The cleaning step preserves OULAD identifiers and keeps relative day fields as nullable integer offsets.


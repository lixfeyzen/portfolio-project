# Raw Data Folder

Place the real OULAD CSV files in this folder before running the pipeline.

Download source:

```text
https://analyse.kmi.open.ac.uk/open-dataset
```

Expected file names:

- `courses.csv`
- `assessments.csv`
- `studentAssessment.csv`
- `studentInfo.csv`
- `studentRegistration.csv`
- `studentVle.csv`
- `vle.csv`

Raw CSV files are excluded from Git by the project `.gitignore`.

This is intentional. Reviewers can download the same public dataset from the official OULAD page above, place the files here, and rerun the pipeline locally.

`studentVle.csv` is required for full student engagement and VLE activity reporting. If it is missing, the extraction step fails clearly and explains that this file must be placed here.

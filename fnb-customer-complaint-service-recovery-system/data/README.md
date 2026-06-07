# Data Notes

This folder contains the cleaned working sample used for the **F&B Customer Complaint & Service Recovery Management System** case study.

## File

- `sample-311-food-complaints.csv`
- Optional SQL seed script: `../sql/load-sample-data.sql`

## Source basis

The sample follows the public field structure of the NYC Open Data **311 Service Requests from 2020 to Present** dataset and uses food-establishment complaint categories from NYC311 food safety complaint guidance.

Primary source:
https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9

Food safety context:
https://portal.311.nyc.gov/article/?kanumber=KA-01111

## Privacy handling

The original public dataset can include detailed address and coordinate fields. This public working sample intentionally removes customer identity, street address, coordinates, and exact establishment names.

The local sample keeps only the fields needed for system analysis:

- complaint type and descriptor
- location type
- status and due date
- borough-level grouping
- complaint channel
- anonymized outlet code
- proposed severity, SLA status, ticket flag, and owner role

## Rebuilding a live sample

A fresh live sample can be exported from the public Socrata endpoint, then cleaned before publishing:

```text
https://data.cityofnewyork.us/resource/erm2-nwe9.csv?$limit=5000&agency=DOHMH&complaint_type=Food%20Establishment&$order=created_date%20DESC
```

Do not publish street-level address fields unless they are intentionally needed and appropriate.

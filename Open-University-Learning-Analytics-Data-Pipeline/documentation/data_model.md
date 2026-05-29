# Data Model

## Overview

The project models OULAD as a local analytical schema in SQLite. Source identifiers are preserved so the model stays traceable to the original CSV files.

## Relationships

### courses to assessments

`courses` joins to `assessments` through:

- `code_module`
- `code_presentation`

One course presentation can have many assessments.

### courses to student_info

`courses` joins to `student_info` through:

- `code_module`
- `code_presentation`

One course presentation can have many student-course records.

### student_info to student_registration

`student_info` joins to `student_registration` through:

- `code_module`
- `code_presentation`
- `id_student`

This links student-course records to registration and unregistration dates.

### assessments to student_assessment

`assessments` joins to `student_assessment` through:

- `id_assessment`

The assessment table supplies course and presentation context for each student assessment submission.

### vle to student_vle

`vle` joins to `student_vle` through:

- `id_site`

This links click activity to the VLE activity type.

### student_info to student_vle

`student_info` joins to `student_vle` through:

- `code_module`
- `code_presentation`
- `id_student`

This links student-course records to engagement activity.

## Reporting Model

The reporting layer is implemented as SQL views:

- course registration summary
- student engagement summary
- assessment performance summary
- VLE activity summary
- student outcome summary
- at-risk student indicators

The at-risk indicator model is rule-based reporting and should not be described as predictive machine learning.


# Healthcare Analytics Platform

An end-to-end healthcare analytics project built using synthetic Electronic Health Record (EHR) data generated with Synthea.

The project demonstrates a realistic healthcare analytics workflow, from relational database design and SQL feature engineering to statistical analysis, interactive dashboards and machine learning using PostgreSQL, R, Quarto, Shiny and Python.

Full Report:  https://reinasdatastudio.github.io/healthcare-analytics-platform/Healthcare_Analytics_report.html

## Motivation

Healthcare organisations generate vast amounts of structured clinical data every day, yet transforming that data into actionable insights requires expertise across databases, analytics and machine learning.

This project was created to simulate the workflow of a healthcare data scientist using a realistic synthetic EHR database. Rather than focusing on isolated coding exercises, it demonstrates how multiple technologies can be integrated to investigate clinically meaningful questions—from understanding patient populations and healthcare utilisation to analysing disease burden, prescribing patterns and patient risk profiles.

## Project Objectives

This project aims to simulate the workflow of a healthcare data scientist by:

- Building a relational healthcare database using PostgreSQL
- Performing exploratory healthcare analytics using SQL
- Investigating patient demographics and healthcare utilisation
- Analysing disease prevalence and prescribing patterns
- Engineering patient-level clinical features
- Creating reproducible statistical analyses in R
- Building interactive dashboards using Shiny
- Developing machine learning models in Python

## Dataset

This project uses **synthetic electronic health record (EHR)** data generated using **Synthea**.

Synthea creates realistic patient records including:

- Patient demographics
- Healthcare encounters
- Diagnoses (SNOMED CT)
- Medications
- Clinical observations
- Procedures
- Care plans
- Immunisations

Because the dataset is synthetic, it contains no real patient information while preserving realistic healthcare relationships.

## Technologies

| Technology | Purpose |
|------------|---------|
| PostgreSQL | Relational database |
| SQL | Data exploration & feature engineering |
| R | Statistical analysis |
| Quarto | Reproducible reporting |
| Shiny | Interactive dashboards |
| Python | Machine learning |
| Git & GitHub | Version control |

---

# Project Workflow

```
Synthetic EHR (Synthea)
            │
            ▼
      PostgreSQL Database
            │
            ▼
      SQL Analytics
            │
            ▼
 Patient-Level Analytical Dataset
      ┌──────────────┬──────────────┐
      ▼              ▼              ▼
      R           Shiny         Python
      │              │              │
      ▼              ▼              ▼
 Statistical     Dashboard     Machine Learning
 Analysis
```

# SQL Modules

## 1. Patient Demographics

Objectives

- Explore the patient population
- Investigate age distribution
- Examine race and geographic distribution

Skills demonstrated

- Aggregation
- GROUP BY
- HAVING
- Date calculations

## 2. Healthcare Utilisation

Objectives

- Analyse healthcare encounters
- Investigate encounter types
- Measure healthcare utilisation

Skills demonstrated

- Date functions
- Aggregation
- Ranking
- GROUP BY

## 3. Disease Analysis

Objectives

- Explore disease prevalence
- Identify common chronic diseases
- Compare disease burden across age groups

Skills demonstrated

- INNER JOIN
- LEFT JOIN
- Common Table Expressions (CTEs)
- Cohort definition

## 4. Medication Analysis

Objectives

- Analyse prescribing patterns
- Link medications to chronic diseases
- Investigate medication utilisation

Skills demonstrated

- Window Functions
- DENSE_RANK
- Multi-table joins
- Ranking

## 5. Clinical Observations

Objectives

- Analyse clinical measurements
- Compare diabetic and non-diabetic patients
- Engineer patient-level cardiovascular risk features

Skills demonstrated

- Feature engineering
- Multiple CTEs
- CASE statements
- Multi-table joins
- Patient-level risk stratification

# Current Progress

- [x] PostgreSQL database
- [x] SQL analytics
- [x] R statistical analysis
- [x] Quarto reporting
- [ ] Interactive Shiny dashboard
- [x] Machine learning (Python)

# Repository Structure

```
healthcare-analytics-platform/

├── README.md
├── LICENSE
├── .gitignore
├── .gitattributes
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 00_project_overview.sql
│   ├── 01_patient_demographics.sql
│   ├── 02_healthcare_utilisation.sql
│   ├── 03_disease_analysis.sql
│   ├── 04_medication_analysis.sql
│   ├── 05_clinical_observations.sql
│   ├── 99_key_findings.md
│   └── create_tables.sql
│
├── r/
│   ├── 01_connect_postgres.R
│   ├── 02_patient_risk_analysis.R
│   ├── 03_disease_epidemiology.R
│   ├── 04_healthcare_utilisation.R
│   ├── 05_statistical_modelling.R
│   ├── 06_publication_visualisation.R
|
├── quarto/
│   ├── Healthcare_Analytics_Report.html
│   ├── Healthcare_Analytics_Report.qmd
├── shiny/
├── python/
│   ├── 01_data_loading.ipynb
│   ├── 02_data_preprocessing.ipynb
│   ├── 03_logistic_regression.ipynb
│   ├── 04_random_forest.ipynb
│   └── 05_model_comparison.ipynb
└── images/
```

# Future Development

The next stage of this project will focus on:

- Developing an interactive Shiny dashboard

# Author

**Reina Kaino**

Pharmacist → System Engineer → Data Scientist

I am passionate about applying data science and machine learning to healthcare to improve evidence generation, clinical decision-making and patient outcomes.

LinkedIn: https://www.linkedin.com/in/reijkg2904/

Portfolio: https://reinasdatastudio.github.io/webpage/portfolio-page.html

GitHub: https://github.com/reinasdatastudio

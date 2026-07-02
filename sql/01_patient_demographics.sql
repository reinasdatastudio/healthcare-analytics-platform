/*
========================================
Patient Demographics
Healthcare Analytics Platform

Objective:
Understand the patient population before
analysing disease prevalence.

Author: Reina Kaino
========================================
*/

-------------------------------------------------
-- Question 1
-- How many patients are in the database?
-------------------------------------------------

SELECT COUNT(*) FROM patients;

-------------------------------------------------
-- Question 2
-- Male vs Female
-------------------------------------------------

SELECT gender,COUNT(*)
FROM patients
GROUP BY gender;

-------------------------------------------------
-- Question 3
-- How old are the patients?
-------------------------------------------------

SELECT EXTRACT(YEAR FROM AGE(birthdate)) AS age_years
FROM patients;

-------------------------------------------------
-- Question 4
-- What is the average age of patients?
-------------------------------------------------

SELECT AVG(EXTRACT(YEAR FROM AGE(birthdate))) AS age_years
FROM patients;

-------------------------------------------------
-- Question 5
-- How many patients belong to each race?
-------------------------------------------------

SELECT
    race,
    COUNT(*) AS patient_count
FROM patients
GROUP BY race
ORDER BY patient_count DESC;

-------------------------------------------------
-- Question 6
-- Which counties has the most patients?
-------------------------------------------------

SELECT
    county,
    COUNT(*) AS patient_count
FROM patients
GROUP BY county
ORDER BY patient_count DESC;

-------------------------------------------------
-- Question 7
-- Which counties have more than 100 patients?
-------------------------------------------------

SELECT county, COUNT(id)
FROM patients
GROUP BY county
HAVING COUNT(id) >= 100
ORDER BY COUNT(id) DESC;

/*
========================================
Disease Analysis
Healthcare Analytics Platform

Objective:
Explore the prevalence and distribution of
medical conditions within the synthetic
patient population.

Author: Reina Kaino
========================================
*/

----------------------------------------
-- Question 1
-- How many conditions have been recorded?
----------------------------------------

SELECT COUNT(*)
FROM conditions;

----------------------------------------
-- Question 2
-- How many unique conditions are recorded?
----------------------------------------

SELECT COUNT(DISTINCT description)
FROM conditions;

----------------------------------------
-- Question 3A
-- What are the 20 most common descriptions?
----------------------------------------

SELECT COUNT(*) AS condition_count, description
FROM conditions
GROUP BY description
ORDER BY condition_count DESC LIMIT 20;

----------------------------------------
-- Question 3B
-- What are the 20 most common medical conditions?
----------------------------------------

SELECT COUNT(*) AS condition_count, description
FROM conditions
WHERE description LIKE '%(disorder)'
GROUP BY description
ORDER BY condition_count DESC LIMIT 20;

----------------------------------------
-- Question 4
-- How many patients have diabetes?
----------------------------------------

SELECT COUNT(DISTINCT patient) AS patient_count, description
FROM conditions
WHERE description ILIKE '%diabetes%'
GROUP BY description;

----------------------------------------
-- Question 5
-- How many patients have hypertension?
----------------------------------------

SELECT COUNT(DISTINCT patient) AS patient_count, description
FROM conditions
WHERE description ILIKE '%hypertension%'
GROUP BY description;

----------------------------------------
-- Question 6
-- Which conditions occur in which encounter class?
----------------------------------------

SELECT
    c.description AS condition_description,
    e.encounterclass,
    COUNT(*) AS number_of_conditions
FROM conditions c
JOIN encounters e
    ON c.encounter = e.id
WHERE c.description LIKE '%(disorder)'
GROUP BY
    c.description,
    e.encounterclass
ORDER BY
    number_of_conditions DESC;

----------------------------------------
-- Question 7
-- Which patients have the largest number of recorded conditions?
----------------------------------------

SELECT 
	COUNT(DISTINCT description) AS number_of_disorders, 
	patient
FROM conditions
WHERE description LIKE '%(disorder)'
GROUP BY patient
ORDER BY number_of_disorders DESC;

----------------------------------------
-- Question 8
-- Which diagnosis codes are used most frequently?
----------------------------------------

SELECT COUNT(*) occurrence_count, code
	FROM conditions
WHERE description LIKE '%(disorder)'
GROUP BY code
ORDER BY occurrence_count DESC;

----------------------------------------
-- Question 9
-- Which encounter is associated with the largest number of conditions?
----------------------------------------

SELECT COUNT(DISTINCT description) AS num_of_conditions,
	encounter
FROM conditions
GROUP BY encounter
ORDER BY num_of_conditions DESC;

----------------------------------------
-- Question 10
-- Which age groups have the highest prevalence of diabetes?
----------------------------------------
-- birthdate in patients, select diabetes in encounters

SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) < 18 THEN '0-17'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) BETWEEN 18 AND 39 THEN '18-39'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) BETWEEN 40 AND 64 THEN '40-64'
        ELSE '65+'
    END AS age_group,
    COUNT(DISTINCT c.patient) AS diabetes_patient_count
FROM conditions c
JOIN patients p
    ON p.id = c.patient
WHERE c.description ILIKE '%diabetes%'
GROUP BY age_group
ORDER BY diabetes_patient_count DESC;
/*
========================================
Clinical Observations and Population Health
Healthcare Analytics Platform

Objective:
Understand the health status of the patient 
population through analysis of clinical measurements.
Author: Reina Kaino
========================================
*/

----------------------------------------
-- Question 1
-- How many observations have been recorded?
----------------------------------------

SELECT COUNT(*)
FROM observations;

----------------------------------------
-- Question 2
-- How many different observation types exist?
----------------------------------------

SELECT COUNT(DISTINCT description)
FROM observations;

----------------------------------------
-- Question 3
-- What are the twenty most common observations?
----------------------------------------

SELECT COUNT(*) AS observation_count, description
FROM observations
GROUP BY description
ORDER BY observation_count DESC limit 20;

----------------------------------------
-- Question 4
-- Which observations are numerical?
----------------------------------------

SELECT description, type
FROM observations
WHERE type ILIKE 'numeric'
GROUP BY type, description;

----------------------------------------
-- Question 5
-- What is the average BMI?
----------------------------------------

SELECT AVG(value::NUMERIC) AS average_bmi
FROM observations
WHERE description ILIKE '%Body mass index (BMI) [Ratio]%';

----------------------------------------
-- Question 6
-- What is the BMI distribution by age group?
----------------------------------------

SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) < 18 THEN '0-17'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) BETWEEN 18 AND 39 THEN '18-39'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) BETWEEN 40 AND 64 THEN '40-64'
        ELSE '65+'
    END AS age_group,
	AVG(value::NUMERIC) AS bmi
FROM observations o
JOIN patients p ON p.id = o.patient
WHERE description ILIKE '%Body mass index (BMI) [Ratio]%'
GROUP BY age_group;

----------------------------------------
-- Question 7
-- Which counties have the highest average BMI?
----------------------------------------

SELECT p.county, AVG(value::NUMERIC) AS bmi
FROM observations o
JOIN patients p ON p.id = o.patient
WHERE o.description ILIKE '%Body mass index (BMI) [Ratio]%'
GROUP BY p.county;

----------------------------------------
-- Question 8
-- Do diabetic patients have a higher BMI?
----------------------------------------

SELECT AVG(value::NUMERIC) AS bmi, c.description
FROM observations o
JOIN conditions c ON c.patient = o.patient
WHERE o.description ILIKE '%Body mass index (BMI) [Ratio]%' AND
c.description ILIKE '%diabetes%'
GROUP BY c.description;

----------------------------------------
-- Question 9
-- Which clinical measurements differ the most 
-- between diabetic and non-diabetic patients?
----------------------------------------

-- Identify diabetic patients
WITH diabetic_patients AS (
    SELECT DISTINCT patient
    FROM conditions
    WHERE description ILIKE '%diabetes%'
),
-- Keep only numeric value
numeric_observations AS (
    SELECT
        patient,
        description,
        value::NUMERIC AS numeric_value
    FROM observations
    WHERE type = 'numeric'
      AND value IS NOT NULL
),
comparison AS (
    SELECT
        n.description,
        CASE
            WHEN d.patient IS NOT NULL THEN 'Diabetic'
            ELSE 'Non-diabetic'
        END AS diabetes_status,
        AVG(n.numeric_value) AS average_value,
        COUNT(*) AS observation_count
    FROM numeric_observations n
    LEFT JOIN diabetic_patients d
        ON n.patient = d.patient
    GROUP BY
        n.description,
        diabetes_status
)
SELECT *
FROM comparison
ORDER BY description, diabetes_status;

----------------------------------------
-- Question 10
-- Build a cardiovascular risk profile of the patient population.
----------------------------------------

WITH bmi AS (
    SELECT patient, MAX(value::NUMERIC) AS bmi
    FROM observations
    WHERE description ILIKE '%Body mass index%'
      AND type = 'numeric'
    GROUP BY patient
), 
diabetic_patients AS (
    SELECT DISTINCT patient
    FROM conditions
    WHERE description ILIKE '%diabetes%'
), 
hypertension_patients AS (
	SELECT DISTINCT patient
    FROM conditions
    WHERE description ILIKE '%hypertension%'
),
cardiovascular_risk AS (
	SELECT p.id AS patient, 
		CASE
			WHEN b.bmi >= 30 THEN 1 ELSE 0 END AS bmi30,
		CASE 
			WHEN EXTRACT(
				YEAR FROM AGE(
					COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) >= 65
			THEN 1 ELSE 0 END AS age65,
		CASE
			WHEN d.patient IS NOT NULL THEN 1 ELSE 0 END AS diabetes,
		CASE 
			WHEN h.patient IS NOT NULL THEN 1 ELSE 0 END AS hypertension
	FROM patients p
	LEFT JOIN bmi b ON b.patient = p.id
	LEFT JOIN diabetic_patients d ON d.patient = p.id
	LEFT JOIN hypertension_patients h ON h.patient = p.id	
),
risk_score AS (
	    SELECT
	        patient,
	        age65,
	        bmi30,
	        diabetes,
	        hypertension,
	        age65 + bmi30 + diabetes + hypertension AS risk_score
		FROM cardiovascular_risk
)
SELECT
    patient,
    age65,
    bmi30,
    diabetes,
    hypertension,
    risk_score,
    CASE
        WHEN risk_score <= 1 THEN 'Low'
        WHEN risk_score <= 3 THEN 'Moderate'
        ELSE 'High'
    END AS risk_category
FROM risk_score
ORDER BY risk_score DESC;
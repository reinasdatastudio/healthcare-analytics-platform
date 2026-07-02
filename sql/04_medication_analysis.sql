/*
========================================
Medication Analysis
Healthcare Analytics Platform

Objective:
Explore prescribing patterns and medication
utilisation within the synthetic patient
population.

Author: Reina Kaino
========================================
*/

----------------------------------------
-- Question 1
--How many medication records are there?
----------------------------------------

SELECT COUNT(*) FROM medications;

----------------------------------------
-- Question 2
-- How many unique medications are prescribed?
----------------------------------------

SELECT COUNT(*) AS medication_count, description
FROM medications
GROUP BY description;

----------------------------------------
-- Question 3
-- What are the 20 most frequently prescribed medications?
----------------------------------------

SELECT COUNT(*) AS medication_count, description
FROM medications
GROUP BY description
ORDER BY medication_count DESC LIMIT 20;

----------------------------------------
-- Question 4
-- Which patients receive the greatest number of medications?
----------------------------------------

SELECT COUNT(DISTINCT description) AS num_of_medication, patient
FROM medications
GROUP BY patient
ORDER BY num_of_medication DESC;

----------------------------------------
-- Question 5
-- Which medications are most commonly prescribed for diabetes?
----------------------------------------

SELECT COUNT(*) AS num_of_medications, m.description AS medcations
FROM medications m
JOIN conditions c ON c.encounter = m.encounter
WHERE c.description ILIKE '%diabetes%'
GROUP BY m.description
ORDER BY num_of_medications DESC;

----------------------------------------
-- Question 6
-- Which medications are most commonly prescribed for hypertension?
----------------------------------------

SELECT COUNT(*) AS num_of_medications, m.description AS medcations
FROM medications m
JOIN conditions c ON c.encounter = m.encounter
WHERE c.description ILIKE '%hypertension%'
GROUP BY m.description
ORDER BY num_of_medications DESC;

----------------------------------------
-- Question 7
-- Which medications have the highest average total cost?
----------------------------------------

SELECT AVG(total_cost), description
FROM medications
GROUP BY description;

----------------------------------------
-- Question 8
-- Which payers cover the greatest medication costs?
----------------------------------------

SELECT SUM(total_cost), payer
FROM medications
GROUP BY payer
ORDER BY sum DESC;

----------------------------------------
-- Question 9
-- Which encounter classes result in the greatest number of prescriptions?
----------------------------------------

SELECT COUNT(*) AS num_of_prescriptions, e.encounterclass
FROM medications m
JOIN encounters e ON e.id = m.encounter
GROUP BY e.encounterclass
ORDER BY num_of_prescriptions DESC;

----------------------------------------
-- Question 10
-- Which medications are most commonly prescribed for the five most prevalent chronic diseases?
----------------------------------------

WITH top_diseases AS (
	SELECT COUNT(*) AS disease_count, description AS disease
	FROM conditions
	WHERE description ILIKE '%(disorder)'
	GROUP BY description
	ORDER BY COUNT(*) DESC LIMIT 5
)
SELECT td.disease, m.description AS medication, COUNT(*) AS prescription_count
FROM top_diseases td
JOIN conditions c ON c.description = td.disease
JOIN medications m ON m.encounter = c.encounter
GROUP BY td.disease, m.description
ORDER BY td.disease, prescription_count DESC;
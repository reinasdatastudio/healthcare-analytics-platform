/*
========================================
Healthcare Utilisation
Healthcare Analytics Platform

Objective:
Characterise healthcare utilisation by
examining patient encounters, encounter
types, and utilisation patterns.

Author: Reina Kaino
========================================
*/

----------------------------------------
-- Question 1
-- How many encounters are recorded?
----------------------------------------

SELECT COUNT(*) AS total_encounters 
FROM encounters;

----------------------------------------
-- Question 2
-- How many encounter classes are there?
----------------------------------------

SELECT COUNT(DISTINCT encounterclass) AS number_of_encounter_classes
FROM encounters;

----------------------------------------
-- Question 3
-- How many encounter classes is most common?
----------------------------------------

SELECT COUNT(*) AS count_classes, encounterclass
FROM encounters
GROUP BY encounterclass
ORDER BY count_classes DESC;

----------------------------------------
-- Question 4
-- How many encounters occurred each year?
----------------------------------------

SELECT
	EXTRACT(YEAR FROM start_time) AS event_year, 
	COUNT(*) AS count_year
FROM encounters
GROUP BY event_year
ORDER BY event_year ASC;

----------------------------------------
-- Question 5
-- How many encounters did each patient have?
----------------------------------------

SELECT patient, COUNT(*)
FROM encounters
GROUP BY patient;

----------------------------------------
-- Question 6
-- Who are the top 10 most frequent hospital users?
----------------------------------------

SELECT
	patient,
	COUNT(*) AS number_of_visits
FROM encounters
GROUP BY patient
ORDER BY number_of_visits DESC
LIMIT 10;

----------------------------------------
-- Question 7a
-- What is the average number of encounters per patient?
----------------------------------------

SELECT (COUNT(*)) / COUNT(DISTINCT patient) AS average_encounters, patient
FROM encounters
GROUP BY patient;

----------------------------------------
-- Question 7b
-- What is the average number of encounters?
----------------------------------------

SELECT (COUNT(*)) / COUNT(DISTINCT patient) AS average_encounters
FROM encounters;

----------------------------------------
-- Question 8
-- How long does each encounter last?
----------------------------------------

SELECT id, patient, (stop_time - start_time) AS duration
FROM encounters;

----------------------------------------
-- Question 9
-- Which organisations had the most encounters?
----------------------------------------

SELECT COUNT(*) AS number_of_encounters, organization
FROM encounters
GROUP BY organization
ORDER BY number_of_encounters DESC;

----------------------------------------
-- Question 10
-- Which providers saw the most patients?
----------------------------------------

SELECT COUNT(DISTINCT patient) AS number_of_patients, provider
FROM encounters
GROUP BY provider
ORDER BY number_of_patients DESC;
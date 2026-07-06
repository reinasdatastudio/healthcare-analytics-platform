-- Patient Risk Profile

CREATE VIEW patient_risk_profile AS
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

-- Disease Summary

CREATE VIEW disease_summary AS
WITH diabetic_patients AS (
    SELECT DISTINCT patient
    FROM conditions
    WHERE description ILIKE '%diabetes%'
), 
hypertension_patients AS (
	SELECT DISTINCT patient
    FROM conditions
    WHERE description ILIKE '%hypertension%'
)
SELECT p.id,
	EXTRACT(YEAR FROM AGE(COALESCE(p.deathdate, CURRENT_DATE), p.birthdate)) AS age, 
	p.county,
	CASE
		WHEN d.patient IS NOT NULL THEN 1 ELSE 0 END AS diabetes,
	CASE 
		WHEN h.patient IS NOT NULL THEN 1 ELSE 0 END AS hypertension
	FROM patients p
	LEFT JOIN diabetic_patients d ON d.patient = p.id
	LEFT JOIN hypertension_patients h ON h.patient = p.id;

-- encounter_summary
CREATE VIEW encounter_summary AS
	SELECT patient, COUNT(*) AS encounter_count
	FROM encounters
	GROUP BY patient;
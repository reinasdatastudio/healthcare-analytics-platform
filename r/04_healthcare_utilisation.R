############################################################
# Healthcare Utilisation
#
# Data source:
# PostgreSQL
#
# Objective:
# Investigate how healthcare utilisation differs
# according to patient characteristics and disease status.
#
# Author: Reina Kaino
############################################################

# 1. Load packages and connect to PostgreSQL 

source("01_connect_postgres.R")

# 2. Join encounter_summary with disease_summary
utilisation <- dbGetQuery(con,"
SELECT
    d.*,
    e.encounter_count
FROM disease_summary d
JOIN encounter_summary e
ON d.id = e.patient;
")

utilisation <- utilisation %>%
  mutate(
    encounter_count = as.numeric(encounter_count)
  )

# Do diabetic patients have more healthcare encounters?
utilisation %>%
  group_by(diabetes) %>%
  summarise(
    mean_encounters = mean(encounter_count),
    median_encounters = median(encounter_count),
    sd = sd(encounter_count)
  )

ggplot(utilisation,
  aes(factor(diabetes), encounter_count))+
  geom_boxplot()

wilcox.test(
  encounter_count ~ diabetes,
  data = utilisation
)

# Do hypertensive patients have more encounters?

utilisation %>%
  group_by(hypertension) %>%
  summarise(
    mean_encounters = mean(encounter_count),
    median_encounters = median(encounter_count),
    sd = sd(encounter_count)
  )

ggplot(utilisation,
       aes(factor(hypertension), encounter_count))+
  geom_boxplot()

wilcox.test(
  encounter_count ~ hypertension,
  data = utilisation
)

# Does age correlate with healthcare utilisation?

ggplot(utilisation, aes(age, encounter_count))+
  geom_point(alpha=.3)+
  geom_smooth(method="lm")

## Correlation test
cor.test(
  utilisation$age,
  utilisation$encounter_count)

# Does cardiovascular risk category influence healthcare utilisation?
utilisation_risk <- dbGetQuery(con,"
SELECT
    e.encounter_count,
    r.risk_category
FROM encounter_summary e
JOIN patient_risk_profile r
ON e.patient=r.patient;
")

utilisation_risk <- utilisation_risk %>%
  mutate(
    encounter_count = as.numeric(encounter_count)
  )

ggplot(utilisation_risk, aes(risk_category, encounter_count))+
  geom_boxplot()

kruskal.test(
  encounter_count ~ risk_category,
  data=utilisation_risk
)

#Highest healthcare use
utilisation_risk %>%
  arrange(desc(encounter_count)) %>%
  slice_head(n = 20)

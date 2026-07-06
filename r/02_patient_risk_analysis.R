############################################################
# Patient Risk Analysis
#
# Data source:
# PostgreSQL view: patient_risk_profile
#
# Objective:
# Summarise patient-level cardiovascular risk factors
# and explore the distribution of risk categories.
#
# Author: Reina Kaino
############################################################

# Connect
source("01_connect_postgres.R")

# Load data
risk <- dbGetQuery(con, "
SELECT *
FROM patient_risk_profile;
")

glimpse(risk)
summary(risk)

# Number of patients in each risk category

risk %>%
  count(risk_category) %>%
  mutate(percent = n / sum(n) * 100)

# The distribution of risk categories

risk %>%
  count(risk_category)

# The distribution of risk scores
risk %>%
  count(risk_score)

# Common cardiovascular risk

risk_factors <- risk %>%
  summarise(
    age65 = sum(age65),
    bmi30 = sum(bmi30),
    diabetes = sum(diabetes),
    hypertension = sum(hypertension)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "risk_factor",
    values_to = "patient_count"
  ) %>%
  mutate(percent = patient_count / nrow(risk) * 100)

# Risk category bar plot

risk %>%
  count(risk_category) %>%
  ggplot(aes(x = risk_category, y = n)) +
  geom_col() +
  labs(
    title = "Distribution of Cardiovascular Risk Categories",
    x = "Risk Category",
    y = "Number of Patients"
  ) +
  theme_minimal()

# Risk factor prevalence plot

risk_factors %>%
  ggplot(aes(x = reorder(risk_factor, patient_count), y = patient_count)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Prevalence of Cardiovascular Risk Factors",
    x = "Risk Factor",
    y = "Number of Patients"
  ) +
  theme_minimal()

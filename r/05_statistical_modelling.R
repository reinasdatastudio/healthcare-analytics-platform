############################################################
# Statistical Modelling
#
# Objective:
# Build interpretable statistical models to investigate
# patient-level factors associated with diabetes.
#
# Author: Reina Kaino
############################################################


# Load packages and connect to PostgreSQL 

source("01_connect_postgres.R")

# Load modelling dataset
model_data <- dbGetQuery(con, "
SELECT
    d.id,
    d.age,
    d.diabetes,
    d.hypertension,
    r.bmi30,
    r.risk_score,
    r.risk_category
FROM disease_summary d
JOIN patient_risk_profile r
ON d.id = r.patient;
")

glimpse(model_data)

# Prepare variables
model_data <- model_data %>%
  mutate(
    diabetes = factor(diabetes, levels = c(0, 1), labels = c("No", "Yes")),
    hypertension = factor(hypertension, levels = c(0, 1), labels = c("No", "Yes")),
    bmi30 = factor(bmi30, levels = c(0, 1), labels = c("No", "Yes")),
    risk_category = factor(risk_category, levels = c("Low", "Moderate", "High"))
  )

# Model 1: Age only
model_age <- glm(
  diabetes ~ age,
  data = model_data,
  family = binomial
)

summary(model_age)
broom::tidy(model_age, exponentiate = TRUE, conf.int = TRUE)

# Model 2: Age + BMI
model_age_bmi <- glm(
  diabetes ~ age + bmi30,
  data = model_data,
  family = binomial
)

summary(model_age_bmi)
broom::tidy(model_age_bmi, exponentiate = TRUE, conf.int = TRUE)

# Model 3: Age + BMI + Hypertension
model_full <- glm(
  diabetes ~ age + bmi30 + hypertension,
  data = model_data,
  family = binomial
)

summary(model_full)
model_results <- broom::tidy(model_full, exponentiate = TRUE, conf.int = TRUE)

model_results

# Compare model fit
AIC(model_age, model_age_bmi, model_full)

# Plot odds ratio
model_results %>%
  filter(term != "(Intercept)") %>%
  mutate(term = recode(
    term,
    "age" = "Age",
    "bmi30Yes" = "BMI ≥ 30",
    "hypertensionYes" = "Hypertension"
  )) %>%
  ggplot(aes(x = reorder(term, estimate), y = estimate)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  coord_flip() +
  labs(
    title = "Factors Associated with Diabetes",
    x = "Predictor",
    y = "Odds Ratio"
  ) +
  theme_minimal()

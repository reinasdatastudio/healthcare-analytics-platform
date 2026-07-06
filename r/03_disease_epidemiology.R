############################################################
# Age and Diabetes Association
#
# Data source:
# PostgreSQL view: disease_summary
#
# Objective:
# Investigate whether older patients are more likely to have
# diabetes in the synthetic EHR population.
#
# Author: Reina Kaino
############################################################

# 1. Load packages and connect to PostgreSQL 

source("01_connect_postgres.R")

# 2. Import analysis dataset 

disease <- dbGetQuery(con, "
    SELECT *
    FROM disease_summary;
")

glimpse(disease)

# 3. Prepare variables

disease <- disease %>%
  mutate(
    diabetes_status = if_else(diabetes == 1, "Diabetic", "Non-diabetic"),
    diabetes_status = factor(diabetes_status, levels = c("Non-diabetic", "Diabetic"))
  )

# 4. Descriptive summary 

age_summary <- disease %>%
  group_by(diabetes_status) %>%
  summarise(
    n = n(),
    mean_age = mean(age, na.rm = TRUE),
    median_age = median(age, na.rm = TRUE),
    sd_age = sd(age, na.rm = TRUE),
    .groups = "drop"
  )

age_summary

# 5. Visualise age distribution 

ggplot(disease, aes(x = age, fill = diabetes_status)) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
  labs(
    title = "Age Distribution by Diabetes Status",
    x = "Age",
    y = "Number of Patients",
    fill = "Diabetes Status"
  ) +
  theme_minimal()

ggplot(disease, aes(x = diabetes_status, y = age)) +
  geom_boxplot() +
  labs(
    title = "Age by Diabetes Status",
    x = "Diabetes Status",
    y = "Age"
  ) +
  theme_minimal()

# 6. Statistical test 

wilcox.test(age ~ diabetes_status, data = disease)

# 7. Logistic regression

diabetes_model <- glm(
  diabetes ~ age,
  data = disease,
  family = binomial
)

summary(diabetes_model)

# 8. Odds ratio

# Odds ratio table

odds_ratios <- broom::tidy(
  diabetes_model,
  exponentiate = TRUE,
  conf.int = TRUE
) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    term = recode(
      term,
      age = "Age (per year)"
    )
  )

odds_ratios

# Odds ratio plot

ggplot(odds_ratios,
       aes(x = term,
           y = estimate)) +
  
  geom_point(size = 3, colour = "#2C7FB8") +
  
  geom_errorbar(
    aes(ymin = conf.low,
        ymax = conf.high),
    width = 0.15,
    colour = "#2C7FB8"
  ) +
  
  geom_hline(
    yintercept = 1,
    linetype = "dashed",
    colour = "red"
  ) +
  
  labs(
    title = "Association Between Age and Diabetes",
    subtitle = "Odds ratio from logistic regression",
    x = "",
    y = "Odds Ratio (95% CI)"
  ) +
  
  theme_minimal(base_size = 13)

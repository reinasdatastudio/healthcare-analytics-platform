############################################################
# Publication Visualisations
#
# Objective:
# Produce publication-quality figures for the
# Healthcare Analytics Platform.
#
# Author: Reina Kaino
############################################################

# Figure 1: Patient Risk Categories
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

ggsave(
  "..images/quarto/risk_category_distribution.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 2: Risk Factor Prevalence
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

ggsave(
  "..images/quarto/risk_factor_prevalence.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 3A: Age vs Diabetes histogram
ggplot(disease, aes(x = age, fill = diabetes_status)) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
  labs(
    title = "Age Distribution by Diabetes Status",
    x = "Age",
    y = "Number of Patients",
    fill = "Diabetes Status"
  ) +
  theme_minimal()

ggsave(
  "..images/quarto/age_diabetes_histogram.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 3B: Age vs Diabetes boxplot
ggplot(disease, aes(x = diabetes_status, y = age)) +
  geom_boxplot() +
  labs(
    title = "Age by Diabetes Status",
    x = "Diabetes Status",
    y = "Age"
  ) +
  theme_minimal()

ggsave(
  "..images/quarto/age_diabetes_boxplot.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 4: Odds ratio plot from 05
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

ggsave(
  "..images/quarto/odds_ratio.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 5: Healthcare Utilisation

## Diabetes vs encounter count
ggplot(utilisation,
       aes(factor(diabetes), encounter_count))+
  geom_boxplot()

ggsave(
  "..images/quarto/utilisation_diabetes.png",
  width=8,
  height=5,
  dpi=300
)

## Hypertension vs encounter count
ggplot(utilisation,
       aes(factor(hypertension), encounter_count))+
  geom_boxplot()

ggsave(
  "..images/quarto/utilisation_hypertension.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 6: Age vs encounter count
ggplot(utilisation, aes(age, encounter_count))+
  geom_point(alpha=.3)+
  geom_smooth(method="lm")

ggsave(
  "..images/quarto/utilisation_age.png",
  width=8,
  height=5,
  dpi=300
)

# Figure 6: Risk category vs encounter count
ggplot(utilisation_risk, aes(risk_category, encounter_count))+
  geom_boxplot()

ggsave(
  "..images/quarto/utilisation_risk.png",
  width=8,
  height=5,
  dpi=300
)

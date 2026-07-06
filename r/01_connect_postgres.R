library(DBI)
library(RPostgres)
library(tidyverse)
library(janitor)

con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "synthea_healthcare",
  host = "localhost",
  port = 5432,
  user = "postgres",
  password = "12345678"
)

dbListTables(con)

patients <- dbGetQuery(con, "
  SELECT *
  FROM patients
  LIMIT 10;
")

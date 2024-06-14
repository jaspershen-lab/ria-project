library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')

####read data
phenotype_data <-
  readxl::read_xlsx("2-data/1_supplemental tables.xlsx", sheet = 1)

dir.create("3-data_analysis/1-data-preparation/1-phenotype-data",
           recursive = TRUE)
setwd("3-data_analysis/1-data-preparation/1-phenotype-data")

phenotype_data <-
  phenotype_data %>%
  dplyr::rename(subject_id = "ID") %>%
  dplyr::rename(
    Tobacco = `Tobacco use（0 equels no, 1 equels yes）`,
    Hypertension = "Hypertension（0 equels no, 1 equels yes）",
    Cardiac_disease = "Cardiac disease (myocardial infarction and angina; 0 equels no, 1 equels yes)",
    Hypercholesterolemia = "Hypercholesterolemia（0 equels no, 1 equels yes）",
    Stroke_history = "Stroke history（0 equels no, 1 equels yes）",
    Diabetes = "Diabetes mellitus（0 equels no, 1 equels yes）"
  )

attr(phenotype_data$subject_id, "note") <- "subject id"
attr(phenotype_data$Tobacco, "note") <- "Tobacco use (0 equels no, 1 equels yes)"
attr(phenotype_data$Hypertension, "note") <- "Hypertension (0 equels no, 1 equels yes)"
attr(phenotype_data$Cardiac_disease, "note") <- "Cardiac disease (myocardial infarction and angina; 0 equels no, 1 equels yes)"
attr(phenotype_data$Hypercholesterolemia, "note") <- "Hypercholesterolemia(0 equels no, 1 equels yes)"
attr(phenotype_data$Stroke_history, "note") <- "Stroke history (0 equels no, 1 equels yes)"
attr(phenotype_data$Diabetes, "note") <- "Diabetes mellitus (0 equels no, 1 equels yes)"

save(phenotype_data, file = "phenotype_data.rda")

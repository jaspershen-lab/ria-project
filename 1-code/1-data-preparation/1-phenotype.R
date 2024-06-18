library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')

####read data
phenotype_data <-
  readxl::read_xlsx("2-data/Supplementary Tables S5-S13.xlsx", sheet = 1)

phenotype_data2 <-
  readxl::read_xlsx("2-data/Supplementary Tables S5-S13.xlsx", sheet = 2)

dir.create("3-data_analysis/1-data-preparation/1-phenotype-data",
           recursive = TRUE)
setwd("3-data_analysis/1-data-preparation/1-phenotype-data")

colnames(phenotype_data) <-
  colnames(phenotype_data) %>% 
  stringr::str_trim(side = "both") %>% 
  stringr::str_replace_all("（", "(") %>% 
  stringr::str_replace_all("）", ")")

colnames(phenotype_data2) <-
  colnames(phenotype_data2) %>% 
  stringr::str_trim(side = "both") %>% 
  stringr::str_replace_all("（", "(") %>% 
  stringr::str_replace_all("）", ")")

phenotype_data <-
phenotype_data %>% 
  dplyr::full_join(phenotype_data2, by = intersect(colnames(phenotype_data), colnames(phenotype_data2)))

phenotype_data <-
  phenotype_data %>%
  dplyr::rename(subject_id = "ID") %>%
  dplyr::rename(
    Tobacco = "Tobacco use(0 equels no, 1 equels yes)",
    Hypertension = "Hypertension(0 equels no, 1 equels yes)",
    Cardiac_disease = "Cardiac disease (myocardial infarction and angina; 0 equels no, 1 equels yes)",
    Hypercholesterolemia = "Hypercholesterolemia(0 equels no, 1 equels yes)",
    Stroke_history = "Stroke history(0 equels no, 1 equels yes)",
    Diabetes = "Diabetes mellitus(0 equels no, 1 equels yes)",
    Multiplicity = "Multiplicity(0 equels no, 1 equels yes)",
    Morphology = "Morphology(1 equels regular intracranial aneurysm, 2 equels irregular intracranial aneurysm)",
    max_diameter = "max diameter-cm"
  )

colnames(phenotype_data)

attr(phenotype_data$subject_id, "note") <- "subject id"
attr(phenotype_data$subject_id, "group") <- "group"
attr(phenotype_data$subject_id, "age") <- "age"
attr(phenotype_data$subject_id, "sex") <- "sex"
attr(phenotype_data$subject_id, "BMI") <- "BMI"
attr(phenotype_data$Tobacco, "note") <- "Tobacco use (0 equels no, 1 equels yes)"
attr(phenotype_data$Hypertension, "note") <- "Hypertension (0 equels no, 1 equels yes)"
attr(phenotype_data$Cardiac_disease, "note") <- "Cardiac disease (myocardial infarction and angina; 0 equels no, 1 equels yes)"
attr(phenotype_data$Hypercholesterolemia, "note") <- "Hypercholesterolemia(0 equels no, 1 equels yes)"
attr(phenotype_data$Stroke_history, "note") <- "Stroke history (0 equels no, 1 equels yes)"
attr(phenotype_data$Diabetes, "note") <- "Diabetes mellitus (0 equels no, 1 equels yes)"
attr(phenotype_data$Multiplicity, "note") <- "Multiplicity(0 equels no, 1 equels yes)"
attr(phenotype_data$Morphology, "note") <- "Morphology(1 equels regular intracranial aneurysm, 2 equels irregular intracranial aneurysm)"
attr(phenotype_data$location, "note") <- "location"
attr(phenotype_data$max_diameter, "note") <- "max diameter-cm"

save(phenotype_data, file = "phenotype_data.rda")

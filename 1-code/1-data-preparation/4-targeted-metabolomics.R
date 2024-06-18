library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')

####read data
data <- readxl::read_xlsx("2-data/Supplementary Tables S5-S13.xlsx", sheet = 8)

load("3-data_analysis/1-data-preparation/1-phenotype-data/phenotype_data.rda")

dir.create("3-data_analysis/1-data-preparation/4-targeted-metabolomics",
           recursive = TRUE)

setwd("3-data_analysis/1-data-preparation/4-targeted-metabolomics")

data <-
  data %>%
  dplyr::select(-Category) %>%
  tibble::column_to_rownames(var = "Sample") %>%
  t() %>%
  as.data.frame()

sample_info <-
  data.frame(sample_id = colnames(data))

variable_info <-
  data.frame(variable_id = rownames(data))

sample_info <-
  sample_info %>%
  dplyr::left_join(phenotype_data, by = c("sample_id" = "subject_id"))

variable_info <-
  variable_info %>%
  dplyr::mutate(compound.name = variable_id)

sample_info$class <- "Subject"

library(massdataset)

targeted_metabolomics_data <-
  create_mass_dataset(
    expression_data = data,
    sample_info = sample_info,
    variable_info = variable_info
  )

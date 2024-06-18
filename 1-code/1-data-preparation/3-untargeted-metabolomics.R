library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')

####read data
data <- readxl::read_xlsx("2-data/Supplementary Tables S5-S13.xlsx", sheet = 7)

data <-
  data[-60, ]

data <-
  data %>%
  tibble::column_to_rownames(var = "Sample") %>%
  t() %>%
  as.data.frame()

sample_info <-
  data.frame(sample_id = colnames(data))

variable_info <-
  data.frame(variable_id = rownames(data))
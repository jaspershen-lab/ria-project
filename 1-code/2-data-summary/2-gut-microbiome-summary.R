library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')


load("3-data_analysis/1-data-preparation/2-gut-microbiome/gut_microbiome_data.rda")

dir.create("3-data_analysis/2-data-summary/2-gut-microbiome",
           recursive = TRUE)

setwd("3-data_analysis/2-data-summary/2-gut-microbiome")

dim(gut_microbiome_data)

gut_microbiome_data@sample_info$group

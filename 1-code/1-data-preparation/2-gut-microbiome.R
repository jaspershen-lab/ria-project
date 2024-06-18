library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')

####read data
data <- readxl::read_xlsx("2-data/Supplementary Tables S5-S13.xlsx", sheet = 3)

load("3-data_analysis/1-data-preparation/1-phenotype-data/phenotype_data.rda")

dir.create("3-data_analysis/1-data-preparation/2-gut-microbiome",
           recursive = TRUE)

setwd("3-data_analysis/1-data-preparation/2-gut-microbiome")

expression_data <-
  data %>%
  tibble::column_to_rownames(var = "ID")

sample_info <-
  data.frame(sample_id = colnames(expression_data))

variable_info <-
  data.frame(variable_id = rownames(expression_data))

sample_info <-
  sample_info %>%
  dplyr::left_join(phenotype_data, by = c("sample_id" = "subject_id"))

variable_info$variable_id

###strain level
# idx <- grep("t__", variable_info$variable_id)
idx <- grep("s__", variable_info$variable_id)

variable_info2 <-
  variable_info$variable_id %>%
  purrr::map(function(x) {
    cat(x, " ")
    
    kingdom <-
      stringr::str_extract(x, "(^k__(.*?)\\|)|^k__(.*?)$") %>%
      stringr::str_replace_all("k__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    phylum <-
      stringr::str_extract(x, "(p__(.*?)\\|)|^p__(.*?)$") %>%
      stringr::str_replace_all("p__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    class <-
      stringr::str_extract(x, "(c__(.*?)\\|)|^c__(.*?)$") %>%
      stringr::str_replace_all("c__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    order <-
      stringr::str_extract(x, "(o__(.*?)\\|)|^o__(.*?)$") %>%
      stringr::str_replace_all("o__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    family <-
      stringr::str_extract(x, "(f__(.*?)\\|)|^f__(.*?)$") %>%
      stringr::str_replace_all("f__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    genus <-
      stringr::str_extract(x, "(g__(.*?)\\|)|^g__(.*?)$") %>%
      stringr::str_replace_all("g__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    species <-
      stringr::str_extract(x, "(s__(.*?)\\|)|^s__(.*?)$") %>%
      stringr::str_replace_all("s__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    strain <-
      stringr::str_extract(x, "(t__(.*?)\\|)|^t__(.*?)$") %>%
      stringr::str_replace_all("t__", "") %>%
      stringr::str_replace_all("\\|", "")
    
    c(
      Kingdom = kingdom,
      Phylum = phylum,
      Class = class,
      Order = order,
      Family = family,
      Genus = genus,
      Species = species,
      Strain = strain
    )
  }) %>%
  do.call(rbind, .) %>%
  as.data.frame()

rownames(expression_data) <-
  paste("OTU", 1:nrow(expression_data), sep = "_")

variable_info2$variable_id <-
  rownames(expression_data)

variable_info2 <-
  variable_info2 %>%
  dplyr::filter(!is.na(Species))

expression_data2 <-
  expression_data[variable_info2$variable_id, ]

library(microbiomedataset)

sample_info$class <- "Subject"

gut_microbiome_data <-
  create_microbiome_dataset(
    expression_data = expression_data2,
    sample_info = sample_info,
    variable_info = variable_info2
  )

save(gut_microbiome_data, file = "gut_microbiome_data.rda")

gut_microbiome_data@expression_data %>%
  apply(2, sum) %>% plot()

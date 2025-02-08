#import packages
packages_names <- c('tidyverse', 'readxl', 'writexl')
lapply(packages_names, require, character.only = TRUE)

#import result files
RIC_01232025_result <- read_xlsx(
  'data_source/raw_data/RIC_01232025.xlsx', 
  col_names = TRUE,
  .name_repair = 'universal'
)

#import packages
packages_names <- c('tidyverse', 'readxl', 'writexl')
lapply(packages_names, require, character.only = TRUE)

#import result files
RIC_01232025_result <- read_xlsx(
  'data_source/raw_data/RIC_01232025.xlsx', 
  col_names = TRUE,
  .name_repair = 'universal'
) |> 
  rowwise() |> 
  mutate(
    noCL_4 = ifelse(is.na(noCL_4), (noCL_5 + noCL_6)/2, noCL_4),
    noCL_5 = ifelse(is.na(noCL_5), (noCL_4 + noCL_6)/2, noCL_5)
  ) |> 
  ungroup()



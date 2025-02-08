#import packages
packages_names <- c('tidyverse', 'readxl', 'writexl')
lapply(packages_names, require, character.only = TRUE)

#raw file

#normalized data
#sample loading
RIC_01232025_result_raw_sl <- read_xlsx('data_source/data_normalization/RIC_01232025_result_raw_sl.xlsx')
#TMM
RIC_01232025_result_raw_sl_tmm <- read_xlsx('data_source/data_normalization/RIC_01232025_result_raw_sl_tmm.xlsx')

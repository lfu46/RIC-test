#import packages
packages_names <- c('tidyverse', 'readxl', 'writexl', 'VennDiagram')
lapply(packages_names, require, character.only = TRUE)

#generate RNA binding protein list
RBP_list <- RIC_01232025_result_toptable_tb |> 
  filter(logFC > 1, adj.P.Val < 0.01) |> 
  distinct(UniProt_Accession) |> 
  pull()

#load RNA binding protein database
Human_RBP_database <- read_delim(
  'data_source/Human_RBP_database/Table_HS_RBP.txt',
  skip = 6,
  col_names = TRUE,
  name_repair = 'universal'
)

human_RBP_list <- Human_RBP_database |> 
  distinct(Uniprot_ID) |> 
  pull()

#venn diagram
venn.diagram(
  x = list(RBP_list, human_RBP_list), 
  category.names = c('Exp_RBP\n(4296)', 'human_RBP\n(6100)'),
  filename = 'venn_diagram.tiff',
  imagetype = 'tiff',
  height = 2,
  width = 2,
  units = 'in',
  
  lwd = 1,
  col=c("#440154ff", '#21908dff'),
  fill = c(alpha("#440154ff",0.3), alpha('#21908dff',0.3)),
  resolution = 1200,
  cat.cex = 0.6,
  cat.pos = c(-30, 150),
  cat.dist = c(0.045, 0.045)
)

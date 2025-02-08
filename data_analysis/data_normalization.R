#import packages
packages_names <- c('tidyverse', 'readxl', 'writexl', 'limma', 'edgeR')
lapply(packages_names, require, character.only = TRUE)

#check the distribution of intensity of each channel
boxplot_protein_raw <- RIC_01232025_result |> 
  select(CL_1:noCL_6) |> 
  pivot_longer(cols = CL_1:noCL_6, names_to = 'Exp', values_to = 'Intensity') |> 
  mutate(log2_intensity = log2(Intensity)) |> 
  ggplot() +
  geom_boxplot(
    aes(x = factor(Exp, levels = c('CL_1', 'CL_2', 'CL_3', 'noCL_4', 'noCL_5', 'noCL_6')),
        y = log2_intensity)
  ) +
  labs(x = '', y = expression(log[2]*'(intensity)')) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

ggsave(
  filename = 'data_source/data_normalization/figures/boxplot_protein_raw.tiff',
  plot = boxplot_protein_raw,
  height = 3, width = 3, units = 'in', dpi = 1200
)

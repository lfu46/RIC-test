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

#sample loading normalization
target_mean_protein_CL <- mean(colSums(RIC_01232025_result |> select(CL_1:CL_3)))
norm_facs_protein_CL <- target_mean_protein_CL/colSums(RIC_01232025_result |> select(CL_1:CL_3))
protein_CL_sl <- tibble(sweep(RIC_01232025_result |> select(CL_1:CL_3), 2, norm_facs_protein_CL, FUN = '*'))
colnames(protein_CL_sl) <- c('CL_1_sl', 'CL_2_sl', 'CL_3_sl')

target_mean_protein_noCL <- mean(colSums(RIC_01232025_result |> select(noCL_4:noCL_6)))
norm_facs_protein_noCL <- target_mean_protein_noCL/colSums(RIC_01232025_result |> select(noCL_4:noCL_6))
protein_noCL_sl <- tibble(sweep(RIC_01232025_result |> select(noCL_4:noCL_6), 2, norm_facs_protein_noCL, FUN = '*'))
colnames(protein_noCL_sl) <- c('noCL_4_sl', 'noCL_5_sl', 'noCL_6_sl')

RIC_01232025_result_raw_sl <- bind_cols(RIC_01232025_result, protein_CL_sl, protein_noCL_sl)
write_xlsx(RIC_01232025_result_raw_sl, path = 'data_source/data_normalization/RIC_01232025_result_raw_sl.xlsx')

#check the distribution of intensity of each sl channel
boxplot_protein_raw_sl <- RIC_01232025_result_raw_sl |> 
  select(CL_1_sl:noCL_6_sl) |> 
  pivot_longer(cols = CL_1_sl:noCL_6_sl, names_to = 'Exp', values_to = 'Intensity') |> 
  mutate(log2_intensity = log2(Intensity)) |> 
  ggplot() +
  geom_boxplot(
    aes(x = factor(Exp, levels = c('CL_1_sl', 'CL_2_sl', 'CL_3_sl', 'noCL_4_sl', 'noCL_5_sl', 'noCL_6_sl')),
        y = log2_intensity)
  ) +
  labs(x = '', y = expression(log[2]*'(intensity)')) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

ggsave(
  filename = 'data_source/data_normalization/figures/boxplot_protein_raw_sl.tiff',
  plot = boxplot_protein_raw_sl,
  height = 3, width = 3, units = 'in', dpi = 1200
)

#TMM normalization
norm_facs_protein_sl_tmm_CL <- calcNormFactors(RIC_01232025_result_raw_sl |> select(CL_1_sl:CL_3_sl))
protein_tmm_CL <- tibble(sweep(RIC_01232025_result_raw_sl |> select(CL_1_sl:CL_3_sl), 2, norm_facs_protein_sl_tmm_CL, FUN = "/"))
colnames(protein_tmm_CL) <- c(
  'CL_1_sl_tmm', 'CL_2_sl_tmm', 'CL_3_sl_tmm'
)

norm_facs_protein_sl_tmm_noCL <- calcNormFactors(RIC_01232025_result_raw_sl |> select(noCL_4_sl:noCL_6_sl))
protein_tmm_noCL <- tibble(sweep(RIC_01232025_result_raw_sl |> select(noCL_4_sl:noCL_6_sl), 2, norm_facs_protein_sl_tmm_noCL, FUN = "/"))
colnames(protein_tmm_noCL) <- c(
  'noCL_4_sl_tmm', 'noCL_5_sl_tmm', 'noCL_6_sl_tmm'
)

RIC_01232025_result_raw_sl_tmm <- bind_cols(RIC_01232025_result_raw_sl, protein_tmm_CL, protein_tmm_noCL)
write_xlsx(RIC_01232025_result_raw_sl_tmm, path = 'data_source/data_normalization/RIC_01232025_result_raw_sl_tmm.xlsx')

#check the distribution of intensity of each sl tmm channel
boxplot_protein_raw_sl_tmm <- RIC_01232025_result_raw_sl_tmm |> 
  select(CL_1_sl_tmm:noCL_6_sl_tmm) |> 
  pivot_longer(cols = CL_1_sl_tmm:noCL_6_sl_tmm, names_to = 'Exp', values_to = 'Intensity') |> 
  mutate(log2_intensity = log2(Intensity)) |> 
  ggplot() +
  geom_boxplot(
    aes(x = factor(Exp, levels = c('CL_1_sl_tmm', 'CL_2_sl_tmm', 'CL_3_sl_tmm', 'noCL_4_sl_tmm', 'noCL_5_sl_tmm', 'noCL_6_sl_tmm')),
        y = log2_intensity)
  ) +
  labs(x = '', y = expression(log[2]*'(intensity)')) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

ggsave(
  filename = 'data_source/data_normalization/figures/boxplot_protein_raw_sl_tmm.tiff',
  plot = boxplot_protein_raw_sl_tmm,
  height = 3, width = 3, units = 'in', dpi = 1200
)

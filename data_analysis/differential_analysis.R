#import packages
packages_names <- c("tidyverse", "limma", "showtext", "writexl")
lapply(packages_names, require, character.only = TRUE)

#experiment model
Experiment_Model <- model.matrix(~ 0 + factor(rep(c("case1", "case2"), each = 3), levels = c("case1", "case2")))
colnames(Experiment_Model) <- c("case1", "case2")
Contrast_matrix <- makeContrasts(case1_case2 = case1 - case2, levels = Experiment_Model)

#differential analysis
RIC_01232025_result_raw_sl_tmm_log2_transformed <- RIC_01232025_result_raw_sl_tmm |> 
  mutate(
    log2_CL_1_sl_tmm = log2(CL_1_sl_tmm),
    log2_CL_2_sl_tmm = log2(CL_2_sl_tmm),
    log2_CL_3_sl_tmm = log2(CL_3_sl_tmm),
    log2_noCL_4_sl_tmm = log2(noCL_4_sl_tmm),
    log2_noCL_5_sl_tmm = log2(noCL_5_sl_tmm),
    log2_noCL_6_sl_tmm = log2(noCL_6_sl_tmm)
  )

RIC_01232025_result_raw_sl_tmm_log2_transformed_Data_Matrix <- data.matrix(RIC_01232025_result_raw_sl_tmm_log2_transformed |> select(starts_with("log2")))
rownames(RIC_01232025_result_raw_sl_tmm_log2_transformed_Data_Matrix) <- RIC_01232025_result_raw_sl_tmm_log2_transformed$Index

RIC_01232025_result_raw_sl_tmm_log2_transformed_Fit <- lmFit(RIC_01232025_result_raw_sl_tmm_log2_transformed_Data_Matrix, Experiment_Model)
RIC_01232025_result_raw_sl_tmm_log2_transformed_Fit_Contrast <- contrasts.fit(RIC_01232025_result_raw_sl_tmm_log2_transformed_Fit, Contrast_matrix)
RIC_01232025_result_raw_sl_tmm_log2_transformed_Fit_Contrast <- eBayes(RIC_01232025_result_raw_sl_tmm_log2_transformed_Fit_Contrast)
RIC_01232025_result_toptable <- topTable(RIC_01232025_result_raw_sl_tmm_log2_transformed_Fit_Contrast, number = Inf, adjust.method = 'BH')

Rownames_RIC_01232025_result_toptable <- rownames(RIC_01232025_result_toptable)
RIC_01232025_result_toptable_tb <- tibble(RIC_01232025_result_toptable)
RIC_01232025_result_toptable_tb$UniProt_Accession <- Rownames_RIC_01232025_result_toptable

write_xlsx(RIC_01232025_result_toptable_tb, path = paste0('data_source/differential_analysis/RIC_01232025_result_toptable_tb.xlsx'))

#import packages
packages_names <- c('tidyverse', 'readxl', 'writexl')
lapply(packages_names, require, character.only = TRUE)

#volcano plot
volcano_plot_RIC_01232025 <- ggplot() +
  geom_point(
    data = RIC_01232025_result_toptable_tb |> filter(adj.P.Val > 0.01),
    aes(
      x = logFC,
      y = -log10(adj.P.Val)
    ), 
    color = 'gray'
  ) +
  geom_point(
    data = RIC_01232025_result_toptable_tb |> filter(adj.P.Val <= 0.01, logFC > 0.5),
    aes(
      x = logFC,
      y = -log10(adj.P.Val)
    ),
    color = '#440154ff'
  ) +
  labs(x = expression(log[2]*'(CL/noCL)'), y = expression(-log[10]*'(adjusted p value)'))

ggsave(
  filename = 'volcano_plot_RIC_01232025.tiff',
  plot = volcano_plot_RIC_01232025,
  height = 3, width = 3, units = 'in', dpi = 1200
)

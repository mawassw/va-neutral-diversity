# ==============================================================================
# figS_maps.R — Fig. S_maps: three ways of evaluating Q^2 on a chromosome
# (Appendix C), relative to the Haldane chromosome average used in the analysis
# ==============================================================================
#   Haldane average   Q2bar_haldane() from linked.R (Eq. C_closed_haldane)
#   linear average    Eq. closed_form, 2/[MZ(1-Z)] - 2/(MZ)^2 ln(1 + MZ/(1-Z))
#   mid-segment       linear-map profile at y = M/2 (Buffalo and Kern 2024,
#                     Supplementary Eq. 33): 1/[(1-Z)(1-Z+ZM/2)]
# One effect class, Z = 1 - s. Run from the repo root. Writes supp/FigS_maps.pdf/.tiff.
# ==============================================================================

library(ggplot2)
library(patchwork)
source("scripts/R/linked.R")
source("scripts/R/theme_genetics.R")

q2_linear_avg <- function(M, Z) 2 / (M * Z * (1 - Z)) - 2 / (M * Z)^2 * log1p(M * Z / (1 - Z))
q2_linear_mid <- function(M, Z) 1 / ((1 - Z) * (1 - Z + Z * M / 2))

M_breaks <- c(0.01, 0.1, 1, 10)
M_labels <- c("0.01", "0.1", "1", "10")

# ---- panel a: ratios against map length at three purging rates ---------------
M_grid <- 10^seq(-2, log10(50), length.out = 300)
s_vals <- c(0.1, 0.01, 0.001)
a_df <- do.call(rbind, lapply(s_vals, function(s) {
  Z <- 1 - s
  H <- Q2bar_haldane(M_grid, Z)
  rbind(data.frame(M = M_grid, s = s, ratio = q2_linear_mid(M_grid, Z) / H,
                   method = "Linear map, mid-segment"),
        data.frame(M = M_grid, s = s, ratio = q2_linear_avg(M_grid, Z) / H,
                   method = "Linear map, chromosome average"))
}))
a_df$s <- factor(a_df$s, levels = s_vals, labels = paste0("s = ", s_vals))
a_df$method <- factor(a_df$method, levels = c("Linear map, mid-segment",
                                              "Linear map, chromosome average"))
s_cols <- setNames(c("#0072B2", "#009E73", "#D55E00"), levels(a_df$s))

pa <- ggplot(a_df, aes(M, ratio, colour = s, linetype = method)) +
  geom_hline(yintercept = 1, linewidth = 0.35, colour = "grey40") +
  geom_line(linewidth = 0.6) +
  scale_x_log10("Map length, M (Morgans)", breaks = M_breaks, labels = M_labels) +
  scale_y_log10(expression("Relative to the Haldane average " * bar(Q^2)[H]),
                breaks = c(0.1, 0.2, 0.5, 1), labels = c("0.1", "0.2", "0.5", "1")) +
  scale_colour_manual(values = s_cols, name = NULL) +
  scale_linetype_manual(values = c("solid", "dashed"), name = NULL) +
  theme_genetics(grid_y = TRUE) +
  theme(legend.position = "bottom", legend.box = "vertical",
        legend.spacing.y = grid::unit(0, "mm"))

# ---- panel b: mid-segment / Haldane average over (M, s), binned ---------------
g_M <- 10^seq(-2, log10(50), length.out = 160)
g_s <- 10^seq(-4, -0.5, length.out = 140)
b_df <- expand.grid(M = g_M, s = g_s)
b_df$ratio <- with(b_df, q2_linear_mid(M, 1 - s) / Q2bar_haldane(M, 1 - s))
b_df$bin <- cut(b_df$ratio, c(0, 0.5, 0.9, 1.1, Inf), right = FALSE,
                labels = c("< 0.5", "0.5 to 0.9", "0.9 to 1.1", "> 1.1"))
bin_cols <- c("< 0.5" = "#2166AC", "0.5 to 0.9" = "#92C5DE", "0.9 to 1.1" = "grey95",
              "> 1.1" = "#F4A582")

pb <- ggplot(b_df, aes(M, s)) +
  geom_raster(aes(fill = bin)) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", linewidth = 0.4) +   # M = s
  geom_abline(intercept = 0, slope = -1, linetype = "dotted", linewidth = 0.4) +  # M = 1/s
  annotate("text", x = 0.06, y = 0.12, label = "M = s", hjust = 1,
           size = pt_mm(7), family = fig_family) +
  annotate("text", x = 2.6, y = 0.2, label = "M = 1/s", hjust = 1,
           size = pt_mm(7), family = fig_family) +
  scale_x_log10("Map length, M (Morgans)", breaks = M_breaks, labels = M_labels,
                expand = c(0, 0)) +
  scale_y_log10(expression("Purging rate, " * s == 1 - Z), breaks = c(1e-4, 1e-3, 1e-2, 1e-1),
                labels = c("0.0001", "0.001", "0.01", "0.1"), expand = c(0, 0)) +
  scale_fill_manual("Mid-segment value relative to the Haldane average",
                    values = bin_cols, drop = FALSE) +
  coord_cartesian(xlim = range(g_M), ylim = range(g_s)) +
  theme_genetics() +
  theme(legend.position = "bottom", legend.title.position = "top")

p <- (pa | pb) + plot_annotation(tag_levels = "a")

ggsave("supp/FigS_maps.pdf", p, width = 178, height = 95, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_maps.tiff", p, width = 178, height = 95, units = "mm", dpi = 600,
       compression = "lzw")

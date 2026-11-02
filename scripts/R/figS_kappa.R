# ==============================================================================
# figS_kappa.R — Fig. S_kappa: the mating-system scalar kappa against the
# extra-pair paternity rate alpha under Models A and B (Appendix B, app:B_limits)
# ==============================================================================
# kappa_A() and kappa_B() from kappa.R (Z = 1, r_mf = 0). Points: the socially
# monogamous populations at their EPP rate (data/species_EPP.csv). Run from the
# repo root. Writes supp/FigS_kappa.pdf and .tiff.
# ==============================================================================

library(ggplot2)
source("scripts/R/kappa.R")
source("scripts/R/theme_genetics.R")

epp <- read.csv("data/species_EPP.csv", check.names = FALSE)
mono <- epp[epp$`Mating system` == "monogamous", ]
mono$alpha <- as.numeric(mono$EPP)

models <- c("Model B", "Model A")
model_cols <- c("Model B" = "#0072B2", "Model A" = "#D55E00")

alpha <- seq(0, 1, by = 0.005)
curves <- rbind(
  data.frame(alpha = alpha, kappa = kappa_B(alpha), model = "Model B"),
  data.frame(alpha = alpha, kappa = kappa_A(alpha), model = "Model A")
)
curves$model <- factor(curves$model, levels = models)

pops <- rbind(
  data.frame(alpha = mono$alpha, kappa = kappa_B(mono$alpha), model = "Model B"),
  data.frame(alpha = mono$alpha, kappa = kappa_A(mono$alpha), model = "Model A")
)
pops$model <- factor(pops$model, levels = models)

p <- ggplot(curves, aes(alpha, kappa, colour = model)) +
  geom_hline(yintercept = 1, linetype = "dashed", linewidth = 0.4, colour = "grey40") +
  annotate("text", x = 1, y = 1.04, label = "random mating", hjust = 1, vjust = 0,
           size = pt_mm(7), family = fig_family, colour = "grey30") +
  geom_line(linewidth = 0.7) +
  geom_point(data = pops, shape = 21, fill = "white", size = 1.6, stroke = 0.5) +
  geom_rug(data = mono, aes(x = alpha), inherit.aes = FALSE, sides = "b",
           length = grid::unit(1.5, "mm"), linewidth = 0.3, colour = "grey30") +
  scale_colour_manual(values = model_cols, name = NULL) +
  scale_x_continuous(expression("Extra-pair paternity rate, " * alpha),
                     limits = c(0, 1), breaks = seq(0, 1, 0.2), expand = c(0.01, 0)) +
  scale_y_continuous(expression("Mating-system scalar, " * kappa),
                     limits = c(0, 2.05), breaks = seq(0, 2, 0.5), expand = c(0, 0)) +
  theme_genetics(grid_y = TRUE) +
  theme(legend.position = c(0.2, 0.2))

ggsave("supp/FigS_kappa.pdf", p, width = 86, height = 70, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_kappa.tiff", p, width = 86, height = 70, units = "mm", dpi = 600,
       compression = "lzw")

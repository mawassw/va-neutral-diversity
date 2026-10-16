# ==============================================================================
# figS_ceiling.R — Supplementary figure: the most V_A observed diversity allows
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/figS_ceiling.R
# Reads only through load_data.R. Writes supp/FigS_ceiling.{pdf,tiff}.
#
# delta = pi / (4 mu N_c): observed diversity relative to its neutral
# expectation. The unlinked model predicts delta = 1 / (1 + 4 kappa V_A), so a
# population with diversity delta can carry at most
#   V_A,max(delta) = (1 - delta) / (4 kappa delta)
# before the model predicts less diversity than is observed. The curve is the
# object: anyone with a delta reads their ceiling off it.
#   band     V_A,max for kappa from 1 (no pair bond) to 2 (strict monogamy)
#   grey     V_A > 1, outside the formula's domain; the ceiling enters the
#            domain at delta = 1 / (1 + 4 kappa), 0.11 to 0.2
#   y rug    the 19 measured hat V_A (posterior modes)
#   x rug    observed delta for the 8 populations with pi and an own-species
#            Buffalo N_c (Soay excluded: domestic Ovis aries census)
# The measured values are shown only as rugs: Figure 1 shows them by population.
# (Was main/Fig3_ceiling, two panels; moved to the supplement 2026-10-16.)
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")

pops <- load_populations("va")
obs <- load_diversity()

d <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(delta = coalesce(pi_obs, pi_lit) / (4 * mu_direct * 10^log10_Nc)) %>%
  filter(!is.na(delta), code != "SSH")

col_req <- "#D95F0E"
x_lo <- 1e-5; y_lo <- 1e-3; y_hi <- 1e4

curve <- tibble::tibble(delta = 10^seq(log10(x_lo), -1e-4, length.out = 400)) %>%
  mutate(k1 = (1 - delta) / (4 * delta), k2 = (1 - delta) / (8 * delta))
d_enter <- c(k2 = 1 / (1 + 8), k1 = 1 / (1 + 4))   # where the ceiling reaches V_A = 1

p <- ggplot() +
  annotate("rect", xmin = x_lo, xmax = 1, ymin = 1, ymax = y_hi, fill = "grey88") +
  annotate("text", x = x_lo * 1.4, y = 4e3, hjust = 0, size = 2.3, fontface = "bold",
           colour = "grey25", parse = TRUE,
           label = 'bold("Outside the model\'s domain:")~bolditalic(V)[bold(A)]~bold("> 1")') +
  geom_ribbon(data = curve, aes(x = delta, ymin = pmax(k2, y_lo), ymax = pmin(pmax(k1, y_lo), y_hi)),
              fill = col_req, alpha = 0.3) +
  geom_line(data = curve, aes(delta, pmin(k1, y_hi)), colour = col_req, linewidth = 0.6) +
  geom_line(data = curve, aes(delta, pmin(k2, y_hi)), colour = col_req, linewidth = 0.6) +
  annotate("text", x = 1.2e-3, y = 1.6e3, parse = TRUE, colour = col_req, size = 2.8, hjust = 0,
           label = 'italic(V)[A*","*max](delta) == frac(1 - delta, 4*kappa*delta)') +
  annotate("text", x = 1.2e-3, y = 450, colour = col_req, size = 2.3, hjust = 0,
           label = "band: κ = 1 (no pair bond) to 2 (strict monogamy)") +
  # where the ceiling enters the domain
  annotate("segment", x = d_enter, xend = d_enter, y = y_lo, yend = 1,
           linetype = "22", linewidth = 0.35, colour = "grey40") +
  annotate("text", x = 0.105, y = 2.5e-3, hjust = 1, size = 2.3, colour = "grey25", lineheight = 0.9,
           label = "ceiling enters the domain\nat δ = 0.11–0.2") +
  # measured values, as rugs
  geom_rug(data = pops, aes(y = va_mode), sides = "l", length = unit(2, "mm"),
           linewidth = 0.35, colour = "grey15") +
  geom_rug(data = d, aes(x = delta), sides = "b", length = unit(2, "mm"),
           linewidth = 0.35, colour = "grey15") +
  scale_x_log10(breaks = 10^seq(-5, 0), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  scale_y_log10(breaks = 10^seq(-3, 4), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  coord_cartesian(xlim = c(x_lo, 1), ylim = c(y_lo, y_hi)) +
  labs(x = expression("Observed diversity relative to its neutral expectation, " *
                        delta == pi / 4 * mu * italic(N)[c]),
       y = expression("Additive genetic variance in relative fitness, " * italic(V)[A])) +
  theme_classic(base_size = 9, base_family = "sans") +
  theme(panel.grid.major = element_line(colour = "grey92", linewidth = 0.3),
        plot.margin = margin(3, 4, 2, 2, "mm"))

dir.create("supp", showWarnings = FALSE)
ggsave("supp/FigS_ceiling.pdf", p, width = 120, height = 95, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_ceiling.tiff", p, width = 120, height = 95, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW")))
  ggsave(Sys.getenv("FIG_PREVIEW"), p, width = 120, height = 95, units = "mm", dpi = 200,
         device = ragg::agg_png)

# delta below which each measured V_A is allowed (V_A <= V_A,max): delta <= 1/(1+4 kappa V_A)
allow <- pops %>% mutate(delta_star = 1 / (1 + 4 * kappa * va_mode))
cat(sprintf("observed delta: %.2g to %.2g\nmeasured V_A would be ruled out only above delta = %.2f to %.2f\n",
            min(d$delta), max(d$delta), min(allow$delta_star), max(allow$delta_star)))

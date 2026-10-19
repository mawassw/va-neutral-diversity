# ==============================================================================
# figS_ceiling.R — Supplementary figure: the V_A ceiling set by observed diversity
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/figS_ceiling.R
# Reads only through load_data.R. Writes supp/FigS_ceiling.{pdf,tiff}.
#
# delta = pi / (4 mu N_c): observed diversity relative to its neutral
# expectation. The curve is the object: anyone with a delta reads their ceiling
# off it. Two forms of one model of fitness (Theory, decided 2026-10-19):
#   first order   V_A,max = (1 - delta) / (4 kappa delta), the inversion of
#                 1/(1 + 4 kappa V_A); drawn only inside its domain, V_A,max <= 1,
#                 i.e. delta >= 1 / (1 + 4 kappa) (0.11 to 0.2). Band: kappa 1 to 2.
#   all orders    V_A,max = ln(1/delta) / (4 kappa_mult), the inversion of the
#                 multiplicative upper bound on the reduction, so the smallest V_A
#                 that could account for delta. Band: kappa_mult 1 (no pair bond)
#                 to 2 (pair bond).
#   y rug    the 19 measured hat V_A (posterior modes)
#   x rug    observed delta for the populations with pi and an own-species
#            Buffalo N_c (Soay excluded: domestic Ovis aries census)
# The measured values are shown only as rugs: Figure 1 shows them by population.
# (Was main/Fig3_ceiling, two panels; moved to the supplement 2026-10-16. Until
# 2026-10-19 it showed the first-order curve alone, with a grey region above V_A = 1.)
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

col_first <- "#7A0177"; col_mult <- "#D95F0E"
x_lo <- 1e-5; y_lo <- 1e-3; y_hi <- 10

curve <- tibble::tibble(delta = 10^seq(log10(x_lo), -1e-4, length.out = 400)) %>%
  mutate(f1 = vamax_first(delta, 1), f2 = vamax_first(delta, 2),
         m1 = vamax_mult(delta, 1),  m2 = vamax_mult(delta, 2))
# first order only inside its domain, V_A,max <= 1
first <- curve %>%
  filter(f2 <= 1) %>%
  mutate(f1 = if_else(f1 <= 1, f1, NA_real_))
d_enter <- c(1 / (1 + 8), 1 / (1 + 4))

p <- ggplot() +
  geom_hline(yintercept = 1, linewidth = 0.3, linetype = "22", colour = "grey40") +
  # all orders, multiplicative upper bound
  geom_ribbon(data = curve, aes(x = delta, ymin = m2, ymax = m1), fill = col_mult, alpha = 0.3) +
  geom_line(data = curve, aes(delta, m1), colour = col_mult, linewidth = 0.6) +
  geom_line(data = curve, aes(delta, m2), colour = col_mult, linewidth = 0.6) +
  # first order, inside its domain
  geom_ribbon(data = first, aes(x = delta, ymin = f2, ymax = coalesce(f1, 1)), fill = col_first,
              alpha = 0.25) +
  geom_line(data = filter(first, !is.na(f1)), aes(delta, f1), colour = col_first, linewidth = 0.6) +
  geom_line(data = first, aes(delta, f2), colour = col_first, linewidth = 0.6) +
  annotate("text", x = 1.4e-5, y = 5.2, parse = TRUE, colour = col_mult, size = 2.6, hjust = 0,
           label = '"All orders:"~~italic(V)[A*","*max] == frac(ln(1/delta), 4*kappa[mult])') +
  annotate("text", x = 1.4e-5, y = 0.62, colour = col_mult, size = 2.2, hjust = 0, lineheight = 0.9,
           label = "from the upper bound on the reduction: the least variance\nthat could explain δ; upper line no pair bond, lower pair bond") +
  annotate("text", x = 0.06, y = 0.012, parse = TRUE, colour = col_first, size = 2.6, hjust = 1,
           label = '"First order:"~~italic(V)[A*","*max] == frac(1 - delta, 4*kappa*delta)') +
  annotate("text", x = 0.06, y = 0.0045, colour = col_first, size = 2.2, hjust = 1, lineheight = 0.9,
           label = "drawn inside its domain, ceiling ≤ 1 (δ ≥ 0.11–0.2);\nband κ = 1 to 2") +
  annotate("segment", x = d_enter, xend = d_enter, y = y_lo, yend = 1,
           linetype = "22", linewidth = 0.3, colour = "grey55") +
  # measured values, as rugs
  geom_rug(data = pops, aes(y = va_mode), sides = "l", length = unit(2, "mm"),
           linewidth = 0.35, colour = "grey15") +
  geom_rug(data = d, aes(x = delta), sides = "b", length = unit(2, "mm"),
           linewidth = 0.35, colour = "grey15") +
  scale_x_log10(breaks = 10^seq(-5, 0), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  scale_y_log10(breaks = 10^seq(-3, 1), labels = scales::label_math(10^.x, format = log10),
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

need <- d %>% mutate(v = vamax_mult(delta, kappa_mult_bound(pair_bond == "social_monogamy")))
cat(sprintf("n = %d populations with delta: %.2g to %.2g\nleast V_A that could explain them: %.2f to %.2f; measured modes at most %.2f\n",
            nrow(d), min(d$delta), max(d$delta), min(need$v), max(need$v), max(pops$va_mode)))

# ==============================================================================
# fig3_ceiling.R — Figure 3: the V_A ceiling set by observed diversity
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig3_ceiling.R
# Reads only through load_data.R. Writes main/Fig3_ceiling.{pdf,tiff}.
#
# delta = pi / (4 mu N_c): observed diversity relative to its neutral
# expectation. The curve is the object: anyone with a delta reads their ceiling
# off it. Two forms of one model of fitness (Theory, decided 2026-10-19):
#   first order   V_A,max = (1 - delta) / (4 kappa delta), the inversion of
#                 1/(1 + 4 kappa V_A); drawn only inside its domain, V_A,max <= 1,
#                 i.e. delta >= 1 / (1 + 4 kappa) (0.11 to 0.2). Band: kappa 1 to 2.
#   all orders    V_A,max = ln(1/delta) / (4 kappa(0)), the inversion of the
#                 multiplicative upper bound on the reduction, so the smallest V_A
#                 that could account for delta. Band: kappa(0) = 1 (no pair bond)
#                 to 2 (pair bond).
#   y rug    the 19 measured hat V_A (posterior modes)
#   x rug    observed delta for the populations with pi and an own-species
#            Buffalo N_c (Soay excluded: domestic Ovis aries census)
# The measured values are shown only as rugs: Figure 1 shows them by population.
# (Two-panel draft 2026-10-16 -> supplement -> back to main as Figure 3, 2026-10-17,
# with the linked ceiling. Until 2026-10-19 it showed the first-order curve alone, with a
# grey region above V_A = 1; both forms of one model since, merged 2026-10-19.)
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

col_first <- "#7A0177"; col_mult <- "#D95F0E"; col_link <- "#01665E"
x_lo <- 1e-5; y_lo <- 1e-3; y_hi <- 10

curve <- tibble::tibble(delta = 10^seq(log10(x_lo), -1e-4, length.out = 400)) %>%
  mutate(f1 = vamax_first(delta, 1), f2 = vamax_first(delta, 2),
         m1 = vamax_mult(delta, 1),  m2 = vamax_mult(delta, 2))
# first order only inside its domain, V_A,max <= 1
first <- curve %>%
  filter(f2 <= 1) %>%
  mutate(f1 = if_else(f1 <= 1, f1, NA_real_))
d_enter <- c(1 / (1 + 8), 1 / (1 + 4))

# Linked ceiling, per population in the linked set: the least V_A at which the
# upper bound on the reduction with linkage, Omega_bar(V_A) exp(-4 kappa(0) V_A),
# reaches delta (Theory, sec:linkage; Q = 2 in the global factor, class-by-class
# Z_k = 1 - s_k in Omega_bar, so the curve cannot rise above the multiplicative
# band). Minimum over the measured DFEs of the population's taxon, i.e. the most
# generous one. Solved along the delta axis in log space. Rebuilt 2026-10-19 with
# linked.R; SHOW_LINKED=0 hides the curves.
show_linked <- Sys.getenv("SHOW_LINKED") != "0"
lcurve <- data.frame(code = character(), delta = numeric(), V = numeric())
if (show_linked) {
source("scripts/R/linked.R")
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")
lpops <- load_populations("linked")
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)
dfe <- dfe_reference()
d_grid <- 10^seq(log10(x_lo), -1e-3, length.out = 120)
lcurve <- bind_rows(lapply(lpops$code, function(cd) {
  a <- filter(auto, code == cd); m <- filter(a, has_map); f <- f_share(m, a, "bp")
  r <- lpops[lpops$code == cd, ]
  k0 <- kappa_mult_bound(r$pair_bond == "social_monogamy")
  tx <- if (cd %in% birds) "Birds" else "Mammals"
  Vs <- sapply(dfe$spec[dfe$taxon == tx], function(sp) {
    lom <- omega_fun(m, f, r$kappa, sp, log = TRUE)
    g <- function(lv) lom(10^lv) - 4 * k0 * 10^lv
    vapply(d_grid, function(dl) {
      if (g(log10(y_hi)) > log(dl)) return(NA_real_)          # above the plotted range
      10^uniroot(function(lv) g(lv) - log(dl), c(-8, log10(y_hi)), tol = 1e-6)$root
    }, numeric(1))
  })
  data.frame(code = cd, delta = d_grid, V = apply(Vs, 1, function(v) suppressWarnings(min(v, na.rm = TRUE))))
})) %>% mutate(V = if_else(is.finite(V), V, NA_real_))
}

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
           label = '"All orders:"~~italic(V)[A*","*max] == frac(ln(1/delta), 4*kappa(0))') +
  annotate("text", x = 1.1e-3, y = 4.3, colour = col_mult, size = 2.2, hjust = 0, lineheight = 0.9,
           label = "from the upper bound on the reduction: the least variance\nthat could explain δ; upper line no pair bond, lower pair bond") +
  annotate("text", x = 0.06, y = 0.012, parse = TRUE, colour = col_first, size = 2.6, hjust = 1,
           label = '"First order:"~~italic(V)[A*","*max] == frac(1 - delta, 4*kappa*delta)') +
  annotate("text", x = 0.06, y = 0.0045, colour = col_first, size = 2.2, hjust = 1, lineheight = 0.9,
           label = "drawn inside its domain, ceiling ≤ 1 (δ ≥ 0.11–0.2);\nband κ = 1 to 2") +
  # linked ceilings, one per linked-set population (upper bound, most generous DFE)
  { if (show_linked) list(
      geom_line(data = lcurve, aes(delta, V, group = code), colour = col_link, linewidth = 0.35,
                alpha = 0.85, na.rm = TRUE),
      annotate("text", x = 1.4e-5, y = 0.04, colour = col_link, size = 2.2, hjust = 0, lineheight = 0.9,
               label = "with linkage, per mapped population: the least variance\nthat could explain δ at the most generous measured DFE")) } +
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

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig3_ceiling.pdf", p, width = 120, height = 95, units = "mm", device = cairo_pdf)
ggsave("main/Fig3_ceiling.tiff", p, width = 120, height = 95, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW_DIR")))
  ggsave(file.path(Sys.getenv("FIG_PREVIEW_DIR"), "Fig3_ceiling.png"), p, width = 120, height = 95, units = "mm", dpi = 200,
         device = ragg::agg_png)

need <- d %>% mutate(v = vamax_mult(delta, kappa_mult_bound(pair_bond == "social_monogamy")))
cat(sprintf("n = %d populations with delta: %.2g to %.2g\nleast V_A that could explain them: %.2f to %.2f; measured modes at most %.2f\n",
            nrow(d), min(d$delta), max(d$delta), min(need$v), max(need$v), max(pops$va_mode)))

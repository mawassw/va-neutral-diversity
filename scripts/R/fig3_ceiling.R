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
#   all orders    V_A,delta = ln(1/delta) / (4 kappa_max), the inversion of the
#                 multiplicative upper bound on the reduction, so the smallest V_A
#                 that could account for delta. Band: kappa_max = 1 (no pair bond)
#                 to 2 (pair bond).
#   y rug    the 19 measured hat V_A (posterior modes)
#   points   the deficit set (pi and an own-species Buffalo N_c; Soay excluded:
#            domestic Ovis aries census) at (observed delta, hat V_A mode), bars over
#            the 95% HPD and the mu CI; a dotted line from each up to its own least
#            V_A, without linkage (orange tick) and with it (teal tick, mapped set).
#            Points replaced the x rug on 2026-10-26 (user: observed delta as dots).
# Every explanation of lines and colours is in the legend and caption, none on the
# panel (user, 2026-10-26); theme in theme_genetics.R.
# (Two-panel draft 2026-10-16 -> supplement -> back to main as Figure 3, 2026-10-17,
# with the linked ceiling. Until 2026-10-19 it showed the first-order curve alone, with a
# grey region above V_A = 1; both forms of one model since, merged 2026-10-19.)
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/theme_genetics.R")

pops <- load_populations("va")
obs <- load_diversity()

# the deficit set: observed delta (bar over the 95% CI of the direct mu, as in
# Figure 2) against the measured hat V_A (mode, 95% HPD)
d <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit),
         delta    = pi_any / (4 * mu_direct    * 10^log10_Nc),
         delta_lo = pi_any / (4 * mu_direct_hi * 10^log10_Nc),
         delta_hi = pi_any / (4 * mu_direct_lo * 10^log10_Nc),
         system = if_else(pair_bond == "social_monogamy", "sm", "rm")) %>%
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
# upper bound on the reduction with linkage, Omega_bar(V_A) exp(-4 kappa_max V_A),
# reaches delta (Theory, sec:linkage; Q = 2 in the global factor, class-by-class
# Z_k = 1 - s_k in Omega_bar, so the curve cannot rise above the multiplicative
# band). At the empirical DFE assigned to the population (data/dfe_assignment.csv,
# the same DFE as Figures 2 and 5). Solved along the delta axis in log space.
# Rebuilt 2026-10-19 with linked.R; assigned DFEs since 2026-10-20 (before: the most
# generous DFE of the taxon). SHOW_LINKED=0 hides the curves.
show_linked <- Sys.getenv("SHOW_LINKED") != "0"
lcurve <- data.frame(code = character(), delta = numeric(), V = numeric())
if (show_linked) {
source("scripts/R/linked.R")
lpops <- load_populations("linked")
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)
dfe_pop <- dfe_assigned()
d_grid <- 10^seq(log10(x_lo), -1e-3, length.out = 120)
linked_ceiling <- function(cd, deltas) {
  a <- filter(auto, code == cd); m <- filter(a, has_map); f <- f_share(m, a, "bp")
  r <- lpops[lpops$code == cd, ]
  k0 <- kappa_mult_bound(r$pair_bond == "social_monogamy")
  lom <- omega_fun(m, f, r$kappa, dfe_pop[[cd]], log = TRUE)
  g <- function(lv) lom(10^lv) - 4 * k0 * 10^lv
  vapply(deltas, function(dl) {
    if (g(log10(y_hi)) > log(dl)) return(NA_real_)          # above the plotted range
    10^uniroot(function(lv) g(lv) - log(dl), c(-8, log10(y_hi)), tol = 1e-6)$root
  }, numeric(1))
}
lcurve <- bind_rows(lapply(lpops$code, function(cd)
  data.frame(code = cd, delta = d_grid, V = linked_ceiling(cd, d_grid))))
}

# Each population's own test (added 2026-10-26): from its measured mode up to the
# least V_A that could explain its observed delta, under the multiplicative bound at
# its kappa_max (orange tick) and, where it has maps, with linkage (teal tick).
need <- d %>%
  mutate(v_unl = vamax_mult(delta, kappa_mult_bound(pair_bond == "social_monogamy")),
         v_lk = if (show_linked) vapply(seq_along(code), function(i)
                  if (code[i] %in% lpops$code) linked_ceiling(code[i], delta[i]) else NA_real_,
                  numeric(1)) else NA_real_,
         v_top = pmin(v_unl, v_lk, na.rm = TRUE))
ticks <- bind_rows(
  need %>% transmute(code, delta, V = v_unl, kind = "unl"),
  need %>% filter(!is.na(v_lk)) %>% transmute(code, delta, V = v_lk, kind = "lk"))
tick_w <- 1.6                                  # half-width of a tick, as a factor in delta

# Legend keys: a band edged by its two limiting lines; the point key carries the
# 95% HPD (vertical) and mu CI (horizontal) bars
key_band <- function(data, params, size) {
  edge <- grid::gpar(col = data$fill, lwd = 0.6 * .pt)
  grid::grobTree(
    grid::rectGrob(height = grid::unit(0.7, "npc"),
                   gp = grid::gpar(fill = alpha(data$fill, data$alpha), col = NA)),
    grid::segmentsGrob(0, 0.85, 1, 0.85, gp = edge), grid::segmentsGrob(0, 0.15, 1, 0.15, gp = edge))
}
key_cross <- function(data, params, size) {
  bar <- grid::gpar(col = "black", lwd = 0.35 * .pt)
  grid::grobTree(grid::segmentsGrob(0.2, 0.5, 0.8, 0.5, gp = bar),
                 grid::segmentsGrob(0.5, 0.05, 0.5, 0.95, gp = bar),
                 draw_key_point(data, params, size))
}
key_need <- function(data, params, size)
  grid::grobTree(
    grid::segmentsGrob(0.5, 0.05, 0.5, 0.85, gp = grid::gpar(col = "grey35", lwd = 0.4 * .pt, lty = "13")),
    grid::segmentsGrob(0.25, 0.85, 0.75, 0.85, gp = grid::gpar(col = col_mult, lwd = 0.8 * .pt)),
    grid::segmentsGrob(0.25, 0.6, 0.75, 0.6, gp = grid::gpar(col = col_link, lwd = 0.8 * .pt)))
lab_need  <- expression("Each population's test: from " * hat(italic(V))[A] *
                          " to the least " * italic(V)[A] * " that could explain its " * delta *
                          ", without and with linkage")
lab_mult  <- expression("Multiplicative bound, " * italic(V)[A*","*delta] == ln(1/delta) / 4 * kappa[max] *
                          ": the least " * italic(V)[A] * " that could explain " * delta)
lab_first <- expression("Small-variance ceiling, " * italic(V)[A*","*max] == (1 - delta) / 4 * kappa * delta *
                          ", where it holds")
lab_link  <- "Multiplicative bound with linkage, one line per mapped population"
lab_rm    <- expression("Measured " * hat(italic(V))[A] * " at observed " * delta * ": random mating")
lab_sm    <- expression("Measured " * hat(italic(V))[A] * " at observed " * delta * ": social monogamy")

p <- ggplot() +
  # V_A = 1, the limit of the small-variance approximation, and the delta at which its
  # ceiling reaches 1 (kappa = 2 and 1): described in the caption
  geom_hline(yintercept = 1, linewidth = 0.3, linetype = "22", colour = "grey40") +
  annotate("segment", x = d_enter, xend = d_enter, y = y_lo, yend = 1,
           linetype = "22", linewidth = 0.3, colour = "grey55") +
  # multiplicative bound: kappa_max = 1 (upper line) to 2 (lower line)
  geom_ribbon(data = curve, aes(x = delta, ymin = m2, ymax = m1, fill = "mult"), alpha = 0.3,
              key_glyph = key_band) +
  geom_line(data = curve, aes(delta, m1), colour = col_mult, linewidth = 0.6) +
  geom_line(data = curve, aes(delta, m2), colour = col_mult, linewidth = 0.6) +
  # small-variance ceiling, inside its domain: kappa = 1 to 2
  geom_ribbon(data = first, aes(x = delta, ymin = f2, ymax = coalesce(f1, 1), fill = "first"),
              alpha = 0.25, key_glyph = key_band) +
  geom_line(data = filter(first, !is.na(f1)), aes(delta, f1), colour = col_first, linewidth = 0.6) +
  geom_line(data = first, aes(delta, f2), colour = col_first, linewidth = 0.6) +
  # linked ceilings, one per mapped population, at its assigned DFE
  { if (show_linked)
      geom_line(data = lcurve, aes(delta, V, group = code, colour = "link"), linewidth = 0.35,
                alpha = 0.85, na.rm = TRUE) } +
  # the 19 measured hat V_A (left rug), and the deficit set as points
  geom_rug(data = pops, aes(y = va_mode), sides = "l", length = unit(2, "mm"),
           linewidth = 0.35, colour = "grey15") +
  geom_segment(data = need, aes(x = delta, xend = delta, y = va_mode, yend = v_top, linetype = "need"),
               linewidth = 0.4, colour = "grey35", key_glyph = key_need) +
  geom_segment(data = ticks, aes(x = delta / tick_w, xend = delta * tick_w, y = V, yend = V),
               colour = if_else(ticks$kind == "unl", col_mult, col_link), linewidth = 0.6) +
  scale_linetype_manual(values = c(need = "13"), labels = list(lab_need), name = NULL) +
  geom_linerange(data = d, aes(x = delta, ymin = va_hpd95_lo, ymax = va_hpd95_hi), linewidth = 0.35) +
  geom_linerange(data = d, aes(y = va_mode, xmin = delta_lo, xmax = delta_hi), linewidth = 0.35) +
  geom_point(data = d, aes(delta, va_mode, shape = system), size = 1.6, stroke = 0.6, fill = "white",
             key_glyph = key_cross) +
  scale_fill_manual(values = c(mult = col_mult, first = col_first), breaks = c("mult", "first"),
                    labels = list(lab_mult, lab_first), name = NULL) +
  scale_colour_manual(values = c(link = col_link), labels = lab_link, name = NULL) +
  scale_shape_manual(values = c(rm = 16, sm = 21), breaks = c("rm", "sm"),
                     labels = list(lab_rm, lab_sm), name = NULL) +
  guides(fill = guide_legend(order = 1, ncol = 1), colour = guide_legend(order = 2),
         shape = guide_legend(order = 3, ncol = 1), linetype = guide_legend(order = 4)) +
  scale_x_log10(breaks = 10^seq(-5, 0), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  scale_y_log10(breaks = 10^seq(-3, 1), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  coord_cartesian(xlim = c(x_lo, 1), ylim = c(y_lo, y_hi)) +
  labs(x = expression("Observed diversity relative to its neutral expectation, " *
                        delta == pi / 4 * mu * italic(N)[c]),
       y = expression("Additive genetic variance in relative fitness, " * italic(V)[A])) +
  theme_genetics(grid_x = TRUE, grid_y = TRUE) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.margin = margin(3, 4, 2, 2, "mm"))

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig3_ceiling.pdf", p, width = 120, height = 125, units = "mm", device = cairo_pdf)
ggsave("main/Fig3_ceiling.tiff", p, width = 120, height = 125, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW_DIR")))
  ggsave(file.path(Sys.getenv("FIG_PREVIEW_DIR"), "Fig3_ceiling.png"), p, width = 120, height = 125, units = "mm", dpi = 200,
         device = ragg::agg_png)

cat(sprintf("n = %d populations with delta: %.2g to %.2g\nleast V_A that could explain them: %.2f to %.2f; measured modes at most %.2f\n",
            nrow(d), min(d$delta), max(d$delta), min(need$v_unl), max(need$v_unl), max(pops$va_mode)))
print(as.data.frame(need %>% transmute(code, delta = signif(delta, 2), va_mode = signif(va_mode, 2),
                                       va_hi = signif(va_hpd95_hi, 2), v_unl = signif(v_unl, 3),
                                       v_lk = signif(v_lk, 3))))

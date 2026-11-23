# ==============================================================================
# fig3_ceiling.R — the variance each observed deficit requires
#   main/Fig3_ceiling    (printed as Figure 2): one row per population of the deficit set
#   supp/FigS_required   the general curve, V_A,delta against delta
#   supp/FigS_ceiling    the small-variance ceiling
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig3_ceiling.R
# Reads only through load_data.R.
#
# delta = pi / (4 mu N_c): observed diversity relative to its neutral expectation.
#   V_A,delta = ln(1/delta) / (4 kappa_max), the inversion of the multiplicative bound,
#               so the minimum V_A that could account for delta (kappa_max = 1 without
#               a pair bond, 2 with one).
#   V_A,max   = (1 - delta) / (4 kappa delta), the inversion of 1/(1 + 4 kappa V_A);
#               drawn only inside its domain, V_A,max <= 1 (FigS_ceiling).
#
# 2026-11-23 (user): the main figure showed the curve against delta with the deficit
# set as points, each joined to its own required value by a dotted line. The claim is
# per population, so the main figure is now population rows on a linear V_A axis (the
# layout of Figures 1 and 3): the measured hat V_A (mode, 95% HPD), the minimum V_A
# its deficit requires without linkage (orange) and with it (teal, mapped set), and
# the share of the deficit hat V_A accounts for under the multiplicative model (the
# "deficit" column of tab_reduction; shares.R). The estimate's position along the
# track from zero to V_A,delta is the same share under the multiplicative bound. The
# curve against delta moved to FigS_required.
# Fix 5 (2026-11-19, REVIEW_FIXES.md): the small-variance ceiling moved out of the
# main figure into FigS_ceiling.
# Every explanation of lines and colours is in the legend and caption, none on the
# panel (user, 2026-10-26), except the share printed at the end of each row.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(patchwork)
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
                  numeric(1)) else NA_real_)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")
row_order <- c("BTR", "BTP", "BTM", "GTU", "GTN", "CF", "SSP", "BHS", "CSM")   # as Figure 1
need <- need %>%
  mutate(kmax = kappa_mult_bound(pair_bond == "social_monogamy"),
         v_unl_lo = vamax_mult(delta_hi, kmax), v_unl_hi = vamax_mult(delta_lo, kmax),
         # share of the deficit, log scale, multiplicative model (as shares.R)
         share_model = log(reduction_mult) / log(1 / delta),
         share_bound = va_mode / v_unl,
         taxon = if_else(code %in% birds, "Birds", "Mammals"),
         label = pop_label(sub(" \\(.*\\)$", "", common_name), sub("^tiritiri", "Tiritiri", location)))
stopifnot(setequal(need$code, row_order))
need <- need %>% mutate(label = factor(label, levels = rev(label[match(row_order, code)])))
fmt_share <- function(x) if_else(x >= 0.095, sprintf("%.0f%%", 100 * x), sprintf("%.1f%%", 100 * x))

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
lab_mult  <- expression("Multiplicative bound: the minimum " * italic(V)[A] * " that could account for " * delta)
lab_first <- expression("Small-variance ceiling, " * italic(V)[A*","*max] == (1 - delta) / 4 * kappa * delta *
                          ", where it holds")
lab_rm    <- expression("Measured " * hat(italic(V))[A] * " at " * hat(delta) * ": random mating")
lab_sm    <- expression("Measured " * hat(italic(V))[A] * " at " * hat(delta) * ": social monogamy")

lab_est <- expression("Measured " * hat(italic(V))[A] * ": mode and 95% HPD")
lab_req <- expression("Minimum " * italic(V)[A] * " that could account for the observed deficit: multiplicative bound")
lab_rlk <- "The same with linkage, mapped populations"
key_hrange <- function(data, params, size)
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5, gp = grid::gpar(col = data$colour, lwd = 0.5 * .pt)),
    draw_key_point(data, params, size))

# --- Figure 2 as printed: population rows --------------------------------------
p <- ggplot(need, aes(y = label)) +
  # the track, from zero to the variance the deficit requires
  geom_linerange(aes(xmin = 0, xmax = v_unl), colour = col_mult, alpha = 0.18, linewidth = 2.6) +
  geom_linerange(aes(xmin = va_hpd95_lo, xmax = va_hpd95_hi), linewidth = 0.5) +
  geom_point(aes(x = va_mode, colour = "est"), shape = 21, fill = "grey60", size = 1.9, stroke = 0.5,
             key_glyph = key_hrange) +
  geom_point(aes(x = v_lk, colour = "lk"), shape = 18, size = 2.6, na.rm = TRUE) +
  geom_linerange(aes(xmin = v_unl_lo, xmax = v_unl_hi), colour = col_mult, linewidth = 0.5, na.rm = TRUE) +
  geom_point(aes(x = v_unl, colour = "unl"), shape = 18, size = 2.6, key_glyph = key_hrange) +
  geom_text(aes(x = coalesce(v_unl_hi, v_unl), label = fmt_share(share_model)), hjust = -0.3,
            size = pt_mm(7), family = fig_family, colour = "grey20") +
  scale_colour_manual(values = c(est = "black", unl = col_mult, lk = col_link),
                      breaks = c("est", "unl", "lk"), labels = list(lab_est, lab_req, lab_rlk),
                      name = NULL, guide = guide_legend(ncol = 1)) +
  scale_x_continuous(limits = c(0, 1.95), breaks = seq(0, 1.75, 0.25), expand = c(0, 0)) +
  facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
  labs(x = expression("Additive genetic variance in relative fitness, " * italic(V)[A]), y = NULL) +
  theme_genetics(grid_x = TRUE) +
  theme(strip.text.y = element_text(angle = 0, hjust = 0), panel.spacing = unit(2.5, "mm"),
        legend.location = "panel")

save_fig <- function(p, stem, w, h) {
  dir.create(dirname(stem), showWarnings = FALSE)
  ggsave(paste0(stem, ".pdf"), p, width = w, height = h, units = "mm", device = cairo_pdf)
  ggsave(paste0(stem, ".tiff"), p, width = w, height = h, units = "mm", dpi = 600,
         device = ragg::agg_tiff, compression = "lzw")
  pv <- Sys.getenv("FIG_PREVIEW_DIR")
  if (nzchar(pv)) ggsave(file.path(pv, paste0(basename(stem), ".png")), p, width = w, height = h,
                         units = "mm", dpi = 200, device = ragg::agg_png)
}
save_fig(p, "main/Fig3_ceiling", 178, 85)

# --- Figure S_required: the curve against delta ---------------------------------
# The orange band is V_A,delta for kappa_max = 1 (upper line) to 2 (lower line); a teal
# line per mapped population is the same with linkage at its assigned DFE; the deficit
# set is placed at its observed delta and measured hat V_A.
lcurve <- lcurve %>% mutate(taxon = if_else(code %in% birds, "Birds", "Mammals"))
lab_lk_b <- "Multiplicative bound with linkage, mapped birds"
lab_lk_m <- "Multiplicative bound with linkage, mapped mammals"
pC <- ggplot() +
  geom_ribbon(data = curve, aes(x = delta, ymin = m2, ymax = m1, fill = "mult"), alpha = 0.3,
              key_glyph = key_band) +
  geom_line(data = curve, aes(delta, m1), colour = col_mult, linewidth = 0.6) +
  geom_line(data = curve, aes(delta, m2), colour = col_mult, linewidth = 0.6) +
  { if (show_linked)
      geom_line(data = lcurve, aes(delta, V, group = code, linetype = taxon), colour = col_link,
                linewidth = 0.35, alpha = 0.85, na.rm = TRUE) } +
  geom_linerange(data = d, aes(x = delta, ymin = va_hpd95_lo, ymax = va_hpd95_hi), linewidth = 0.35) +
  geom_linerange(data = d, aes(y = va_mode, xmin = delta_lo, xmax = delta_hi), linewidth = 0.35) +
  geom_point(data = d, aes(delta, va_mode, shape = system), size = 1.6, stroke = 0.6, fill = "white",
             key_glyph = key_cross) +
  scale_fill_manual(values = c(mult = col_mult), breaks = "mult",
                    labels = list(lab_mult), name = NULL) +
  scale_linetype_manual(values = c(Birds = "solid", Mammals = "42"), labels = c(lab_lk_b, lab_lk_m),
                        name = NULL) +
  scale_shape_manual(values = c(rm = 16, sm = 21), breaks = c("rm", "sm"),
                     labels = list(lab_rm, lab_sm), name = NULL) +
  guides(fill = guide_legend(order = 1, ncol = 1),
         linetype = guide_legend(order = 2, ncol = 1, override.aes = list(colour = col_link, alpha = 1)),
         shape = guide_legend(order = 3, ncol = 1)) +
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
save_fig(pC, "supp/FigS_required", 120, 120)

cat(sprintf("n = %d populations with delta: %.2g to %.2g\nleast V_A that could explain them: %.2f to %.2f; measured modes at most %.2f\n",
            nrow(d), min(d$delta), max(d$delta), min(need$v_unl), max(need$v_unl), max(pops$va_mode)))
print(as.data.frame(need %>% transmute(code, delta = signif(delta, 2), va_mode = signif(va_mode, 2),
                                       va_hi = signif(va_hpd95_hi, 2), v_unl = signif(v_unl, 3),
                                       v_lk = signif(v_lk, 3), share_model = signif(share_model, 3),
                                       share_bound = signif(share_bound, 3))))

# ------------------------------------------------------------------------------
# Figure S_ceiling (Fix 5, 2026-11-19): the small-variance ceiling
# V_A,max = (1 - delta)/(4 kappa delta), drawn only inside its domain
# (V_A,max <= 1, delta >= 1/(1 + 4 kappa)); band kappa = 1 to 2.
# (a) Each of the 19 estimates at the delta where its mode reaches the ceiling at its
#     population's kappa (kappa_B), delta_reach = 1/(1 + 4 kappa hat V_A); the deficit
#     set at its observed delta, joined to its own delta_reach by a dotted line.
# (b) Number of the 19 modes above V_A,max(delta), each at its population's kappa
#     (the counts quoted in the supplementary note: 0 at delta <= 0.2, 2 at 0.25-0.3,
#     5 at 0.5, 15 at 0.9; as audit_numbers.R).
# ------------------------------------------------------------------------------
reach <- pops %>%
  mutate(d_reach = 1 / (1 + 4 * kappa * va_mode))
join <- d %>% select(code, delta, va_mode) %>%
  left_join(reach %>% select(code, d_reach), by = "code")
n_above <- function(dl) sum(pops$va_mode > vamax_first(dl, pops$kappa))
count_grid <- tibble::tibble(delta = 10^seq(-1.2, 0, length.out = 1200)) %>%
  mutate(n = vapply(delta, n_above, numeric(1)))
cat("\nestimates above the small-variance ceiling:\n")
for (dl in c(0.2, 0.25, 0.3, 0.5, 0.9))
  cat(sprintf("  delta %.2f: %d of %d\n", dl, n_above(dl), nrow(pops)))
cat(sprintf("delta_reach of the 19: %.2f to %.2f\n", min(reach$d_reach), max(reach$d_reach)))
cat(sprintf("orders of magnitude from observed delta to delta_reach: %.2f to %.2f\n",
            min(log10(join$d_reach / join$delta)), max(log10(join$d_reach / join$delta))))

lab_reach <- expression("Each " * hat(italic(V))[A] * " where it reaches its own ceiling")
lab_join  <- expression("From " * hat(delta) * " to where the estimate reaches its ceiling")
key_join <- function(data, params, size)
  grid::segmentsGrob(0.05, 0.5, 0.95, 0.5,
                     gp = grid::gpar(col = "grey35", lwd = 0.4 * .pt, lty = "13"))

pSa <- ggplot() +
  # V_A = 1, the limit of the small-variance approximation, and the delta at which its
  # ceiling reaches 1 (kappa = 2 and 1): described in the caption
  geom_hline(yintercept = 1, linewidth = 0.3, linetype = "22", colour = "grey40") +
  annotate("segment", x = d_enter, xend = d_enter, y = y_lo, yend = 1,
           linetype = "22", linewidth = 0.3, colour = "grey55") +
  geom_ribbon(data = first, aes(x = delta, ymin = f2, ymax = coalesce(f1, 1), fill = "first"),
              alpha = 0.25, key_glyph = key_band) +
  geom_line(data = filter(first, !is.na(f1)), aes(delta, f1), colour = col_first, linewidth = 0.6) +
  geom_line(data = first, aes(delta, f2), colour = col_first, linewidth = 0.6) +
  geom_rug(data = pops, aes(y = va_mode), sides = "l", length = unit(2, "mm"),
           linewidth = 0.35, colour = "grey15") +
  geom_segment(data = join, aes(x = delta, xend = d_reach, y = va_mode, yend = va_mode,
                                linetype = "join"),
               linewidth = 0.4, colour = "grey35", key_glyph = key_join) +
  geom_point(data = reach, aes(d_reach, va_mode, colour = "reach"), shape = 18, size = 1.8) +
  geom_linerange(data = d, aes(x = delta, ymin = va_hpd95_lo, ymax = va_hpd95_hi), linewidth = 0.35) +
  geom_linerange(data = d, aes(y = va_mode, xmin = delta_lo, xmax = delta_hi), linewidth = 0.35) +
  geom_point(data = d, aes(delta, va_mode, shape = system), size = 1.6, stroke = 0.6, fill = "white",
             key_glyph = key_cross) +
  scale_fill_manual(values = c(first = col_first), labels = list(lab_first), name = NULL) +
  scale_colour_manual(values = c(reach = col_first), labels = list(lab_reach), name = NULL) +
  scale_linetype_manual(values = c(join = "13"), labels = list(lab_join), name = NULL) +
  scale_shape_manual(values = c(rm = 16, sm = 21), breaks = c("rm", "sm"),
                     labels = list(lab_rm, lab_sm), name = NULL) +
  guides(fill = guide_legend(order = 1), colour = guide_legend(order = 2),
         linetype = guide_legend(order = 3), shape = guide_legend(order = 4, ncol = 1)) +
  scale_x_log10(breaks = 10^seq(-5, 0), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  scale_y_log10(breaks = 10^seq(-3, 1), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  coord_cartesian(xlim = c(x_lo, 1), ylim = c(y_lo, y_hi)) +
  labs(x = expression("Observed diversity relative to its neutral expectation, " * delta),
       y = expression("Additive genetic variance in relative fitness, " * italic(V)[A]),
       tag = "a") +
  theme_genetics(grid_x = TRUE, grid_y = TRUE) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.margin = margin(3, 4, 2, 2, "mm"))

pSb <- ggplot(count_grid, aes(delta, n)) +
  geom_step(colour = col_first, linewidth = 0.6) +
  scale_x_log10(breaks = c(0.1, 0.2, 0.3, 0.5, 1), labels = c("0.1", "0.2", "0.3", "0.5", "1"),
                expand = c(0, 0)) +
  scale_y_continuous(breaks = c(0, 5, 10, 15, 19), limits = c(0, 19.5), expand = c(0, 0)) +
  coord_cartesian(xlim = c(10^-1.2, 1)) +
  labs(x = expression(delta),
       y = "Estimates above the small-variance ceiling (of 19)", tag = "b") +
  theme_genetics(grid_x = TRUE, grid_y = TRUE) +
  theme(plot.margin = margin(3, 5, 2, 2, "mm"))

pS <- pSa + pSb + plot_layout(widths = c(1.6, 1))
dir.create("supp", showWarnings = FALSE)
ggsave("supp/FigS_ceiling.pdf", pS, width = 178, height = 115, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_ceiling.tiff", pS, width = 178, height = 115, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW_DIR")))
  ggsave(file.path(Sys.getenv("FIG_PREVIEW_DIR"), "FigS_ceiling.png"), pS, width = 178,
         height = 115, units = "mm", dpi = 200, device = ragg::agg_png)

# ==============================================================================
# fig5_rescaling.R — Figure 5: no long-run V_A reconciles both comparisons
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig5_rescaling.R
# Reads only through load_data.R. Writes main/Fig5_rescaling.{pdf,tiff}.
#
# Let the long-run V_A be c times the pedigree estimate: bar V_A = c * hat V_A
# (c < 1: the estimate is inflated; c > 1: it understates). For each population
# with an observed deficit, two ratios as functions of c:
#   bar V_A / (U_d s_bar)              long-run V_A over what MSD balance maintains;
#                                      rises with c. s_bar is the mean of the empirical
#                                      DFE assigned to the population (data/dfe_assignment.csv:
#                                      own species, else the closest relatives in Lin et
#                                      al. 2026), the same DFE used for the linked curve in
#                                      FigS_rescaling_linked. (Before 2026-10-20: s = 1e-2
#                                      for every population.)
#   (N_e/N)_pred / delta               diversity the model predicts is retained over the
#                                      diversity observed to be retained; falls with c.
# One model of fitness (Appendix A; decided 2026-10-19): the diversity ratio uses the
# multiplicative upper bound on the reduction, (N_e/N)_pred = exp(-4 kappa_mult bar V_A),
# kappa_mult = 2 with a pair bond and 1 without, valid at every bar V_A and the form
# most generous to explaining the deficit. Dashed: the first-order form
# 1/(1 + 4 kappa bar V_A), drawn only while bar V_A <= 1.
# A comparison agrees where its ratio is <= 1. Unlinked term only. hat V_A at the
# posterior mode; kappa Model B; direct mutation rate. Bold lines: mean over species of
# log10 ratio (populations of a species averaged first), t-based 95% CI across species.
# Faint lines: individual populations.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")
source("scripts/R/theme_genetics.R")

dfe_pop <- dfe_assigned()
s_bar <- vapply(dfe_pop, `[[`, numeric(1), "s_bar")
c_grid <- 10^seq(-4, 3, length.out = 400)
x_max <- 1e3

pops <- load_populations("va")
obs <- load_diversity()

d <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit),
         deficit = 4 * mu_direct * 10^log10_Nc / pi_any,
         pair = pair_bond == "social_monogamy",
         species = sub("^(\\S+ \\S+).*", "\\1", scientific_name),
         s_bar = unname(s_bar[code])) %>%
  # Soay: Buffalo's Ovis aries census is domestic sheep
  filter(!is.na(deficit), !is.na(U_d_direct), code != "SSH")
stopifnot(!anyNA(d$s_bar))

curves <- d %>%
  select(code, species, va_mode, kappa, pair, U_d_direct, deficit, s_bar) %>%
  tidyr::crossing(c = c_grid) %>%
  # log10 ratios, computed directly: exp(-4 kappa_mult bar V_A) underflows at large c
  mutate(msd  = log10(c * va_mode / (U_d_direct * s_bar)),
         div  = log10(deficit) - 4 * kappa_mult_bound(pair) * c * va_mode / log(10),
         div1 = if_else(c * va_mode <= 1, log10(deficit / (1 + 4 * kappa * c * va_mode)), NA_real_)) %>%
  tidyr::pivot_longer(c(msd, div, div1), names_to = "side", values_to = "l") %>%
  filter(!is.na(l)) %>%
  mutate(ratio = 10^l)

# Average: populations of a species share pi and N_c, so average within species
# first, then the mean of log10 ratio across species with a t-based 95% CI
n_sp <- n_distinct(curves$species)
avg <- curves %>%
  group_by(side, c, species) %>%
  summarise(l = mean(l), .groups = "drop") %>%
  group_by(side, c) %>%
  summarise(m = mean(l), se = sd(l) / sqrt(n()), n = n(), .groups = "drop") %>%
  mutate(t = qt(0.975, n_sp - 1),
         ratio = 10^m, lo = 10^(m - t * se), hi = 10^(m + t * se)) %>%
  # the first-order average only while every species is still drawn
  filter(side != "div1" | n == n_sp)
# drawn only while the average is on scale: past that the species curves fall steeply
# and the across-species interval says nothing
avg_plot <- avg %>% filter(m > -3.2)

# Where each average curve reaches 1, and where the two cross (best compromise)
at_one <- function(s) { a <- filter(avg, side == s); 10^approx(a$m, log10(a$c), 0)$y }
c_msd1 <- at_one("msd"); c_div1 <- at_one("div")
w <- avg %>% filter(side %in% c("msd", "div")) %>% select(side, c, m) %>%
  tidyr::pivot_wider(names_from = side, values_from = m)
c_star <- 10^approx(w$msd - w$div, log10(w$c), 0)$y
ratio_star <- 10^approx(log10(w$c), w$msd, log10(c_star))$y
stopifnot(c_msd1 < c_div1)

# Per-population values of c at which each comparison is satisfied
pop_c <- d %>%
  mutate(c_msd = U_d_direct * s_bar / va_mode,
         c_div = vamax_mult(1 / deficit, kappa_mult_bound(pair)) / va_mode,
         gap = c_div / c_msd)

col_msd <- "#2C7FB8"; col_req <- "#D95F0E"
lab_msd <- expression(bar(italic(V))[A] / italic(U)[d] * bar(italic(s)) *
                        ":  long-run " * italic(V)[A] * " ÷ the " * italic(V)[A] *
                        " MSDB maintains")
lab_div <- expression((italic(N)[e] / italic(N))[pred] / delta *
                        ":  predicted ÷ observed diversity, multiplicative bound")
lab_div1 <- expression("the same under the small-variance approximation, " * 1 / (1 + 4 * kappa * bar(italic(V))[A]) *
                         ", while " * bar(italic(V))[A] <= 1)

regimes <- tibble::tibble(
  xmin = c(1e-4, c_msd1, c_div1), xmax = c(c_msd1, c_div1, x_max),
  fill = c("msd_ok", "none", "div_ok"),
  x = sqrt(c(1e-4 * c_msd1, c_msd1 * c_div1, c_div1 * x_max)),
  lab = c("Maintainable, but\nexplains almost none\nof the lost diversity",
          "Neither maintainable\nnor enough to explain\nthe lost diversity",
          "Could explain the\nlost diversity, far\nfrom maintainable"))
lab_gap <- sprintf("no single c:\n%.0f-fold gap", c_div1 / c_msd1)

p <- ggplot(avg_plot, aes(c)) +
  geom_rect(data = regimes, aes(xmin = xmin, xmax = xmax, ymin = 1e-3, ymax = 1e5, fill = fill),
            inherit.aes = FALSE, show.legend = FALSE) +
  scale_fill_manual(values = c(msd_ok = "#EAF2F8", none = "white", div_ok = "#FBEDE3")) +
  geom_hline(yintercept = 1, linewidth = 0.4) +
  # individual populations, faint
  geom_line(data = filter(curves, side != "div1", l > -3.2),
            aes(y = ratio, colour = side, group = interaction(code, side)),
            linewidth = 0.3, alpha = 0.3) +
  # species average and 95% CI
  geom_ribbon(data = filter(avg_plot, side == "msd"), aes(ymin = lo, ymax = hi), fill = col_msd, alpha = 0.2) +
  geom_ribbon(data = filter(avg_plot, side == "div"), aes(ymin = lo, ymax = hi), fill = col_req, alpha = 0.2) +
  geom_line(aes(y = ratio, colour = side, linetype = side), linewidth = 1.1) +
  # the gap between the two agreement points
  annotate("segment", x = c_msd1, xend = c_div1, y = 0.25, yend = 0.25, linewidth = 0.4,
           arrow = arrow(ends = "both", length = unit(1.2, "mm"))) +
  annotate("text", x = sqrt(c_msd1 * c_div1), y = 0.17, label = lab_gap, vjust = 1, size = 2.1,
           fontface = "bold", lineheight = 0.9) +
  geom_label(data = regimes, aes(x = x, y = 1.6, label = lab), inherit.aes = FALSE, size = 2.1,
             fontface = "bold", lineheight = 0.9, vjust = 0, colour = "grey25",
             fill = alpha("white", 0.75), linewidth = 0, label.padding = unit(0.6, "mm")) +
  scale_colour_manual(values = c(msd = col_msd, div = col_req, div1 = col_req),
                      breaks = c("msd", "div", "div1"), labels = list(lab_msd, lab_div, lab_div1),
                      name = NULL) +
  scale_linetype_manual(values = c(msd = "solid", div = "solid", div1 = "22"),
                        breaks = c("msd", "div", "div1"), labels = list(lab_msd, lab_div, lab_div1),
                        name = NULL) +
  scale_x_log10(breaks = 10^seq(-4, 3), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  scale_y_log10(breaks = 10^seq(-3, 5), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  coord_cartesian(xlim = c(1e-4, x_max), ylim = c(1e-3, 1e5)) +
  labs(x = expression("Long-run " * italic(V)[A] * " as a multiple of the pedigree estimate, " *
                        italic(c) == bar(italic(V))[A] / hat(italic(V))[A]),
       y = "Ratio") +
  guides(colour = guide_legend(ncol = 1, override.aes = list(linewidth = 1.1, alpha = 1))) +
  theme_genetics() +
  theme(plot.margin = margin(2, 3, 2, 2, "mm"))

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig5_rescaling.pdf", p, width = 120, height = 100, units = "mm", device = cairo_pdf)
ggsave("main/Fig5_rescaling.tiff", p, width = 120, height = 100, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW")))
  ggsave(Sys.getenv("FIG_PREVIEW"), p, width = 120, height = 100, units = "mm", dpi = 200,
         device = ragg::agg_png)

cat(sprintf("n = %d species (%d populations)\nAverage: MSD ratio 1 at c = %.3g; diversity ratio 1 at c = %.3g (gap %.0f-fold); curves cross at c = %.3g, ratio %.0f\n",
            n_sp, n_distinct(curves$code), c_msd1, c_div1, c_div1 / c_msd1, c_star, ratio_star))
cat(sprintf("Per population: c_div %.2g-%.2g (median %.2g); c_msd %.2g-%.2g; gap %.0f-%.0f-fold\n",
            min(pop_c$c_div), max(pop_c$c_div), median(pop_c$c_div), min(pop_c$c_msd), max(pop_c$c_msd),
            min(pop_c$gap), max(pop_c$gap)))
print(as.data.frame(pop_c %>% select(code, s_bar, c_msd, c_div, gap) %>% mutate(across(where(is.numeric), ~ signif(.x, 3)))))

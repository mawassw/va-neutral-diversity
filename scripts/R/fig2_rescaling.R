# ==============================================================================
# fig2_rescaling.R — Figure 2: no long-run V_A reconciles both comparisons
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig2_rescaling.R
# Reads only through load_data.R. Writes main/Fig2_rescaling.{pdf,tiff}.
#
# Let the long-run V_A be c times the pedigree estimate: bar V_A = c * hat V_A
# (c < 1: the estimate is inflated; c > 1: it understates). For each population
# with an observed deficit, two ratios as functions of c:
#   bar V_A / (U_d s)                         long-run V_A over what MSD balance
#                                             maintains; rises with c
#   (1/delta) / (1 + 4 kappa bar V_A)         observed over predicted loss of
#                                             diversity; falls with c
# A comparison agrees where its ratio is <= 1; the best any c can do is where
# the two cross (point). s = 1e-2, the top of Figure 1's band, is the value most
# generous to MSD balance. Unlinked term only.
# hat V_A at the posterior mode; kappa primary (Model B; 1 without a pair bond,
# Appendix B); direct mutation rate. Dashed: the diversity ratio with G = 1 - V_A
# (Appendix A sensitivity), defined only inside the domain (long-run V_A < 1).
# Bold lines: mean over species of log10 ratio (populations of a species averaged
# first), t-based 95% CI across species. Faint lines: individual populations.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")

s_msd <- 1e-2
c_grid <- 10^seq(-4, 7, length.out = 400)

pops <- load_populations("va")
obs <- load_diversity()

d <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit),
         deficit = 4 * mu_direct * 10^log10_Nc / pi_any,
         species = sub("^(\\S+ \\S+).*", "\\1", scientific_name)) %>%
  # Soay: Buffalo's Ovis aries census is domestic sheep
  filter(!is.na(deficit), !is.na(U_d_direct), code != "SSH")

curves <- d %>%
  select(code, species, va_mode, kappa, pair_bond, epp_alpha, U_d_direct, deficit) %>%
  tidyr::crossing(c = c_grid) %>%
  mutate(msd = c * va_mode / (U_d_direct * s_msd),
         div = deficit / (1 + 4 * kappa * c * va_mode),
         # Appendix A sensitivity: G = 1 - V_A (defined only while long-run V_A < 1)
         divG = deficit * mapply(ne_ratio, c * va_mode, pair_bond == "social_monogamy",
                                 epp_alpha, MoreArgs = list(gamma = 1, G_correct = TRUE))) %>%
  tidyr::pivot_longer(c(msd, div, divG), names_to = "side", values_to = "ratio") %>%
  filter(!is.na(ratio))

# Average: populations of a species share pi and N_c, so average within species
# first, then the mean of log10 ratio across species with a t-based 95% CI
n_sp <- n_distinct(curves$species)
avg <- curves %>%
  group_by(side, c, species) %>%
  summarise(l = mean(log10(ratio)), .groups = "drop") %>%
  group_by(side, c) %>%
  summarise(m = mean(l), se = sd(l) / sqrt(n()), .groups = "drop") %>%
  mutate(t = qt(0.975, n_sp - 1),
         ratio = 10^m, lo = 10^(m - t * se), hi = 10^(m + t * se)) %>%
  # the G-corrected average only where every population is inside the domain,
  # so species do not drop out of it part-way along c
  filter(side != "divG" | c < min(1 / d$va_mode))

# Where each average curve reaches 1, and where the two cross (best compromise)
at_one <- function(s) { a <- filter(avg, side == s); 10^approx(a$m, log10(a$c), 0)$y }
c_msd1 <- at_one("msd"); c_div1 <- at_one("div")
w <- avg %>% select(side, c, m) %>% tidyr::pivot_wider(names_from = side, values_from = m)
c_star <- 10^approx(w$msd - w$div, log10(w$c), 0)$y
ratio_star <- 10^approx(log10(w$c), w$msd, log10(c_star))$y

col_msd <- "#2C7FB8"; col_req <- "#D95F0E"
lab_msd <- expression(bar(italic(V))[A] / italic(U)[d] * italic(s) *
                        ":  long-run " * italic(V)[A] * " ÷ the " * italic(V)[A] *
                        " mutation–selection balance maintains")
lab_div <- expression(delta^-1 / (1 + 4 * kappa * bar(italic(V))[A]) *
                        ":  observed ÷ predicted loss of diversity")
lab_divG <- expression("the same with " * italic(G) == 1 - bar(italic(V))[A] *
                         " (selection depletes the variance it acts on)")

# Domain of 1/(1 + 4 kappa V_A): weak selection, V_A << 1. Its edge, long-run
# V_A = 1, sits at c = 1 / hat V_A, which differs by species (hat V_A averaged
# geometrically within species). Grey from the species-average edge; dashed
# lines at the smallest and largest species edge.
c_dom_sp <- d %>% group_by(species) %>% summarise(c_dom = 1 / exp(mean(log(va_mode))))
c_dom <- exp(mean(log(c_dom_sp$c_dom)))
# Agreement on the diversity side lies beyond the domain edge, so that regime is
# not drawn as a regime: it is part of the grey region.
stopifnot(c_dom < c_div1, c_msd1 < c_dom)

# Regimes along c, bounded where the average MSD curve reaches 1 and at the
# domain edge
regimes <- tibble::tibble(
  xmin = c(1e-4, c_msd1, c_dom), xmax = c(c_msd1, c_dom, 1e7),
  fill = c("msd_ok", "none", "out"),
  # middle label centred left of the first dashed line, so it does not cross it
  x = sqrt(c(1e-4 * c_msd1, c_msd1 * min(c_dom_sp$c_dom), c_dom * 1e7)),
  lab = c("Maintainable, but\nexplains almost none\nof the lost diversity",
          "Not\nmaintainable,\nexplains little",
          ""))   # grey label drawn separately, as plotmath

p <- ggplot(avg, aes(c)) +
  geom_rect(data = regimes, aes(xmin = xmin, xmax = xmax, ymin = 1e-3, ymax = 1e6, fill = fill),
            inherit.aes = FALSE, show.legend = FALSE) +
  scale_fill_manual(values = c(msd_ok = "#EAF2F8", none = "white", out = "grey88")) +
  geom_hline(yintercept = 1, linewidth = 0.4) +
  geom_vline(xintercept = range(c_dom_sp$c_dom), linetype = "22", linewidth = 0.4,
             colour = "grey40") +
  # individual populations, faint
  geom_line(data = filter(curves, side != "divG"),
            aes(y = ratio, colour = side, group = interaction(code, side)),
            linewidth = 0.3, alpha = 0.3) +
  # species average and 95% CI
  geom_ribbon(data = filter(avg, side == "msd"), aes(ymin = lo, ymax = hi),
              fill = col_msd, alpha = 0.2) +
  geom_ribbon(data = filter(avg, side == "div"), aes(ymin = lo, ymax = hi),
              fill = col_req, alpha = 0.2) +
  geom_line(aes(y = ratio, colour = side, linetype = side), linewidth = 1.1) +
  # regime labels drawn last, on a light backing, so curves pass behind them
  geom_label(data = filter(regimes, lab != ""), aes(x = x, y = 1.6, label = lab),
             inherit.aes = FALSE, size = 2.1, fontface = "bold", lineheight = 0.9, vjust = 0,
             colour = "grey25", fill = alpha("white", 0.75), linewidth = 0,
             label.padding = unit(0.6, "mm")) +
  annotate("text", x = regimes$x[3], y = 1.6, vjust = 0, size = 2.1, colour = "grey25", parse = TRUE,
           label = 'atop(bold("Outside the model\'s domain:"), bold("long-run ")*bolditalic(V)[bold(A)]*bold(" > 1"))') +
  scale_colour_manual(values = c(msd = col_msd, div = col_req, divG = col_req),
                      breaks = c("msd", "div", "divG"), labels = list(lab_msd, lab_div, lab_divG),
                      name = NULL) +
  scale_linetype_manual(values = c(msd = "solid", div = "solid", divG = "22"),
                        breaks = c("msd", "div", "divG"), labels = list(lab_msd, lab_div, lab_divG),
                        name = NULL) +
  scale_x_log10(breaks = 10^seq(-4, 7), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  scale_y_log10(breaks = 10^seq(-3, 6), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  coord_cartesian(xlim = c(1e-4, 1e7), ylim = c(1e-3, 1e6)) +
  labs(x = expression("Long-run " * italic(V)[A] * " as a multiple of the pedigree estimate, " *
                        italic(c) == bar(italic(V))[A] / hat(italic(V))[A]),
       y = "Ratio") +
  guides(colour = guide_legend(ncol = 1, override.aes = list(linewidth = 1.1, alpha = 1))) +
  theme_classic(base_size = 9, base_family = "sans") +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 8),
    legend.key.width = unit(7, "mm"),
    plot.margin = margin(2, 3, 2, 2, "mm")
  )

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig2_rescaling.pdf", p, width = 120, height = 100, units = "mm", device = cairo_pdf)
ggsave("main/Fig2_rescaling.tiff", p, width = 120, height = 100, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW")))
  ggsave(Sys.getenv("FIG_PREVIEW"), p, width = 120, height = 100, units = "mm", dpi = 200,
         device = ragg::agg_png)

cat(sprintf("n = %d species (%d populations)\nratio 1 at c = %.3g (MSD) and %.3g (diversity)\nbest compromise c = %.3g, ratio %.0f\n",
            n_sp, n_distinct(curves$code), c_msd1, c_div1, c_star, ratio_star))

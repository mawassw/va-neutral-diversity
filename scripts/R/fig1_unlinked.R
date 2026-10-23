# ==============================================================================
# fig1_unlinked.R — Figure 1: the unlinked reduction in N_e/N, one model at two orders
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig1_unlinked.R
# Reads only through load_data.R; kappa from kappa.R. Writes
# main/Fig1_unlinked.{pdf,tiff}.
#
# The reduction caused by heritable variance in fitness at unlinked loci, under the
# one model of fitness of Theory (sec:onemodel), with full retention (Z = 1):
#   first order     N_e/N = 1 / (1 + 4 kappa V_A)   (Robertson; Santiago & Caballero),
#                   the reduction at the measured values, valid while V_A << 1
#   multiplicative  N_e/N at all orders (Barton & Etheridge 2011; Appendix A; pair bond, Appendix B):
#                   exp(-4 V_A) without a pair bond, the Model-B nest-sharing value
#                   with one (reduction_mult); its upper bound on the reduction,
#                   exp(-4 kappa_max V_A), kappa_max = 2 with a pair bond and 1 without
#                   (reduction_mult_bound). The two coincide without a pair bond.
#   A  one row per population (19), rows as in Figure 4: first order at the hat V_A
#      mode (circle), 50% and 95% HPD (thick, thin); multiplicative at the mode
#      (triangle) and its upper bound (cross)
#   B  the forms as curves in V_A for kappa = 1 and 2: first order solid, drawn only
#      inside its domain (V_A <= 1); multiplicative upper bound dashed; each population
#      at its hat V_A mode and own kappa (first order)
# kappa primary (Model B; 1 without a pair bond). Until 2026-10-20 this figure showed
# the additive-map G = 1 - V_A sensitivity, retired 2026-10-19 (Appendix A.4).
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(patchwork)
})
source("scripts/R/load_data.R")
source("scripts/R/kappa.R")

pops <- load_populations("va")
draws <- load_va_draws(long = TRUE)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")

hpd <- function(x, p) as.numeric(coda::HPDinterval(coda::as.mcmc(x), prob = p))
h50 <- draws %>% group_by(code) %>%
  summarise(lo50 = hpd(va, 0.5)[1], hi50 = hpd(va, 0.5)[2], .groups = "drop")

d <- pops %>%
  left_join(h50, by = "code") %>%
  mutate(
    taxon = if_else(code %in% birds, "Birds", "Mammals"),
    system = if_else(pair_bond == "social_monogamy", "Social monogamy", "No pair bond"),
    species_lab = sub(" \\(.*\\)$", "", common_name),
    location_lab = sub("^tiritiri", "Tiritiri", location),
    label = paste(species_lab, location_lab, sep = ", "),
    label_math = sprintf('"%s"~~scriptstyle("%s")', species_lab, location_lab),
    ne    = 1 / (1 + 4 * kappa * va_mode),
    ne95a = 1 / (1 + 4 * kappa * va_hpd95_hi), ne95b = 1 / (1 + 4 * kappa * va_hpd95_lo),
    ne50a = 1 / (1 + 4 * kappa * hi50),        ne50b = 1 / (1 + 4 * kappa * lo50),
    ne_mult  = 1 / reduction_mult,
    ne_bound = 1 / reduction_mult_bound)

row_order <- c(
  "SFW", "HT", "HK", "BTR", "BTP", "BTM", "GTU", "GTN", "CF", "SSP",
  "SV", "KS", "NH", "MK", "RD", "SSH", "BHS", "CSM", "AB")
d <- d %>% mutate(label = factor(label, levels = rev(label[match(row_order, code)])))

col_np <- "#1B9E77"; col_sm <- "#7570B3"; col_mult <- "#D95F0E"
key_hpd <- function(data, params, size) {
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5, gp = grid::gpar(col = data$colour, lwd = 0.4 * .pt)),
    grid::segmentsGrob(0.25, 0.5, 0.75, 0.5,
                       gp = grid::gpar(col = data$colour, lwd = 1.3 * .pt, lineend = "butt")),
    draw_key_point(data, params, size))
}
theme_fig <- theme_classic(base_size = 9, base_family = "sans") +
  theme(panel.grid.major.x = element_line(colour = "grey92", linewidth = 0.3),
        legend.position = "bottom", legend.text = element_text(size = 8, hjust = 0),
        legend.key.width = unit(7, "mm"), plot.tag = element_text(face = "bold"))

ne_lab <- expression("Effective size relative to breeding adults, " * italic(N)[e] / italic(N))
ne_brk <- c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1)
ne_log <- function() scale_x_log10(limits = c(0.01, 1.05), breaks = ne_brk, labels = format(ne_brk),
                                   expand = c(0, 0))

# --- A: per population ----------------------------------------------------------
pA <- ggplot(d, aes(y = label)) +
  geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
  geom_linerange(aes(xmin = ne95a, xmax = ne95b), linewidth = 0.4) +
  geom_linerange(aes(xmin = ne50a, xmax = ne50b), linewidth = 1.3) +
  geom_point(aes(x = ne_bound, shape = "bound"), size = 1.5, stroke = 0.6, colour = col_mult) +
  geom_point(aes(x = ne_mult, shape = "mult"), size = 1.6, stroke = 0.6, colour = col_mult) +
  geom_point(aes(x = ne, shape = "first"), size = 1.6, fill = "white", stroke = 0.6,
             key_glyph = key_hpd) +
  scale_shape_manual(values = c(first = 21, mult = 2, bound = 4), breaks = c("first", "mult", "bound"),
                     name = NULL,
                     labels = list(expression("First order: mode, 50% and 95% HPD"),
                                   "All orders, multiplicative: mode",
                                   expression("Its upper bound, " * e^{-4 * kappa[max] * hat(italic(V))[A]} *
                                                ": mode"))) +
  ne_log() +
  scale_y_discrete(labels = function(l) parse(text = d$label_math[match(l, d$label)])) +
  facet_grid(taxon ~ ., scales = "free_y", space = "free_y", switch = "y") +
  labs(x = ne_lab, y = NULL, tag = "A") +
  guides(shape = guide_legend(ncol = 1, override.aes = list(colour = c("black", col_mult, col_mult)))) +
  theme_fig +
  theme(strip.background = element_blank(), strip.placement = "outside",
        strip.text.y.left = element_text(angle = 90, face = "bold"),
        panel.spacing = unit(2.5, "mm"))

# --- B: the forms as curves -----------------------------------------------------
va <- 10^seq(-3, log10(2), length.out = 300)
curves <- bind_rows(
  tibble::tibble(Va = va, ne = 1 / (1 + 4 * va), sys = "No pair bond", form = "first"),
  tibble::tibble(Va = va, ne = 1 / (1 + 8 * va), sys = "Social monogamy", form = "first"),
  tibble::tibble(Va = va, ne = exp(-4 * va), sys = "No pair bond", form = "mult"),
  tibble::tibble(Va = va, ne = exp(-8 * va), sys = "Social monogamy", form = "mult")) %>%
  filter(form == "mult" | Va <= 1)

pB <- ggplot() +
  annotate("rect", xmin = 1, xmax = 2, ymin = 0.01, ymax = 1.05, fill = "grey93") +
  geom_line(data = curves, aes(Va, ne, colour = sys, linetype = form), linewidth = 0.6) +
  geom_point(data = d, aes(va_mode, ne, colour = system), size = 1.7, shape = 21,
             fill = "white", stroke = 0.7) +
  annotate("text", x = 0.0012, y = 0.012, hjust = 0, vjust = 0, size = 2.2, colour = "grey30",
           lineheight = 0.9,
           label = "curves: κ = 1 and κ = 2\npoints: first order at\neach mode and own κ\ngrey: V_A > 1") +
  scale_colour_manual(values = c("No pair bond" = col_np, "Social monogamy" = col_sm), name = NULL) +
  scale_linetype_manual(values = c(first = "solid", mult = "22"), name = NULL,
                        labels = c(first = "first order", mult = "multiplicative upper bound")) +
  scale_x_log10(breaks = c(10^(-3:0), 2), labels = c("0.001", "0.01", "0.1", "1", "2"),
                expand = c(0, 0)) +
  scale_y_log10(breaks = ne_brk, labels = format(ne_brk), expand = c(0, 0)) +
  coord_cartesian(xlim = c(1e-3, 2), ylim = c(0.01, 1.05)) +
  labs(x = expression(italic(V)[A]),
       y = expression(italic(N)[e] / italic(N)), tag = "B") +
  guides(colour = guide_legend(ncol = 1, order = 1),
         linetype = guide_legend(ncol = 1, order = 2)) +
  theme_fig + theme(panel.grid.major.y = element_line(colour = "grey92", linewidth = 0.3),
                    legend.direction = "vertical", legend.box = "vertical",
                    legend.box.just = "left", plot.margin = margin(2, 5, 2, 2, "mm"))

p <- pA + pB + plot_layout(widths = c(1.25, 1))

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig1_unlinked.pdf", p, width = 178, height = 115, units = "mm", device = cairo_pdf)
ggsave("main/Fig1_unlinked.tiff", p, width = 178, height = 115, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW_DIR")))
  ggsave(file.path(Sys.getenv("FIG_PREVIEW_DIR"), "Fig1_unlinked.png"), p, width = 178,
         height = 115, units = "mm", dpi = 200, device = ragg::agg_png)

cat(sprintf("First order: median %.2f, min %.2f (%s); at the upper 95%% HPD min %.2f\nMultiplicative: median %.2f, min %.3f (%s); bound min %.3f\n",
            median(d$ne), min(d$ne), d$code[which.min(d$ne)], min(d$ne95a),
            median(d$ne_mult), min(d$ne_mult), d$code[which.min(d$ne_mult)], min(d$ne_bound)))

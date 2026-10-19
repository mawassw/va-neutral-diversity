# ==============================================================================
# fig1_unlinked.R — Figure 1: the unlinked reduction in N_e/N (Santiago & Caballero)
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig1_unlinked.R
# Reads only through load_data.R; kappa and G from kappa.R. Writes
# main/Fig1_unlinked.{pdf,tiff}.
#
# N_e/N = 1 / (1 + 4 kappa V_A) (Appendices A, B), the demographic ratio implied
# by heritable variance in fitness at unlinked loci, at G = 1 (primary; the
# largest reduction) and G = 1 - V_A (Appendix A sensitivity).
#   A  one row per population (19), rows as in Figure 4: G = 1 at the hat V_A
#      mode (circle), 50% and 95% HPD (thick, thin); G = 1 - V_A at the mode
#      (open triangle)
#   B  the same formula as a curve in V_A, for kappa = 1 (no pair bond) and
#      kappa = 2 (strict monogamy), solid at G = 1 and dashed at G = 1 - V_A;
#      each population at its hat V_A mode and own kappa, by mating system
# kappa primary (Model B; 1 without a pair bond).
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
    ne_G  = 1 / reduction_Gsym)

row_order <- c(
  "SFW", "HT", "HK", "BTR", "BTP", "BTM", "GTU", "GTN", "CF", "SSP",
  "SV", "KS", "NH", "MK", "RD", "SSH", "BHS", "CSM", "AB")
d <- d %>% mutate(label = factor(label, levels = rev(label[match(row_order, code)])))

col_np <- "#1B9E77"; col_sm <- "#7570B3"
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

ne_lab <- expression("Effective size relative to census, " * italic(N)[e] / italic(N))

# --- A: per population ----------------------------------------------------------
pA <- ggplot(d, aes(y = label)) +
  geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
  geom_linerange(aes(xmin = ne95a, xmax = ne95b), linewidth = 0.4) +
  geom_linerange(aes(xmin = ne50a, xmax = ne50b), linewidth = 1.3) +
  geom_point(aes(x = ne_G, shape = "G"), size = 1.6, stroke = 0.6, colour = "grey35") +
  geom_point(aes(x = ne, shape = "G1"), size = 1.6, fill = "white", stroke = 0.6,
             key_glyph = key_hpd) +
  scale_shape_manual(values = c(G1 = 21, G = 2), breaks = c("G1", "G"), name = NULL,
                     labels = list(expression(italic(G) == 1 * ": mode, 50% and 95% HPD"),
                                   expression(italic(G) == 1 - hat(italic(V))[A] * ": mode"))) +
  scale_x_continuous(limits = c(0.15, 1.02), breaks = seq(0.2, 1, 0.2), expand = c(0, 0)) +
  scale_y_discrete(labels = function(l) parse(text = d$label_math[match(l, d$label)])) +
  facet_grid(taxon ~ ., scales = "free_y", space = "free_y", switch = "y") +
  labs(x = ne_lab, y = NULL, tag = "A") +
  guides(shape = guide_legend(ncol = 1)) +
  theme_fig +
  theme(strip.background = element_blank(), strip.placement = "outside",
        strip.text.y.left = element_text(angle = 90, face = "bold"),
        panel.spacing = unit(2.5, "mm"))

# --- B: the formula as a curve --------------------------------------------------
va <- 10^seq(-3, log10(0.99), length.out = 300)
curves <- bind_rows(
  tibble::tibble(Va = va, ne = 1 / (1 + 4 * va), sys = "No pair bond", G = "G = 1"),
  tibble::tibble(Va = va, ne = 1 / (1 + 8 * va), sys = "Social monogamy", G = "G = 1"),
  tibble::tibble(Va = va, ne = ne_ratio(va, FALSE, G_correct = TRUE),
                 sys = "No pair bond", G = "G = 1 - V_A"),
  tibble::tibble(Va = va, ne = mapply(ne_ratio, va, TRUE, 0, MoreArgs = list(G_correct = TRUE)),
                 sys = "Social monogamy", G = "G = 1 - V_A"))

pB <- ggplot() +
  geom_line(data = curves, aes(Va, ne, colour = sys, linetype = G), linewidth = 0.6) +
  geom_point(data = d, aes(va_mode, ne, colour = system), size = 1.7, shape = 21,
             fill = "white", stroke = 0.7) +
  annotate("text", x = 0.0012, y = 0.24, hjust = 0, size = 2.3, colour = "grey30", lineheight = 0.9,
           label = "curves: κ = 1 (no pair bond) and\nκ = 2 (strict monogamy); points at\neach population's own κ") +
  scale_colour_manual(values = c("No pair bond" = col_np, "Social monogamy" = col_sm), name = NULL) +
  scale_linetype_manual(values = c("G = 1" = "solid", "G = 1 - V_A" = "22"), name = NULL,
                        labels = list(expression(italic(G) == 1),
                                      expression(italic(G) == 1 - italic(V)[A]))) +
  scale_x_log10(breaks = 10^(-3:0), labels = scales::label_math(10^.x, format = log10),
                expand = c(0, 0)) +
  scale_y_continuous(limits = c(0.1, 1.02), breaks = seq(0.2, 1, 0.2), expand = c(0, 0)) +
  coord_cartesian(xlim = c(1e-3, 1)) +
  labs(x = expression(italic(V)[A]),
       y = ne_lab, tag = "B") +
  guides(colour = guide_legend(ncol = 1, order = 1),
         linetype = guide_legend(ncol = 1, position = "inside")) +
  theme_fig + theme(panel.grid.major.y = element_line(colour = "grey92", linewidth = 0.3),
                    legend.position.inside = c(0.03, 0.28), legend.justification.inside = c(0, 0),
                    legend.background = element_blank(), plot.margin = margin(2, 5, 2, 2, "mm"))

p <- pA + pB + plot_layout(widths = c(1.2, 1))

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig1_unlinked.pdf", p, width = 178, height = 115, units = "mm", device = cairo_pdf)
ggsave("main/Fig1_unlinked.tiff", p, width = 178, height = 115, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW_DIR")))
  ggsave(file.path(Sys.getenv("FIG_PREVIEW_DIR"), "Fig1_unlinked.png"), p, width = 178,
         height = 115, units = "mm", dpi = 200, device = ragg::agg_png)

cat(sprintf("N_e/N at G = 1: median %.2f, min %.2f (%s); at the upper 95%% HPD min %.2f\nG = 1 - V_A: median %.2f, min %.2f\n",
            median(d$ne), min(d$ne), d$code[which.min(d$ne)], min(d$ne95a),
            median(d$ne_G), min(d$ne_G)))

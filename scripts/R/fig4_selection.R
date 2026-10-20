# ==============================================================================
# fig4_selection.R — Figure 4: the selection measured V_A would need at MSD balance
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig4_selection.R
# Reads only through load_data.R. Writes main/Fig4_selection.{pdf,tiff}.
#
# In the strong-selection limit of mutation-selection-drift balance (Appendix D),
# the standing additive variance is V_A = U_d s, so measured V_A implies
#   s* = V_A / U_d,
# the mean heterozygous selection coefficient deleterious mutations would need
# for MSD balance to maintain it. One row per population with a U_d (18; the
# fairy-wren has no annotated assembly), rows as in Figure 1.
#   posterior   s* = V_A draw / U_d draw: V_A from the 4000 animal-model draws,
#               U_d = 4 mu L_coding with the direct mu drawn lognormal from its
#               95% CI, so both uncertainties are carried. 95% HPD (thin),
#               50% HPD (thick), mode (circle).
#   blue        mean s of the empirical DFE assigned to the population
#               (data/dfe_assignment.csv via dfe_assigned(): own species, else an
#               equal mixture of the closest relatives in Lin et al. 2026), the same
#               DFE as Figures 2, 3 and 5. Diamond: the assigned mean; bar: the range
#               of the component species' means where the assignment is a mixture.
#               (Before 2026-10-20: one band per taxon over every DFE used.)
#   grey        s* > 1: V_A > U_d, which no selection coefficient can maintain
#   right       posterior probability that s* exceeds the assigned mean
# The strong-selection limit holds here: 2 N_e s* >> 1 wherever pi gives N_e.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")

x_min <- 1e-4; x_max <- 10

pops <- load_populations("va") %>% filter(!is.na(U_d_direct))
draws <- load_va_draws(long = TRUE) %>% filter(code %in% pops$code)

birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")

# Assigned DFE per population (Lin et al. 2026, one fitdadi pipeline across
# species, nonsynonymous sites, heterozygous s under semi-dominance): the mixture
# mean, and the range of the component species' means
s_bar_pop <- vapply(dfe_assigned(), `[[`, numeric(1), "s_bar")
ref <- read.csv("data/dfe_reference.csv", stringsAsFactors = FALSE)
asg <- read.csv("data/dfe_assignment.csv", stringsAsFactors = FALSE)
comp_s <- lapply(strsplit(asg$dfe, ";"), function(nm) ref$mean_s[match(trimws(nm), ref$common_name)])
s_ref <- data.frame(code = asg$code, s_bar = unname(s_bar_pop[asg$code]),
                    s_lo = vapply(comp_s, min, numeric(1)), s_hi = vapply(comp_s, max, numeric(1)))

# s* draws, carrying the mutation-rate uncertainty through U_d
set.seed(1)
s_draws <- draws %>%
  left_join(pops %>% select(code, U_d_direct, U_d_direct_lo, U_d_direct_hi), by = "code") %>%
  group_by(code) %>%
  mutate(sdlog = (log(U_d_direct_hi) - log(U_d_direct_lo)) / (2 * qnorm(0.975)),
         U_d = exp(rnorm(n(), log(U_d_direct), sdlog)),
         s = va / U_d) %>%
  ungroup() %>%
  left_join(s_ref %>% select(code, s_bar), by = "code")

hpd <- function(x, p) as.numeric(coda::HPDinterval(coda::as.mcmc(x), prob = p))
s_sum <- s_draws %>%
  group_by(code, s_bar) %>%
  summarise(mode = MCMCglmm::posterior.mode(coda::as.mcmc(s)),
            lo95 = hpd(s, 0.95)[1], hi95 = hpd(s, 0.95)[2],
            lo50 = hpd(s, 0.50)[1], hi50 = hpd(s, 0.50)[2],
            P_band = mean(s > s_bar), P_one = mean(s > 1),
            .groups = "drop")

d <- pops %>%
  left_join(s_sum, by = "code") %>%
  left_join(s_ref %>% select(code, s_lo, s_hi), by = "code") %>%
  mutate(
    taxon = if_else(code %in% birds, "Birds", "Mammals"),
    species_lab = sub(" \\(.*\\)$", "", common_name),
    location_lab = sub("^tiritiri", "Tiritiri", location),
    label = paste(species_lab, location_lab, sep = ", "),
    label_math = sprintf('"%s"~~scriptstyle("%s")', species_lab, location_lab),
    lo95 = pmax(lo95, x_min), lo50 = pmax(lo50, x_min),
    P_lab = formatC(floor(P_band * 100) / 100, format = "f", digits = 2)
  )

row_order <- c(
  "SFW", "HT", "HK", "BTR", "BTP", "BTM", "GTU", "GTN", "CF", "SSP",
  "SV", "KS", "NH", "MK", "RD", "SSH", "BHS", "CSM", "AB")
row_order <- row_order[row_order %in% d$code]
d <- d %>% mutate(label = factor(label, levels = rev(label[match(row_order, code)])))

col_msd <- "#2C7FB8"
lab_band <- expression("Mean " * italic(s) * " of new nonsynonymous mutations, assigned empirical DFE")
# hats: both inputs are estimates (pedigree V_A; U_d from estimated mu and the
# annotated coding length), so s* is an estimate too
lab_post <- expression("Implied " * hat(italic(s))^"*" == hat(italic(V))[A] / hat(italic(U))[d] *
                         ": mode, 50% and 95% HPD")
lab_none <- expression(hat(italic(s))^"*" > 1 * ": no selection coefficient maintains " *
                         hat(italic(V))[A])

key_hpd <- function(data, params, size) {
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5,
                       gp = grid::gpar(col = data$colour, lwd = 0.4 * .pt)),
    grid::segmentsGrob(0.25, 0.5, 0.75, 0.5,
                       gp = grid::gpar(col = data$colour, lwd = 1.3 * .pt, lineend = "butt")),
    draw_key_point(data, params, size))
}
key_rect <- function(data, params, size)
  grid::rectGrob(gp = grid::gpar(fill = alpha(data$fill, data$alpha), col = NA))

bands <- tibble::tibble(taxon = c("Birds", "Mammals"), xmin = 1, xmax = x_max, what = "none")

p <- ggplot(d, aes(y = label)) +
  geom_rect(data = bands, aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, fill = what),
            inherit.aes = FALSE, alpha = 0.35, key_glyph = key_rect) +
  scale_fill_manual(values = c(none = "grey60"), breaks = "none",
                    labels = list(lab_none), name = NULL) +
  # assigned DFE: range of the component species' means, and the mixture mean
  geom_linerange(aes(xmin = s_lo, xmax = s_hi), colour = col_msd, linewidth = 1.6, alpha = 0.45) +
  geom_point(aes(x = s_bar, shape = "dfe"), colour = col_msd, fill = col_msd, size = 2) +
  scale_shape_manual(values = c(dfe = 23), labels = list(lab_band), name = NULL) +
  geom_linerange(aes(xmin = lo95, xmax = hi95), linewidth = 0.4) +
  geom_linerange(aes(xmin = lo50, xmax = hi50), linewidth = 1.3) +
  geom_point(aes(x = mode, colour = "post"), size = 1.6, shape = 21, fill = "white",
             stroke = 0.6, key_glyph = key_hpd) +
  scale_colour_manual(values = c(post = "black"), labels = list(lab_post), name = NULL) +
  # posterior probability that s* exceeds the assigned DFE mean
  geom_text(aes(x = x_max, label = P_lab), hjust = -0.35, size = 2.6) +
  geom_text(data = data.frame(taxon = "Birds"), inherit.aes = FALSE, parse = TRUE,
            aes(x = x_max, y = Inf, label = 'italic(P)(hat(italic(s))^"*" > bar(italic(s)))'),
            hjust = -0.05, vjust = -0.4, size = 2.4) +
  scale_x_log10(limits = c(x_min, x_max), expand = c(0, 0), breaks = 10^seq(-4, 1),
                labels = scales::label_math(10^.x, format = log10)) +
  scale_y_discrete(labels = function(l) parse(text = d$label_math[match(l, d$label)])) +
  facet_grid(taxon ~ ., scales = "free_y", space = "free_y", switch = "y") +
  coord_cartesian(clip = "off") +
  labs(x = expression("Mean heterozygous selection coefficient, " * italic(s)), y = NULL) +
  guides(fill = guide_legend(order = 3, ncol = 1), shape = guide_legend(order = 2),
         colour = guide_legend(order = 1)) +
  theme_classic(base_size = 9, base_family = "sans") +
  theme(
    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 90, face = "bold"),
    panel.grid.major.x = element_line(colour = "grey92", linewidth = 0.3),
    panel.spacing = unit(2.5, "mm"),
    legend.position = "bottom",
    legend.direction = "vertical",
    legend.box = "vertical",
    legend.location = "plot",
    legend.spacing.y = unit(0, "mm"),
    legend.margin = margin(0, 0, 0, 0),
    legend.key.height = unit(3.5, "mm"),
    legend.key.spacing.y = unit(0.5, "mm"),
    legend.text = element_text(size = 8, hjust = 0),
    legend.key.width = unit(7, "mm"),
    plot.margin = margin(5, 14, 2, 2, "mm")
  )

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig4_selection.pdf", p, width = 150, height = 125, units = "mm", device = cairo_pdf)
ggsave("main/Fig4_selection.tiff", p, width = 150, height = 125, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW")))
  ggsave(Sys.getenv("FIG_PREVIEW"), p, width = 150, height = 125, units = "mm", dpi = 200,
         device = ragg::agg_png)

print(as.data.frame(d %>% arrange(label) %>%
  transmute(code, s_bar = signif(s_bar, 3), mode = signif(mode, 2), lo95 = signif(lo95, 2),
            hi95 = signif(hi95, 2), ratio_mode = signif(mode / s_bar, 2),
            P_sbar = round(P_band, 3), P_one = round(P_one, 3))))

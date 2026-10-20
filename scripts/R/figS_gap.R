# ==============================================================================
# figS_gap.R — Supplementary figure (was Figure 1): measured V_A sits between the two equilibrium ends
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/figS_gap.R
# Reads only through load_data.R. Writes supp/FigS_gap.{pdf,tiff}.
#
# One row per population, on a log V_A axis:
#   MSD           V_A that mutation-selection-drift balance can maintain, U_d * s_bar
#                 (strong-selection limit, Appendix D), U_d from the direct mutation
#                 rate, s_bar the mean of the empirical DFE assigned to the population
#                 (data/dfe_assignment.csv, as Figures 2-5). Diamond: U_d s_bar; band:
#                 U_d times the range of the component species' means where the
#                 assignment is a mixture. (Before 2026-10-20: s in [1e-3, 1e-2].)
#   posterior     measured V_A: 95% HPD (thin), 50% interval (thick), mode
#   required      smallest V_A that could produce the observed deficit at unlinked sites,
#                 from the multiplicative upper bound on the reduction (Appendix A.3,
#                 decided 2026-10-19): V_A = ln(1/delta) / (4 kappa_mult), kappa_mult = 2
#                 with a pair bond and 1 without; delta = pi / (4 mu N_c); bar spans the
#                 95% CI on mu. (Until 2026-10-19 this was the first-order inversion
#                 (1/delta - 1)/(4 kappa), which lands far outside that formula's domain.)
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")

x_min <- 1e-4                      # axis floor; HPD lines are clipped here

# Assigned DFE per population: the mixture mean, and the range of the component means
s_bar_pop <- vapply(dfe_assigned(), `[[`, numeric(1), "s_bar")
ref <- read.csv("data/dfe_reference.csv", stringsAsFactors = FALSE)
asg <- read.csv("data/dfe_assignment.csv", stringsAsFactors = FALSE)
comp_s <- lapply(strsplit(asg$dfe, ";"), function(nm) ref$mean_s[match(trimws(nm), ref$common_name)])
s_ref <- data.frame(code = asg$code, s_bar = unname(s_bar_pop[asg$code]),
                    s_lo = vapply(comp_s, min, numeric(1)), s_hi = vapply(comp_s, max, numeric(1)))

pops <- load_populations("va")
obs <- load_diversity()
draws <- load_va_draws(long = TRUE)

birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")

# 50% HPD, so the interval contains the mode (the posteriors are right-skewed,
# and a 25-75% quantile range can exclude it)
va50 <- draws %>%
  group_by(code) %>%
  summarise(h = list(coda::HPDinterval(coda::as.mcmc(va), prob = 0.5)), .groups = "drop") %>%
  mutate(q25 = sapply(h, `[`, 1), q75 = sapply(h, `[`, 2)) %>%
  select(-h)

d <- pops %>%
  left_join(va50, by = "code") %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  left_join(s_ref, by = "code") %>%
  mutate(
    taxon = if_else(code %in% birds, "Birds", "Mammals"),
    species_lab = sub(" \\(.*\\)$", "", common_name),
    location_lab = sub("^tiritiri", "Tiritiri", location),
    label = paste(species_lab, location_lab, sep = ", "),
    # axis label: species name at full size, location smaller
    label_math = sprintf('"%s"~~scriptstyle("%s")', species_lab, location_lab),
    # MSD: at the assigned DFE mean, and over the component means
    msd    = U_d_direct * s_bar,
    msd_lo = U_d_direct * s_lo,
    msd_hi = U_d_direct * s_hi,
    # Diversity requirement
    pi_any = coalesce(pi_obs, pi_lit),
    Nc = 10^log10_Nc,
    k_mult = kappa_mult_bound(pair_bond == "social_monogamy"),
    req    = vamax_mult(pi_any / (4 * mu_direct    * Nc), k_mult),
    req_lo = vamax_mult(pi_any / (4 * mu_direct_lo * Nc), k_mult),
    req_hi = vamax_mult(pi_any / (4 * mu_direct_hi * Nc), k_mult),
    # Posterior clipped to the axis edge (no marker; the three poorly
    # identified populations are described in the caption)
    hpd_lo_clip = pmax(va_hpd95_lo, x_min),
    q25 = pmax(q25, x_min)
  )

# Rows: by taxon, then populations of a species kept together, in rough
# taxonomic order (top to bottom within each panel)
row_order <- c(
  # birds: Maluridae, Notiomystidae, Paridae, Muscicapidae, Passerellidae
  "SFW", "HT", "HK", "BTR", "BTP", "BTM", "GTU", "GTN", "CF", "SSP",
  # mammals: Rodentia, Carnivora, Artiodactyla, Primates
  "SV", "KS", "NH", "MK", "RD", "SSH", "BHS", "CSM", "AB")
d <- d %>%
  mutate(label = factor(label, levels = rev(label[match(row_order, code)])))

# Soay: Buffalo's Ovis aries census is domestic sheep, so no requirement is drawn
d <- d %>% mutate(across(c(req, req_lo, req_hi), ~ if_else(code == "SSH", NA_real_, .x)))

lab_msd <- expression("Maintainable at MSD balance: " * italic(U)[d] * bar(italic(s)) *
                        ", assigned empirical DFE")
lab_post <- "Measured: mode, 50% and 95% HPD"
lab_own <- expression("Least needed for observed " * pi * ", study species")
lab_lit <- expression("Least needed for observed " * pi * ", another population")

d <- d %>% mutate(req_kind = case_when(!is.na(pi_obs) ~ "own", !is.na(pi_lit) ~ "lit"))
col_msd <- "#2C7FB8"; col_req <- "#D95F0E"

# Legend keys drawn horizontally, as in the panel: a point on its interval
key_hrange <- function(data, params, size) {
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5,
                       gp = grid::gpar(col = data$colour, lwd = 0.5 * .pt)),
    draw_key_point(data, params, size))
}
# The measured key also carries the thick 50% HPD segment
key_hpd <- function(data, params, size) {
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5,
                       gp = grid::gpar(col = data$colour, lwd = 0.4 * .pt)),
    grid::segmentsGrob(0.25, 0.5, 0.75, 0.5,
                       gp = grid::gpar(col = data$colour, lwd = 1.3 * .pt, lineend = "butt")),
    draw_key_point(data, params, size))
}

p <- ggplot(d, aes(y = label)) +
  # MSD-compatible variance: component range (band) and the assigned mean (diamond)
  geom_linerange(aes(xmin = msd_lo, xmax = msd_hi), colour = col_msd, alpha = 0.35,
                 linewidth = 4.2, na.rm = TRUE) +
  geom_point(aes(x = msd, colour = "msd"), shape = 23, fill = col_msd, size = 2,
             na.rm = TRUE, key_glyph = key_hrange) +
  # measured V_A
  geom_linerange(aes(xmin = hpd_lo_clip, xmax = va_hpd95_hi), linewidth = 0.4) +
  geom_linerange(aes(xmin = q25, xmax = q75), linewidth = 1.3) +
  geom_point(aes(x = va_mode, colour = "post"), size = 1.6, shape = 21, fill = "white",
             stroke = 0.6, key_glyph = key_hpd) +
  # V_A required by the observed deficit
  geom_linerange(aes(xmin = req_lo, xmax = req_hi), colour = col_req, linewidth = 0.5,
                 na.rm = TRUE) +
  geom_point(data = filter(d, req_kind == "own"), aes(x = req, colour = "own"), key_glyph = key_hrange,
             shape = 18, size = 2.4, na.rm = TRUE) +
  geom_point(data = filter(d, req_kind == "lit"), aes(x = req, colour = "lit"), key_glyph = key_hrange,
             shape = 5, size = 2, stroke = 0.7) +
  scale_colour_manual(
    values = c(msd = col_msd, post = "black", own = col_req, lit = col_req),
    breaks = c("msd", "post", "own", "lit"),
    labels = list(lab_msd, lab_post, lab_own, lab_lit), name = NULL,
    guide = guide_legend(ncol = 2)) +
  scale_x_log10(limits = c(x_min, 10), expand = c(0, 0),
                breaks = 10^seq(-4, 1),
                labels = scales::label_math(10^.x, format = log10)) +
  scale_y_discrete(labels = function(l) parse(text = d$label_math[match(l, d$label)])) +
  facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
  labs(x = expression("Additive genetic variance in relative fitness, " * italic(V)[A]),
       y = NULL) +
  theme_classic(base_size = 9, base_family = "sans") +
  theme(
    strip.background = element_blank(),
    strip.text.y = element_text(angle = 0, face = "bold", hjust = 0),
    panel.grid.major.x = element_line(colour = "grey92", linewidth = 0.3),
    panel.spacing = unit(2.5, "mm"),
    legend.position = "bottom",
    legend.location = "plot",
    legend.key.spacing.y = unit(0.5, "mm"),
    legend.key.spacing.x = unit(4, "mm"),
    legend.text = element_text(size = 8, hjust = 0),
    legend.key.width = unit(7, "mm"),
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

dir.create("supp", showWarnings = FALSE)
ggsave("supp/FigS_gap.pdf", p, width = 178, height = 120, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_gap.tiff", p, width = 178, height = 120, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")

print(as.data.frame(d %>% transmute(code, va_mode = signif(va_mode, 2), msd = signif(msd, 2),
  ratio = signif(va_mode / msd, 2), req = signif(req, 2), req_lo = signif(req_lo, 2), req_hi = signif(req_hi, 2))))

# Optional low-resolution preview: FIG_PREVIEW=path.png Rscript scripts/R/figS_gap.R
if (nzchar(Sys.getenv("FIG_PREVIEW")))
  ggsave(Sys.getenv("FIG_PREVIEW"), p, width = 178, height = 120, units = "mm", dpi = 200,
         device = ragg::agg_png)

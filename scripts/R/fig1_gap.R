# ==============================================================================
# fig1_gap.R — Figure 1: measured V_A sits between the two equilibrium ends
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig1_gap.R
# Reads only through load_data.R. Writes main/Fig1_gap.{pdf,tiff}.
#
# One row per population, on a log V_A axis:
#   MSD band      V_A that mutation-selection-drift balance can maintain,
#                 U_d * s for s in [1e-3, 1e-2] (strong-selection limit,
#                 Appendix D), U_d from the direct mutation rate
#   posterior     measured V_A: 95% HPD (thin), 50% interval (thick), mode
#   required      V_A needed for the unlinked term to produce the observed
#                 deficit: 1/delta = 1 + 4 kappa V_A, so V_A = (1/delta - 1)/(4 kappa),
#                 delta = pi / (4 mu N_c); bar spans the 95% CI on mu
# kappa is the primary Model B value (2 for non-monogamous systems).
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")

x_min <- 1e-4                      # axis floor; HPD lines are clipped here
s_band <- c(1e-3, 1e-2)            # vertebrate DFE, mean heterozygous s

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
  mutate(
    taxon = if_else(code %in% birds, "Birds", "Mammals"),
    species_lab = sub(" \\(.*\\)$", "", common_name),
    location_lab = sub("^tiritiri", "Tiritiri", location),
    label = paste(species_lab, location_lab, sep = ", "),
    # axis label: species name at full size, location smaller
    label_math = sprintf('"%s"~~scriptstyle("%s")', species_lab, location_lab),
    # MSD band
    msd_lo = U_d_direct * s_band[1],
    msd_hi = U_d_direct * s_band[2],
    # Diversity requirement
    pi_any = coalesce(pi_obs, pi_lit),
    Nc = 10^log10_Nc,
    req    = (pi_any^-1 * 4 * mu_direct    * Nc - 1) / (4 * kappa),
    req_lo = (pi_any^-1 * 4 * mu_direct_lo * Nc - 1) / (4 * kappa),
    req_hi = (pi_any^-1 * 4 * mu_direct_hi * Nc - 1) / (4 * kappa),
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

lab_msd <- expression("Maintainable at MSD balance: " * italic(U)[d] * italic(s) * ", " *
                        italic(s) == 10^-3 * " to " * 10^-2)
lab_post <- "Measured: mode, 50% and 95% HPD"
lab_own <- expression("Required by observed " * pi * ", study species")
lab_lit <- expression("Required by observed " * pi * ", another population")

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
  # MSD-compatible range
  geom_linerange(aes(xmin = msd_lo, xmax = msd_hi, colour = "msd"), alpha = 0.35,
                 linewidth = 4.2, na.rm = TRUE, key_glyph = "path") +
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
    guide = guide_legend(ncol = 2, override.aes = list(
      linewidth = c(4.2, 0, 0, 0), alpha = c(0.35, 1, 1, 1)))) +
  scale_x_log10(limits = c(x_min, 1e5), expand = c(0, 0),
                breaks = 10^seq(-4, 5),
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

dir.create("main", showWarnings = FALSE)
ggsave("main/Fig1_gap.pdf", p, width = 178, height = 120, units = "mm", device = cairo_pdf)
ggsave("main/Fig1_gap.tiff", p, width = 178, height = 120, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")

print(as.data.frame(d %>% transmute(code, va_mode = signif(va_mode, 2), msd_lo = signif(msd_lo, 2),
  msd_hi = signif(msd_hi, 2), req = signif(req, 2), req_lo = signif(req_lo, 2), req_hi = signif(req_hi, 2))))

# Optional low-resolution preview: FIG_PREVIEW=path.png Rscript scripts/R/fig1_gap.R
if (nzchar(Sys.getenv("FIG_PREVIEW")))
  ggsave(Sys.getenv("FIG_PREVIEW"), p, width = 178, height = 120, units = "mm", dpi = 200,
         device = ragg::agg_png)

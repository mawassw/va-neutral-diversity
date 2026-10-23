# ==============================================================================
# fig2_linked.R — Figure 2: the reduction with linkage, against the observed deficit
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig2_linked.R
# Reads only through load_data.R; model in linked.R. Writes
#   main/Fig2_linked.{pdf,tiff}          primary: f_i from coding bp
#   supp/FigS_linked_fgene.{pdf,tiff}    the same with f_i from gene counts
#   supp/FigS_omega.{pdf,tiff}           the linked factor Omega_bar alone
#
# One row per population in the linked set (9: mapped autosomes, microchromosomes
# included), on one log axis of N_e/N (effective size relative to breeding adults):
#   unlinked      1 / (1 + 4 kappa hat V_A): mode (circle), 95% HPD (line)
#   with linkage  the total, unlinked and linked combined:
#                 Omega_bar / (1 + 4 kappa hat V_A), Omega_bar the linked factor of
#                 Theory eq. linked_penalty (exponential), with class-by-class
#                 retention Z_k = 1 - s_k averaged over the empirical DFE assigned
#                 to the population (data/dfe_assignment.csv: own species, else an
#                 equal mixture of the closest relatives in Lin et al. 2026; the
#                 same DFE as Figure 5's maintenance line), at the measured V_A.
#                 The global factor is drawn at Q = 2 (Z = 1), its upper bound, so
#                 the total is generous to the mechanism.
#                 Dot: at the hat V_A mode; bar: over the 95% HPD of hat V_A.
#                 (Before 2026-10-20: a band over every measured DFE of the taxon,
#                 dot at the most generous; before 2026-10-19: hyperbolic composite
#                 at the aggregate Z = 1 - E[s^2]/E[s].)
#   observed      delta = pi / (4 mu N_c), where pi and an own-species Buffalo
#                 N_c exist; bar = 95% CI on the direct mu. Soay has no usable
#                 N_c (domestic Ovis aries census); red deer and baboon none.
# Omega_bar (supp/FigS_omega): the genome-wide N_e/N relative to the unlinked
# baseline at the same Z (<= 1), i.e. the linked effect by itself.
# kappa primary (Model B; kappa_cis = kappa_own = 1).
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")

pops <- load_populations("linked")
obs <- load_diversity()
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")

dfe_pop <- dfe_assigned()

# Omega_bar for every population x hat V_A (HPD low, mode, HPD high) x partition,
# at the population's assigned DFE. omega_fun() precomputes the class-averaged
# coefficients once per population x partition.
grid <- pops %>%
  select(code, kappa, lo = va_hpd95_lo, mode = va_mode, hi = va_hpd95_hi) %>%
  tidyr::pivot_longer(c(lo, mode, hi), names_to = "va_at", values_to = "Va") %>%
  tidyr::crossing(partition = c("bp", "gene"))
om_cache <- list()
grid$omega <- mapply(function(cd, Va, k, part) {
  key <- paste(cd, part)
  if (is.null(om_cache[[key]])) {
    a <- filter(auto, code == cd); m <- filter(a, has_map)
    om_cache[[key]] <<- omega_fun(m, f_share(m, a, part), k, dfe_pop[[cd]])
  }
  om_cache[[key]](Va)
}, grid$code, grid$Va, grid$kappa, grid$partition)
grid <- grid %>% mutate(unl = 1 / (1 + 4 * kappa * Va), total = omega * unl)

# the HPD bound of hat V_A that is high gives the low N_e/N, and vice versa
summ <- grid %>%
  group_by(code, partition) %>%
  summarise(tot_mode = total[va_at == "mode"], tot_lo = total[va_at == "hi"],
            tot_hi = total[va_at == "lo"],
            om_mode = omega[va_at == "mode"], om_lo = omega[va_at == "hi"],
            om_hi = omega[va_at == "lo"], .groups = "drop")

base <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(
    taxon = if_else(code %in% birds, "Birds", "Mammals"),
    species_lab = sub(" \\(.*\\)$", "", common_name),
    location_lab = sub("^tiritiri", "Tiritiri", location),
    label = paste(species_lab, location_lab, sep = ", "),
    label_math = sprintf('"%s"~~scriptstyle("%s")', species_lab, location_lab),
    unl    = 1 / (1 + 4 * kappa * va_mode),
    unl_lo = 1 / (1 + 4 * kappa * va_hpd95_hi),
    unl_hi = 1 / (1 + 4 * kappa * va_hpd95_lo),
    pi_any = coalesce(pi_obs, pi_lit),
    obs    = pi_any / (4 * mu_direct    * 10^log10_Nc),
    obs_lo = pi_any / (4 * mu_direct_hi * 10^log10_Nc),
    obs_hi = pi_any / (4 * mu_direct_lo * 10^log10_Nc),
    obs_kind = case_when(!is.na(pi_obs) ~ "own", !is.na(pi_lit) ~ "lit")) %>%
  mutate(across(c(obs, obs_lo, obs_hi), ~ if_else(code == "SSH", NA_real_, .x)),
         obs_kind = if_else(code == "SSH" | is.na(obs), NA_character_, obs_kind))
row_order <- c("GTU", "GTN", "CF", "SSP", "RD", "SSH", "BHS", "CSM", "AB")
base <- base %>% mutate(label = factor(label, levels = rev(label[match(row_order, code)])))

col_lk <- "#7B3294"; col_req <- "#D95F0E"
key_hrange <- function(data, params, size) {
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5, gp = grid::gpar(col = data$colour, lwd = 0.5 * .pt)),
    draw_key_point(data, params, size))
}
key_bar <- function(data, params, size) {
  grid::grobTree(
    grid::segmentsGrob(0.05, 0.5, 0.95, 0.5,
                       gp = grid::gpar(col = alpha(data$colour, 0.4), lwd = 2.2 * .pt, lineend = "butt")),
    draw_key_point(data, params, size))
}
theme_rows <- theme_classic(base_size = 9, base_family = "sans") +
  theme(strip.background = element_blank(),
        strip.text.y = element_text(angle = 0, face = "bold", hjust = 0),
        panel.grid.major.x = element_line(colour = "grey92", linewidth = 0.3),
        panel.spacing = unit(2.5, "mm"),
        legend.position = "bottom", legend.location = "plot",
        legend.key.spacing.y = unit(0.5, "mm"), legend.key.spacing.x = unit(4, "mm"),
        legend.text = element_text(size = 8, hjust = 0), legend.key.width = unit(7, "mm"),
        plot.margin = margin(2, 2, 2, 2, "mm"), plot.tag = element_text(face = "bold"))
y_scale <- scale_y_discrete(labels = function(l) parse(text = base$label_math[match(l, base$label)]))
x_log <- function(lims, brks) scale_x_log10(limits = lims, breaks = brks, expand = c(0, 0), oob = scales::oob_squish,
                                            labels = scales::label_math(10^.x, format = log10))

# --- Figure 2A (and its gene-count twin): total N_e/N against the observed ------
plot_total <- function(part) {
  d <- base %>% left_join(filter(summ, partition == part), by = "code")
  lab_unl <- expression("Unlinked: 1" / (1 + 4 * kappa * hat(italic(V))[A]) * ", mode and 95% HPD")
  lab_lk  <- expression("With linkage (total): " * bar(Omega) / (1 + 4 * kappa * hat(italic(V))[A]) *
                          ", assigned DFE: mode and 95% HPD")
  lab_own <- expression("Observed: " * delta * ", " * pi * " of study species")
  lab_lit <- expression("Observed: " * delta * ", " * pi * " from another population")
  ggplot(d, aes(y = label)) +
    geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
    geom_linerange(aes(xmin = tot_lo, xmax = tot_hi), colour = col_lk, linewidth = 2.2, alpha = 0.4) +
    geom_point(aes(x = tot_mode, colour = "lk"), shape = 16, size = 1.8, key_glyph = key_bar) +
    geom_linerange(aes(xmin = unl_lo, xmax = unl_hi), linewidth = 0.4) +
    geom_point(aes(x = unl, colour = "unl"), shape = 21, fill = "white", size = 1.8, stroke = 0.6,
               key_glyph = key_hrange) +
    geom_linerange(aes(xmin = obs_lo, xmax = obs_hi), colour = col_req, linewidth = 0.5, na.rm = TRUE) +
    geom_point(data = filter(d, obs_kind == "own"), aes(x = obs, colour = "own"),
               shape = 18, size = 2.6, key_glyph = key_hrange) +
    geom_point(data = filter(d, obs_kind == "lit"), aes(x = obs, colour = "lit"),
               shape = 5, size = 2, stroke = 0.7, key_glyph = key_hrange) +
    scale_colour_manual(values = c(unl = "black", lk = col_lk, own = col_req, lit = col_req),
                        breaks = c("unl", "lk", "own", "lit"),
                        labels = list(lab_unl, lab_lk, lab_own, lab_lit), name = NULL,
                        guide = guide_legend(ncol = 1)) +
    x_log(c(1e-5, 1.25), 10^(-5:0)) + y_scale +
    facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
    labs(x = expression("Effective size relative to breeding adults, " * italic(N)[e] / italic(N)), y = NULL) +
    theme_rows
}

# --- Supplementary: the linked factor alone ------------------------------------
plot_omega <- function(part) {
  d <- base %>% left_join(filter(summ, partition == part), by = "code")
  lab_om <- expression(bar(Omega) * ": " * italic(N)[e] / italic(N) *
                         " with linkage relative to unlinked, assigned DFE: mode and 95% HPD")
  ggplot(d, aes(y = label)) +
    geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
    geom_linerange(aes(xmin = om_lo, xmax = om_hi), colour = col_lk, linewidth = 2.2, alpha = 0.4) +
    geom_point(aes(x = om_mode, colour = "om"), shape = 16, size = 1.8, key_glyph = key_bar) +
    scale_colour_manual(values = c(om = col_lk), labels = list(lab_om), name = NULL) +
    y_scale +
    x_log(c(1e-4, 1.05), 10^(-4:0)) +
    facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
    labs(x = expression("Linked effect alone, " * bar(Omega)), y = NULL) +
    theme_rows
}

# --- Figure 2B, C: map architecture alone ---------------------------------------
# At one common Z and V_A, Omega depends only on each genome's maps and coding
# partition, so species differences in B and C are differences in recombination
# landscape, not in DFE (Z) or in measured V_A.
s_common <- 0.01; V_common <- 0.1          # uniform effects, Z = 1 - s = 0.99
arch <- bind_rows(lapply(pops$code, function(cd) {
  a <- filter(auto, code == cd); m <- filter(a, has_map); f <- f_share(m, a, "bp")
  cf <- linked_coefs(m, dfe_uniform(s_common)); vh <- V_common * f / 2
  data.frame(code = cd, M = m$M_morgans, f = f, L = m$Physical_Length_bp,
             micro = m$Physical_Length_bp < 20e6,
             om_i = exp(-vh * (cf$A - cf$B)))
})) %>% mutate(taxon = if_else(code %in% birds, "Birds", "Mammals"))
arch_g <- arch %>% group_by(code) %>%
  summarise(om_bar = sum(L / sum(L) * om_i), cM_Mb = 100 * sum(M) / (sum(L) / 1e6), .groups = "drop")

col_tx <- c(Birds = "#7B3294", Mammals = "#008837")
plot_arch_rows <- function() {
  d <- base %>% left_join(arch_g, by = "code")
  ggplot(d, aes(y = label)) +
    geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
    geom_segment(aes(x = 1, xend = om_bar, yend = label), linewidth = 0.4, colour = "grey70") +
    geom_point(aes(x = om_bar, colour = taxon), size = 2) +
    geom_text(aes(x = 0.42, label = sprintf("%.1f", cM_Mb)), size = 2.3, hjust = 0, colour = "grey30") +
    geom_text(data = data.frame(taxon = "Birds"), aes(x = 0.42, y = Inf, label = "cM/Mb"),
              inherit.aes = FALSE, hjust = 0, vjust = -0.6, size = 2.3, colour = "grey30") +
    scale_colour_manual(values = col_tx, guide = "none") +
    scale_x_continuous(limits = c(0.4, 1.02), breaks = c(0.6, 0.8, 1), expand = c(0, 0)) +
    scale_y_discrete(labels = NULL) +
    facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
    coord_cartesian(clip = "off") +
    labs(x = expression(bar(Omega) * ", maps only"), y = NULL,
         tag = "B") +
    theme_rows + theme(strip.text.y = element_blank(), axis.ticks.y = element_blank(),
                       plot.margin = margin(9, 2, 2, 1, "mm"),
                       plot.tag.position = c(0.05, 1.07))
}
plot_arch_chrom <- function() {
  ggplot(arch, aes(f / M, om_i)) +
    geom_point(aes(colour = taxon, shape = micro), size = 1.5, stroke = 0.5, alpha = 0.8) +
    scale_colour_manual(values = col_tx, name = NULL) +
    scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 1), name = NULL,
                       labels = c(`FALSE` = "chromosome ≥ 20 Mb", `TRUE` = "microchromosome < 20 Mb")) +
    scale_x_log10(labels = scales::label_math(10^.x, format = log10)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    labs(x = expression("Selective target per Morgan, " * italic(f)[i] / italic(M)[i]),
         y = expression("Chromosome " * Omega[i]), tag = "C") +
    theme_classic(base_size = 9, base_family = "sans") +
    theme(panel.grid.major = element_line(colour = "grey92", linewidth = 0.3),
          legend.position = "bottom", legend.text = element_text(size = 8),
          plot.tag = element_text(face = "bold"))
}

save_fig <- function(p, stem, w, h) {
  dir.create(dirname(stem), showWarnings = FALSE)
  ggsave(paste0(stem, ".pdf"), p, width = w, height = h, units = "mm", device = cairo_pdf)
  ggsave(paste0(stem, ".tiff"), p, width = w, height = h, units = "mm", dpi = 600,
         device = ragg::agg_tiff, compression = "lzw")
  pv <- Sys.getenv("FIG_PREVIEW_DIR")
  if (nzchar(pv)) ggsave(file.path(pv, paste0(basename(stem), ".png")), p, width = w, height = h,
                         units = "mm", dpi = 200, device = ragg::agg_png)
}
library(patchwork)
fig2 <- ((plot_total("bp") + labs(tag = "A") + theme(legend.location = "panel",
           legend.justification = "left")) + plot_arch_rows() + plot_layout(widths = c(4, 1))) /
  plot_arch_chrom() + plot_layout(heights = c(1, 0.9))
save_fig(fig2,               "main/Fig2_linked",       178, 160)
save_fig(plot_total("gene"), "supp/FigS_linked_fgene", 178, 80)
save_fig(plot_omega("bp"),   "supp/FigS_omega",        150, 70)

print(as.data.frame(base %>% select(code, unl, obs) %>%
  left_join(summ %>% select(code, partition, tot_mode, tot_lo, om_mode, om_lo), by = "code") %>%
  tidyr::pivot_wider(names_from = partition, values_from = c(tot_mode, tot_lo, om_mode, om_lo)) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))))

# Methods' uniform effects (s = 0.005, 0.01, 0.02) and s = s* = hat V_A / U_d, at the
# hat V_A mode, coding-bp partition: Omega_bar, and the total against the observed delta.
unif <- bind_rows(lapply(pops$code, function(cd) {
  a <- filter(auto, code == cd); m <- filter(a, has_map); f <- f_share(m, a, "bp")
  r <- pops[pops$code == cd, ]; s_star <- r$va_mode / r$U_d_direct
  bind_rows(lapply(c(0.005, 0.01, 0.02, s_star), function(s)
    data.frame(code = cd, s = if (s == s_star) "s*" else format(s),
               s_val = s, omega = omega_fun(m, f, r$kappa, dfe_uniform(min(s, 0.99)))(r$va_mode))))
})) %>% left_join(base %>% select(code, unl, obs), by = "code") %>%
  mutate(total = omega * unl)
cat("\nUniform effects (Methods), at the hat V_A mode:\n")
print(as.data.frame(unif %>% select(code, s, s_val, omega) %>%
  tidyr::pivot_wider(id_cols = code, names_from = s, values_from = omega) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))))

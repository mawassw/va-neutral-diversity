# ==============================================================================
# fig2_linked.R — Figure 2: linkage deepens the reduction, far short of the deficit
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fig2_linked.R
# Reads only through load_data.R; model in linked.R. Writes
#   main/Fig2_linked.{pdf,tiff}          primary: f_i from coding bp
#   supp/FigS_linked_fgene.{pdf,tiff}    the same with f_i from gene counts
#   supp/FigS_omega.{pdf,tiff}           the linked factor Omega_bar alone
#
# One row per population in the linked set (9: mapped autosomes, microchromosomes
# included), on one log axis of N_e/N (effective size relative to census):
#   unlinked      1 / (1 + 4 kappa hat V_A): mode (circle), 95% HPD (line)
#   with linkage  the total, unlinked and linked combined:
#                 Omega_bar / (1 + 4 kappa hat V_A), Omega_bar from the composite
#                 model at the persistence Z = 1 - E[s^2]/E[s] of each measured
#                 DFE in the population's taxon (data/dfe_reference.csv).
#                 Thick bar: range over those DFEs at the hat V_A mode; faint
#                 extension: also over the 95% HPD of hat V_A; dot: the lowest
#                 N_e/N at the mode (most generous to the mechanism).
#                 Birds: pied and collared flycatcher (Z = 0.998, 0.988);
#                 mammals: mouse, vaquita, fin whale (Z = 0.94, 0.89, 0.78)
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

dfe <- read.csv("data/dfe_reference.csv") %>%
  filter(used_for_band == "yes") %>%
  mutate(Z = Z_gamma(shape_alpha, scale_beta_prime))

# Omega_bar for every population x taxon DFE x hat V_A (HPD low, mode, HPD high)
# x partition
grid <- pops %>%
  mutate(taxon = if_else(code %in% birds, "Birds", "Mammals")) %>%
  select(code, taxon, kappa, lo = va_hpd95_lo, mode = va_mode, hi = va_hpd95_hi) %>%
  tidyr::pivot_longer(c(lo, mode, hi), names_to = "va_at", values_to = "Va") %>%
  inner_join(dfe %>% select(taxon, dfe_sp = common_name, Z), by = "taxon",
             relationship = "many-to-many") %>%
  tidyr::crossing(partition = c("bp", "gene"))
grid$omega <- mapply(function(cd, Va, k, Z, part) {
  a <- filter(auto, code == cd); m <- filter(a, has_map)
  omega_bar(m, Va, k, Z, f_share(m, a, part))
}, grid$code, grid$Va, grid$kappa, grid$Z, grid$partition)
grid <- grid %>% mutate(unl = 1 / (1 + 4 * kappa * Va), total = omega * unl)

summ <- grid %>%
  group_by(code, partition) %>%
  summarise(tot_mode_lo = min(total[va_at == "mode"]), tot_mode_hi = max(total[va_at == "mode"]),
            tot_all_lo = min(total), tot_all_hi = max(total),
            om_mode_lo = min(omega[va_at == "mode"]), om_mode_hi = max(omega[va_at == "mode"]),
            om_all_lo = min(omega), om_all_hi = max(omega), .groups = "drop")

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
    grid::segmentsGrob(0.02, 0.5, 0.98, 0.5,
                       gp = grid::gpar(col = alpha(data$colour, 0.25), lwd = 2.2 * .pt, lineend = "butt")),
    grid::segmentsGrob(0.25, 0.5, 0.75, 0.5,
                       gp = grid::gpar(col = alpha(data$colour, 0.6), lwd = 2.2 * .pt, lineend = "butt")),
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
x_log <- function(lims, brks) scale_x_log10(limits = lims, breaks = brks, expand = c(0, 0),
                                            labels = scales::label_math(10^.x, format = log10))

# --- Figure 2A (and its gene-count twin): total N_e/N against the observed ------
plot_total <- function(part) {
  d <- base %>% left_join(filter(summ, partition == part), by = "code")
  lab_unl <- expression("Unlinked: 1" / (1 + 4 * kappa * hat(italic(V))[A]) * ", mode and 95% HPD")
  lab_lk  <- expression("With linkage (total): " * bar(Omega) / (1 + 4 * kappa * hat(italic(V))[A]) *
                          ", over measured DFEs; faint: and over the HPD")
  lab_own <- expression("Observed: " * delta * ", " * pi * " of study species")
  lab_lit <- expression("Observed: " * delta * ", " * pi * " from another population")
  ggplot(d, aes(y = label)) +
    geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
    geom_linerange(aes(xmin = tot_all_lo, xmax = tot_all_hi), colour = col_lk, linewidth = 2.2,
                   alpha = 0.22) +
    geom_linerange(aes(xmin = tot_mode_lo, xmax = tot_mode_hi), colour = col_lk, linewidth = 2.2,
                   alpha = 0.6) +
    geom_point(aes(x = tot_mode_lo, colour = "lk"), shape = 16, size = 1.8, key_glyph = key_bar) +
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
    labs(x = expression("Effective size relative to census, " * italic(N)[e] / italic(N)), y = NULL) +
    theme_rows
}

# --- Supplementary: the linked factor alone ------------------------------------
plot_omega <- function(part) {
  d <- base %>% left_join(filter(summ, partition == part), by = "code")
  lab_om <- expression(bar(Omega) * ": " * italic(N)[e] / italic(N) *
                         " with linkage relative to unlinked, over measured DFEs; faint: and over the HPD")
  ggplot(d, aes(y = label)) +
    geom_vline(xintercept = 1, linewidth = 0.3, colour = "grey60") +
    geom_linerange(aes(xmin = om_all_lo, xmax = om_all_hi), colour = col_lk, linewidth = 2.2,
                   alpha = 0.22) +
    geom_linerange(aes(xmin = om_mode_lo, xmax = om_mode_hi), colour = col_lk, linewidth = 2.2,
                   alpha = 0.6) +
    geom_point(aes(x = om_mode_lo, colour = "om"), shape = 16, size = 1.8, key_glyph = key_bar) +
    scale_colour_manual(values = c(om = col_lk), labels = list(lab_om), name = NULL) +
    y_scale +
    scale_x_log10(limits = c(0.01, 1.05), breaks = c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1),
                  labels = c("0.01", "0.02", "0.05", "0.1", "0.2", "0.5", "1"), expand = c(0, 0)) +
    facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
    labs(x = expression("Linked effect alone, " * bar(Omega)), y = NULL) +
    theme_rows
}

# --- Figure 2B, C: map architecture alone ---------------------------------------
# At one common Z and V_A, Omega depends only on each genome's maps and coding
# partition, so species differences in B and C are differences in recombination
# landscape, not in DFE (Z) or in measured V_A.
Z_common <- 0.99; V_common <- 0.1
arch <- bind_rows(lapply(pops$code, function(cd) {
  a <- filter(auto, code == cd); m <- filter(a, has_map); f <- f_share(m, a, "bp")
  k <- pops$kappa[pops$code == cd]; q2 <- Q2bar_vec(m$M_morgans, Z_common); vh <- V_common * f / 2
  data.frame(code = cd, M = m$M_morgans, f = f, L = m$Physical_Length_bp,
             micro = m$Physical_Length_bp < 20e6,
             om_i = exp(-q2 * vh) * (1 + Qu2(Z_common) * k * V_common) /
                    (1 + Qu2(Z_common) * (k * V_common - vh)))
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
  left_join(summ %>% select(code, partition, tot_mode_lo, tot_all_lo, om_mode_lo, om_all_lo), by = "code") %>%
  tidyr::pivot_wider(names_from = partition, values_from = c(tot_mode_lo, tot_all_lo, om_mode_lo, om_all_lo)) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))))

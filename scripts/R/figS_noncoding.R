# ==============================================================================
# figS_noncoding.R — sensitivity to the functional target beyond coding sequence
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/figS_noncoding.R
# Reads data/processed/ through load_data.R and data/functional_target_lengths.csv
# (scripts/R/functional_target.R); model in linked.R. Writes
#   supp/FigS_noncoding.{pdf,tiff}
#   data/processed/noncoding_sensitivity.csv   per population x phi (both panels)
#
# The primary analysis takes the deleterious target to be the autosomal exome
# doubled, U_d = 4 mu L_coding, and partitions V_A among autosomes by coding bp.
# Here the target is built from the annotation instead, with one dial:
#   T_i(phi) = L_annot,i + phi L_other,i       per autosome i
#   L_annot  = |CDS u UTR u non-coding RNA exons| (collapsed), L_other = the rest
#   U_d(phi) = 2 mu_direct sum_i T_i(phi)      (no extra factor 2; phi replaces it)
# phi in [0, 0.15], the fraction of unannotated sequence (introns, intergenic) under
# purifying selection. phi_eq solves U_d(phi_eq) = 4 mu L_coding: the current target.
#   a  maintenance test, 18 populations with a U_d: hat V_A / (U_d(phi) s_bar) at the
#      hat V_A posterior mode and the point direct mu, s_bar the mean of the assigned
#      DFE (dfe_assigned(), the point convention of the text). Faint: populations
#      (by taxon); bold: median across populations over [0, 0.15]. Open circle: each
#      population's current target, at phi_eq. phi_eq is below 0 (current target
#      smaller than the annotation) for 14 of 18, so the axis extends left to the
#      smallest phi_eq; that strip is shaded, and lines enter it only from phi_eq.
#      Solid vertical: phi = 0 (annotation only); dashed: median phi_eq.
#   b  mapped set (9): total genome-wide N_e/N with linkage, Omega_bar / (1 + 4 kappa
#      hat V_A) as in fig2_linked.R, at the hat V_A mode and assigned DFE, with
#      f_i(phi) = T_i(phi) / sum over all autosomes of T_i(phi). Only Omega_bar
#      depends on phi (sum_i f_i = 1, so the global term does not move). Grey dashed:
#      the coding-bp partition of Figure 2. Orange: observed delta, where pi and an
#      own-species Buffalo N_c exist (as Figure 2; Soay N_c is domestic sheep).
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(patchwork)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")
source("scripts/R/theme_genetics.R")

phi <- seq(0, 0.15, by = 0.0025)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")
ft <- readr::read_csv("data/functional_target_lengths.csv", show_col_types = FALSE,
                      col_types = readr::cols(NCBI_Chromosome = readr::col_character()))
s_bar <- vapply(dfe_assigned(), `[[`, numeric(1), "s_bar")
lab_of <- function(d) d %>% mutate(
  taxon = if_else(code %in% birds, "Birds", "Mammals"),
  label = pop_label(sub(" \\(.*\\)$", "", common_name), sub("^tiritiri", "Tiritiri", location)))

# --- a: maintenance ratio against phi -----------------------------------------
msd <- load_populations("msd") %>% lab_of() %>%
  left_join(ft %>% group_by(code) %>%
              summarise(A = sum(L_annot), O = sum(L_other), C = sum(L_cds), .groups = "drop"),
            by = "code") %>%
  mutate(s_bar = unname(s_bar[code]),
         ratio_now = va_mode / (U_d_direct * s_bar),
         phi_eq = (2 * L_coding_bp - A) / O,
         phi_one = (va_mode / (2 * mu_direct * s_bar) - A) / O)
stopifnot(nrow(msd) == 18, !anyNA(msd$A))
# U_d(phi_eq) is the current U_d by construction, so the ratio there is the current one
chk <- with(msd, va_mode / (2 * mu_direct * (A + phi_eq * O) * s_bar))
stopifnot(isTRUE(all.equal(chk, msd$ratio_now)))
ma <- tidyr::crossing(msd %>% select(code, label, taxon, va_mode, mu_direct, s_bar, A, O), phi = phi) %>%
  mutate(U_d = 2 * mu_direct * (A + phi * O), ratio = va_mode / (U_d * s_bar))
ma_med <- ma %>% group_by(phi) %>% summarise(ratio = median(ratio), .groups = "drop")

# --- b: linked total against phi ----------------------------------------------
lk <- load_populations("linked") %>% lab_of()
obs <- load_diversity()
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE) %>%
  left_join(ft %>% select(code, NCBI_Chromosome, L_annot, L_other), by = c("code", "NCBI_Chromosome"))
stopifnot(!anyNA(auto$L_annot[auto$code %in% lk$code]))
dfe_pop <- dfe_assigned()
lb <- bind_rows(lapply(lk$code, function(cd) {
  a <- filter(auto, code == cd); r <- lk[lk$code == cd, ]
  mm <- a$has_map; m <- a[mm, ]
  unl <- 1 / (1 + 4 * r$kappa * r$va_mode)
  om <- vapply(phi, function(p) {
    Ti <- a$L_annot + p * a$L_other
    omega_fun(m, Ti[mm] / sum(Ti), r$kappa, dfe_pop[[cd]])(r$va_mode)
  }, numeric(1))
  om_bp <- omega_fun(m, f_share(m, a, "bp"), r$kappa, dfe_pop[[cd]])(r$va_mode)
  data.frame(code = cd, phi = phi, omega = om, total = om * unl,
             omega_bp = om_bp, total_bp = om_bp * unl)
})) %>% left_join(lk %>% select(code, label, taxon), by = "code")

delta <- lk %>% select(code, label, taxon, mu_direct) %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(delta = coalesce(pi_obs, pi_lit) / (4 * mu_direct * 10^log10_Nc),
         delta = if_else(code == "SSH", NA_real_, delta)) %>%   # domestic Ovis aries N_c
  filter(!is.na(delta))

readr::write_csv(
  full_join(ma %>% select(code, phi, U_d, ratio_maintenance = ratio),
            lb %>% select(code, phi, omega_bar = omega, ne_n_total = total,
                          omega_bar_coding_bp = omega_bp, ne_n_total_coding_bp = total_bp),
            by = c("code", "phi")),
  "data/processed/noncoding_sensitivity.csv")

# --- figure -------------------------------------------------------------------
col_tx <- c(Birds = "#7B3294", Mammals = "#008837")
col_req <- "#D95F0E"
x_phi <- scale_x_continuous(limits = c(0, 0.15), breaks = seq(0, 0.15, 0.05),
                            labels = function(x) paste0(100 * x, "%"), expand = c(0, 0))
y_log <- function(lims, brks) scale_y_log10(limits = lims, breaks = brks, expand = c(0, 0),
                                            labels = scales::label_math(10^.x, format = log10))

# a: each population's line runs from its current target (phi_eq, open circle) where
# phi_eq < 0, i.e. where the current target is smaller than the annotation, to the
# top of the grid; the shaded strip is that sub-annotation range. Vertical lines: the
# annotation-only target (phi = 0, solid) and the median phi_eq (dashed).
phi_lo <- floor(min(msd$phi_eq) / 0.005) * 0.005
ma_ext <- bind_rows(lapply(seq_len(nrow(msd)), function(k) {
  r <- msd[k, ]; p <- sort(unique(c(if (r$phi_eq < 0) r$phi_eq, phi[phi >= min(r$phi_eq, 0)])))
  data.frame(code = r$code, taxon = r$taxon, phi = p,
             ratio = r$va_mode / (2 * r$mu_direct * (r$A + p * r$O) * r$s_bar))
}))
med_eq <- median(msd$phi_eq)
med_top <- ma_med$ratio[ma_med$phi == max(phi)]
pa <- ggplot() +
  annotate("rect", xmin = phi_lo, xmax = 0, ymin = 0.03, ymax = 2000, fill = "grey92") +
  geom_hline(yintercept = 1, linewidth = 0.4, colour = "grey30") +
  geom_vline(xintercept = 0, linewidth = 0.3, colour = "grey30") +
  geom_vline(xintercept = med_eq, linewidth = 0.3, colour = "grey30", linetype = "22") +
  geom_line(data = ma_ext, aes(phi, ratio, group = code, colour = taxon), linewidth = 0.35, alpha = 0.55) +
  geom_point(data = msd, aes(phi_eq, ratio_now, colour = taxon), shape = 21, fill = "white",
             size = 1.3, stroke = 0.45) +
  geom_line(data = ma_med, aes(phi, ratio), linewidth = 1.1, colour = "black") +
  annotate("text", x = 0, y = 0.038, label = "annotation only", angle = 90, hjust = 0,
           vjust = -0.5, size = pt_mm(7), family = fig_family) +
  annotate("text", x = med_eq, y = 0.038, label = "current, median", angle = 90,
           hjust = 0, vjust = -0.5, size = pt_mm(7), family = fig_family) +
  annotate("text", x = 0.149, y = med_top * 1.3, label = "median", hjust = 1, vjust = 0,
           size = pt_mm(7), family = fig_family, fontface = "bold") +
  scale_colour_manual(values = col_tx, name = NULL) +
  scale_x_continuous(limits = c(phi_lo, 0.15), breaks = seq(0, 0.15, 0.05),
                     labels = function(x) paste0(100 * x, "%"), expand = c(0, 0)) +
  y_log(c(0.03, 2000), 10^(-1:3)) +
  coord_cartesian(clip = "off") +
  labs(x = expression("Unannotated sequence under purifying selection, " * varphi),
       y = expression(hat(italic(V))[A] / (italic(U)[d](varphi) * bar(italic(s)))), tag = "a") +
  theme_genetics(grid_y = TRUE) +
  theme(legend.position = "inside", legend.position.inside = c(0.98, 0.98),
        legend.justification = c(1, 1), legend.direction = "vertical")

# b: one facet per mapped population, common log axis
row_order <- c("GTU", "GTN", "CF", "SSP", "RD", "SSH", "BHS", "CSM", "AB")
lvl <- lk$label[match(row_order, lk$code)]
lb <- lb %>% mutate(label = factor(label, levels = lvl))
delta <- delta %>% mutate(label = factor(label, levels = lvl))
bp_ref <- lb %>% distinct(code, label, taxon, total_bp)
no_delta <- bp_ref %>% filter(!code %in% delta$code) %>%
  mutate(x = 0.075, y = 1e-4, lab = "no observed δ")
lab_bp <- "Coding-bp partition (Figure 2)"
lab_dl <- expression("Observed " * delta)
pb <- ggplot(lb, aes(phi, total)) +
  geom_hline(data = bp_ref, aes(yintercept = total_bp, linetype = "bp"), linewidth = 0.35,
             colour = "grey45") +
  geom_hline(data = delta, aes(yintercept = delta, linetype = "dl"), linewidth = 0.35,
             colour = col_req) +
  geom_line(aes(colour = taxon), linewidth = 0.7) +
  geom_text(data = no_delta, aes(x = x, y = y, label = lab), size = pt_mm(7),
            family = fig_family, colour = "grey45") +
  scale_colour_manual(values = col_tx, guide = "none") +
  scale_linetype_manual(values = c(bp = "22", dl = "solid"), breaks = c("bp", "dl"),
                        labels = list(lab_bp, lab_dl), name = NULL) +
  scale_x_continuous(limits = c(0, 0.15), breaks = c(0, 0.05, 0.1, 0.15),
                     labels = c("0", "5", "10", "15"), expand = c(0, 0)) +
  y_log(c(1e-5, 1), 10^c(-4, -2, 0)) +
  facet_wrap(~ label, ncol = 3, labeller = label_wrap_gen(30)) +
  labs(x = expression("Unannotated sequence under purifying selection, " * varphi * " (%)"),
       y = expression("Genome-wide " * italic(N)[e] / italic(N) * " with linkage"), tag = "b") +
  theme_genetics(grid_y = TRUE) +
  theme(strip.text = element_text(size = 7, face = "plain"), panel.spacing.x = unit(5, "mm"),
        panel.spacing.y = unit(1.5, "mm"), legend.key.width = unit(5, "mm"))

fig <- pa / pb + plot_layout(heights = c(1, 1.45))
dir.create("supp", showWarnings = FALSE)
ggsave("supp/FigS_noncoding.pdf", fig, width = 178, height = 160, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_noncoding.tiff", fig, width = 178, height = 160, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
pv <- Sys.getenv("FIG_PREVIEW_DIR")
if (nzchar(pv)) ggsave(file.path(pv, "FigS_noncoding.png"), fig, width = 178, height = 160,
                       units = "mm", dpi = 200, device = ragg::agg_png)

# --- report -------------------------------------------------------------------
options(width = 160)
at <- function(p) ma %>% filter(abs(phi - p) < 1e-9)
cat("\nphi_eq (U_d(phi_eq) = 4 mu L_coding): median", signif(med_eq, 3), "range",
    paste(signif(range(msd$phi_eq), 3), collapse = " to "), "\n")
cat("L_annot / (2 L_coding): range", paste(signif(range(msd$A / (2 * msd$L_coding_bp)), 3), collapse = "-"), "\n")
cat("Current ratio (point convention): median", signif(median(msd$ratio_now), 3), "\n")
for (p in c(0, 0.05, 0.1, 0.15)) cat(sprintf("phi = %.2f: median %.3g, range %.3g-%.3g, n(<1) = %d, n(<3) = %d\n",
  p, median(at(p)$ratio), min(at(p)$ratio), max(at(p)$ratio), sum(at(p)$ratio < 1), sum(at(p)$ratio < 3)))
print(as.data.frame(msd %>% arrange(phi_one) %>% transmute(code, label, phi_eq = signif(phi_eq, 3),
  ratio_now = signif(ratio_now, 3), ratio_phi0 = signif(at(0)$ratio[match(code, at(0)$code)], 3),
  ratio_phi15 = signif(at(0.15)$ratio[match(code, at(0.15)$code)], 3), phi_ratio_one = signif(phi_one, 3))))
cat("\nLinked (mapped set), hat V_A mode, assigned DFE:\n")
print(as.data.frame(lb %>% filter(abs(phi) < 1e-9 | abs(phi - 0.15) < 1e-9) %>%
  select(code, phi, omega, total, total_bp) %>%
  tidyr::pivot_wider(names_from = phi, values_from = c(omega, total)) %>%
  left_join(delta %>% select(code, delta), by = "code") %>%
  mutate(rel_phi0 = total_0 / total_bp - 1, rel_phi15 = total_0.15 / total_bp - 1,
         gap_phi15 = total_0.15 / delta) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))))

####### poster_figs.R — poster-scale figures for the MWPG 2026 poster ##########
#
# WHY THIS EXISTS. The TIFFs in main/ are sized for a journal page (7–12.6 in
# wide). On a 30x40 poster they get placed at 0.54–0.65x, which shrinks their
# axis type proportionally and is what makes them hard to read on the wall.
# This script re-renders them at EXACTLY the size each one occupies on the
# poster, so the placement scale is 1.0 and axis text lands at a known point
# size on the printed sheet.
#
# It also builds one figure that does not exist yet: the bound as a function of
# the retained diversity fraction (Panel B).
#
# It does NOT modify the manuscript pipeline. unlinked.R / data_gen.R are
# sourced with two shims so nothing in the repo is touched:
#   read.csv : falls back to data/<name> when a bare filename is absent (Rule 2)
#   tiff     : sends those scripts' own manuscript TIFFs to a scratch dir
#
# Run from the repo root:   Rscript scripts/R/poster_figs.R
################################################################################

OUTDIR  <- "poster/figs"
SCRATCH <- file.path(tempdir(), "manuscript_tiffs")
dir.create(OUTDIR,  showWarnings = FALSE, recursive = TRUE)
dir.create(SCRATCH, showWarnings = FALSE, recursive = TRUE)

## ---- shims -------------------------------------------------------------------
.real_tiff <- grDevices::tiff
tiff <- function(filename, ...) {
  .real_tiff(file.path(SCRATCH, basename(filename)), ...)
}

# unlinked.R also writes SuppTable1_Bayesian_Indices.csv into the CWD; divert it
# so a poster build does not drop a duplicate at the repo root.
.real_write_csv <- utils::write.csv
write.csv <- function(x, file = "", ...) {
  # a bare filename (no directory part) would land in the repo root
  if (is.character(file) && nzchar(file) && identical(basename(file), file)) {
    file <- file.path(SCRATCH, file)
  }
  .real_write_csv(x, file, ...)
}

.real_read_csv <- utils::read.csv
read.csv <- function(file, ...) {
  if (is.character(file) && !file.exists(file) && file.exists(file.path("data", file))) {
    file <- file.path("data", file)
  }
  .real_read_csv(file, ...)
}

message("sourcing unlinked.R (builds df_va from alldistzip) ...")
source("scripts/R/unlinked.R")

library(ggplot2)
library(dplyr)

## ---- palette (matches the poster) --------------------------------------------
SLATE  <- "#1E242B"   # primary text / structure
INDIGO <- "#2C4A6F"   # theoretical / neutral baseline
RUST   <- "#C85227"   # discrepancy signal
SAGE   <- "#4D7A68"   # secondary / mediators

## ---- poster theme ------------------------------------------------------------
# Sizes are absolute points as they will appear on the printed poster, because
# every figure below is rendered at its exact placed size.
#
# Hard constraint worth knowing before raising these: the 19-population forest
# plots get ~0.30 in per row (5.72 in / 19), so species labels cannot exceed
# ~14 pt without colliding. Bigger labels require a taller panel, not a bigger
# base_size.
theme_Poster <- function(base = 20, axis_text = 14, legend_text = 15) {
  theme_classic(base_size = base, base_family = "serif") +
    theme(
      axis.title       = element_text(face = "bold", size = base, colour = SLATE),
      axis.text        = element_text(size = axis_text, colour = SLATE),
      axis.line        = element_line(colour = SLATE, linewidth = 0.9),
      axis.ticks       = element_line(colour = SLATE, linewidth = 0.9),
      legend.position  = "bottom",
      legend.title     = element_text(face = "bold", size = legend_text),
      legend.text      = element_text(size = legend_text),
      legend.key.width = unit(0.42, "in"),
      strip.text       = element_text(face = "bold", size = legend_text + 1),
      strip.background = element_rect(colour = "grey35", linewidth = 0.8),
      plot.title       = element_text(face = "bold", size = base + 2, colour = SLATE),
      plot.margin      = unit(c(3, 4, 3, 3), "mm")
    )
}

# geom-level sizes are absolute and do not scale with the theme, so bump them
# or points and rules stay journal-sized inside a poster-sized panel.
bump_layers <- function(p, f = 1.6) {
  for (i in seq_along(p$layers)) {
    ap <- p$layers[[i]]$aes_params
    if (!is.null(ap$size))      p$layers[[i]]$aes_params$size      <- ap$size * f
    if (!is.null(ap$linewidth)) p$layers[[i]]$aes_params$linewidth <- ap$linewidth * f
    # the manuscript reference lines are pure red; move them onto the poster accent
    if (!is.null(ap$colour) && ap$colour %in% c("red", "red4"))
      p$layers[[i]]$aes_params$colour <- RUST
  }
  p
}

save_poster <- function(p, file, w, h) {
  .real_tiff(file.path(OUTDIR, file), units = "in", width = w, height = h,
             res = 300, compression = "lzw")
  print(p)
  dev.off()
  cat(sprintf("  %-38s %5.2f x %-5.2f in\n", file, w, h))
}

# Placed sizes reported by poster/make_poster.py. Keep the aspect ratios in
# sync with that report; the width is what fixes the effective type size.
# Sheet is 24 x 36 (was 30 x 40); these are the slots make_poster.py reports for
# that sheet. Panel B used to be 6.94 x 2.46 and was HEIGHT-bound inside a much
# wider region, so a third of its panel width sat unused -- it now fills the
# column, and the right-hand kappa legend is paid for out of that spare width.
DIM_A <- c(4.31, 5.38)   # Panel A  baseline constraint   (portrait 0.80)
DIM_B <- c(10.06, 2.98)  # Panel B  the bound vs delta    (landscape 3.38)
DIM_C <- c(6.67, 3.81)   # Panel C  mu sensitivity        (landscape 1.75)
DIM_D <- c(4.53, 5.66)   # Panel D  Va deflation          (portrait 0.80)

cat("\nwriting poster figures to", OUTDIR, "\n")

## ---- label overrides ---------------------------------------------------------
# The manuscript axis titles and legend labels are written for a wide journal
# figure. At poster type sizes they are longer than the panel is wide, and ggplot
# clips rather than shrinks -- so they have to be shortened, not just re-themed.
# The panel caption in the poster carries the detail these drop.
LAB_NE <- expression(bold("Expected ") * bolditalic(N[e]) * bold("/") *
                       bolditalic(N) * bold("  (log)"))

## =============================================================== Panel A ======
if (exists("p_main")) {
  save_poster(bump_layers(p_main, 1.4) +
                labs(x = LAB_NE, y = NULL) +
                theme_Poster(base = 18, axis_text = 14),
              "PosterFig_A_Baseline_Constraint.tiff", DIM_A[1], DIM_A[2])
} else {
  message("  ! p_main not found; skipping Panel A")
}

## =============================================================== Panel D ======
if (exists("p_deflation")) {
  save_poster(bump_layers(p_deflation, 1.7) +
                labs(x = LAB_NE, y = NULL) +
                scale_color_viridis_d(option = "mako", begin = 0.2, end = 0.8,
                                      direction = -1,
                                      labels = c("100%", "50%", "25%", "10%"),
                                      name = expression(bold("Directional share of ") *
                                                          bolditalic(V[A]))) +
                # One row of four keys overflowed a 4.58 in panel and clipped the
                # last label, so the keys go 2 x 2 and the legend gets a title:
                # bare percentages do not say what they are a percentage of.
                guides(color = guide_legend(nrow = 2, ncol = 2, byrow = TRUE,
                                            title.position = "top")) +
                theme_Poster(base = 18, axis_text = 14, legend_text = 14) +
                theme(legend.title = element_text(face = "bold", size = 14),
                      legend.key.width = unit(0.38, "in")),
              "PosterFig_D_Va_Deflation.tiff", DIM_D[1], DIM_D[2])
} else {
  message("  ! p_deflation not found; skipping Panel D")
}

## =============================================================== Panel B ======
# The bound as a function of the retained diversity fraction.
#
#   V_{A,max}(delta) = (1 - delta) / (4 * kappa * delta)
#
# kappa = 1 is random mating and kappa = 2 obligate monogamy; kappa is bounded
# in [1, 2], so these two curves bracket every mating system in the dataset.
#
# Log y axis on purpose. The bound is hyperbolic as delta -> 1, so a linear axis
# hides the fact that the SIZE of any violation depends steeply on the retained
# diversity fraction assumed. Reading the crossing off this figure is what keeps
# the claim honest: it states the delta above which reported values exceed the
# ceiling, instead of asserting a fixed number of orders of magnitude.
#
# Note the crossing has a closed form. Reported V_A exceeds the ceiling exactly
# when delta > 1 / (1 + 4 * kappa * V_A) — which is the unlinked prediction for
# Ne/N itself. So this panel is Panel A in different coordinates, and "the bound
# is violated" means precisely "observed Ne/N exceeds predicted Ne/N".

delta_seq <- seq(0.005, 0.9995, length.out = 1200)
df_bounds <- rbind(
  data.frame(Delta = delta_seq, Kappa = "Random mating (k = 1)",
             Va_max = (1 - delta_seq) / (4 * 1 * delta_seq)),
  data.frame(Delta = delta_seq, Kappa = "Obligate monogamy (k = 2)",
             Va_max = (1 - delta_seq) / (4 * 2 * delta_seq))
)
df_bounds$Kappa <- factor(df_bounds$Kappa,
                          levels = c("Random mating (k = 1)",
                                     "Obligate monogamy (k = 2)"))
levels(df_bounds$Kappa) <- c("Random mating (\u03ba = 1)",
                             "Obligate monogamy (\u03ba = 2)")

# Per-population posterior modes of Va, so everything reported here is derived
# from the data rather than quoted from the text.
va_mode <- vapply(df_va_filtered,
                  function(v) as.numeric(posterior.mode(as.mcmc(v))),
                  numeric(1))
va_lo <- min(va_mode); va_hi <- max(va_mode); va_md <- median(va_mode)
va_q  <- quantile(va_mode, c(0.25, 0.75))

# delta above which a population violates the kappa = 1 bound. Closed form, and
# it is just the unlinked prediction for Ne/N.
crossing <- function(v, k = 1) 1 / (1 + 4 * k * v)
d_md <- crossing(va_md); d_hi <- crossing(va_hi); d_lo <- crossing(va_lo)
# delta needed for the violation to reach 100x and 1000x, median population
d_100 <- 1 / (1 + 4 * 1 * va_md / 100)
d_1000 <- 1 / (1 + 4 * 1 * va_md / 1000)

cat(sprintf("\n  Va posterior modes: n = %d | min %.4f  Q1 %.4f  median %.4f  Q3 %.4f  max %.4f\n",
            length(va_mode), va_lo, va_q[1], va_md, va_q[2], va_hi))
cat(sprintf("  kappa=1 ceiling exceeded once delta >  %.3f (median pop) | %.3f (highest Va) | %.3f (lowest Va)\n",
            d_md, d_hi, d_lo))
cat(sprintf("  for the median population a 100x excess needs delta > %.4f ; 1000x needs delta > %.4f\n",
            d_100, d_1000))

lab_pop <- sprintf("reported~pedigree~V[A]~(n == %d)", length(va_mode))

p_bound <- ggplot() +
  geom_ribbon(data = subset(df_bounds, Kappa == "Random mating (\u03ba = 1)"),
              aes(x = Delta, ymin = Va_max, ymax = Inf),
              fill = "grey86", alpha = 0.75) +
  # reported Va: interquartile band, median line, and every population as a rug
  annotate("rect", xmin = 0, xmax = 1, ymin = va_q[1], ymax = va_q[2],
           fill = RUST, alpha = 0.18) +
  geom_hline(yintercept = va_md, colour = RUST, linewidth = 1.2) +
  annotate("segment", x = 0, xend = 0.022, y = va_mode, yend = va_mode,
           colour = RUST, linewidth = 0.9) +
  geom_line(data = df_bounds,
            aes(x = Delta, y = Va_max, colour = Kappa, linetype = Kappa),
            linewidth = 1.5) +
  # crossings
  annotate("segment", x = d_md, xend = d_md, y = 1e-4, yend = va_md,
           colour = SLATE, linetype = "dotted", linewidth = 1) +
  annotate("point", x = d_md, y = va_md, colour = SLATE, size = 3.4) +
  # The dotted line and the dot already mark the crossing, so the labels are
  # placed where they fit rather than hard against their line: flush left for the
  # first, right-aligned inside its line for the second. At hjust = 0 the median
  # label ran off the panel edge, and at hjust = 1 the other lost its first letter.
  annotate("text", x = d_md - 0.014, y = 3.5e-3, hjust = 1, vjust = 0,
           label = sprintf("median population\nallowed only if δ < %.2f", d_md),
           colour = SLATE, fontface = "bold", size = 4.5, family = "serif",
           lineheight = 1.0) +
  annotate("segment", x = d_hi, xend = d_hi, y = 1e-4, yend = va_hi,
           colour = SLATE, linetype = "dotted", linewidth = 1) +
  annotate("point", x = d_hi, y = va_hi, colour = SLATE, size = 3.4) +
  annotate("text", x = 0.025, y = 3.4e-4, hjust = 0, vjust = 0,
           label = sprintf("most variable population\nallowed only if δ < %.2f", d_hi),
           colour = SLATE, fontface = "bold", size = 4.5, family = "serif",
           lineheight = 1.0) +
  # Below the median line rather than above it: above, this label crossed the
  # kappa = 2 curve at delta ~ 0.43.
  annotate("text", x = 0.05, y = va_md * 0.40, hjust = 0, parse = TRUE,
           label = lab_pop, colour = RUST, fontface = "bold",
           size = 4.6, family = "serif") +
  annotate("text", x = 0.62, y = 4.6, hjust = 0.5,
           label = "italic(V[A])~\"too large for this much diversity\"",
           parse = TRUE,
           colour = "grey20", fontface = "italic", size = 5.0, family = "serif") +
  scale_colour_manual(values = c(INDIGO, SAGE), name = NULL) +
  scale_linetype_manual(values = c("solid", "longdash"), name = NULL) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), labels = c("0", "0.2", "0.4", "0.6", "0.8", "1")) +
  scale_y_continuous(trans = "log10", breaks = 10^(-4:1),
                     labels = c("0.0001", "0.001", "0.01", "0.1", "1", "10")) +
  coord_cartesian(xlim = c(0, 1), ylim = c(1e-4, 10), expand = FALSE) +
  # delta is DERIVED, not measured (CLAUDE.md Amendment F5), so the axis carries
  # its definition rather than the N_e/N shorthand, which invites exactly the
  # variance-Ne / coalescent-Ne conflation F5 exists to stop.
  labs(x = expression(bold("Neutral diversity retained, ") * bolditalic(delta) *
                        bold(" = ") * bolditalic(pi) * bold("/4") *
                        bolditalic(mu) * bolditalic(N)),
       y = expression(bold("Allowed ") * bolditalic(V[A]))) +
  # Legend along the BOTTOM: on the right it cost ~2.6 in of plotting width, which
  # is the dimension this panel is short of. The height it costs is paid for by
  # trimming the Panel B body allowance in make_poster.py.
  theme_Poster(base = 20, axis_text = 16, legend_text = 17) +
  theme(legend.position = "bottom",
        legend.direction = "horizontal",
        legend.key.height = unit(0.26, "in"),
        legend.key.width = unit(0.62, "in"),
        legend.margin = margin(t = 0, b = 0),
        legend.box.spacing = unit(2, "mm"),
        plot.margin = unit(c(3, 5, 2, 3), "mm"))

save_poster(p_bound, "PosterFig_B_Bound_vs_Delta.tiff", DIM_B[1], DIM_B[2])

## =============================================================== Panel C ======
# Needs the linked model, which lives in data_gen.R. Guarded: if it fails, the
# poster falls back to the existing main/ TIFF for this panel only.
# data_gen.R cannot run start-to-finish from a clean session. The arch_map block
# at line 469 carries a truncated column select:
#
#   left_join(epp_data %>% select(Code, Ud, EPP, Species.y), by = "Code")
#
# Two things are wrong with it. (a) `Species.y` is not a column of
# data/species_EPP.csv -- that name only appears AFTER a join collision with
# chrom_data$Species. (b) it drops mu_1 / X95ci_lower_1 / X95ci_upper_1, which
# the mu-sensitivity block at line 633 then reads off sp_arch. The equivalent
# block at line 73 (see line 86) carries the correct, complete select.
#
# Interactively this survives on leftover session state -- an arch_map from an
# earlier block that still has those columns. That is the dangerous case
# CLAUDE.md Rule 1 describes, and it is why the committed
# MainFig_Empirical_Sensitivity_MutationRate.tiff is not reproducible from a
# clean start.
#
# Fixed below in a temporary copy, so the manuscript pipeline stays untouched.
# The real fix is to make data_gen.R:479 match line 86.
SKIP_DG <- nzchar(Sys.getenv("POSTER_SKIP_DATAGEN"))
DG_BROKEN <- "select(Code, Ud, EPP, Species.y)"
DG_FIXED  <- "select(Code, Ud, EPP, Species, mu_1, X95ci_lower_1, X95ci_upper_1)"

message("sourcing data_gen.R for the linked-model panel (patched copy, slow) ...")
ok_dg <- !SKIP_DG && tryCatch({
  dg <- readLines("scripts/R/data_gen.R", warn = FALSE)
  hits <- grep(DG_BROKEN, dg, fixed = TRUE)
  if (length(hits) != 1) {
    stop(sprintf("expected 1 truncated select, found %d", length(hits)))
  }
  message("  patching data_gen.R line ", hits, " in a temp copy")
  dg[hits] <- sub(DG_BROKEN, DG_FIXED, dg[hits], fixed = TRUE)
  tmp_dg <- file.path(tempdir(), "data_gen_posterpatch.R")
  writeLines(dg, tmp_dg)
  source(tmp_dg)
  TRUE
}, error = function(e) {
  message("  ! data_gen.R failed: ", conditionMessage(e))
  FALSE
})

if (ok_dg && exists("p_Ne_N_Mu") && exists("p_Omega_Mu")) {
  library(patchwork)
  p_left <- bump_layers(p_Ne_N_Mu, 1.6) +
    ggtitle("A · total, with linkage") +
    labs(x = expression(bold("Expected total ") * bolditalic(N[e]) * bold("/") *
                          bolditalic(N) * bold(" (log)")),
         y = NULL, color = "μ:") +
    guides(color = guide_legend(nrow = 1))
  p_right <- bump_layers(p_Omega_Mu, 1.6) +
    ggtitle("B · linkage penalty") +
    labs(x = expression(bold("Genome-wide ") * bolditalic(bar(Omega))),
         y = NULL, color = "μ:")
  p_c <- (p_left + p_right) +
    plot_layout(widths = c(1.25, 1), guides = "collect") &
    theme_Poster(base = 16, axis_text = 11, legend_text = 11)
  # species names are shared, so drop the duplicate axis on the right subpanel
  p_c[[2]] <- p_c[[2]] + theme(axis.text.y = element_blank(),
                               axis.ticks.y = element_blank())
  p_c <- p_c & theme(legend.key.width = unit(0.30, "in"),
                     legend.box.spacing = unit(2, "mm"))
  save_poster(p_c, "PosterFig_C_Mu_Sensitivity.tiff", DIM_C[1], DIM_C[2])
} else {
  message("  ! skipping Panel C; poster will keep the main/ version")
}

cat("\ndone. figures in", normalizePath(OUTDIR, mustWork = FALSE), "\n")
cat("manuscript TIFFs from the sourced scripts were diverted to", SCRATCH, "\n")

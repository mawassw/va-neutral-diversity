# ==============================================================================
# theme_genetics.R — one figure style for Figures 1-5 (GENETICS, OUP)
# ==============================================================================
# Sourced by fig1_unlinked.R ... fig5_rescaling.R. GENETICS author guidelines
# (checked 2026-10-26): panels labelled with lowercase letters in the upper-left
# corner; graphs as vector PDF (TIFF at >= 600 dpi for line art); figures readable
# under colour-vision deficiency; the information fully described by the caption.
# OUP figure guidance: one standard font for all figures (Arial), embedded; line
# weights 0.35-1.5 pt. Figures are drawn at their print width (178 mm, two columns),
# so the sizes below are the printed sizes: axis titles 8 pt, everything else 7 pt,
# nothing below 6 pt.
# ==============================================================================

fig_family <- "Arial"
pt_mm <- function(pt) pt / ggplot2::.pt            # text size for geom_text(), in mm

theme_genetics <- function(grid_x = FALSE, grid_y = FALSE) {
  grid_line <- ggplot2::element_line(colour = "grey92", linewidth = 0.3)
  ggplot2::theme_classic(base_size = 8, base_family = fig_family) +
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 7, colour = "black"),
      axis.title = ggplot2::element_text(size = 8),
      axis.line = ggplot2::element_line(linewidth = 0.3),
      axis.ticks = ggplot2::element_line(linewidth = 0.3),
      panel.grid.major.x = if (grid_x) grid_line else ggplot2::element_blank(),
      panel.grid.major.y = if (grid_y) grid_line else ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(size = 8, face = "bold"),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(size = 7),
      legend.text = ggplot2::element_text(size = 7, hjust = 0),
      legend.key.height = ggplot2::unit(3, "mm"),
      legend.key.width = ggplot2::unit(6, "mm"),
      legend.key.spacing.x = ggplot2::unit(1.5, "mm"),
      legend.key.spacing.y = ggplot2::unit(0.4, "mm"),
      legend.spacing.y = ggplot2::unit(0.8, "mm"),
      legend.margin = ggplot2::margin(0, 0, 0, 0),
      legend.box.spacing = ggplot2::unit(2, "mm"),
      legend.box.just = "left",
      legend.justification = "left",
      legend.location = "plot",
      plot.tag = ggplot2::element_text(size = 10, face = "bold"),
      plot.tag.position = "topleft",
      plot.margin = ggplot2::margin(2, 2, 2, 2, "mm"))
}

# Row label for a population: "Species (Location)", at one size. (Until 2026-10-26
# the location was set in plotmath scriptstyle, about 5 pt at print size.)
pop_label <- function(species, location) paste0(species, " (", location, ")")

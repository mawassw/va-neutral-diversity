# ==============================================================================
# figS_rescaling_linked.R — Figure 5 with linkage, for the linked set
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/figS_rescaling_linked.R
# Reads only through load_data.R; model in linked.R. Writes
# supp/FigS_rescaling_linked.{pdf,tiff}.
#
# As Figure 5 (bar V_A = c hat V_A), for the populations that have both a
# deficit and a linkage map: collared flycatcher, macaque, song sparrow, bighorn
# and both great tits (6 populations, 5 species). Three ratios against c:
#   blue           bar V_A / (U_d s), s = 1e-2 (as Figure 5)
#   orange dashed  observed / predicted loss of diversity, unlinked (as Figure 5)
#   purple         the same with linkage: delta^-1 Omega_bar(bar V_A) / (1 + 4 kappa bar V_A),
#                  at the most generous measured DFE of each taxon (largest Z);
#                  ribbon = range over the taxon's DFEs for the species average
# Bold: species average of log10 ratio (great tits averaged first); faint: populations.
# Grey: outside the formula's domain, bar V_A > 1 at the species-average edge.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")

s_msd <- 1e-2
c_grid <- 10^seq(-4, 3, length.out = 160)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")

pops <- load_populations("linked")
obs <- load_diversity()
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)
dfe <- read.csv("data/dfe_reference.csv") %>% filter(used_for_band == "yes") %>%
  mutate(Z = Z_gamma(shape_alpha, scale_beta_prime))

d <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(deficit = 4 * mu_direct * 10^log10_Nc / coalesce(pi_obs, pi_lit),
         species = sub("^(\\S+ \\S+).*", "\\1", scientific_name),
         taxon = if_else(code %in% birds, "Birds", "Mammals")) %>%
  filter(!is.na(deficit), !is.na(U_d_direct), code != "SSH")

curves <- bind_rows(lapply(seq_len(nrow(d)), function(i) {
  r <- d[i, ]; a <- filter(auto, code == r$code); m <- filter(a, has_map)
  f <- f_share(m, a, "bp"); V <- c_grid * r$va_mode
  unl <- 1 + 4 * r$kappa * V
  lk <- sapply(dfe$Z[dfe$taxon == r$taxon], function(z) omega_fun(m, f, r$kappa, z)(V))
  tibble::tibble(code = r$code, species = r$species, c = c_grid, inside = V < 1,
                 msd = V / (r$U_d_direct * s_msd),
                 div = r$deficit / unl,
                 lk_hi = r$deficit * apply(lk, 1, max) / unl,    # least generous DFE
                 lk = r$deficit * apply(lk, 1, min) / unl)       # most generous DFE
}))

n_sp <- n_distinct(curves$species)
spm <- function(x) curves %>% group_by(c, species) %>% summarise(l = mean(log10({{ x }})), .groups = "drop")
avg <- bind_rows(
  spm(msd) %>% mutate(side = "msd"), spm(div) %>% mutate(side = "div"),
  spm(lk) %>% mutate(side = "lk"), spm(lk_hi) %>% mutate(side = "lk_hi")) %>%
  group_by(side, c) %>%
  summarise(m = mean(l), se = sd(l) / sqrt(n()), .groups = "drop") %>%
  mutate(ratio = 10^m)

c_dom <- exp(mean(log(1 / tapply(d$va_mode, d$species, function(v) exp(mean(log(v)))))))
avg_draw <- avg %>% filter(side == "msd" | c <= c_dom)
cur_draw <- curves %>% filter(inside)
rib <- avg_draw %>% filter(side %in% c("lk", "lk_hi")) %>%
  select(side, c, ratio) %>% tidyr::pivot_wider(names_from = side, values_from = ratio)

col_msd <- "#2C7FB8"; col_req <- "#D95F0E"; col_lk <- "#7B3294"
lab <- list(
  msd = expression(bar(italic(V))[A] / italic(U)[d] * italic(s) * ": long-run " * italic(V)[A] *
                     " ÷ what mutation–selection balance maintains"),
  div = expression("observed ÷ predicted loss of diversity, unlinked"),
  lk  = expression("observed ÷ predicted loss of diversity, with linkage (" *
                     bar(Omega) * ")"))

p <- ggplot(avg_draw, aes(c)) +
  annotate("rect", xmin = c_dom, xmax = 1e3, ymin = 1e-3, ymax = 1e6, fill = "grey88") +
  annotate("text", x = sqrt(c_dom * 1e3), y = 2e5, size = 2.1, colour = "grey25", parse = TRUE,
           label = 'atop(bold("Outside the model\'s domain:"), bold("long-run ")*bolditalic(V)[bold(A)]*bold(" > 1"))') +
  geom_hline(yintercept = 1, linewidth = 0.4) +
  geom_line(data = filter(curves, c <= 1e3), aes(y = msd, group = code), colour = col_msd, linewidth = 0.3, alpha = 0.3) +
  geom_line(data = cur_draw, aes(y = lk, group = code), colour = col_lk, linewidth = 0.3, alpha = 0.3) +
  geom_ribbon(data = rib, aes(ymin = lk, ymax = lk_hi), fill = col_lk, alpha = 0.2) +
  geom_line(data = filter(avg_draw, side %in% c("msd", "div", "lk")),
            aes(y = ratio, colour = side, linetype = side), linewidth = 1.1) +
  scale_colour_manual(values = c(msd = col_msd, div = col_req, lk = col_lk),
                      breaks = c("msd", "div", "lk"), labels = lab, name = NULL) +
  scale_linetype_manual(values = c(msd = "solid", div = "22", lk = "solid"),
                        breaks = c("msd", "div", "lk"), labels = lab, name = NULL) +
  scale_x_log10(breaks = 10^seq(-4, 3), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  scale_y_log10(breaks = 10^seq(-3, 6), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  coord_cartesian(xlim = c(1e-4, 1e3), ylim = c(1e-3, 1e6)) +
  labs(x = expression("Long-run " * italic(V)[A] * " as a multiple of the pedigree estimate, " *
                        italic(c) == bar(italic(V))[A] / hat(italic(V))[A]),
       y = "Ratio") +
  guides(colour = guide_legend(ncol = 1)) +
  theme_classic(base_size = 9, base_family = "sans") +
  theme(legend.position = "bottom", legend.text = element_text(size = 8),
        legend.key.width = unit(7, "mm"), plot.margin = margin(2, 3, 2, 2, "mm"))

dir.create("supp", showWarnings = FALSE)
ggsave("supp/FigS_rescaling_linked.pdf", p, width = 130, height = 105, units = "mm", device = cairo_pdf)
ggsave("supp/FigS_rescaling_linked.tiff", p, width = 130, height = 105, units = "mm", dpi = 600,
       device = ragg::agg_tiff, compression = "lzw")
if (nzchar(Sys.getenv("FIG_PREVIEW_DIR")))
  ggsave(file.path(Sys.getenv("FIG_PREVIEW_DIR"), "FigS_rescaling_linked.png"), p, width = 130,
         height = 105, units = "mm", dpi = 200, device = ragg::agg_png)

at1 <- function(s) { a <- filter(avg, side == s); if (min(a$m) > 0) NA else 10^approx(a$m, log10(a$c), 0)$y }
cat(sprintf("species %d; domain edge c = %.3g\nratio 1: MSD c = %.3g; diversity unlinked c = %.3g; linked (most generous) c = %.3g; linked (least) c = %.3g\n",
            n_sp, c_dom, at1("msd"), at1("div"), at1("lk"), at1("lk_hi")))

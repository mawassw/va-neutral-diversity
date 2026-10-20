# ==============================================================================
# figS_rescaling_linked.R — Figure 5 with linkage, for the linked set
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/figS_rescaling_linked.R
# Reads only through load_data.R; model in linked.R. Writes
# supp/FigS_rescaling_linked.{pdf,tiff}.
#
# As Figure 5 (bar V_A = c hat V_A), for the populations that have both a
# deficit and a linkage map: collared flycatcher, macaque, song sparrow, bighorn
# and both great tits (6 populations, 5 species). Three ratios against c, all
# under the multiplicative upper bound on the reduction (as Figure 5):
#   blue           bar V_A / (U_d s_bar), s_bar the mean of the population's assigned DFE (as Figure 5)
#   orange dashed  predicted / observed diversity, unlinked:
#                  deficit * exp(-4 kappa(0) bar V_A)
#   teal           the same with linkage: deficit * Omega_bar(bar V_A) * exp(-4 kappa(0) bar V_A),
#                  Omega_bar with class-by-class retention Z_k = 1 - s_k over the SAME
#                  assigned DFE (data/dfe_assignment.csv), so both sides share one s.
#                  Open circle on each average curve: c = c_MSD, where the variance is what
#                  that DFE maintains; there the linked ratio is the self-consistent prediction
#                  of mutation--selection balance with background selection.
# Before 2026-10-20: s = 1e-2 for MSD and the most generous taxon DFE for linkage.
# Bold: species average of log10 ratio (great tits averaged first); faint: populations.
# Rebuilt 2026-10-19 with linked.R (exponential composite, class-by-class Z_k);
# before that, first order with an aggregate Z and a domain cut at bar V_A = 1.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")

dfe_pop <- dfe_assigned()
c_grid <- 10^seq(-4, 3, length.out = 160)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")

pops <- load_populations("linked")
obs <- load_diversity()
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)

d <- pops %>%
  left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(deficit = 4 * mu_direct * 10^log10_Nc / coalesce(pi_obs, pi_lit),
         species = sub("^(\\S+ \\S+).*", "\\1", scientific_name),
         taxon = if_else(code %in% birds, "Birds", "Mammals"),
         k0 = kappa_mult_bound(pair_bond == "social_monogamy")) %>%
  filter(!is.na(deficit), !is.na(U_d_direct), code != "SSH")

# log10 ratios throughout: the linked factor underflows at large c
curves <- bind_rows(lapply(seq_len(nrow(d)), function(i) {
  r <- d[i, ]; a <- filter(auto, code == r$code); m <- filter(a, has_map)
  f <- f_share(m, a, "bp"); V <- c_grid * r$va_mode
  l_div <- log10(r$deficit) - 4 * r$k0 * V / log(10)
  sp <- dfe_pop[[r$code]]
  l_om <- omega_fun(m, f, r$kappa, sp, log = TRUE)(V) / log(10)
  tibble::tibble(code = r$code, species = r$species, c = c_grid,
                 msd = log10(V / (r$U_d_direct * sp$s_bar)), s_bar = sp$s_bar,
                 div = l_div,
                 lk = l_div + l_om)
}))

n_sp <- n_distinct(curves$species)
spm <- function(x) curves %>% group_by(c, species) %>% summarise(l = mean({{ x }}), .groups = "drop")
avg <- bind_rows(
  spm(msd) %>% mutate(side = "msd"), spm(div) %>% mutate(side = "div"),
  spm(lk) %>% mutate(side = "lk")) %>%
  group_by(side, c) %>%
  summarise(m = mean(l), se = sd(l) / sqrt(n()), .groups = "drop") %>%
  mutate(ratio = 10^m)

y_lo <- 1e-3; y_hi <- 1e6
avg_draw <- avg %>% filter(m > log10(y_lo) - 0.2)
cur_draw <- curves %>% mutate(across(c(msd, div, lk), ~ 10^.x))
at1 <- function(cc, l) if (min(l) > 0 || max(l) < 0) NA else 10^approx(l, log10(cc), 0, ties = mean)$y
c_msd_avg <- with(filter(avg, side == "msd"), at1(c, m))
pt <- avg %>% filter(side %in% c("div", "lk")) %>% group_by(side) %>%
  summarise(ratio = 10^approx(log10(c), m, log10(c_msd_avg))$y, .groups = "drop")

col_msd <- "#2C7FB8"; col_req <- "#D95F0E"; col_lk <- "#01665E"
lab <- list(
  msd = expression(bar(italic(V))[A] / italic(U)[d] * bar(italic(s)) * ": long-run " * italic(V)[A] *
                     " ÷ what mutation–selection balance maintains"),
  div = expression("predicted ÷ observed diversity, unlinked, multiplicative upper bound"),
  lk  = expression("the same with linkage (" * bar(Omega) * "), same DFE as " * bar(italic(s))))

p <- ggplot(avg_draw, aes(c)) +
  geom_hline(yintercept = 1, linewidth = 0.4) +
  geom_line(data = filter(cur_draw, c <= 1e3), aes(y = msd, group = code), colour = col_msd,
            linewidth = 0.3, alpha = 0.3) +
  geom_line(data = filter(cur_draw, lk > y_lo / 10), aes(y = lk, group = code), colour = col_lk,
            linewidth = 0.3, alpha = 0.3) +
  geom_line(data = filter(avg_draw, side %in% c("msd", "div", "lk")),
            aes(y = ratio, colour = side, linetype = side), linewidth = 1.1) +
  geom_vline(xintercept = c_msd_avg, linewidth = 0.3, linetype = "13", colour = col_msd) +
  geom_point(data = pt, aes(x = c_msd_avg, y = ratio, colour = side), shape = 21, fill = "white",
             size = 2, stroke = 0.8, show.legend = FALSE) +
  scale_colour_manual(values = c(msd = col_msd, div = col_req, lk = col_lk),
                      breaks = c("msd", "div", "lk"), labels = lab, name = NULL) +
  scale_linetype_manual(values = c(msd = "solid", div = "22", lk = "solid"),
                        breaks = c("msd", "div", "lk"), labels = lab, name = NULL) +
  scale_x_log10(breaks = 10^seq(-4, 3), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  scale_y_log10(breaks = 10^seq(-3, 6), expand = c(0, 0),
                labels = scales::label_math(10^.x, format = log10)) +
  coord_cartesian(xlim = c(1e-4, 1e3), ylim = c(y_lo, y_hi)) +
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

# where each curve reaches ratio 1 (log10 = 0), averaged and per population; and the
# ratios at c = c_MSD, the self-consistent balance prediction
a1 <- function(s) { a <- filter(avg, side == s); at1(a$c, a$m) }
cat(sprintf("species %d
ratio 1 (species average): MSD c = %.3g; diversity unlinked c = %.3g; linked c = %.3g
at c = c_MSD (average): unlinked ratio %.3g, linked ratio %.3g
",
            n_sp, a1("msd"), a1("div"), a1("lk"), pt$ratio[pt$side == "div"], pt$ratio[pt$side == "lk"]))
per <- curves %>% group_by(code) %>%
  summarise(s_bar = s_bar[1], c_msd = at1(c, msd), c_div = at1(c, div), c_lk = at1(c, lk),
            lk_at_cmsd = 10^approx(log10(c), lk, log10(c_msd))$y,
            div_at_cmsd = 10^approx(log10(c), div, log10(c_msd))$y, .groups = "drop") %>%
  mutate(gap_lk = c_lk / c_msd) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))
print(as.data.frame(per))

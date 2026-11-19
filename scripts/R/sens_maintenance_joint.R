# ==============================================================================
# sens_maintenance_joint.R — joint sensitivity of the maintenance test
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/sens_maintenance_joint.R
# Reads data/processed/ (load_data.R), data/functional_target_lengths.csv and the
# assigned DFEs (linked.R). Writes
#   data/processed/maintenance_joint_sensitivity.csv         one row per scenario
#   data/processed/maintenance_joint_sensitivity_bypop.csv   one row per population x scenario
#   supp/FigS_maintenance_joint.{pdf,tiff}                   Figure S_maintenance_joint (end of file)
#
# The manuscript varies the three inputs of the maintenance test one at a time. Here
# they vary together, for the 18 populations with a U_d:
#
#   ratio = (hat V_A / k) / (U_d(target) * s_bar(p))        test failed where ratio > 1
#
#   target  the deleterious target T, U_d = 2 mu_direct T
#             "current"  T = 2 L_coding (the primary analysis, U_d = 4 mu L_coding)
#             zeta       T = L_annot + zeta L_other, as figS_noncoding.R
#   p       fraction of new mutations in a tail of large effects that site-frequency
#           spectra do not see, each with heterozygous effect s_L = 0.5 (the value the
#           Results sentence on a hidden tail uses):  s_bar(p) = (1 - p) s_bar + p s_L.
#           The tail is applied to every mutation in the target, coding or not, which
#           is biased toward passing.
#   k       factor by which the pedigree estimate overstates the long-term variance,
#           V_A = hat V_A / k
#
# Two conventions, as in the text:
#   point      hat V_A at its posterior mode, mu_direct at its point value
#   posterior  P(ratio > 1) over the 4,000 draws of V_A, each paired with a U_d draw
#              from the log-normal implied by the 95% CI of mu_direct (fig4_selection.R)
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
})
source("scripts/R/load_data.R")
source("scripts/R/linked.R")
set.seed(20261118)

zeta_levels <- c(current = NA, `0` = 0, `0.03` = 0.03, `0.08` = 0.08, `0.15` = 0.15)
p_levels <- c(0, 0.005, 0.01, 0.02, 0.05)
k_levels <- c(1, 2, 3, 5, 10)
s_L <- 0.5

birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")
ft <- readr::read_csv("data/functional_target_lengths.csv", show_col_types = FALSE,
                      col_types = readr::cols(NCBI_Chromosome = readr::col_character()))
s_bar <- vapply(dfe_assigned(), `[[`, numeric(1), "s_bar")

msd <- load_populations("msd") %>%
  left_join(ft %>% group_by(code) %>%
              summarise(A = sum(L_annot), O = sum(L_other), .groups = "drop"), by = "code") %>%
  mutate(s_bar = unname(s_bar[code]),
         taxon = if_else(code %in% birds, "Birds", "Mammals"),
         sdlog = (log(U_d_direct_hi) - log(U_d_direct_lo)) / (2 * qnorm(0.975)))
stopifnot(nrow(msd) == 18, !anyNA(msd$A), !anyNA(msd$s_bar),
          isTRUE(all.equal(msd$U_d_direct, 4 * msd$mu_direct * msd$L_coding_bp)))

va <- load_va_draws(codes = msd$code)
n_draw <- nrow(va)
# U_d draws at the current target; other targets rescale them by T / (2 L_coding)
ud_draw <- sapply(seq_len(nrow(msd)), function(i)
  exp(rnorm(n_draw, log(msd$U_d_direct[i]), msd$sdlog[i])))
colnames(ud_draw) <- msd$code

grid <- crossing(target = names(zeta_levels), p = p_levels, k = k_levels)
bypop <- bind_rows(lapply(seq_len(nrow(grid)), function(g) {
  z <- zeta_levels[[grid$target[g]]]; p <- grid$p[g]; k <- grid$k[g]
  Tg <- if (is.na(z)) 2 * msd$L_coding_bp else msd$A + z * msd$O
  sb <- (1 - p) * msd$s_bar + p * s_L
  U_d <- 2 * msd$mu_direct * Tg
  p_fail <- vapply(seq_len(nrow(msd)), function(i) {
    ud <- ud_draw[, i] * Tg[i] / (2 * msd$L_coding_bp[i])
    mean(va[[msd$code[i]]] / k > ud * sb[i])
  }, numeric(1))
  data.frame(target = grid$target[g], p_tail = p, k_inflation = k, code = msd$code,
             taxon = msd$taxon, U_d = U_d, s_bar_eff = sb,
             ratio_point = msd$va_mode / k / (U_d * sb), p_fail = p_fail)
}))

summ <- bypop %>%
  group_by(target, p_tail, k_inflation) %>%
  summarise(median_ratio = median(ratio_point),
            n_fail_point = sum(ratio_point > 1),
            n_fail_birds = sum(ratio_point > 1 & taxon == "Birds"),
            n_fail_mammals = sum(ratio_point > 1 & taxon == "Mammals"),
            n_fail_p50 = sum(p_fail > 0.5),
            n_fail_p95 = sum(p_fail >= 0.95),
            still_fail = paste(code[ratio_point > 1], collapse = ";"),
            .groups = "drop") %>%
  mutate(target = factor(target, levels = names(zeta_levels))) %>%
  arrange(target, p_tail, k_inflation)

readr::write_csv(summ, "data/processed/maintenance_joint_sensitivity.csv")
readr::write_csv(bypop, "data/processed/maintenance_joint_sensitivity_bypop.csv")

# --- report -------------------------------------------------------------------
options(width = 200)
cat("\n18 populations (", sum(msd$taxon == "Birds"), " birds, ", sum(msd$taxon == "Mammals"),
    " mammals). s_L = ", s_L, ". Cells: populations that still fail (ratio > 1), point convention.\n",
    sep = "")
tab <- function(col, kk) summ %>% filter(k_inflation == kk) %>%
  select(target, p_tail, all_of(col)) %>%
  pivot_wider(names_from = p_tail, values_from = all_of(col), names_prefix = "p=") %>%
  as.data.frame()
for (kk in k_levels) {
  cat("\n--- estimate inflated ", kk, "x: n failing (point) ---\n", sep = ""); print(tab("n_fail_point", kk))
}
cat("\n--- median ratio at k = 1 (divide by k for other inflations) ---\n")
print(tab("median_ratio", 1) %>% mutate(across(where(is.numeric), ~ signif(.x, 3))))
for (kk in k_levels) {
  cat("\n--- estimate inflated ", kk, "x: n with P(fail) >= 0.95 ---\n", sep = ""); print(tab("n_fail_p95", kk))
}
for (kk in k_levels) {
  cat("\n--- estimate inflated ", kk, "x: n with P(fail) > 0.5 ---\n", sep = ""); print(tab("n_fail_p50", kk))
}

cat("\n--- birds / mammals failing (point), selected scenarios ---\n")
sel <- tribble(~target, ~p_tail, ~k_inflation,
               "current", 0, 1,
               "0.08", 0, 1,
               "0.08", 0, 2,
               "0.08", 0.01, 1,
               "0.08", 0.01, 2,
               "0.08", 0.01, 3,
               "0.15", 0.01, 2,
               "0.15", 0.02, 3,
               "0.15", 0.05, 5,
               "0.15", 0.05, 10)
print(as.data.frame(sel %>% left_join(summ %>% mutate(target = as.character(target)),
                                      by = c("target", "p_tail", "k_inflation")) %>%
  mutate(median_ratio = signif(median_ratio, 3))))

# the inflation each population would need to pass, k* = ratio at k = 1
cat("\n--- inflation of the estimate each population needs to pass (ratio at k = 1) ---\n")
print(as.data.frame(bypop %>% filter(k_inflation == 1, (target == "current" & p_tail == 0) |
                                       (target == "0.08" & p_tail %in% c(0, 0.01)) |
                                       (target == "0.15" & p_tail %in% c(0, 0.02))) %>%
  mutate(scen = paste0(target, "|p=", p_tail)) %>%
  select(code, taxon, scen, ratio_point) %>%
  pivot_wider(names_from = scen, values_from = ratio_point) %>%
  arrange(taxon, desc(`current|p=0`)) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))))

# ==============================================================================
# Figure S_maintenance_joint (added 2026-11-19, REVIEW_FIXES Fix 2)
#   a-e  populations still failing (point convention), deleterious target x tail,
#        one panel per inflation of the estimate; outlined cells are the moderate
#        (zeta 8%, 1% tail, twofold) and stronger (zeta 15%, 2% tail, threefold)
#        joint scenarios quoted in Results
#   f    inflation each population would need to pass (= ratio at k = 1) at three
#        target x tail combinations
# Writes supp/FigS_maintenance_joint.{pdf,tiff}
# ==============================================================================
suppressPackageStartupMessages({
  library(ggplot2)
  library(patchwork)
})
source("scripts/R/theme_genetics.R")

target_lab <- c(current = "Primary", `0` = "Annotated", `0.03` = "+ 3%", `0.08` = "+ 8%",
                `0.15` = "+ 15%")
k_lab <- c(`1` = "No inflation", `2` = "Twofold", `3` = "Threefold", `5` = "Fivefold",
           `10` = "Tenfold")
hm <- summ %>%
  mutate(target = factor(target_lab[as.character(target)], levels = target_lab),
         tail = factor(paste0(100 * p_tail), levels = paste0(100 * p_levels)),
         ink = if_else(n_fail_point >= 10, "white", "black"))
box <- tibble::tribble(~k_inflation, ~target, ~tail,
                       2, "+ 8%", "1",
                       3, "+ 15%", "2") %>%
  mutate(target = factor(target, levels = target_lab), tail = factor(tail, levels = levels(hm$tail)))

heat <- function(kk, first, tag) {
  ggplot(filter(hm, k_inflation == kk), aes(tail, target)) +
    geom_tile(aes(fill = n_fail_point), colour = "white", linewidth = 0.6) +
    geom_tile(data = filter(box, k_inflation == kk), fill = NA, colour = "black",
              linewidth = 0.6) +
    geom_text(aes(label = n_fail_point, colour = ink), size = pt_mm(7), family = fig_family) +
    scale_colour_identity() +
    scale_fill_gradient(low = "#F7FBFF", high = "#08306B", limits = c(0, 18),
                        breaks = c(0, 6, 12, 18), name = "Populations failing (of 18)") +
    scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) +
    labs(title = k_lab[[as.character(kk)]], x = NULL, tag = tag,
         y = if (first) "Deleterious target" else NULL) +
    theme_genetics() +
    theme(plot.title = element_text(size = 7, face = "plain", hjust = 0.5),
          axis.line = element_blank(), axis.ticks = element_blank(),
          axis.text.y = if (first) element_text(size = 7) else element_blank(),
          legend.key.width = unit(10, "mm"))
}
p_heat <- wrap_plots(lapply(seq_along(k_levels), function(i) heat(k_levels[i], i == 1, letters[i])),
                     nrow = 1) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")
p_heat[[3]] <- p_heat[[3]] + labs(x = "Large-effect tail (% of new mutations)")

lab_msd <- msd %>%
  transmute(code, taxon,
            label = pop_label(sub(" \\(.*\\)$", "", common_name),
                              sub("^tiritiri", "Tiritiri", location)))
scen <- c(`current|0` = "Primary target, no tail", `0.08|0.01` = "+ 8%, 1% tail",
          `0.15|0.02` = "+ 15%, 2% tail")
need <- bypop %>%
  filter(k_inflation == 1, paste0(target, "|", p_tail) %in% names(scen)) %>%
  mutate(scen = factor(scen[paste0(target, "|", p_tail)], levels = scen)) %>%
  select(code, scen, ratio_point) %>%
  left_join(lab_msd, by = "code")
ord <- need %>% filter(scen == scen[[1]]) %>% arrange(taxon, ratio_point)
need <- need %>% mutate(label = factor(label, levels = ord$label))
p_need <- ggplot(need, aes(ratio_point, label)) +
  geom_vline(xintercept = 1, linewidth = 0.4, colour = "grey30") +
  geom_line(aes(group = label), linewidth = 0.3, colour = "grey75") +
  geom_point(aes(fill = scen), shape = 21, size = 2, stroke = 0.3, colour = "black") +
  scale_fill_manual(values = c("#D9D9D9", "#6BAED6", "#08519C"), name = NULL) +
  scale_x_log10(breaks = c(0.1, 1, 10, 100, 1000), labels = c("0.1", "1", "10", "100", "1,000")) +
  facet_grid(taxon ~ ., scales = "free_y", space = "free_y") +
  labs(x = "Inflation of the estimate required to pass the maintenance test", y = NULL, tag = "f") +
  theme_genetics(grid_x = TRUE) +
  theme(strip.text.y = element_text(size = 7, angle = 0, hjust = 0))

fig <- wrap_elements(full = p_heat) / p_need + plot_layout(heights = c(1.35, 2))
dir.create("supp", showWarnings = FALSE)
pv <- Sys.getenv("FIG_PREVIEW_DIR")
ggsave("supp/FigS_maintenance_joint.pdf", fig, width = 178, height = 165, units = "mm",
       device = cairo_pdf)
ggsave("supp/FigS_maintenance_joint.tiff", fig, width = 178, height = 165, units = "mm",
       dpi = 600, device = ragg::agg_tiff, compression = "lzw")
if (nzchar(pv)) ggsave(file.path(pv, "FigS_maintenance_joint.png"), fig, width = 178,
                       height = 165, units = "mm", dpi = 200, device = ragg::agg_png)

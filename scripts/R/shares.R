# ==============================================================================
# shares.R — the two shares that size each equilibrium (adopted 2026-11-18, user)
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/shares.R
# Writes data/processed/shares.csv, one row per population.
#
#   share_maintained   U_d s_bar / hat V_A  (= c_MSD): the part of the measured variance
#                      that recurrent mutation maintains at the assigned DFE. 18 populations
#                      with a U_d. Values above 1 mean mutation maintains all of it.
#   share_deficit_*    ln[1 / (N_e/N)_pred] / ln(1 / hat delta): the part of the observed
#                      deficit that the measured variance accounts for at unlinked sites, on
#                      a logarithmic scale (successive reductions multiply). 9 populations
#                      with pi and a census size.
#                        _model  the multiplicative model (exact moment equation)
#                        _bound  the multiplicative bound, = hat V_A / V_{A,delta} = 1 / c_div
#                        _small  the small-variance approximation
#
# Point convention: hat V_A at its posterior mode, mu_direct at its point value.
# ==============================================================================

suppressPackageStartupMessages(library(dplyr))
source("scripts/R/load_data.R")
source("scripts/R/linked.R")

s_bar <- vapply(dfe_assigned(), function(x) x$s_bar, numeric(1))
d <- load_populations("va") %>%
  left_join(load_diversity() %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(delta = coalesce(pi_obs, pi_lit) / (4 * mu_direct * 10^log10_Nc),
         delta = if_else(code == "SSH", NA_real_, delta),     # domestic Ovis aries N_c
         s_bar = unname(s_bar[code]),
         share_maintained = if_else(in_set_msd, U_d_direct * s_bar / va_mode, NA_real_),
         fold_deficit = 1 / delta,
         fold_model = reduction_mult,
         share_deficit_model = log(reduction_mult) / log(1 / delta),
         share_deficit_bound = log(reduction_mult_bound) / log(1 / delta),
         share_deficit_small = log(reduction_G1) / log(1 / delta)) %>%
  select(code, common_name, location, va_mode, s_bar, U_d_direct, share_maintained,
         fold_deficit, fold_model, share_deficit_model, share_deficit_bound, share_deficit_small)
readr::write_csv(d, "data/processed/shares.csv")

options(width = 200)
q <- function(x) signif(quantile(x, c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE), 3)
m <- d %>% filter(!is.na(share_maintained)); v <- d %>% filter(!is.na(fold_deficit))
cat("Share of hat V_A that mutation maintains, n =", nrow(m), "\n"); print(q(m$share_maintained))
cat("  at or above 1:", sum(m$share_maintained >= 1), "\n")
cat("Share of the log deficit accounted for, n =", nrow(v), "\n model:\n"); print(q(v$share_deficit_model))
cat(" bound:\n"); print(q(v$share_deficit_bound)); cat(" small-variance:\n"); print(q(v$share_deficit_small))
cat("Share maintained within the deficit set:\n"); print(q(v$share_maintained))
print(as.data.frame(d %>% arrange(is.na(fold_deficit), code) %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3))) %>% select(-common_name, -location)))

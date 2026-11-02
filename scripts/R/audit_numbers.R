# audit_numbers.R: recompute manuscript numbers that no figure script prints (numbers audit
# 2026-11-02). Run from the repo root: Rscript scripts/R/audit_numbers.R. Three sections in sequence.
# Recompute manuscript numbers that no figure script prints. Run from the worktree root.
suppressPackageStartupMessages(library(dplyr))
source("scripts/R/load_data.R")
source("scripts/R/linked.R")
pops <- load_populations("va"); obs <- load_diversity(); va <- load_va_draws()
s_bar <- vapply(dfe_assigned(), `[[`, numeric(1), "s_bar")
cat("s_bar assigned:\n"); print(signif(s_bar, 4))

cat("\n== V_A modes (19)\n"); print(signif(quantile(pops$va_mode, c(0, .25, .5, .75, 1)), 4))
cat("upper HPD range:", signif(range(pops$va_hpd95_hi), 3), "\n")
ne1 <- 1 / pops$reduction_G1; nem <- 1 / pops$reduction_mult; neb <- 1 / pops$reduction_mult_bound
cat("small-var N_e/N range", signif(range(ne1), 3), "median", signif(median(ne1), 3), "\n")
cat("mult median", signif(median(nem), 3), "range", signif(range(nem), 3), "\n")
cat("bound median", signif(median(neb), 3), "range", signif(range(neb), 3), "\n")
cat("median N/N_e (mult):", signif(median(1 / nem), 3), " small-var:", signif(median(1/ne1), 3), "\n")
print(pops %>% transmute(code, kappa = round(kappa, 3), va = signif(va_mode, 3), ne1 = signif(ne1, 3),
                         nem = signif(nem, 3), neb = signif(neb, 3), rel = signif(nem / ne1 - 1, 2)) %>% arrange(va))
cat("kappa_B range (pair):", signif(range(pops$kappa[pops$pair_bond == "social_monogamy"]), 3),
    " n pair:", sum(pops$pair_bond == "social_monogamy"), "\n")
cat("EPP alphas:\n"); print(pops %>% filter(pair_bond == "social_monogamy") %>% select(code, epp_alpha, kappa, kappa_A))

cat("\n== Ceiling curve exceedances (first-order V_A,max at kappa of each pop)\n")
for (dl in c(0.1, 0.2, 0.25, 0.3, 0.5, 0.9)) {
  vm <- vamax_first(dl, pops$kappa); vd <- vamax_mult(dl, kappa_mult_bound(pops$pair_bond == "social_monogamy"))
  cat(sprintf("delta %.2f: mode > V_A,max: %d ; mode > V_A,delta: %d ; hpd_hi > V_A,max: %d\n", dl,
              sum(pops$va_mode > vm), sum(pops$va_mode > vd), sum(pops$va_hpd95_hi > vm)))
}
cat("V_A,delta at 100x, 1e4x (kappa_max 1):", round(vamax_mult(1e-2, 1), 3), round(vamax_mult(1e-4, 1), 3),
    " (kappa_max 2):", round(vamax_mult(1e-2, 2), 3), round(vamax_mult(1e-4, 2), 3), "\n")
cat("1/(1+4k): k=1", 1/5, " k=2", 1/9, "\n")

cat("\n== Deficit set\n")
d <- pops %>% left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit), pair = pair_bond == "social_monogamy",
         delta = pi_any / (4 * mu_direct * 10^log10_Nc),
         delta_muhi = pi_any / (4 * mu_direct_hi * 10^log10_Nc),   # largest delta (smallest deficit)
         lit = is.na(pi_obs) & !is.na(pi_lit)) %>% filter(!is.na(delta), code != "SSH")
d <- d %>% mutate(def = 1 / delta, need = vamax_mult(delta, kappa_mult_bound(pair)),
  need_muhi = vamax_mult(delta_muhi, kappa_mult_bound(pair)),
  need_x10 = vamax_mult(10 * delta, kappa_mult_bound(pair)),
  shortfall = def * exp(-4 * kappa_mult_bound(pair) * va_mode),
  margin_mu = need_muhi / va_hpd95_hi, margin_x10 = need_x10 / va_hpd95_hi,
  pi_pred = 4 * mu_direct * 10^log10_Nc * exp(-4 * kappa_mult_bound(pair) * va_mode))
print(d %>% transmute(code, lit, def = signif(def, 3), need = round(need, 2), hpd_hi = round(va_hpd95_hi, 2),
   shortfall = signif(shortfall, 2), margin_mu = round(margin_mu, 2), need_x10 = round(need_x10, 2),
   margin_x10 = round(margin_x10, 2), pi_obs = signif(pi_any, 3), pi_pred = signif(pi_pred, 3)))
cat("n species:", n_distinct(sub("^(\\S+ \\S+).*", "\\1", d$scientific_name)), " n lit pi:", sum(d$lit), "\n")
cat("all-pops with pi (incl Soay, others):\n")
print(pops %>% left_join(obs, by = "code") %>% transmute(code, pi_obs, pi_lit, log10_Nc) %>% filter(!is.na(pi_obs) | !is.na(pi_lit) | !is.na(log10_Nc)))

cat("\n== MSD side (18)\n")
m <- pops %>% filter(!is.na(U_d_direct)) %>% mutate(sb = s_bar[code],
  s_star = va_mode / U_d_direct, s_star_ph = va_mode / U_d_phylo, ratio = va_mode / (U_d_direct * sb),
  ratio_ph = va_mode / (U_d_phylo * sb), msd = U_d_direct * sb, ud_2va = U_d_direct / (2 * va_mode))
cat("n =", nrow(m), " U_d direct range", signif(range(m$U_d_direct), 3), " phylo range", signif(range(m$U_d_phylo), 3), "\n")
cat("s* median direct", signif(median(m$s_star), 3), " phylo", signif(median(m$s_star_ph), 3),
    " range", signif(range(m$s_star), 3), "\n")
cat("ratio median direct", signif(median(m$ratio), 3), " phylo", signif(median(m$ratio_ph), 3),
    " n>1", sum(m$ratio > 1), " n<3", sum(m$ratio < 3), paste(m$code[m$ratio < 3], collapse = ","), "\n")
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")
cat("birds ratio range", signif(range(m$ratio[m$code %in% birds]), 3), " mammals", signif(range(m$ratio[!m$code %in% birds]), 3), "\n")
cat("MSD maintains fraction of V_A: median", signif(median(1 / m$ratio), 3), "\n")
cat("U_d/(2 V_A) range", signif(range(m$ud_2va), 3), "\n")
cat("L_coding (Mb) range", signif(range(m$L_coding_bp) / 1e6, 3), "\n")
print(m %>% transmute(code, U_d = signif(U_d_direct, 3), U_d_ph = signif(U_d_phylo, 3), sb = signif(sb, 3), s_star = signif(s_star, 2),
                      ratio = signif(ratio, 3), ratio_ph = signif(ratio_ph, 3)))

cat("\n== 2 N_e s* where pi gives N_e (N_e = pi / 4 mu_direct)\n")
n2 <- m %>% left_join(obs %>% select(code, pi_obs, pi_lit), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit), Ne = pi_any / (4 * mu_direct), x = 2 * Ne * s_star) %>% filter(!is.na(x))
cat("n =", nrow(n2), " range", signif(range(n2$x), 3), "\n"); print(n2 %>% transmute(code, Ne = signif(Ne, 3), x = signif(x, 3)))
n2b <- m %>% left_join(obs %>% select(code, pi_obs), by = "code") %>% mutate(x = 2 * pi_obs / (4 * mu_direct) * s_star) %>% filter(!is.na(x))
cat("own-pi only: n =", nrow(n2b), " range", signif(range(n2b$x), 3), "\n")
suppressPackageStartupMessages(library(dplyr))
source("scripts/R/load_data.R"); source("scripts/R/linked.R")
pops <- load_populations("va"); obs <- load_diversity(); va <- load_va_draws()
s_bar <- vapply(dfe_assigned(), `[[`, numeric(1), "s_bar"); dfe_pop <- dfe_assigned()
pair <- pops$pair_bond == "social_monogamy"

cat("== mu: direct vs phylo\n")
x <- pops %>% filter(!is.na(mu_direct)) %>% mutate(below = 1 - mu_direct / mu_phylo, above = mu_phylo / mu_direct - 1)
cat("1 - direct/phylo:", signif(range(x$below), 3), " phylo/direct - 1:", signif(range(x$above), 3), "\n")
cat("== autosomal vs genome-wide coding length\n")
print(pops %>% transmute(code, L_auto = L_coding_autosomal_bp, L_gw = L_coding_genomewide_bp, drop = signif(1 - L_coding_autosomal_bp / L_coding_genomewide_bp, 3)))

cat("== deficit set robustness (mu_lo = smallest deficit)\n")
d <- pops %>% left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit), pr = pair_bond == "social_monogamy",
         delta = pi_any / (4 * mu_direct * 10^log10_Nc), delta_big = pi_any / (4 * mu_direct_lo * 10^log10_Nc)) %>%
  filter(!is.na(delta), code != "SSH") %>%
  mutate(m_mu = vamax_mult(delta_big, kappa_mult_bound(pr)) / va_hpd95_hi,
         m_x10 = vamax_mult(10 * delta, kappa_mult_bound(pr)) / va_hpd95_hi,
         m_both = vamax_mult(10 * delta_big, kappa_mult_bound(pr)) / va_hpd95_hi,
         d_star = 1 / (1 + 4 * kappa * va_mode), orders = log10(d_star / delta))
print(d %>% transmute(code, delta = signif(delta, 3), log10d = round(log10(delta), 2), m_mu = round(m_mu, 3), m_x10 = round(m_x10, 3), m_both = round(m_both, 3), orders = round(orders, 2)))

cat("== linked at upper HPD vs 10*delta at mu_lo (Fig 2 form: small-var global x Omega)\n")
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)
lk <- load_populations("linked")
res <- bind_rows(lapply(lk$code, function(cd) {
  a <- filter(auto, code == cd); m <- filter(a, has_map); r <- lk[lk$code == cd, ]
  f <- f_share(m, a, "bp"); om <- omega_fun(m, f, r$kappa, dfe_pop[[cd]])
  pr <- r$pair_bond == "social_monogamy"
  data.frame(code = cd, va = r$va_mode, hi = r$va_hpd95_hi,
    tot_sv_mode = om(r$va_mode) / (1 + 4 * r$kappa * r$va_mode),
    tot_sv_hi = om(r$va_hpd95_hi) / (1 + 4 * r$kappa * r$va_hpd95_hi),
    tot_bd_mode = om(r$va_mode) * exp(-4 * kappa_mult_bound(pr) * r$va_mode),
    tot_bd_hi = om(r$va_hpd95_hi) * exp(-4 * kappa_mult_bound(pr) * r$va_hpd95_hi),
    om_unif = omega_fun(m, f, r$kappa, dfe_uniform(0.01))(0.1),
    cM_per_Mb = sum(m$M_morgans) * 100 / (sum(m$Physical_Length_bp) / 1e6))
}))
res <- res %>% left_join(d %>% select(code, delta, delta_big), by = "code") %>%
  mutate(short_sv = tot_sv_mode / delta, short_bd = tot_bd_mode / delta,
         x10_sv = tot_sv_hi / (10 * delta_big), x10_bd = tot_bd_hi / (10 * delta_big))
print(res %>% mutate(across(where(is.numeric), ~ signif(.x, 3))))

cat("== MSD side, posterior-mode convention\n")
smode <- c(AB=.29,CSM=.11,BHS=.37,SSH=.29,RD=.31,MK=.036,NH=.64,KS=.011,SV=.0064,SSP=.089,CF=.036,GTN=.0097,GTU=.14,BTM=.64,BTP=.62,BTR=.17,HK=.016,HT=.44)
cat("1/(2 s*) median", signif(median(1 / (2 * smode)), 3), "range", signif(range(1 / (2 * smode)), 3), "\n")
cat("purge 1/(1+s)^2 posterior: median", signif(median(1/(1+smode)^2), 3), "range", signif(range(1/(1+smode)^2), 3), "\n")
m <- pops %>% filter(!is.na(U_d_direct)) %>% mutate(s = va_mode / U_d_direct)
cat("purge point: median", signif(median(1/(1+m$s)^2), 3), "range", signif(range(1/(1+m$s)^2), 3), "\n")
cat("U_d s_bar range (18):", signif(range(m$U_d_direct * s_bar[m$code]), 3), "\n")

cat("== noncoding: phi 7-9%, U_d at 15%, target needed vs genome\n")
ft <- readr::read_csv("data/functional_target_lengths.csv", show_col_types = FALSE,
                      col_types = readr::cols(NCBI_Chromosome = readr::col_character()))
print(names(ft))
nc <- load_populations("msd") %>% left_join(ft %>% group_by(code) %>% summarise(A = sum(L_annot), O = sum(L_other), .groups = "drop"), by = "code") %>%
  mutate(sb = s_bar[code], G = A + O)
for (p in c(0.07, 0.08, 0.09)) cat("phi", p, "median ratio", signif(median(nc$va_mode / (2 * nc$mu_direct * (nc$A + p * nc$O) * nc$sb)), 3), "\n")
nc <- nc %>% mutate(Ud15 = 2 * mu_direct * (A + 0.15 * O), T_need = va_mode / (2 * mu_direct * sb), exceeds = T_need > G)
birds <- c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN")
cat("U_d at 15% birds", signif(range(nc$Ud15[nc$code %in% birds]), 3), " mammals", signif(range(nc$Ud15[!nc$code %in% birds]), 3), "\n")
print(nc %>% transmute(code, Ud15 = signif(Ud15, 3), T_need_Gb = signif(T_need / 1e9, 3), auto_Gb = signif(G / 1e9, 3), exceeds))
cat("birds with target needed > autosomal genome:", sum(nc$exceeds & nc$code %in% birds), "of", sum(nc$code %in% birds), "\n")

cat("== at phi = 0.15, c = c_MSD(phi): linked, bound global, MSD-maintained variance\n")
dd <- d %>% filter(code %in% lk$code)
r15 <- bind_rows(lapply(dd$code, function(cd) {
  a <- filter(auto, code == cd) %>% left_join(ft %>% select(code, NCBI_Chromosome, L_annot, L_other), by = c("code", "NCBI_Chromosome"))
  mm <- a$has_map; m <- a[mm, ]; r <- dd[dd$code == cd, ]
  Ti <- a$L_annot + 0.15 * a$L_other; f <- Ti[mm] / sum(Ti)
  V <- 2 * r$mu_direct * sum(Ti) * s_bar[cd]
  pr <- r$pr
  tot <- omega_fun(m, f, r$kappa, dfe_pop[[cd]])(V) * exp(-4 * kappa_mult_bound(pr) * V)
  data.frame(code = cd, species = sub("^(\\S+ \\S+).*", "\\1", r$scientific_name), V = V, tot = tot, ratio = tot / r$delta)
}))
print(r15 %>% mutate(across(where(is.numeric), ~ signif(.x, 3))))
sp <- r15 %>% group_by(species) %>% summarise(l = mean(log10(ratio)))
cat("species-average ratio:", signif(10^mean(sp$l), 3), "\n")
# also with autosomal-only denominator but V from all autosomes Ti (should be the same)
suppressPackageStartupMessages(library(dplyr))
source("scripts/R/load_data.R"); source("scripts/R/linked.R")
pops <- load_populations("linked"); obs <- load_diversity(); dfe_pop <- dfe_assigned()
auto <- load_chromosomes(autosomes_only = TRUE, mapped_only = FALSE, macro_only = FALSE)
ft <- readr::read_csv("data/functional_target_lengths.csv", show_col_types = FALSE,
                      col_types = readr::cols(NCBI_Chromosome = readr::col_character()))
d <- pops %>% left_join(obs %>% select(code, pi_obs, pi_lit, log10_Nc), by = "code") %>%
  mutate(pi_any = coalesce(pi_obs, pi_lit), pr = pair_bond == "social_monogamy",
         delta = pi_any / (4 * mu_direct * 10^log10_Nc), delta_big = pi_any / (4 * mu_direct_lo * 10^log10_Nc)) %>%
  filter(!is.na(delta), code != "SSH")
for (cd in d$code) {
  r <- d[d$code == cd, ]; a <- filter(auto, code == cd); m <- filter(a, has_map)
  om <- omega_fun(m, f_share(m, a, "bp"), r$kappa, dfe_pop[[cd]], log = TRUE)
  bd <- function(V) om(V) - 4 * kappa_mult_bound(r$pr) * V        # log N_e/N, bound global
  sv <- function(V) om(V) - log1p(4 * r$kappa * V)                 # Fig 2 form
  need <- function(f, target) uniroot(function(V) f(V) - log(target), c(1e-6, 5))$root
  out <- sapply(list(bd = bd, sv = sv), function(f) c(
    pt = need(f, r$delta) / r$va_hpd95_hi, x10 = need(f, 10 * r$delta) / r$va_hpd95_hi,
    x10mu = need(f, 10 * r$delta_big) / r$va_hpd95_hi, mu = need(f, r$delta_big) / r$va_hpd95_hi))
  cat(cd, "\n"); print(round(out, 3))
}
# 3,240 variants: phi = 0.15, V = U_d(phi) s_bar
v <- bind_rows(lapply(d$code, function(cd) {
  a <- filter(auto, code == cd) %>% left_join(ft %>% select(code, NCBI_Chromosome, L_annot, L_other), by = c("code", "NCBI_Chromosome"))
  mm <- a$has_map; m <- a[mm, ]; r <- d[d$code == cd, ]
  Ti <- a$L_annot + 0.15 * a$L_other; f <- Ti[mm] / sum(Ti); fbp <- f_share(m, a[mm | TRUE, ], "bp")
  V <- 2 * r$mu_direct * sum(Ti) * dfe_pop[[cd]]$s_bar
  Om <- omega_fun(m, f, r$kappa, dfe_pop[[cd]])(V); Ombp <- omega_fun(m, f_share(m, a, "bp"), r$kappa, dfe_pop[[cd]])(V)
  data.frame(code = cd, sp = sub("^(\\S+ \\S+).*", "\\1", r$scientific_name),
    bd = Om * exp(-4 * kappa_mult_bound(r$pr) * V) / r$delta,
    bdbp = Ombp * exp(-4 * kappa_mult_bound(r$pr) * V) / r$delta,
    sv = Om / (1 + 4 * r$kappa * V) / r$delta,
    nel = ne_linked(m, V, r$kappa, dfe_pop[[cd]], f) / r$delta)
}))
print(v)
for (k in c("bd", "bdbp", "sv", "nel")) {
  s <- v %>% group_by(sp) %>% summarise(l = mean(log10(.data[[k]])))
  cat(k, "species avg", signif(10^mean(s$l), 4), " pop avg", signif(10^mean(log10(v[[k]])), 4), "\n") }

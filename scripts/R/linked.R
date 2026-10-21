# ==============================================================================
# linked.R — the composite (unlinked + linked) model on the data layer
# ==============================================================================
# Theory, eqs. total_red, linked_penalty, genome_linked (rebuilt 2026-10-19 to the
# one-model-family specification; before that this file used the hyperbolic
# composite with an aggregate Z = 1 - E[s^2]/E[s]):
#   (N_e/N)_i = exp{-[kappa_cis Q2bar_i v_h + Q^2 (kappa V_A - kappa_own v_h)]}
#   Omega_i   = exp[-v_h (kappa_cis Q2bar_i - kappa_own Q^2)]          (<= 1)
#   genome-wide N_e/N = Omega_bar * exp(-Q^2 kappa V_A),
#   Omega_bar = sum_i (L_i / L_total) Omega_i over mapped autosomes
#   v_i = V_A f_i (the MEASURED V_A, user 2026-10-19), v_h = v_i / 2,
#   f_i = chromosome i's share of autosomal coding bp (denominator over ALL
#   autosomes, so variance on unmapped chromosomes stays in the global term)
#   Q2bar_i = position-averaged cumulative factor under a Haldane map (Appendix C)
#   Q = 2 / (2 - Z), the unlinked factor at the same retention.
# Retention is class by class (Theory eq. Z): an effect class k is retained at
# Z_k = 1 - s_k, independent of V_A, and every Z-dependent factor (Q2bar_i and
# Q^2) is the nu-weighted average over classes, nu_k = phi_k s_k / s_bar, the
# class's share of V_A at balance. For a gamma DFE (shape alpha, scale beta') the
# nu-weights are the Gamma(alpha + 1, beta') density on s. The aggregate
# 1 - E[s^2]/E[s] is NOT used: interference is nonlinear in Z.
# first-order variant (form = "first"): the global factor is the hyperbolic
# 1 / [1 + Q^2 (kappa V_A - kappa_own v_h)] (Theory, below eq. total_red), and
# Omega_i = exp(-kappa_cis Q2bar_i v_h) (1 + Q^2 kappa V_A) / (1 + Q^2 (kappa V_A - kappa_own v_h)).
# Under Model B and without a pair bond, kappa_cis = kappa_own = 1 (kappa.R).
# Not modelled: weak selection (4 N_e s <~ 1) lowers retention further; classes
# below s = 1e-8 are dropped and above s = 1 truncated (both negligible here).
# ==============================================================================

source("scripts/R/kappa.R")

# Dilogarithm Li2(x) for 0 <= x < 1, vectorised: series for x <= 1/2, and the
# reflection Li2(x) = pi^2/6 - ln(x) ln(1 - x) - Li2(1 - x) above it.
Li2 <- function(x) {
  k <- 1:60
  ser <- function(v) vapply(v, function(u) sum(u^k / k^2), numeric(1))
  out <- numeric(length(x))
  lo <- x <= 0.5
  out[lo] <- ser(x[lo])
  y <- 1 - x[!lo]
  out[!lo] <- pi^2 / 6 - log(x[!lo]) * log(y) - ser(y)
  out
}

# Position-averaged Q^2 under a Haldane map, closed form (Appendix C, eq.
# C_closed_haldane), vectorised over M and Z. Agrees with quadrature of
# (2/M^2) int_0^M (M - d) / [1 - (Z/2)(1 + exp(-2d))]^2 dd to < 1e-9 (relative)
# for M in [1e-4, 50] Morgans and 1 - Z in [1e-7, 0.99] (checked 2026-10-19).
Q2bar_haldane <- function(M, Z) {
  stopifnot(all(Z < 1), all(Z >= 0))
  n <- max(length(M), length(Z)); M <- rep_len(M, n); Z <- rep_len(Z, n)
  G <- 1 - Z / 2; e <- Z / 2; eps <- e / G
  t1 <- (M^2 - M * log(1 - Z) + M * log(G) + 0.5 * (Li2(eps * exp(-2 * M)) - Li2(eps))) / G^2
  t2 <- (M / (1 - Z) - (2 * M + log((G - e * exp(-2 * M)) / (1 - Z))) / (2 * G)) / G
  out <- (t1 + t2) / M^2
  out[M < 1e-6] <- 1 / (1 - Z[M < 1e-6])^2           # no recombination
  out
}
Q2bar_vec <- Q2bar_haldane

# Retention specifications: effect classes s_k with weights nu_k (sum to one), and
# s_bar, the DFE's arithmetic mean effect, which sets U_d s_bar at balance.
dfe_uniform <- function(s) list(s = s, nu = 1, s_bar = s)
dfe_gamma <- function(shape, scale, n = 240, s_min = 1e-8) {
  lo <- max(s_min, qgamma(1e-9, shape + 1, scale = scale))
  hi <- min(1 - 1e-9, qgamma(1 - 1e-12, shape + 1, scale = scale))
  s <- exp(seq(log(lo), log(hi), length.out = n))
  nu <- dgamma(s, shape + 1, scale = scale) * s        # density on log s
  list(s = s, nu = nu / sum(nu), s_bar = shape * scale)
}
# Mixture of DFEs with weights w (new mutations drawn from DFE j with probability
# w_j): the mean is sum w_j s_bar_j, and class weights scale as w_j s_bar_j, the
# share of V_A that DFE j carries at balance.
dfe_mixture <- function(specs, w = rep(1 / length(specs), length(specs))) {
  sb <- vapply(specs, `[[`, numeric(1), "s_bar"); a <- w * sb / sum(w * sb)
  list(s = unlist(lapply(specs, `[[`, "s")),
       nu = unlist(Map(function(sp, aj) aj * sp$nu, specs, a)),
       s_bar = sum(w * sb))
}

# Class-averaged coefficients for one population's mapped autosomes:
#   A_i = sum_k nu_k Q2bar(M_i, 1 - s_k),  B = sum_k nu_k Q(1 - s_k)^2 = sum_k nu_k 4/(1 + s_k)^2.
linked_coefs <- function(mapped, dfe) {
  Zk <- 1 - dfe$s
  A <- vapply(mapped$M_morgans, function(M) sum(dfe$nu * Q2bar_haldane(M, Zk)), numeric(1))
  list(A = A, B = sum(dfe$nu * Qu2(Zk)),
       w = mapped$Physical_Length_bp / sum(mapped$Physical_Length_bp))
}

# Omega_bar as a function of V_A for one population. A_i and B do not depend on
# V_A, so they are computed once; the returned function is vectorised in Va.
# log = TRUE returns ln(Omega_bar), computed by log-sum-exp so that it does not
# underflow when the linked reduction is very large.
omega_fun <- function(mapped, f_i, kappa, dfe, form = c("mult", "first"),
                      kappa_cis = 1, kappa_own = 1, log = FALSE) {
  form <- match.arg(form)
  cf <- linked_coefs(mapped, dfe)
  function(Va) vapply(Va, function(v) {
    v_h <- v * f_i / 2
    l_i <- if (form == "mult") -v_h * (kappa_cis * cf$A - kappa_own * cf$B)
           else -kappa_cis * cf$A * v_h + log1p(cf$B * kappa * v) -
                  log1p(cf$B * (kappa * v - kappa_own * v_h))
    x <- log(cf$w) + l_i; mx <- max(x)
    lo <- mx + log(sum(exp(x - mx)))
    if (log) lo else exp(lo)
  }, numeric(1))
}
omega_bar <- function(mapped, Va, kappa, dfe, f_i, form = "mult", kappa_cis = 1, kappa_own = 1)
  omega_fun(mapped, f_i, kappa, dfe, form, kappa_cis, kappa_own)(Va)

# Genome-wide N_e/N at the same retention in both terms (Theory eq. genome_linked):
# Omega_bar exp(-Q^2 kappa V_A), or Omega_bar / (1 + Q^2 kappa V_A) at first order.
ne_linked <- function(mapped, Va, kappa, dfe, f_i, form = c("mult", "first"),
                      kappa_cis = 1, kappa_own = 1) {
  form <- match.arg(form)
  B <- linked_coefs(mapped, dfe)$B
  glob <- if (form == "mult") exp(-B * kappa * Va) else 1 / (1 + B * kappa * Va)
  omega_bar(mapped, Va, kappa, dfe, f_i, form, kappa_cis, kappa_own) * glob
}

# The DFEs of data/dfe_reference.csv used for bands, as retention specifications.
dfe_reference <- function(path = "data/dfe_reference.csv") {
  d <- read.csv(path)
  d <- d[d$used_for_band == "yes", ]
  d$spec <- Map(dfe_gamma, d$shape_alpha, d$scale_beta_prime)
  d
}

# The empirical DFE assigned to each population (data/dfe_assignment.csv): its own
# species where estimated, else an equal mixture of the closest relatives' DFEs in
# data/dfe_reference.csv (all rows, whether or not used for bands). Returns a named
# list of retention specifications, one per code, each with s_bar.
dfe_assigned <- function(path = "data/dfe_assignment.csv", ref = "data/dfe_reference.csv") {
  a <- read.csv(path, stringsAsFactors = FALSE)
  r <- read.csv(ref, stringsAsFactors = FALSE)
  one <- function(nm) { i <- match(nm, r$common_name); stopifnot(!is.na(i))
                        dfe_gamma(r$shape_alpha[i], r$scale_beta_prime[i]) }
  out <- lapply(strsplit(a$dfe, ";"), function(nms) {
    sp <- lapply(trimws(nms), one)
    if (length(sp) == 1) sp[[1]] else dfe_mixture(sp)
  })
  setNames(out, a$code)
}

# f_i for the mapped chromosomes of one population.
#   mapped  that population's mapped autosomes; all_auto  all its autosomes
f_share <- function(mapped, all_auto, partition = c("bp", "gene")) {
  partition <- match.arg(partition)
  if (partition == "bp") mapped$L_coding_bp / sum(all_auto$L_coding_bp)
  else mapped$Gene_Count / sum(all_auto$Gene_Count)
}

# ==============================================================================
# kappa.R — mating-system scalar and the G correction (scratch.tex Appendices A, B)
# ==============================================================================
# One definition for every script. N/N_e = 1 + 4 kappa V_A, where kappa follows
# from the cumulative advantage L of a neutral gene copy (Woolliams, Bijma &
# Villanueva 1999) and the two-sex mean of Santiago & Caballero (1995):
#   N/N_e = 1 + (Var L_f + Var L_m) / 2.
#
# Arguments shared by the functions below
#   alpha  extra-pair paternity rate (social monogamy only)
#   gamma  dependence of extra-pair success on male breeding value:
#          0 = Model A (lottery), 1 = Model B (gains replace within-pair loss)
#   G      fraction of additive variance remaining among selected parents.
#          G = 1 is Appendix A's assumption and gives the LARGEST reduction in
#          N_e, so it is the conservative case for the diversity comparison.
#   rho    r_mf: correlation of social partners' breeding values (0 = random
#          pairing with respect to breeding value)
# ==============================================================================

# Santiago & Caballero's cumulative factor, Q = 2 / (2 - G (1 + r_mf))
Q_sc <- function(G = 1, rho = 0) 2 / (2 - G * (1 + rho))
# Unlinked Q^2 with the same per-generation persistence Z as the linked term
# (main text, total_red; decided 2026-10-15). Equals the M -> infinity limit of the
# linked Q2bar, so Omega <= 1 holds exactly. Z = 1 recovers Appendix A's 4.
Qu2 <- function(Z) (2 / (2 - Z))^2

# No pair bond (polygynous, polygynandrous): each parent's family size depends on
# its own breeding value only, so kappa = Q^2 / 4 (= 1 at G = 1, rho = 0).
kappa_nopair <- function(G = 1, rho = 0) Q_sc(G, rho)^2 / 4

# Social monogamy with a shared nest: female advantage a_f + a_s; male
# (1 - alpha)(a_m + a_f') + alpha gamma a_m.
kappa_pair <- function(alpha, gamma = 1, G = 1, rho = 0) {
  m    <- 1 - alpha + alpha * gamma                  # own-value weight, males
  cbar <- (1 + m) / 2 + rho * (2 - alpha) / 2        # carrier advantage per unit h
  th   <- (G / 2) * (1 + (1 - alpha) * rho)          # per-generation persistence
  Phi  <- cbar * (G / 2) / (1 - th)
  v <- function(x, y) x^2 + y^2 + 2 * rho * x * y    # Var(x a + y b) / V_A
  vF <- v(1 + Phi, 1 + Phi * (1 - alpha))
  vM <- v(m + Phi, (1 - alpha) * (1 + Phi))
  (vF + vM) / 8
}

# Closed forms at G = 1, rho = 0 (Appendix B)
kappa_A <- function(alpha)
  ((4 - alpha)^2 * (1 + (1 - alpha)^2) + (4 - 3 * alpha + alpha^2)^2 + (4 - 3 * alpha)^2) / 32
kappa_B <- function(alpha) 2 - 1.5 * alpha + 0.625 * alpha^2

# Split of kappa for the linked term (Appendix B, "Own, partner and linked
# components"; G = 1, rho = 0). kappa = own + partner. The partner's breeding
# value is never in cis with a focal copy, so only the own part loses v_h to the
# linked term, and the linked exponent carries kappa_cis, not kappa:
#   (N_e/N)_i = exp(-kappa_cis Q2bar v_h) / (1 + 4 kappa V_A - 4 kappa_own v_h).
# Without a pair bond, and under Model B (gamma = 1), own = cis = 1.
kappa_own <- function(alpha, gamma = 1) {
  m <- 1 - alpha + alpha * gamma; Phi <- (1 + m) / 2
  ((1 + Phi)^2 + (m + Phi)^2) / 8
}
kappa_partner <- function(alpha, gamma = 1) kappa_pair(alpha, gamma) - kappa_own(alpha, gamma)
# cis weight for a linked locus with per-generation persistence rho = (1 - r) Z;
# between mbar^2 (tight linkage) and (1 + m^2)/2 (loose); 1 when m = 1
kappa_cis <- function(alpha, gamma = 1, rho) {
  m <- 1 - alpha + alpha * gamma; mb <- (1 + m) / 2; X <- rho / (1 - rho)
  ((1 + mb * X)^2 + (m + mb * X)^2) / (2 * (1 + X)^2)
}

# G under fecundity selection on Gaussian breeding values (Appendix A): a parent
# whose expected family size is 1 + b a has selected-parent variance
# V_A - b^2 V_A^2, so G = 1 - b^2 V_A. Sexes averaged (Santiago & Caballero 1995).
# Valid only while G > 0; NA outside that domain.
G_fecundity <- function(Va, alpha = NA, gamma = 1, pair = FALSE) {
  if (!pair) G <- 1 - Va
  else {
    m <- 1 - alpha + alpha * gamma
    G <- 1 - Va * (1 + m^2) / 2
  }
  ifelse(G > 0, G, NA_real_)
}

# N_e / N for a population, with or without the G correction
ne_ratio <- function(Va, pair, alpha = NA, gamma = 1, G_correct = FALSE, rho = 0) {
  G <- if (G_correct) G_fecundity(Va, alpha, gamma, pair) else 1
  k <- if (pair) kappa_pair(alpha, gamma, G, rho) else kappa_nopair(G, rho)
  1 / (1 + 4 * k * Va)
}

# ------------------------------------------------------------------------------
# Multiplicative fitness map (Appendix A; pair bond and EPP in Appendix B since 2026-10-21; decided 2026-10-19). Log-fitness is
# additive and Gaussian, w ∝ e^z, the structure of Bonnet et al.'s log-link model,
# for which V_A(w) = Var(z) (de Villemereuil et al. 2016). Reproductive value of an
# ancestor with log value z is exp(2(z - zbar) - 2V) and coalescence goes as its
# square (Barton & Etheridge 2011), so N/N_e = E[r^2] / E[r]^2 over gene copies.
#   no pair bond:  N_e/N = exp(-4 V_A)                               (exact)
#   social monogamy, Model B: copies in females and males have long-term
#   contributions that are two-term lognormal mixtures (within-pair nest term
#   e^{2(a+a_s)}, extra-pair term e^{2a + a_s} or e^{2a}); averaged over sexes:
#     exp(-8 V_A) <= N_e/N <= exp(-4 kappa_B V_A),
#   equal at alpha = 0, matching 1/(1 + 4 kappa_B V_A) to first order. The upper
#   end of the reduction, exp(8 V_A), follows from u_k . u_l <= max |u|^2 = 8.
# Every form here is an UPPER bound on the reduction in real populations: it rests
# on the Gaussian upper tail of log-fitness, which territory, clutch-size and
# breeding-probability ceilings (Bonnet's zero-inflation) truncate.
# ------------------------------------------------------------------------------
.lognorm_ratio <- function(w, U, V) {   # E[r^2]/E[r]^2, r = sum_k w_k exp(U[k,] . x), x ~ N(0, V I)
  m1 <- sum(w * exp(V * rowSums(U^2) / 2)); m2 <- 0
  for (k in seq_along(w)) for (l in seq_along(w))
    m2 <- m2 + w[k] * w[l] * exp(V * sum((U[k, ] + U[l, ])^2) / 2)
  m2 / m1^2
}
# Exact multiplicative N_e/N (Model B nest sharing, gamma = 1, G = 1, r_mf = 0)
ne_ratio_mult <- function(Va, pair, alpha = NA) {
  f <- function(Va, pair, alpha) {
    if (!pair) return(exp(-4 * Va))
    F <- .lognorm_ratio(c(1 - alpha, alpha), rbind(c(2, 2), c(2, 1)), Va)
    M <- .lognorm_ratio(c(1 - alpha, alpha), rbind(c(2, 2), c(2, 0)), Va)
    1 / ((F + M) / 2)
  }
  mapply(f, Va, pair, alpha)
}
# Largest reduction the multiplicative model allows: exp(-4 kappa_mult V_A) with
# kappa_mult = 2 under social monogamy (any alpha) and 1 without a pair bond
kappa_mult_bound <- function(pair) ifelse(pair, 2, 1)
ne_ratio_mult_bound <- function(Va, pair) exp(-4 * kappa_mult_bound(pair) * Va)
# Ceiling on V_A from a diversity ratio delta, at all orders: ln(1/delta) / (4 kappa).
# With kappa = kappa_mult_bound it is the smallest V_A that could explain delta.
vamax_mult <- function(delta, kappa) log(1 / delta) / (4 * kappa)
# First-order ceiling (Equation vamax), meaningful only while it is << 1
vamax_first <- function(delta, kappa) (1 - delta) / (4 * kappa * delta)

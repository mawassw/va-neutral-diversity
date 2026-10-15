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

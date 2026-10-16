# ==============================================================================
# linked.R — the composite (unlinked + linked) model on the data layer
# ==============================================================================
# scratch.tex Theory, eq. total_red and the genome-wide aggregation after it:
#   (N_e/N)_i = exp(-kappa_cis Q2bar_i v_h) / [1 + Qu^2 (kappa V_A - kappa_own v_h)]
#   v_i = V_A f_i,  v_h = v_i / 2,  f_i = chromosome i's share of autosomal coding bp
#   Q2bar_i = position-averaged cumulative factor under a Haldane map (Appendix C)
#   Qu = 2 / (2 - Z), the unlinked factor at the same persistence Z
#   genome-wide N_e/N = sum_i (L_i / L_total) (N_e/N)_i over mapped autosomes
# Under Model B and without a pair bond, kappa_cis = kappa_own = 1 (kappa.R).
# Z = 1 - E[s^2]/E[s]; for a gamma DFE with shape alpha and scale beta' (s units)
# E[s^2]/E[s] = beta' (1 + alpha).
# ==============================================================================

source("scripts/R/kappa.R")

# Position-averaged Q^2 under a Haldane map: (2/M^2) * int_0^M (M - d) / D(d)^2,
# D(d) = 1 - (Z/2)(1 + exp(-2d)). Finite for any Z < 1 (D(0) = 1 - Z).
Q2bar_haldane <- function(M, Z) {
  stopifnot(Z < 1)
  if (M < 1e-6) return(1 / (1 - Z)^2)
  f <- function(d) (M - d) / (1 - (Z / 2) * (1 + exp(-2 * d)))^2
  (2 / M^2) * integrate(f, 0, M, rel.tol = 1e-9)$value
}
Q2bar_vec <- Vectorize(Q2bar_haldane)

Z_gamma <- function(shape, scale) 1 - scale * (1 + shape)

# Genome-wide N_e/N for one population.
#   chrom  mapped autosomes: M_morgans, L_coding_bp, Physical_Length_bp
#   L_coding_auto  autosomal coding bp over ALL autosomes (f_i denominator, so
#                  variance on unmapped chromosomes is not reassigned)
ne_linked <- function(chrom, Va, kappa, Z, L_coding_auto, kappa_cis = 1, kappa_own = 1) {
  f_i <- chrom$L_coding_bp / L_coding_auto
  v_h <- Va * f_i / 2
  q2 <- Q2bar_vec(chrom$M_morgans, Z)
  ne_i <- exp(-kappa_cis * q2 * v_h) / (1 + Qu2(Z) * (kappa * Va - kappa_own * v_h))
  w <- chrom$Physical_Length_bp / sum(chrom$Physical_Length_bp)
  sum(w * ne_i)
}

# Genome-wide linkage effect Omega_bar = sum_i w_i Omega_i, with Omega_i the
# chromosome's N_e/N relative to the unlinked baseline at the same Z (eq.
# linked_penalty); Omega_bar <= 1. The total reduction is then
# (1 + 4 kappa V_A) / Omega_bar, as in V_A,max^(linked) = (Omega_bar - delta) / (4 kappa delta).
omega_bar <- function(chrom, Va, kappa, Z, L_coding_auto, kappa_cis = 1, kappa_own = 1) {
  ne_linked(chrom, Va, kappa, Z, L_coding_auto, kappa_cis, kappa_own) * (1 + Qu2(Z) * kappa * Va)
}

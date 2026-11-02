# ==============================================================================
# check_q2bar_quadrature.R — closed-form Haldane Q2bar against numerical quadrature
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/check_q2bar_quadrature.R
# Appendix C, eq. C_closed_haldane (Q2bar_haldane() in linked.R) against adaptive
# quadrature of the position average (Theory eq. haldane_avg, reduced to one integral
# over the distance d between the two sites):
#   Q2bar(M, Z) = (2 / M^2) int_0^M (M - d) / [1 - (Z/2)(1 + exp(-2d))]^2 dd.
# The integrand peaks at d = 0 with width ~ (1 - Z), so the interval is split at
# d = (1 - Z) * 10^k before integrating. The check spans every retention factor
# the analysis uses (all classes of every assigned DFE, the uniform effects of
# Figure 2b-c and Methods, and s = s*) and every mapped autosome's map length,
# with margins on both sides. Added 2026-11-02 (user: cover the Z range of the
# analysis; Appendix C had stated Z 0.5-0.999, M >= 0.05).
# ==============================================================================
suppressPackageStartupMessages(library(dplyr))
source("scripts/R/load_data.R"); source("scripts/R/linked.R")

# Range used by the analysis
s_cls <- unlist(lapply(dfe_assigned(), `[[`, "s"))
pops <- load_populations("linked")
s_star <- pops$va_mode / pops$U_d_direct
s_used <- c(s_cls, 0.005, 0.01, 0.02, s_star)
M_used <- load_chromosomes(autosomes_only = TRUE, mapped_only = TRUE, macro_only = FALSE)$M_morgans
cat(sprintf("analysis range: s %.3g to %.3g (Z %.10g to %.10g); M %.4g to %.4g Morgans\n",
            min(s_used), max(s_used), 1 - max(s_used), 1 - min(s_used), min(M_used), max(M_used)))

# Stable integrand: 1 - (Z/2)(1 + e^{-2d}) = (1 - Z) + (Z/2)(1 - e^{-2d}), with 1 - Z
# formed exactly from the double Z the closed form receives (Sterbenz), so that
# quadrature does not lose digits to cancellation as Z -> 1.
quad <- function(M, Z) {
  oZ <- 1 - Z
  f <- function(d) (M - d) / (oZ - (Z / 2) * expm1(-2 * d))^2
  br <- sort(unique(c(0, pmin(M, oZ * 10^(-2:8)), M)))
  tot <- 0
  for (j in seq_len(length(br) - 1))
    tot <- tot + integrate(f, br[j], br[j + 1], rel.tol = 1e-12, abs.tol = 0,
                           subdivisions = 5000L)$value
  2 * tot / M^2
}

# Grid with margins: 1 - Z from 1e-9 to 1 - 1e-9 (Z from 1e-9 to 1 - 1e-9), M from 0.005 to 60
oneZ <- c(10^seq(-9, -0.05, length.out = 46), 0.99, 0.999, 1 - 1e-6, 1 - 1e-9)
Ms <- 10^seq(log10(0.005), log10(60), length.out = 30)
g <- expand.grid(oneZ = oneZ, M = Ms)
g$closed <- mapply(function(M, z1) Q2bar_haldane(M, 1 - z1), g$M, g$oneZ)
g$quad <- mapply(function(M, z1) quad(M, 1 - z1), g$M, g$oneZ)
g$rel <- abs(g$closed / g$quad - 1)
cat(sprintf("grid: %d points, Z from %.0e to 1 - %.0e, M in [%.3g, %.3g]\n",
            nrow(g), 1 - max(oneZ), min(oneZ), min(Ms), max(Ms)))
cat(sprintf("max relative difference: %.2e at 1 - Z = %.2e, M = %.3g\n",
            max(g$rel), g$oneZ[which.max(g$rel)], g$M[which.max(g$rel)]))
in_use <- g$oneZ >= min(s_used) / 10 &
  g$M >= min(M_used) / 2 & g$M <= max(M_used) * 2
cat(sprintf("within the analysis range (with margins): max relative difference %.2e\n", max(g$rel[in_use])))
for (lim in c(1e-9, 1e-10, 1e-12)) cat(sprintf("  points with relative difference > %.0e: %d\n", lim, sum(g$rel > lim)))

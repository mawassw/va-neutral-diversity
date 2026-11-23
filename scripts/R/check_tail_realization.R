# check_tail_realization.R — when does a finite population realize the multiplicative reduction?
#
# Under the multiplicative bound, log R = sigma * X with X ~ N(0, 1) and sigma^2 = 4 kappa_max V_A
# (Appendix B). E[R^2] is dominated by ancestors at X = 2 sigma, a fraction ~ exp(-2 sigma^2) =
# exp(-8 kappa_max V_A) of individuals. A population of N breeding individuals contains them in a
# typical generation only while 8 kappa_max V_A < ln N, i.e. V_A < V* = ln(N) / (8 kappa_max).
# At V*, N_e/N = exp(-4 kappa_max V*) = N^(-1/2), so N_e = sqrt(N).
#
# Part 1: V_A,delta (least variance for each observed deficit) relative to V*, with N = N_c and
#         N = N_c / 10 (one adult in ten breeds).
# Part 2: simulation, random mating. N individuals, each with two gene copies sharing R_i.
#         Pairwise coalescence probability per generation = sum over copies of p_j^2
#         = 2 * sum_i (R_i / (2 sum R))^2 = sum R_i^2 / (2 (sum R)^2); expectation e^{4V}/(2N).
#         P(third lineage joins | pair) ~ sum p^3 / sum p^2 (copy level).
# Run from the repo root: Rscript scripts/R/check_tail_realization.R   (2026-11-18)

source("scripts/R/kappa.R")
p <- read.csv("data/processed/populations.csv")
d <- read.csv("data/processed/diversity_census.csv")
x <- merge(p, d[, c("code", "pi_obs", "pi_lit", "log10_Nc")], by = "code")
x$pi_any <- ifelse(is.na(x$pi_obs), x$pi_lit, x$pi_obs)
x <- x[!is.na(x$pi_any) & !is.na(x$log10_Nc) & x$code != "SSH", ]   # deficit set (9)
x$Nc <- 10^x$log10_Nc
x$dhat <- x$pi_any / (4 * x$mu_direct * x$Nc)
x$km <- kappa_mult_bound(x$pair_bond != "no_pair_bond")

cat("Part 1: V_A,delta / V*  (V* = ln N / (8 kappa_max))\n")
for (b in c(1, 10)) {
  N <- x$Nc / b; dl <- x$dhat * b
  VAd <- log(1 / dl) / (4 * x$km); Vs <- log(N) / (8 * x$km); r <- VAd / Vs
  cat(sprintf("  N = N_c/%-2d  ratio %.2f-%.2f (median %.2f); V* %.2f-%.2f\n",
              b, min(r), max(r), median(r), min(Vs), max(Vs)))
  if (b == 1) print(data.frame(code = x$code, kappa_max = x$km, VA_delta = round(VAd, 2),
                               V_star = round(Vs, 2), ratio = round(r, 2),
                               Ne_obs = signif(x$pi_any / (4 * x$mu_direct), 3),
                               sqrt_N = signif(sqrt(N), 3)), row.names = FALSE)
}

cat("\nPart 2: simulation, random mating, N = 1e6 individuals, 20 generations per V\n")
set.seed(20261118); N <- 1e6
cat(sprintf("  V* = ln(N)/8 = %.2f\n", log(N) / 8))
for (V in c(0.5, 1, 1.5, 1.73, 2, 2.5)) {
  r <- replicate(20, {
    lr <- rnorm(N, 0, sqrt(4 * V)); R <- exp(lr - max(lr))
    c2 <- sum(R^2) / (2 * sum(R)^2)                  # pairwise coalescence probability
    pc <- R / (2 * sum(R))                           # share of one copy
    c(ratio = c2 / (exp(4 * V) / (2 * N)), triple = 2 * sum(pc^3) / (2 * sum(pc^2)),
      maxshare = 2 * max(pc))                        # share of the top individual
  })
  cat(sprintf("  V = %.2f: realized/expected median %.2f [%.2f-%.2f]; P(triple|pair) %.1e; top individual's share %.1e\n",
              V, median(r["ratio", ]), min(r["ratio", ]), max(r["ratio", ]),
              median(r["triple", ]), median(r["maxshare", ])))
}

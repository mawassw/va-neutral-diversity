# ==============================================================================
# load_data.R — the one entry point analysis and plotting scripts use for data
# ==============================================================================
#   source("scripts/R/load_data.R")      # from the repo root
#   pops  <- load_populations()           # 19 rows; filter on in_set_*
#   va    <- load_va_draws()              # 4000 x 19 posterior draws of V_A
#   chrom <- load_chromosomes(code = "RD")
#
# Everything comes from data/processed/, built by scripts/R/00_prepare_data.R.
# If that folder is missing or older than its sources, rebuild it first:
#   Rscript scripts/R/00_prepare_data.R
# ==============================================================================

.processed <- "data/processed"

.read_processed <- function(file) {
  path <- file.path(.processed, file)
  if (!file.exists(path)) {
    stop(path, " not found. Run `Rscript scripts/R/00_prepare_data.R` from the repo root.",
         call. = FALSE)
  }
  utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
}

# One row per population. `set` restricts to an analysis set:
#   "va"     all 19 (V_A-only and unlinked results)
#   "msd"    populations with a computable U_d (mutation-selection-drift side)
#   "linked" populations with mapped macro-autosomes (linked term)
load_populations <- function(set = c("va", "msd", "linked")) {
  set <- match.arg(set)
  pops <- .read_processed("populations.csv")
  pops[pops[[paste0("in_set_", set)]], , drop = FALSE]
}

# Posterior draws of V_A; columns are population codes. `long = TRUE` returns
# (draw, code, va) for ggplot.
load_va_draws <- function(codes = NULL, long = FALSE) {
  va <- .read_processed("va_posterior.csv")
  draws <- va$draw
  va <- va[, setdiff(names(va), "draw"), drop = FALSE]
  if (!is.null(codes)) va <- va[, codes, drop = FALSE]
  if (!long) return(va)
  data.frame(draw = rep(draws, ncol(va)),
             code = rep(names(va), each = nrow(va)),
             va   = unlist(va, use.names = FALSE))
}

# Per-chromosome table. Defaults reproduce the model conventions in CLAUDE.md:
# autosomes only, mapped chromosomes only, macrochromosomes (>= 20 Mb) only.
# Adds f_i under both partitions in scratch.tex / the code:
#   f_bp   = L_coding_bp / sum(L_coding_bp)   (what the code uses)
#   f_gene = Gene_Count  / sum(Gene_Count)    (what Methods describes)
# computed within each population over the rows retained.
load_chromosomes <- function(code = NULL, autosomes_only = TRUE,
                             mapped_only = TRUE, macro_only = TRUE) {
  ch <- .read_processed("chromosomes.csv")
  if (!is.null(code))   ch <- ch[ch$code %in% code, ]
  if (autosomes_only)   ch <- ch[ch$is_autosome, ]
  if (mapped_only)      ch <- ch[ch$has_map, ]
  if (macro_only)       ch <- ch[ch$is_macro, ]
  ch$f_bp   <- ave(ch$L_coding_bp, ch$code, FUN = function(x) x / sum(x))
  ch$f_gene <- ave(ch$Gene_Count,  ch$code, FUN = function(x) x / sum(x))
  ch$L_weight <- ave(ch$Physical_Length_bp, ch$code, FUN = function(x) x / sum(x))
  ch
}

# Observed side: pi and census per population, with gaps left as NA.
load_diversity <- function() .read_processed("diversity_census.csv")

# Model constants as a named numeric vector: p <- load_parameters(); p["Z_cap"]
load_parameters <- function() {
  p <- .read_processed("parameters.csv")
  stats::setNames(p$value, p$name)
}

# Mating-system scalar, Theory section / Appendix B.
calc_kappa <- function(alpha, model = c("A", "B")) {
  model <- match.arg(model)
  if (model == "A") 1 + (1 - alpha)^2 else 2 * (1 - alpha + alpha^2)
}

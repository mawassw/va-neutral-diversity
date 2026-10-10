# ==============================================================================
# 00_prepare_data.R — build the analysis-ready data layer in data/processed/
# ==============================================================================
# Run headless from the repo root:   Rscript scripts/R/00_prepare_data.R
#
# Reads every live source once, joins them through one explicit population
# crosswalk, validates the result, and writes tidy UTF-8 CSVs. Downstream
# analysis and plotting scripts read data/processed/ only (via
# scripts/R/load_data.R) and never touch the scattered sources directly.
#
# Nothing here changes a source file. Sources:
#   alldistzip                                  Bonnet et al. 2022 posteriors
#   data/species_EPP.csv                        mating system, EPP, mu, legacy Ud
#   data/raw/clean_chromosome_data.csv          per-chromosome assembly stats
#                                               (data_gen_2.R output; live
#                                               intermediate despite living in raw/)
#   data/recomb_data.csv                        linkage-map cM per linkage group
#   data/master_chromosome_recomb_data.csv      legacy joined table (validation only)
#   data/genomic_parameters_summary.csv         genome-wide assembly stats
#                                               (copied from gitignored genomic_data/)
#   data/lewin_eyre_walker_2026_data.xlsx       pi, mu, Ne, density, range
#
# Outputs (data/processed/):
#   populations.csv      one row per population (19): identity, mating system,
#                        kappa, mu, L_coding, U_d, V_A summaries, analysis sets
#   va_posterior.csv     4000 posterior draws of V_A x 19 populations
#   chromosomes.csv      one row per assembled chromosome per population, with
#                        map length where a linkage map matches
#   diversity_census.csv observed-side inputs (pi, census) per population,
#                        with explicit gaps
#   parameters.csv       model constants used across scripts
# See data/README.md for the data dictionary and provenance.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
  library(readxl)
  library(MCMCglmm)   # posterior.mode(), matching unlinked.R
  library(coda)
})

if (!file.exists("alldistzip")) {
  stop("Run from the repo root (alldistzip not found in the working directory).",
       call. = FALSE)
}
out_dir <- "data/processed"
dir.create(out_dir, showWarnings = FALSE)

# ------------------------------------------------------------------------------
# 1. Population crosswalk — the single source of truth for joins
# ------------------------------------------------------------------------------
# code         : project code (alldistzip names, species_EPP.csv)
# bonnet_code  : science.abk0853_data_s1/ArchivedData folder
# map_code     : Code in data/recomb_data.csv
# genome_sp    : Species in clean_chromosome_data / genomic_parameters_summary
# lewin_sp     : species in Lewin & Eyre-Walker 2026 STable1/3/5
# lewin_match  : exact | proxy (congener or subspecies) | none
crosswalk <- tribble(
  ~code, ~bonnet_code, ~map_code, ~genome_sp,             ~lewin_sp,                     ~lewin_match,
  "RD",  "rdR",        "rdR",     "cervus_elaphus",       "Cervus_elaphus_yarkandensis", "proxy",
  "SV",  "svG",        NA,        "chionomys_nivalis",    NA,                            "none",
  "NH",  "shN",        NA,        NA,                     NA,                            "none",
  "BTR", "btR",        "bt",      "cyanistes_caeruleus",  "Cyanistes_caeruleus",         "exact",
  "BTP", "btP",        "bt",      "cyanistes_caeruleus",  "Cyanistes_caeruleus",         "exact",
  "BTM", "btM",        "bt",      "cyanistes_caeruleus",  "Cyanistes_caeruleus",         "exact",
  "CF",  "cfG",        "cfG",     "ficedula_albicollis",  "Ficedula_albicollis",         "exact",
  "CSM", "rmC",        "rmC",     "macaca_mulatta",       "Macaca_mulatta",              "exact",
  "SFW", "sfC",        "sfC",     NA,                     NA,                            "none",
  "SSP", "spM",        "spM",     "melospiza_melodia",    NA,                            "none",
  "HT",  "hhT",        "hh",      "notiomystis_cincta",   NA,                            "none",
  "HK",  "hhK",        "hh",      "notiomystis_cincta",   NA,                            "none",
  "SSH", "ssS",        "ssS",     "ovis_aries",           NA,                            "none",
  "BHS", "bsR",        "bsR",     "ovis_canadensis",      NA,                            "none",
  "AB",  "ybA",        "ybA",     "papio_cynocephalus",   "Papio_anubis",                "proxy",
  "GTU", "gtW",        "gtW",     "parus_major",          NA,                            "none",
  "GTN", "gtH",        "gtH",     "parus_major",          NA,                            "none",
  # KS: species_EPP.csv says Sciurus vulgaris, but the Kluane Red Squirrel
  # Project studies the North American red squirrel, Tamiasciurus hudsonicus.
  # The sciurus_vulgaris assembly in genomic_data/ is therefore the wrong
  # species; it is NOT used here. See species_flag in populations.csv.
  "KS",  "rsK",        NA,        NA,                     NA,                            "none",
  "MK",  "mkK",        NA,        "suricata_suricatta",   NA,                            "none"
)
stopifnot(!anyDuplicated(crosswalk$code), nrow(crosswalk) == 19)

# ------------------------------------------------------------------------------
# 2. V_A posteriors (alldistzip$<code>$id = additive variance in relative fitness)
# ------------------------------------------------------------------------------
load("alldistzip")
stopifnot(setequal(names(alldistzip), crosswalk$code))
va_draws <- as.data.frame(lapply(alldistzip[crosswalk$code], function(x) x$id))
stopifnot(all(sapply(va_draws, length) == 4000), all(va_draws > 0))

va_summary <- tibble(
  code      = crosswalk$code,
  va_mode   = sapply(va_draws, function(x) unname(posterior.mode(as.mcmc(x)))),
  va_median = sapply(va_draws, median),
  va_mean   = sapply(va_draws, mean),
  va_hpd95_lo = sapply(va_draws, function(x) HPDinterval(as.mcmc(x))[1]),
  va_hpd95_hi = sapply(va_draws, function(x) HPDinterval(as.mcmc(x))[2]),
  va_n_draws  = sapply(va_draws, length)
)

write_csv(bind_cols(draw = seq_len(nrow(va_draws)), va_draws),
          file.path(out_dir, "va_posterior.csv"))

# ------------------------------------------------------------------------------
# 3. Mating system, EPP, mutation rate, legacy census (species_EPP.csv)
# ------------------------------------------------------------------------------
epp_raw <- read.csv("data/species_EPP.csv", fileEncoding = "latin1",
                    check.names = FALSE, stringsAsFactors = FALSE)
names(epp_raw)[names(epp_raw) == ""] <- "log10_Nc_legacy"   # unnamed last column
epp <- epp_raw %>%
  transmute(
    code            = Code,
    common_name     = Species,
    bonnet_label    = Names,
    location        = Location,
    scientific_name = `Scientific name`,
    mating_system   = `Mating system`,
    epp_alpha       = EPP,
    Ud_legacy       = Ud,
    mu_1 = mu_1, mu_1_lo = `95ci_lower_1`, mu_1_hi = `95ci_upper_1`,
    mu_2 = mu_2, mu_2_lo = `95ci_lower_2`, mu_2_hi = `95ci_upper_2`,
    log10_Nc_legacy = suppressWarnings(as.numeric(log10_Nc_legacy))
  )
stopifnot(setequal(epp$code, crosswalk$code))

# kappa (scratch.tex Theory, Appendix B). For non-monogamous systems the source
# codes EPP = 1 as a placeholder meaning "paternity not constrained by a social
# pair"; Model A then gives kappa = 1, but Model B gives kappa = 2, which is an
# artefact of the placeholder, not a prediction. Flagged, not altered.
kappa_A <- function(a) 1 + (1 - a)^2
kappa_B <- function(a) 2 * (1 - a + a^2)
epp <- epp %>%
  mutate(
    alpha_is_placeholder = mating_system != "monogamous",
    kappa_A = kappa_A(epp_alpha),
    kappa_B = kappa_B(epp_alpha)
  )

# ------------------------------------------------------------------------------
# 4. Chromosomes: assembly stats x linkage maps, per population
# ------------------------------------------------------------------------------
sex_or_organelle <- c("X", "Y", "Z", "W", "MT", "M", "MITO", "W1", "Z1")

assembly <- read_csv("data/raw/clean_chromosome_data.csv", show_col_types = FALSE,
                     col_types = cols(NCBI_Chromosome = col_character())) %>%
  filter(!toupper(NCBI_Chromosome) %in% c("MT", "M", "MITO"))

maps <- read_csv("data/recomb_data.csv", show_col_types = FALSE,
                 col_types = cols(NCBI_Chromosome = col_character(),
                                  Linkage_Group = col_character())) %>%
  mutate(Code = trimws(Code)) %>%
  # Maps for bt, hh, spM were never matched to assembly chromosomes
  # (NCBI_Chromosome = NA). Name matching is NOT a safe fallback: the song
  # sparrow assembly numbers chromosomes 1-31 sequentially while its map uses
  # avian names (1A, 4A, LGE22). Those maps stay unjoined until curated.
  filter(!is.na(NCBI_Chromosome)) %>%
  # Collared flycatcher: linkage groups Fal35 and Fal36 both map to assembly
  # LG35 (NC_021702.1, 0.25 Mb), so the legacy master table counts that
  # chromosome twice. Keep the first (Fal35) and record the collision.
  group_by(Code, NCBI_Chromosome) %>%
  mutate(map_note = if_else(n() > 1,
           paste0("multiple linkage groups map here: ",
                  paste(Linkage_Group, collapse = ";"), "; first kept"),
           NA_character_)) %>%
  slice(1) %>%
  ungroup()

chromosomes <- crosswalk %>%
  filter(!is.na(genome_sp)) %>%
  select(code, genome_sp, map_code) %>%
  inner_join(assembly, by = c("genome_sp" = "Species"), relationship = "many-to-many") %>%
  left_join(maps %>% select(map_code = Code, NCBI_Chromosome, Linkage_Group,
                            Total_cM, map_note),
            by = c("map_code", "NCBI_Chromosome")) %>%
  mutate(
    is_autosome = !toupper(NCBI_Chromosome) %in% sex_or_organelle,
    is_macro    = Physical_Length_bp >= 20e6,
    has_map     = !is.na(Total_cM),
    M_morgans   = Total_cM / 100
  ) %>%
  select(code, genome_sp, NCBI_Chromosome, SeqID, Assembly_Level,
         Physical_Length_bp, L_coding_bp, Gene_Count,
         is_autosome, is_macro, has_map, map_note, Linkage_Group,
         Total_cM, M_morgans) %>%
  arrange(code, suppressWarnings(as.numeric(NCBI_Chromosome)), NCBI_Chromosome)

stopifnot(!anyDuplicated(chromosomes[c("code", "NCBI_Chromosome")]))
write_csv(chromosomes, file.path(out_dir, "chromosomes.csv"))

# Validation: the curated rows must reproduce the legacy master table exactly.
master <- read_csv("data/master_chromosome_recomb_data.csv", show_col_types = FALSE,
                   col_types = cols(NCBI_Chromosome = col_character()))
chk <- master %>%
  distinct(Code, NCBI_Chromosome, .keep_all = TRUE) %>%   # drop the LG35 duplicate
  select(code = Code, NCBI_Chromosome, m_len = Physical_Length_bp,
         m_cds = L_coding_bp, m_M = M_morgans) %>%
  left_join(chromosomes, by = c("code", "NCBI_Chromosome"))
if (any(is.na(chk$M_morgans)) ||
    any(abs(chk$m_M - chk$M_morgans) > 1e-9) ||
    any(chk$m_len != chk$Physical_Length_bp) ||
    any(chk$m_cds != chk$L_coding_bp)) {
  stop("chromosomes.csv does not reproduce data/master_chromosome_recomb_data.csv")
}

# ------------------------------------------------------------------------------
# 5. Functional target size and U_d per population
# ------------------------------------------------------------------------------
# Primary: collapsed CDS bp summed over assembled autosomes (chromosome-level
# assemblies). Fallback for assemblies with no per-chromosome table: the
# genome-wide total in genomic_parameters_summary.csv (includes sex chromosomes
# and unplaced scaffolds, so slightly larger; flagged in L_coding_source).
genome_summary <- read_csv("data/genomic_parameters_summary.csv",
                           show_col_types = FALSE)

L_auto <- chromosomes %>%
  filter(is_autosome) %>%
  group_by(code) %>%
  summarise(L_coding_autosomal_bp = sum(L_coding_bp),
            L_coding_mapped_autosomal_bp = sum(L_coding_bp[has_map]),
            n_autosomes = n(),
            n_mapped_autosomes = sum(has_map),
            n_mapped_macro_autosomes = sum(has_map & is_macro),
            .groups = "drop")

populations <- crosswalk %>%
  left_join(epp, by = "code") %>%
  left_join(va_summary, by = "code") %>%
  left_join(L_auto, by = "code") %>%
  left_join(genome_summary %>%
              select(genome_sp = Species, L_coding_genomewide_bp = L_coding_bp,
                     genome_accession = Source_GCF, scaffold_N50 = Scaffold_N50),
            by = "genome_sp") %>%
  mutate(
    L_coding_bp = coalesce(L_coding_autosomal_bp, L_coding_genomewide_bp),
    L_coding_source = case_when(
      !is.na(L_coding_autosomal_bp)  ~ "autosomal_chromosomes",
      !is.na(L_coding_genomewide_bp) ~ "genome_wide_summary",
      TRUE ~ NA_character_),
    # Methods: U_d = 4 mu L_coding (2 mu per bp diploid x 2 for a regulatory
    # target equal to the exome). Carried for mu_1 with its 95% CI.
    U_d    = 4 * mu_1    * L_coding_bp,
    U_d_lo = 4 * mu_1_lo * L_coding_bp,
    U_d_hi = 4 * mu_1_hi * L_coding_bp,
    species_flag = if_else(code == "KS",
      "species_EPP.csv lists Sciurus vulgaris; Kluane population is Tamiasciurus hudsonicus",
      NA_character_),
    # Analysis sets
    in_set_va     = TRUE,
    in_set_msd    = !is.na(U_d),
    in_set_linked = !is.na(n_mapped_macro_autosomes) & n_mapped_macro_autosomes > 0,
    in_set_linked_legacy = code %in% unique(master$Code)
  ) %>%
  select(code, bonnet_code, common_name, bonnet_label, location, scientific_name,
         species_flag, mating_system, epp_alpha, alpha_is_placeholder,
         kappa_A, kappa_B,
         mu_1, mu_1_lo, mu_1_hi, mu_2, mu_2_lo, mu_2_hi,
         va_mode, va_median, va_mean, va_hpd95_lo, va_hpd95_hi, va_n_draws,
         genome_sp, genome_accession, scaffold_N50, L_coding_bp, L_coding_source,
         L_coding_autosomal_bp, L_coding_mapped_autosomal_bp, L_coding_genomewide_bp,
         n_autosomes, n_mapped_autosomes, n_mapped_macro_autosomes,
         U_d, U_d_lo, U_d_hi, Ud_legacy,
         map_code, in_set_va, in_set_msd, in_set_linked, in_set_linked_legacy)

stopifnot(nrow(populations) == 19, !anyDuplicated(populations$code))
write_csv(populations, file.path(out_dir, "populations.csv"))

# ------------------------------------------------------------------------------
# 6. Observed side: nucleotide diversity and census (Lewin & Eyre-Walker 2026)
# ------------------------------------------------------------------------------
lew_xlsx <- "data/lewin_eyre_walker_2026_data.xlsx"
st1 <- read_excel(lew_xlsx, "STable1", skip = 1)
st3 <- read_excel(lew_xlsx, "STable3", skip = 1, .name_repair = "unique_quiet")
st5 <- read_excel(lew_xlsx, "STable5", skip = 1, .name_repair = "unique_quiet")

st3_tidy <- st3 %>%
  transmute(lewin_sp = gsub(" ", "_", trimws(species)),
            pi_compartments = paste(na.omit(c(type...3)), collapse = "; "),
            pi_primary_compartment = type...3,
            pi_primary_source = trimws(source...5))

diversity <- crosswalk %>%
  select(code, lewin_sp, lewin_match) %>%
  left_join(st1 %>% transmute(lewin_sp = species, pi_obs = as.numeric(mean_pi),
                              lewin_mu = as.numeric(u_mean), lewin_Ne = as.numeric(Ne)),
            by = "lewin_sp") %>%
  left_join(st3_tidy %>% select(lewin_sp, pi_primary_compartment, pi_primary_source),
            by = "lewin_sp") %>%
  left_join(st5 %>% transmute(lewin_sp = species,
                              density_per_km2 = suppressWarnings(as.numeric(density_n_km2)),
                              density_source = ref_density,
                              range_km2 = suppressWarnings(as.numeric(range_area_km2)),
                              range_source = ref_range),
            by = "lewin_sp") %>%
  left_join(epp %>% select(code, log10_Nc_legacy), by = "code") %>%
  mutate(
    Nc_density_range = density_per_km2 * range_km2,
    pi_source = if_else(!is.na(pi_obs), "Lewin & Eyre-Walker 2026 STable1 mean_pi", NA_character_),
    # Breeding-adult N (the N in delta) is not available from any source yet.
    N_breeders = NA_real_,
    N_breeders_instrument = NA_character_
  )
write_csv(diversity, file.path(out_dir, "diversity_census.csv"))

# ------------------------------------------------------------------------------
# 7. Model constants
# ------------------------------------------------------------------------------
parameters <- tribble(
  ~name,                 ~value,  ~unit,      ~source,                                       ~used_in,
  "Ud_target_multiplier", 4,      "",         "Methods: U_d = 4 mu L_coding",                "MSD side",
  "s_het_default",        0.01,   "",         "Kim et al. DFE (E10); Z/Q exploration only",  "linked term",
  "s_het_grid_low",       0.005,  "",         "sensitivity grid",                            "linked term",
  "s_het_grid_high",      0.02,   "",         "sensitivity grid",                            "linked term",
  "s_dfe_benchmark_1",    1e-3,   "",         "vertebrate DFE mean, lower",                  "MSD forward reading",
  "s_dfe_benchmark_2",    5e-3,   "",         "vertebrate DFE mean, mid",                    "MSD forward reading",
  "s_dfe_benchmark_3",    1e-2,   "",         "vertebrate DFE mean, upper",                  "MSD forward reading",
  "Z_cap",                0.995,  "",         "numerical guard at Z -> 1",                   "linked term",
  "macro_min_length_bp",  20e6,   "bp",       "macrochromosome filter (undescribed, E9)",    "linked term",
  "cne_multiplier_none",  1,      "",         "coding only",                                 "linked term",
  "cne_multiplier_bird",  2,      "",         "conserved non-coding, birds",                 "linked term",
  "cne_multiplier_mammal",4,      "",         "conserved non-coding, mammals",               "linked term",
  "cne_multiplier_max",   5,      "",         "maximum-rescue",                              "linked term",
  "kappa_min",            1,      "",         "Theory: kappa in [1,2]",                      "all",
  "kappa_max",            2,      "",         "Theory: kappa in [1,2]",                      "all"
)
write_csv(parameters, file.path(out_dir, "parameters.csv"))

# ------------------------------------------------------------------------------
# 8. Report
# ------------------------------------------------------------------------------
message("\nWrote ", out_dir, "/: populations.csv, va_posterior.csv, chromosomes.csv, ",
        "diversity_census.csv, parameters.csv")
message("Analysis sets: V_A ", sum(populations$in_set_va),
        " | MSD (U_d computable) ", sum(populations$in_set_msd),
        " | linked (mapped macro-autosomes) ", sum(populations$in_set_linked),
        " [legacy linked set ", sum(populations$in_set_linked_legacy), "]")
message("Observed pi: ", sum(!is.na(diversity$pi_obs)), " of 19 (",
        sum(diversity$lewin_match == "exact"), " exact-species matches); ",
        "breeding-adult N: 0 of 19")

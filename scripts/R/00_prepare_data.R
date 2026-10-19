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
#   data/assembly_stats_added.csv               assemblies added 2026-10-10
#                                               (fetch_extract_assemblies.R)
#   data/lg_orthology.csv                       map LG <-> assembly chromosome for
#                                               size-numbered assemblies (lg_orthology.R)
#   data/mutation_rate_sources.csv              which species each direct mu comes from
#   data/census/census_buffalo_method.csv       census for species Buffalo 2021 lacks
#                                               (census_buffalo.R)
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
  "NH",  "shN",        NA,        "crocuta_crocuta",      NA,                            "none",
  # Blue tit map (bt) is fragmentary (chromosomes split into lettered pieces,
  # many at 0 cM); it is not joined to the assembly. map_code kept for reference.
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
  # KS: the Kluane population is Tamiasciurus hudsonicus (corrected 2026-10-10
  # from Sciurus vulgaris; the sciurus_vulgaris rows in clean_chromosome_data
  # are the wrong species and are not used).
  "KS",  "rsK",        NA,        "tamiasciurus_hudsonicus", NA,                         "none",
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
    epp_alpha_source = EPP,
    Ud_legacy       = Ud,
    # Two mutation-rate estimates, methodologically distinct. Not averaged: the
    # phylogenetic model is fitted to the direct estimates, so they are not
    # independent, and averaging CI bounds does not give a CI.
    #   mu_phylo  : species_EPP mu_1, phylogenetic mixed-model prediction
    #               (Wang & Obbard 2023, Evol. Lett.)
    #   mu_direct : species_EPP mu_2, direct pedigree/trio estimate of the
    #               species or its closest relative (Lewin & Eyre-Walker 2026)
    mu_phylo  = mu_1, mu_phylo_lo  = `95ci_lower_1`, mu_phylo_hi  = `95ci_upper_1`,
    mu_direct = mu_2, mu_direct_lo = `95ci_lower_2`, mu_direct_hi = `95ci_upper_2`,
    log10_Nc_buffalo = suppressWarnings(as.numeric(log10_Nc_legacy))
  )
stopifnot(setequal(epp$code, crosswalk$code))

# kappa (Theory section, Appendix B; formulas in scripts/R/kappa.R). The EPP
# rate alpha is a measurement only for socially monogamous systems. For
# polygynous/polygynandrous systems the source codes EPP = 1 to mean "no social
# pair constrains paternity"; that is not a measured rate, so epp_alpha is NA.
# Without a pair bond each parent's own breeding value sets its family size and
# the two-sex mean of Santiago & Caballero (1995) leaves Appendix A unchanged:
# kappa = 1 under both models (re-derived 2026-10-14; was 2 for Model B, which
# summed the sexes). Under social monogamy both partners set a shared nest's
# productivity; Model B (primary, decided 2026-10-10) lets extra-pair gains
# replace the within-pair loss, Model A makes them a lottery. All at G = 1 and
# r_mf = 0; the G = 1 - V_A sensitivity is computed per population below.
source("scripts/R/kappa.R")
epp <- epp %>%
  mutate(
    pair_bond = if_else(mating_system == "monogamous", "social_monogamy", "no_pair_bond"),
    epp_alpha = if_else(pair_bond == "social_monogamy", epp_alpha_source, NA_real_),
    kappa_A = if_else(pair_bond == "social_monogamy", kappa_A(epp_alpha), 1),
    kappa_B = if_else(pair_bond == "social_monogamy", kappa_B(epp_alpha), 1),
    kappa = kappa_B
  ) %>%
  left_join(read_csv("data/mutation_rate_sources.csv", show_col_types = FALSE),
            by = "code")

# ------------------------------------------------------------------------------
# 4. Chromosomes: assembly stats x linkage maps, per population
# ------------------------------------------------------------------------------
sex_or_organelle <- c("X", "Y", "Z", "W", "MT", "M", "MITO", "W1", "Z1")

added <- read_csv("data/assembly_stats_added.csv", show_col_types = FALSE,
                  col_types = cols(NCBI_Chromosome = col_character()))
assembly <- read_csv("data/raw/clean_chromosome_data.csv", show_col_types = FALSE,
                     col_types = cols(NCBI_Chromosome = col_character())) %>%
  filter(Species != "sciurus_vulgaris") %>%            # wrong species for KS
  mutate(accession = NA_character_) %>%
  bind_rows(added %>% filter(Assembly_Level == "Chromosome")) %>%
  filter(!toupper(NCBI_Chromosome) %in% c("MT", "M", "MITO"))
stopifnot(!anyDuplicated(assembly[c("Species", "NCBI_Chromosome")]))
genome_totals <- added %>% filter(Assembly_Level == "Genome_total")

maps <- read_csv("data/recomb_data.csv", show_col_types = FALSE,
                 col_types = cols(NCBI_Chromosome = col_character(),
                                  Linkage_Group = col_character())) %>%
  mutate(Code = trimws(Code),
         map_match = if_else(is.na(NCBI_Chromosome), NA_character_, "curated"))

# Song sparrow: its assembly numbers chromosomes by size, its map uses avian
# homology names, so the join goes through gene-symbol orthology to great tit
# (lg_orthology.R). Name matching would mis-assign.
orth <- read_csv("data/lg_orthology.csv", show_col_types = FALSE,
                 col_types = cols(NCBI_Chromosome = col_character(),
                                  Linkage_Group = col_character()))
maps <- maps %>%
  left_join(orth %>% select(Code = map_code, Linkage_Group, orth_chr = NCBI_Chromosome,
                            orth_share = share),
            by = c("Code", "Linkage_Group")) %>%
  mutate(map_match = if_else(is.na(NCBI_Chromosome) & !is.na(orth_chr),
                             sprintf("gene orthology to great tit (share %.2f)", orth_share),
                             map_match),
         NCBI_Chromosome = coalesce(NCBI_Chromosome, orth_chr)) %>%
  filter(!is.na(NCBI_Chromosome)) %>%
  select(-orth_chr, -orth_share)
# One linkage group per assembly chromosome. (Flycatcher Fal36 was mapped to
# LG35 alongside Fal35; corrected in recomb_data.csv on 2026-10-10.)
stopifnot(!anyDuplicated(maps[c("Code", "NCBI_Chromosome")]))

chromosomes <- crosswalk %>%
  filter(!is.na(genome_sp)) %>%
  select(code, genome_sp, map_code) %>%
  inner_join(assembly, by = c("genome_sp" = "Species"), relationship = "many-to-many") %>%
  left_join(maps %>% select(map_code = Code, NCBI_Chromosome, Linkage_Group,
                            Total_cM, map_match),
            by = c("map_code", "NCBI_Chromosome")) %>%
  mutate(
    is_autosome = !toupper(NCBI_Chromosome) %in% sex_or_organelle,
    is_macro    = Physical_Length_bp >= 20e6,
    # A map length below 1 cM is a sparse-marker artefact, not a measurement:
    # every bivalent needs at least one crossover (~50 cM sex-averaged). Five
    # song sparrow linkage groups (chr 14, 20, 23, 26, 31; 3-21 Mb) report
    # 0-0.2 cM. They are treated as unmapped (decided 2026-10-17).
    has_map     = !is.na(Total_cM) & Total_cM >= 1,
    M_morgans   = Total_cM / 100
  ) %>%
  select(code, genome_sp, NCBI_Chromosome, SeqID, Assembly_Level,
         Physical_Length_bp, L_coding_bp, Gene_Count,
         is_autosome, is_macro, has_map, map_match, Linkage_Group,
         Total_cM, M_morgans) %>%
  arrange(code, suppressWarnings(as.numeric(NCBI_Chromosome)), NCBI_Chromosome)

stopifnot(!anyDuplicated(chromosomes[c("code", "NCBI_Chromosome")]))
write_csv(chromosomes, file.path(out_dir, "chromosomes.csv"))

# Validation: the curated rows must reproduce the legacy master table exactly.
master <- read_csv("data/master_chromosome_recomb_data.csv", show_col_types = FALSE,
                   col_types = cols(NCBI_Chromosome = col_character()))
chk <- master %>%
  distinct(Code, NCBI_Chromosome, .keep_all = TRUE) %>%   # master counts LG35 twice
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
# 5. Functional target size and U_d per population — AUTOSOMES ONLY
# ------------------------------------------------------------------------------
# Sex chromosomes are excluded from the model, so U_d counts autosomal coding
# sequence only: collapsed CDS bp summed over assembled autosomes.
# Two species have no chromosome-level annotated assembly (hyena, hihi). Their
# genome-wide CDS total is scaled by the autosomal share of CDS in the closest
# chromosome-level relative in the data:
#   crocuta_crocuta    <- suricata_suricatta (both Feliformia)
#   notiomystis_cincta <- mean of the chromosome-level passerines
genome_summary <- read_csv("data/genomic_parameters_summary.csv",
                           show_col_types = FALSE)

auto_share <- assembly %>%
  group_by(Species) %>%
  summarise(share = sum(L_coding_bp[!toupper(NCBI_Chromosome) %in% sex_or_organelle]) /
                    sum(L_coding_bp), .groups = "drop")
passerines <- c("ficedula_albicollis", "parus_major", "melospiza_melodia", "cyanistes_caeruleus")
share_proxy <- tribble(
  ~genome_sp,           ~auto_share_proxy,                                        ~auto_share_from,
  "crocuta_crocuta",    auto_share$share[auto_share$Species == "suricata_suricatta"], "suricata_suricatta",
  "notiomystis_cincta", mean(auto_share$share[auto_share$Species %in% passerines]),  paste(passerines, collapse = "+")
)

genome_totals_all <- bind_rows(
  genome_summary %>% transmute(genome_sp = Species, L_coding_genomewide_bp = L_coding_bp,
                               genome_accession = Source_GCF),
  genome_totals %>% transmute(genome_sp = Species, L_coding_genomewide_bp = L_coding_bp,
                              genome_accession = accession)
) %>%
  # assemblies added 2026-10-10 supersede the summary's older accession
  left_join(added %>% distinct(genome_sp = Species, added_acc = accession), by = "genome_sp") %>%
  mutate(genome_accession = coalesce(added_acc, genome_accession)) %>%
  select(-added_acc) %>%
  distinct(genome_sp, .keep_all = TRUE)

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
  left_join(genome_totals_all, by = "genome_sp") %>%
  left_join(share_proxy, by = "genome_sp") %>%
  mutate(
    L_coding_bp = coalesce(L_coding_autosomal_bp, L_coding_genomewide_bp * auto_share_proxy),
    L_coding_source = case_when(
      !is.na(L_coding_autosomal_bp) ~ "autosomal_chromosomes",
      !is.na(auto_share_proxy) ~ sprintf("genome_total x autosomal share %.3f (%s)",
                                         auto_share_proxy, auto_share_from),
      TRUE ~ NA_character_),
    # Methods: U_d = 4 mu L_coding (2 mu per bp diploid x 2 for a regulatory
    # target equal to the exome), under each mutation-rate estimate.
    U_d_phylo     = 4 * mu_phylo     * L_coding_bp,
    U_d_phylo_lo  = 4 * mu_phylo_lo  * L_coding_bp,
    U_d_phylo_hi  = 4 * mu_phylo_hi  * L_coding_bp,
    U_d_direct    = 4 * mu_direct    * L_coding_bp,
    U_d_direct_lo = 4 * mu_direct_lo * L_coding_bp,
    U_d_direct_hi = 4 * mu_direct_hi * L_coding_bp,
    # Unlinked reduction N/N_e at the posterior mode, Model B: at G = 1
    # (primary) and with G = 1 - V_A (Appendix A sensitivity bound)
    reduction_G1   = 1 + 4 * kappa * va_mode,
    G_sym          = 1 - va_mode,
    reduction_Gsym = 1 / mapply(ne_ratio, va_mode, pair_bond == "social_monogamy",
                                epp_alpha, MoreArgs = list(gamma = 1, G_correct = TRUE)),
    # Analysis sets
    in_set_va     = TRUE,
    in_set_msd    = !is.na(L_coding_bp),
    in_set_linked = !is.na(n_mapped_macro_autosomes) & n_mapped_macro_autosomes > 0,
    in_set_linked_legacy = code %in% unique(master$Code)
  ) %>%
  select(code, bonnet_code, common_name, bonnet_label, location, scientific_name,
         mating_system, pair_bond, epp_alpha, epp_alpha_source, kappa, kappa_A, kappa_B,
         mu_phylo, mu_phylo_lo, mu_phylo_hi,
         mu_direct, mu_direct_lo, mu_direct_hi, mu_direct_species, mu_direct_relation,
         va_mode, va_median, va_mean, va_hpd95_lo, va_hpd95_hi, va_n_draws,
         reduction_G1, G_sym, reduction_Gsym,
         genome_sp, genome_accession, L_coding_bp, L_coding_source,
         L_coding_autosomal_bp, L_coding_mapped_autosomal_bp, L_coding_genomewide_bp,
         n_autosomes, n_mapped_autosomes, n_mapped_macro_autosomes,
         U_d_phylo, U_d_phylo_lo, U_d_phylo_hi, U_d_direct, U_d_direct_lo, U_d_direct_hi,
         Ud_legacy, map_code, in_set_va, in_set_msd, in_set_linked, in_set_linked_legacy)

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
  left_join(epp %>% select(code, scientific_name, log10_Nc_buffalo), by = "code") %>%
  mutate(
    Nc_density_range_lewin = density_per_km2 * range_km2,
    pi_source = if_else(!is.na(pi_obs), "Lewin & Eyre-Walker 2026 STable1 mean_pi", NA_character_)
  )

# Literature pi for populations Lewin & Eyre-Walker lack (data/pi_literature.csv,
# compiled 2026-10-10). Kept apart from pi_obs: none is from the study population,
# and the bighorn and song sparrow values are MAF-filtered lower bounds. Single-
# genome heterozygosity is a different statistic and is carried separately.
pi_lit <- read_csv("data/pi_literature.csv", show_col_types = FALSE) %>%
  transmute(code, pi_lit = pi, pi_lit_compartment = compartment,
            pi_lit_population = sample_population, pi_lit_citation = citation,
            pi_lit_doi = doi, pi_lit_confidence = confidence,
            het_individual_lit = heterozygosity_individual)
diversity <- diversity %>% left_join(pi_lit, by = "code")

# Census N_c (density x range, Buffalo 2021).
#   log10_Nc          primary: Buffalo's published value, own species only
#   log10_Nc_congener Buffalo's published value for a congener (SFW: Malurus
#                     melanocephalus; AB: Papio anubis), not used as primary
#   log10_Nc_provisional  our reimplementation of his method (census_buffalo.R)
#                     for species he lacks. NOT validated: it reproduces his
#                     mammal densities but not his bird densities (he predicts
#                     mass from body length), and GBIF-wide ranges exceed his for
#                     3 of 4 check species. See data/README.md.
buffalo_species <- c(BTR = "Cyanistes caeruleus", BTP = "Cyanistes caeruleus",
                     BTM = "Cyanistes caeruleus", CF = "Ficedula albicollis",
                     CSM = "Macaca mulatta", SFW = "Malurus melanocephalus",
                     SSP = "Melospiza melodia", SSH = "Ovis aries", BHS = "Ovis canadensis",
                     AB = "Papio anubis", GTU = "Parus major", GTN = "Parus major")
census_method <- read_csv("data/census/census_buffalo_method.csv", show_col_types = FALSE) %>%
  filter(role == "new") %>%
  select(scientific_name = species, log10_Nc_provisional = log10_Nc,
         provisional_mass_g = mass_g, provisional_n_cells = n_cells)
diversity <- diversity %>%
  mutate(buffalo_species = unname(buffalo_species[code])) %>%
  left_join(census_method, by = "scientific_name") %>%
  mutate(
    # compare binomials ("Parus major (UK)" -> "Parus major")
    buffalo_exact = !is.na(buffalo_species) &
      buffalo_species == sub("^(\\S+ \\S+).*", "\\1", scientific_name),
    log10_Nc = if_else(buffalo_exact, log10_Nc_buffalo, NA_real_),
    log10_Nc_congener = if_else(!buffalo_exact & !is.na(buffalo_species), log10_Nc_buffalo, NA_real_),
    Nc_source = case_when(buffalo_exact ~ "Buffalo 2021 (published, own species)",
                          TRUE ~ NA_character_),
    # Caveats on the published values (stated in the manuscript where N_c is used).
    # Buffalo predicts bird body mass from body length (blue tit ~150 g vs 11 g
    # measured), which lowers predicted density by ~1.2 orders, so his bird N_c is
    # likely understated. His Ovis aries value is domestic sheep worldwide, not
    # the St Kilda Soay population.
    Nc_caveat = case_when(
      code == "SSH" ~ "domestic Ovis aries range, not the Soay population",
      buffalo_exact & code %in% c("BTR", "BTP", "BTM", "CF", "SFW", "SSP", "HT", "HK", "GTU", "GTN") ~ "bird density from length-predicted mass: likely understated",
      TRUE ~ NA_character_),
    # Breeding-adult N (the N in delta) is not available from any source yet.
    N_breeders = NA_real_,
    N_breeders_instrument = NA_character_
  ) %>%
  select(-log10_Nc_buffalo)
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
  "kappa_min",            1,      "",         "Appendix B: Model B kappa in [1,2] (Model A down to 7/16)", "all",
  "kappa_max",            2,      "",         "Appendix B: strict monogamy",                 "all"
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
        sum(diversity$lewin_match == "exact"), " exact-species matches); census N_c: ",
        sum(!is.na(diversity$log10_Nc)), " of 19; breeding-adult N: 0 of 19")

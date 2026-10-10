# data/

## How to use

```sh
Rscript scripts/R/00_prepare_data.R      # from the repo root; ~10 s; rebuilds data/processed/
```

```r
source("scripts/R/load_data.R")          # analysis and plotting scripts read data through this only
pops  <- load_populations("msd")         # "va" (19) | "msd" (16) | "linked" (8)
va    <- load_va_draws(long = TRUE)      # 4000 draws x 19 populations
chrom <- load_chromosomes()              # autosomal, mapped, >= 20 Mb by default; adds f_bp, f_gene, L_weight
obs   <- load_diversity()                # pi and census, gaps as NA
p     <- load_parameters()               # model constants
```

`data/processed/` is derived. Never edit it by hand: change a source or `00_prepare_data.R` and rebuild.
The build stops if the chromosome table fails to reproduce `master_chromosome_recomb_data.csv`.

## Sources (inputs to `00_prepare_data.R`)

| file | content | provenance |
|---|---|---|
| `../alldistzip` | MCMCglmm posteriors, 4000 draws per variance component, 19 populations; `$id` is $V_A$ | Bonnet et al. 2022, back-transformed to observed-scale relative fitness |
| `species_EPP.csv` | mating system, EPP rate $\alpha$, $\mu$ (two sets, 95% CI), legacy $U_d$, unnamed last column = log10 census | compiled by WM. `mu_2` equals Lewin & Eyre-Walker 2026 `u_mean` wherever both exist; **`mu_1` (used by the code) has no recorded source**. The census column matches `log10_popsize` in `raw/mutation_rate_literature_updating3.xlsx` (Buffalo 2021) for 4 species; the rest are undocumented |
| `raw/clean_chromosome_data.csv` | per-chromosome physical length, collapsed CDS bp, gene count, 11 assemblies | `data_gen_2.R` from NCBI GFF/GTF. **A live intermediate despite living in `raw/`** |
| `recomb_data.csv` | linkage-group cM per species, matched to an assembly chromosome where curated | linkage-map sources listed in `raw/species.xlsx` Sheet1 |
| `genomic_parameters_summary.csv` | genome-wide assembly stats, incl. blue tit and hihi | copied from gitignored `genomic_data/` so the build works from a clone |
| `lewin_eyre_walker_2026_data.xlsx` | $\pi$, $\mu$, $N_e$ (STable1), $\pi$ compartments (STable3), density and range (STable5) | Lewin & Eyre-Walker 2026, *Mol. Ecol.* |
| `master_chromosome_recomb_data.csv` | legacy joined table | **validation target only**, superseded by `processed/chromosomes.csv` |

`va_species_bonnet.csv` is superseded by `processed/populations.csv`. It mislabels the Rouvière blue tits
(`Blue.tits.R`) as `BTM`, which duplicates that code. Not read by any script.

## Outputs (`processed/`)

**`populations.csv`**: one row per population.
Identity: `code`, `bonnet_code`, `common_name`, `location`, `scientific_name`, `species_flag`.
Mating system: `mating_system`, `epp_alpha`, `alpha_is_placeholder`, `kappa_A`, `kappa_B`.
Mutation: `mu_1`, `mu_1_lo`, `mu_1_hi`, `mu_2`, `mu_2_lo`, `mu_2_hi` (per bp per generation).
$V_A$: `va_mode` (MCMCglmm `posterior.mode`, as in `unlinked.R`), `va_median`, `va_mean`, `va_hpd95_lo/hi`.
Genome: `genome_sp`, `genome_accession`, `L_coding_bp` (primary), `L_coding_source`,
`L_coding_autosomal_bp`, `L_coding_mapped_autosomal_bp`, `L_coding_genomewide_bp`, chromosome counts.
$U_d = 4\mu_1 L_{\text{coding}}$: `U_d`, `U_d_lo`, `U_d_hi`; `Ud_legacy` is the old column, kept for comparison.
Sets: `in_set_va`, `in_set_msd`, `in_set_linked`, `in_set_linked_legacy`.

**`va_posterior.csv`**: `draw` plus one column per population code.

**`chromosomes.csv`**: one row per assembled chromosome per population. Assembly stats, `is_autosome`,
`is_macro` (≥ 20 Mb), `has_map`, `Total_cM`, `M_morgans`, `map_note`.

**`diversity_census.csv`**: `lewin_match` (exact / proxy / none), `pi_obs`, `pi_primary_compartment`,
`pi_primary_source`, `lewin_mu`, `lewin_Ne`, `density_per_km2`, `range_km2`, `Nc_density_range`,
`log10_Nc_legacy`, `N_breeders` (all NA), `N_breeders_instrument`.

**`parameters.csv`**: model constants (`s_het` grid, DFE benchmarks, CNE multipliers, `Z_cap`, 20 Mb filter).

## Coverage, as of 2026-10-10

| input | have | missing |
|---|---|---|
| $V_A$ posterior | 19 / 19 | — |
| $\alpha$, $\kappa$ | 19 / 19 | per-species EPP citations; non-monogamous systems coded $\alpha = 1$ (placeholder) |
| $\mu$ with CI | 19 / 19 | source for `mu_1` |
| $L_{\text{coding}}$, $U_d$ | 16 / 19 | NH (*Crocuta*), SFW (*Malurus*), KS (*Tamiasciurus*) assemblies |
| linkage map joined to assembly | 8 / 19 | SSP (map present, needs LG↔chromosome curation), blue tits ×3 (map present, no per-chromosome assembly table), hihi ×2 (scaffold assembly), SFW (map, no assembly), SV/MK/NH/KS (no map) |
| $\pi_{\text{obs}}$ | 7 / 19 (5 exact, 2 proxy) | SSH, BHS, GTU, GTN, SSP, SFW, HT, HK, SV, NH, KS, MK |
| breeding-adult $N$ | 0 / 19 | all |

## Known data issues (flagged, not silently fixed)

1. **KS is the wrong species.** `species_EPP.csv` lists *Sciurus vulgaris*. The Kluane population is the
   North American red squirrel, *Tamiasciurus hudsonicus*, so `genomic_data/sciurus_vulgaris` is not
   used and KS has no $U_d$.
2. **The $\alpha = 1$ placeholder.** For polygynous and polygynandrous systems, $\alpha = 1$ gives
   $\kappa_A = 1$ (sensible) but $\kappa_B = 2$, which is an artefact of the placeholder. Report
   Model B only for socially monogamous populations, or recode.
3. **Flycatcher LG35 was double-counted** in the legacy master table: linkage groups Fal35 and Fal36
   both map to assembly LG35. `chromosomes.csv` keeps Fal35 and records the collision. It's a 0.25 Mb
   chromosome, so it is outside the macro set and doesn't affect current results.
4. **$U_d$ depends on which coding length is used.** Earlier quoted values (0.69–1.19, median 1.07)
   summed the master table, which includes X/Z. Autosomes only gives 0.65–1.19, median 1.04, on the
   same 8 populations. Blue tits and hihi use genome-wide totals because they have no per-chromosome
   table.
5. **Two census sources disagree for collared flycatcher:** Lewin STable5 density × range gives
   3.5 × 10⁷, while the legacy log10 column gives 1.4 × 10⁹. Both are contemporary density × range
   figures, which scope condition 4 deprioritises.

# data/

## How to use

```sh
Rscript scripts/R/00_prepare_data.R      # from the repo root; ~10 s; rebuilds data/processed/
```

```r
source("scripts/R/load_data.R")          # analysis and plotting scripts read data through this only
pops  <- load_populations("msd")         # "va" (19) | "msd" (18) | "linked" (9)
va    <- load_va_draws(long = TRUE)      # 4000 draws x 19 populations
chrom <- load_chromosomes()              # autosomal, mapped, >= 20 Mb by default; adds f_bp, f_gene, L_weight
obs   <- load_diversity()                # pi and census, gaps as NA
p     <- load_parameters()               # model constants
```

`data/processed/` is derived. Never edit it by hand: change a source or a script and rebuild.
The build stops if the chromosome table fails to reproduce the curated rows of
`master_chromosome_recomb_data.csv`.

### The pipeline, in run order

| step | script | needs network | output (tracked) |
|---|---|---|---|
| 1 | `fetch_extract_assemblies.R` | yes, first run only | `assembly_stats_added.csv` |
| 2 | `lg_orthology.R` | yes, first run only | `lg_orthology.csv` |
| 3 | `census_buffalo.R` | yes (GBIF) | `census/census_buffalo_method.csv` |
| 4 | `00_prepare_data.R` | no | `processed/*.csv` |

Steps 1–3 only need rerunning if an assembly, a map, or the census method changes; their outputs are
committed, so step 4 alone rebuilds everything from a fresh clone. NCBI zips live in
`genomic_data/<species>/<accession>.zip` (gitignored, streamed, never unpacked) via `ncbi_helpers.R`.

## Sources

| file | content | provenance |
|---|---|---|
| `../alldistzip` | MCMCglmm posteriors, 4000 draws per variance component, 19 populations; `$id` is $V_A$ | Bonnet et al. 2022, back-transformed to observed-scale relative fitness |
| `species_EPP.csv` | mating system, EPP, two mutation rates with 95% CI, legacy $U_d$, unnamed last column = Buffalo 2021 log10 census | compiled by WM (see *Mutation rates* and *Census* below) |
| `mutation_rate_sources.csv` | which species each direct mutation rate comes from, and its relation to the population's species | added 2026-10-10 |
| `raw/clean_chromosome_data.csv` | per-chromosome length, collapsed CDS bp, gene count, 11 assemblies | `data_gen_2.R`. **A live input despite living in `raw/`.** Its `sciurus_vulgaris` rows are the wrong species and are ignored. 2026-10-28: `Gene_Count` recounted as protein-coding genes (`type == "gene"` with `gene_biotype=protein_coding`, the `ncbi_helpers.R` rule) from the same GFF/GTF files, replacing `data_gen_2.R`'s count of every `gene` feature; other columns untouched; `sciurus_vulgaris` rows not recounted |
| `assembly_stats_added.csv` | same, for blue tit (GCF_971803275.1), red squirrel (GCA_057657825.1), hyena (GCF_008692635.1, genome total only) | `fetch_extract_assemblies.R`, added 2026-10-10 |
| `recomb_data.csv` | linkage-group cM, matched to an assembly chromosome where curated | linkage-map sources in `raw/species.xlsx` Sheet1 |
| `lg_orthology.csv` | song sparrow assembly chromosome ↔ linkage group, via gene symbols shared with great tit | `lg_orthology.R`, added 2026-10-10 |
| `genomic_parameters_summary.csv` | genome-wide assembly stats (used for hihi) | copied from gitignored `genomic_data/` |
| `lewin_eyre_walker_2026_data.xlsx` | $\pi$, $\mu$, $N_e$ (STable1), $\pi$ compartments (STable3), density and range (STable5) | Lewin & Eyre-Walker 2026, *Mol. Ecol.* |
| `pi_literature.csv` | literature π (and single-genome heterozygosity) for the 12 populations Lewin & Eyre-Walker lack, with compartment, sample, DOI and verbatim evidence per row | literature search, added 2026-10-10 |
| `dfe_reference.csv` | measured gamma DFEs of new nonsynonymous mutations (shape α, scale β′ in *s* units, mean *s* = αβ′, heterozygous under semi-dominance); sets Figure 4's per-taxon bands (birds: two flycatchers; mammals: mouse, vaquita, fin whale) | Lin et al. 2026 *PLoS Biol* Table 1, verified 2026-10-15 against the published table and the means stated in its text |
| `census/damuth1987.tsv` | density–body mass data | Damuth 1987, via Buffalo's repository |
| `master_chromosome_recomb_data.csv` | legacy joined table | **validation target only** |

`va_species_bonnet.csv` is superseded and read by nothing. It mislabels the Rouvière blue tits as `BTM`.

## Decisions encoded here (2026-10-10)

**Mating system and κ.** The EPP rate α is a measurement only for socially monogamous systems. For
polygynous and polygynandrous systems, `species_EPP.csv` codes EPP = 1 to mean "no social pair constrains
paternity". That isn't a measured rate, so `epp_alpha` is NA for those systems (the source value is kept
in `epp_alpha_source`).

**κ re-derived 2026-10-14** (scratch.tex Appendix B; formulas in `scripts/R/kappa.R`). Without a
pair bond, each parent's own breeding value sets its family size, and Santiago & Caballero's (1995)
two-sex combination is a mean over the sexes, so **κ = 1** under both models (previously `kappa_B =
2`, which summed the sexes). Under social monogamy both partners set a shared nest's productivity:

- `kappa_A`: extra-pair siring is a lottery. Falls from 2 at α = 0 to 7/16 at α = 1.
- `kappa_B` $= 2 - 1.5\alpha + 0.625\alpha^2$: extra-pair gains replace the within-pair loss. Falls
  from 2 to 9/8.

**Primary κ is Model B for every population** (`kappa` column; decided 2026-10-10, kept 2026-10-14
because it is the only version consistent with Bonnet et al.'s single additive variance across
sexes). Model A (`kappa_A`) is the sensitivity bound. Both are at G = 1 and $r_{mf}$ = 0. The
monogamous populations run κ_B = 1.22 (fairy-wren, α = 0.76) to 1.93 (great tits, α = 0.047).

**Reduction columns (added 2026-10-14).** `reduction_G1` = $1 + 4\kappa V_A$ at the posterior mode;
`G_sym` = $1 - V_A$; `reduction_Gsym` = the same reduction with G = 1 − V_A (Appendix A sensitivity,
symmetric additive breeding values).

**Mutation rates: both carried, not averaged.**

- `mu_phylo` (`mu_1` in the source) is the phylogenetic mixed-model prediction, consistent with Wang &
  Obbard 2023 (*Evol. Lett.*; their `mutation_meta3.R` predicts rates with CIs for tips and nodes).
- `mu_direct` (`mu_2`) is a direct pedigree or trio estimate, for the species itself or its closest
  relative, from Lewin & Eyre-Walker 2026. The relative used is recorded in `mutation_rate_sources.csv`.

They aren't averaged, for two reasons. The phylogenetic model is fitted to those same direct estimates,
so the two aren't independent. And averaging two CI bounds doesn't produce a CI. Results should be
reported under both. `mu_phylo` runs 7–60% above `mu_direct`.

**U_d uses autosomes only:** $U_d = 4\mu L_{\text{coding}}$, with $L_{\text{coding}}$ the collapsed CDS on
assembled autosomes. Hyena and hihi have no chromosome-level annotated assembly, so their genome-wide
CDS total is scaled by the autosomal CDS share of the nearest chromosome-level relative:

| species | relative used for the scaling | autosomal share |
|---|---|---|
| hyena | meerkat | 0.965 |
| hihi | mean of the four chromosome-level passerines | 0.948 |

**Census N_c follows Buffalo 2021:**

- `log10_Nc`: his published value, own species only (10 populations).
- `log10_Nc_congener`: his value for a congener (SFW uses *Malurus melanocephalus*, AB uses *Papio
  anubis*). Not used as primary.
- `log10_Nc_provisional`: our reimplementation of his method for the species he lacks
  (`census_buffalo.R`). **Not validated and not pursued further (decided 2026-10-10); do not use.**
  See *Census reimplementation* below.
- `Nc_caveat`: per-population caveat on the published value, to be stated in the manuscript where
  N_c is used. Bird values are likely understated (length-predicted mass, below). The Soay value is
  Buffalo's species-wide *Ovis aries*, which is domestic sheep, not the St Kilda population.
- No breeding-adult N, and no historical census scaled by a breeder fraction (decided 2026-10-10:
  not for the preprint). Using N_c in place of N lowers δ by the breeder fraction (a factor of
  2–10), which cannot move a comparison between a mechanism removing at most ~20× and deficits of
  10²–10⁶.

## Coverage

| input | have | missing |
|---|---|---|
| $V_A$ posterior | 19 / 19 | — |
| mating system, κ | 19 / 19 | per-species EPP citations |
| $\mu$ (both estimates) | 19 / 19 | KS `mu_phylo` was predicted under *Sciurus vulgaris* |
| $L_{\text{coding}}$, $U_d$ (autosomal) | **18 / 19** | SFW: the only *Malurus cyaneus* assembly (GCA_009741485.1) is unannotated |
| linkage map joined to assembly | **9 / 19** | blue tits ×3 (map too fragmentary), hihi ×2 (scaffold assembly), SFW (unannotated), SV/NH/KS/MK (no map) |
| $\pi_{\text{obs}}$ | 7 / 19 | SSH, BHS, GTU, GTN, SSP, SFW, HT, HK, SV, NH, KS, MK |
| $\pi$, literature (`pi_lit`, not study population) | 4 / 12 missing | great tit ×2 (medium), bighorn and song sparrow (low: MAF-filtered lower bounds); SSH, SFW, KS nothing; HT/HK, SV, NH, MK single-genome heterozygosity only |
| census $N_c$ (Buffalo, own species) | 10 / 19 | RD, SV, NH, SFW, HT, HK, AB, KS, MK |
| breeding-adult $N$ | 0 / 19 | all |

## Census reimplementation: what it does and why it isn't used

`census_buffalo.R` computes density × range:

- **Density** comes from Damuth's (1987) allometry, using measured adult body mass (AnAge; Amniote
  Database; hihi 36 g from Walker et al. 2014).
- **Range** is an alpha hull (α = 8°, Buffalo's terrestrial default) around GBIF density-tile cells,
  clipped to land.

It was checked against four species Buffalo published:

| check species | density (ours / Buffalo) | range |
|---|---|---|
| bighorn sheep | −0.01 / 0.07 | 6.74 / 6.65 |
| rhesus macaque | 0.97 / 1.19 | 7.06 / 6.76 |
| blue tit | 3.96 / 2.76 | 7.22 / 6.84 |
| collared flycatcher | 3.91 / 2.70 | 7.40 / 6.46 |

All values are log10. The two mammals agree; the two birds don't. Two reasons:

1. **Bird densities.** Damuth's data contain no birds. Buffalo predicts body mass from body *length*,
   and for a blue tit that chain implies roughly 150 g against a true 11 g. His published bird
   densities are therefore about 1.2 orders of magnitude below what measured mass gives. **This also
   affects his published bird censuses used as primary here:** if anything, they understate $N_c$
   for birds.
2. **Ranges.** GBIF-wide hulls include wintering grounds (flycatcher in Africa), introductions (red
   deer), and occasional vagrants. Hihi is a managed, reintroduced species, so a range-based census is
   meaningless for it.

Making this usable would need either Buffalo's length → mass step, with body lengths sourced per
species, or breeding-range polygons. **Not pursued (2026-10-10):** the length → mass step is the
source of the bird bias, so copying it would reproduce a known error. The finding is kept as a
caveat on Buffalo's published bird censuses instead.

## Known data issues still open

1. **Blue tit coding length (30.5 Mb autosomal) is well above great tit's (25.1 Mb).** It comes from a
   newer RefSeq annotation release, so part of the difference across species reflects annotation, not
   biology. U_d inherits it.
2. **Map lengths below 1 cM are treated as unmapped** (`has_map = FALSE`; decided 2026-10-17). Five
   song sparrow linkage groups report 0–0.2 cM for chromosomes of 3–21 Mb (chr 14, 20, 23, 26, 31),
   which no real map can: every bivalent needs at least one crossover (~50 cM sex-averaged). They
   are sparse-marker artefacts, and left in they made the linked term near-total for those
   chromosomes.
3. **Song sparrow chromosome 25 matches its linkage group at only 0.59 gene share.** Great tit splits
   that chromosome into 25LG1 and 25LG2. Chromosome 31 (LGE22) matches at 0.92. Both are
   microchromosomes.
3. **SV's `mu_direct` (5.35e-9) matches no single Lewin entry.** It is close to a Wang & Obbard
   compilation value for *Mus musculus*.
4. **The red squirrel assembly is 5.7 Gb.** That's genuinely large; its coding density is therefore
   low, but its CDS total (36 Mb autosomal) is typical for a mammal.

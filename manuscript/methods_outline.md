# Materials and Methods — section outline

Target: **nine subsections, 1,600–1,900 words.** The current `manuscript/methods_materials.tex` runs
1,227 words across six subsections, carries five bracketed author-input notes, and has one subsection
that is nothing but a placeholder. Three subsections are new; the rest are revised.

**Placement is settled:** after Theory and Model, before Results — GENETICS' standard order, and the
order `main.tex` already implements.

**The organising rule.** Methods appears before Results, so it must supply, in the order the Results
consume them, every quantity a reader meets there. Two things the current section never establishes
and the Results cannot open without: **which populations are in which analysis** and **what was
actually computed versus what was derived**.

---

## The nine subsections

### M1 — Study populations and analysis sets · NEW · ~180 words

**Why it is first.** The Results report some quantities across nineteen populations and others across
eight, and a reader who meets "median 0.146 across the eight" without warning stops reading. This is
the subsection that prevents that.

**Carries.** The source of the population set. The three-way join on population code — posterior $V_A$
estimates, extra-pair paternity data, chromosome-level assembly and map data — and that its
intersection is eight: RD, BHS, AB, SSH, CSM, GTU, CF, GTN. Which results use nineteen ($V_A$ alone
and the unlinked baseline, which need no maps or annotation) and which use eight (anything requiring
$U_d$, recombination maps, or functional targets). Name the eight explicitly and state that the other
eleven are dropped by the join rather than excluded on any analytical ground.

### M2 — Additive genetic variance in relative fitness · revised · ~200 words

**Carries.** Inclusion criteria for published pedigree animal-model estimates. The posterior
distributions used, and that per-population posterior modes are the point summaries carried forward.

**Resolve the standardisation placeholder — it is answerable now.** The text currently says estimates
"reported on a different scale were standardized prior to analysis [author: describe standardization
procedure]". **No standardisation was required.** Bonnet et al. fitted a zero-inflated over-dispersed
Poisson animal model and back-transformed with $V_A(w) = \mathbf{d}^\top\mathbf{G}\mathbf{d}$, where
$\mathbf{d}$ collects average partial derivatives of mean relative fitness with respect to the logit
and log link predictors. The published values are therefore already observed-scale, mean-standardised
additive variance in relative fitness — Santiago and Caballero's $C^2$, and the currency both engines
require. Say that and delete the placeholder.

**Still needs the author.** The resolution rule where multiple estimates exist for one population.

### M3 — Mating system and extra-pair paternity · revised · ~180 words

**Carries.** The source of $\alpha$ per species. Both $\kappa$ models computed, and **which is primary
in the reported results** — the analysis code implements Model A, so say so and state that Model B is
reported to bracket the assumption.

**Still needs the author, and one of these matters more than it looks.** Whether $\alpha$ is the
proportion of *offspring* or the proportion of *broods containing at least one extra-pair offspring*.
The theory takes the proportion of offspring; the two differ substantially in the passerines that
dominate the set, and any conversion has to be stated. Also: how species lacking a direct $\alpha$
estimate were handled — assumed monogamous, or excluded.

### M4 — Genomic architecture and functional target size · revised · ~250 words

**Carries.** Assembly and annotation sources; restriction to assembled autosomes with an unambiguous
linkage-group correspondence; exclusion of unplaced scaffolds, sex chromosomes and mitochondrial
sequence. The collapse of overlapping CDS intervals into non-redundant ranges, so isoforms do not
inflate the target.

**Resolve the $f_i$ definition — Methods and the analysis disagree.** The current text defines
$\hat f_i = G_i/G_{\text{total}}$ from annotated protein-coding gene counts. The analysis partitions by
**collapsed coding base pairs**, and the Theory section describes $f_i$ as the chromosome's fraction of
total functional sequence. Two of the three agree; the gene-count definition is the outlier. Resolve
toward what was computed, and if the gene-count version is retained as a robustness check, say that it
is one.

**Describe the chromosome-length filter.** The pipeline drops chromosomes below 20 Mb. This is
currently in the code and nowhere in the manuscript, and it excludes precisely the avian
microchromosomes the linked-interference discussion treats as the sensitive regime. Either describe
and justify it, or scope the microchromosome claims to what was actually analysed. **Do not leave it
undocumented.**

**State the conserved-non-coding treatment once.** The code applies taxon-specific multipliers to
inflate coding to functional target; the mutational-parameter subsection takes the regulatory target
as equal to the exome. These are different parameterizations of the same quantity and the manuscript
should carry one, with the other named as a sensitivity analysis.

### M5 — Genetic maps · revised · ~150 words

**Carries.** Published linkage-map sources; use of sex-averaged map lengths and why; assignment of
assembled chromosomes to linkage groups by marker content. The fallback approximation
$M_i = \bar\rho L_i$ for species without per-chromosome map data, and which species it was applied to.

**Still needs the author.** What happens to the variance apportioned to chromosomes excluded for want
of a resolved linkage group — the text says it was redistributed to the unlinked background and asks
the author to verify. Verify it against the code and state it.

### M6 — Numerical evaluation · NEW · ~150 words

**Why it is needed.** The Theory derives an integral; the Results report numbers. Nothing currently
says how one became the other, and a reproducibility-minded referee will ask.

**Carries.** That the chromosome-averaged interference is evaluated **numerically under the Haldane
mapping function** for every chromosome, with the closed form of Appendix C used only as a check on
the numerics. **This resolves a live contradiction:** the Theory section argues for numerical Haldane
and against the linear approximation, while the current Methods describes closed-form expressions
under the linear approximation. Both cannot describe what was run; the code does numerical Haldane.

Also: the cap applied to the survival parameter to avoid the singularity at perfect
mutation–selection balance; the software and version; and where the analysis code is deposited.

### M7 — Mutational parameters and the implied selection coefficient · revised · ~200 words

**Carries.** Per-species per-base-pair mutation rates with their published intervals.
$U_d = 4\mu L_{\text{coding}}$, with the factor of four accounted for as $2\mu$ for a diploid rate and a
further doubling for a regulatory target taken equal to the exome — cross-referenced to M4 so the two
treatments of functional target do not read as unrelated.

**Resolve the direction of $s$ — the text and the analysis currently disagree outright.** The Methods
state that no point estimate of $s$ is fixed and that $s^{*}$ is inferred by inverting the equilibrium
relation across the joint intervals of $V_A$ and $\mu$. The analysis code **hardcodes a heterozygous
coefficient of 0.01**, with a small sensitivity grid. These are opposite logical directions. Establish
which produced the reported numbers and describe that; if both were run, say which is primary and
which is the sensitivity analysis.

**Keep the logical-direction paragraph.** $s^{*}$ is a consequence inferred from a reported variance,
not an estimate of selection fitted to any data, so comparing it against published DFE estimates tests
whether the reported variance can be maintained rather than calibrating the model. That sentence is
the section's best and should survive intact.

### M8 — Observed nucleotide diversity and census size · **[DATA-BLOCKED]** · ~250 words

**The one subsection that cannot be completed.** It is currently a bracketed note and nothing else.

**Carries, when the data exist.** The source of $\pi$ per population; the genomic compartment it is
estimated from — fourfold-degenerate, synonymous, intergenic or genome-wide; and the source and
instrument of the census.

**Two things to write into the structure now, because they are decisions rather than data.**

1. **The comparison runs in $\pi$ units, not $\delta$ units:**
   $\pi_{\text{pred}} = 4\mu N/(1+4\kappa V_A)$ against $\pi_{\text{obs}}$. Algebraically identical to
   comparing $\delta$ with $1/(1+4\kappa V_A)$, but $\pi_{\text{obs}}$ is a measurement whereas $\delta$
   is a composite of three quantities, two of them uncertain. $\delta$ remains the natural axis for the
   ceiling curve.
2. **The census instrument is recorded per population**, and a long-term or historical census scaled by
   a breeder fraction is preferred over a contemporary density-times-range estimate. $\pi/(4\mu)$ is a
   long-run coalescent quantity and every available census is contemporary; that mismatch is the
   substantive methodological objection this paper will face, and pre-empting it in Methods is cheaper
   than defending it in the Discussion.

**Carries the bias-direction table**, cross-referenced from the Discussion: coalescent size exceeding
the contemporary census, cryptic immigration, total census rather than breeding adults, background
selection at the sites used for $\pi$, and mutation-rate error — each with the direction it pushes the
apparent gap, and the statement that none of them closes it.

**Write the structure with `[PI_OBS]`, `[N_BREED]`, `[DELTA]` placeholders and invent no magnitude.**

### M9 — Independence of the inputs from diversity data · NEW · ~120 words

**Carries.** $V_A$ from pedigrees, $\alpha$ from molecular parentage, $M_i$ from linkage maps, $f_i$
from genome annotation, $\mu$ from mutation-rate studies. Five bodies of data, none of them observed
diversity, so the prediction meets diversity only at the final comparison.

**Register matters here.** State it as a property of the design in a few flat sentences. It is a
genuine methodological strength and it is **not** the reason the paper matters; the settled framing is
explicit that this argument was demoted from thesis to Methods note. Do not use the word *circular*,
and do not position the design against diversity-calibrated estimates of linked selection.

---

## Decisions the author owns before drafting

| # | decision | blocks |
|---|---|---|
| 1 | Resolution rule where a population has multiple published $V_A$ estimates | M2 |
| 2 | Is $\alpha$ the proportion of offspring or of broods? Any conversion applied? | M3 |
| 3 | How were species without a direct $\alpha$ estimate handled? | M3 |
| 4 | Which $\kappa$ model is primary in the reported numbers — A or B? | M3, and every reported magnitude |
| 5 | $f_i$ by collapsed coding bp or by gene count? Which produced the reported results? | M4 |
| 6 | Describe and justify the 20 Mb chromosome filter, or scope the microchromosome claims | M4, and the Discussion |
| 7 | One conserved-non-coding treatment as primary; the other as sensitivity | M4, M7 |
| 8 | Was variance from map-excluded chromosomes redistributed to the unlinked background? | M5 |
| 9 | Was $s$ inferred by inversion, or fixed at 0.01? Which produced the reported numbers? | M7, and the whole maintenance comparison |
| 10 | Where is the analysis code deposited, and under what identifier? | M6, and GENETICS' data-availability requirement |
| 11 | $\pi_{\text{obs}}$ and a breeding-adult census $N$ | M8 — the only true data blocker |

Items 5, 6 and 9 are the ones that change reported numbers rather than only prose. Item 9 is the
sharpest: the manuscript and the code currently implement opposite logical directions.

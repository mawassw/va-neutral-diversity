# Open items register

Every error and unanswered question raised during the redraft, as of 2026-09-03. Errors are defects
in existing files; questions need an author decision. **Nothing here has been applied.** Items marked
`BLOCKS` prevent specific drafting work from starting.

All of E1–E10 belong in CLAUDE.md's *Known staleness & inconsistencies (Rule 5)* log at the next
sign-off; E1 and E2 are new findings of 2026-09-03 and are not recorded anywhere else.

---

## Errors in existing files

| # | item | where | status |
|---|---|---|---|
| E1 | **Jensen direction stated backwards.** The derivation is right: the uniform density yields the *lower* $N_e/N$, i.e. the larger reduction. The summary says uniform "minimizes local interference … and yields an upper bound on $N_e/N$" — wrong twice. Under the settled claim the correct direction is favourable: the spatial assumption is the one most generous to the mechanism. | `scratch.tex:317`; also `:23`, moot once the Introduction lands | **new 2026-09-03** |
| E2 | **Mutation–selection–drift balance has no main-text presence.** It exists only as Appendix D, though it carries one of the paper's two comparisons. | §Theory | **new 2026-09-03**; T8 fixes it |
| E3 | **RESOLVED 2026-09-03 (author + Buffalo and Kern supplement).** $v_i$ is the selective variance of a **diploid** chromosome; only the focal **haplotype's** share stays associated with the tracked neutral allele, so the linked exponent takes $v_i/2$. Buffalo and Kern (2024) supplementary text: "only half the fitness variation in a diploid can stay associated with the neutral allele through the generations", and they denote the haplotype variance $V_h$. **Fix:** give the haplotype variance its own symbol ($v_h$) in T4 and supply $v_h = v_i/2$, $v_i = V_A f_i$ in T5, so the halving is never an unexplained factor. Note also that Buffalo and Kern *neglect* the homologous ($Q''$) associations, whereas this model reassigns that variance to the unlinked background — state as a modelling choice. | `scratch.tex:113` vs `:149` | **resolved, not yet applied** |
| E4 | **$\overline{Q^2}$ method contradiction.** §Theory says numerical Haldane and argues against the linear approximation; §Methods describes closed-form linear expressions. Both cannot describe what was run. Resolve toward numerical Haldane. | §Theory vs §Methods | `BLOCKS` T4 |
| E5 | **Appendix cross-reference.** §Theory points to Appendix A for the closed-form linear limit; it is in Appendix C. Appendix A is the unlinked baseline. | §Theory | trivial |
| E6 | **Reported $V_A$ range wrong.** States $V_A \in [0.10, 0.30]$; posterior modes are 0.0029–0.4963, median 0.0997. | `scratch.tex:309` | not fixed |
| E7 | **Standardisation placeholder is answerable.** No standardisation was required — Bonnet et al. report observed-scale $V_A(w)$ via $\mathbf{d}^\top\mathbf{G}\mathbf{d}$. Say so and delete it. | `scratch.tex:235` | not fixed |
| E8 | **Appendix D `[XX]` placeholders are computable now.** $U_d$ = 0.69–1.19 (median 1.07); $s^*$ = 0.019–0.313 (median 0.145), or 0.092 at the upper CI on $\mu$. | Appendix D | not fixed |
| E9 | **The 20 Mb macrochromosome filter is undescribed in Methods** and excludes precisely the avian microchromosomes the Discussion leans on. Either describe and justify it, or scope those claims to macrochromosomes. | code vs §Methods | not fixed |
| E10 | **RESOLVED 2026-09-06 (author).** No contradiction: $s^{*}$ *is* inferred by inversion for the maintenance comparison. The hardcoded `s_het = 0.01` belongs to separate blocks exploring the $Z$ and $Q$ parameter space, taken from a Kim et al. DFE, and does not feed the maintenance result. **The code redraft must keep the two uses visibly separate and label them.** | `data_gen.R` | **resolved** |
| E11 | **The 136/27/14 factors are computed against the eight-population median $V_A$ = 0.146**, not the nineteen-population median 0.0997. Against 0.0997 they are 93/19/9. Name the set wherever they appear. | Results R5 as briefed | flagged before drafting |
| E12 | **The four-branch disjunction and the branch-(i) mechanisms sit in §Theory**, pre-empting the Discussion. | `scratch.tex` §Upper Bound | T7 removes them |
| E13 | **Title asserts the retired claim** — "predicts severe depletion of neutral diversity". | `scratch.tex:9` | not fixed |
| E14 | **Discussion carries retired claims throughout** — "violate that limit", "exceeds $V_{A,\max}$", "two to three orders of magnitude". | `scratch.tex:288–321` | briefed, not drafted |
| E15 | **Results is one subsection long and reports no numbers.** It is a build, not a redraft. | `scratch.tex:276–286` | briefed, not drafted |
| E16 | **No figure is wired into any `.tex` file**, and the payoff figure (the two thresholds with the posteriors between them) does not exist. | `main/`, `scratch.tex` | not built |

---

## Questions needing an author decision

| # | question | why it matters | status |
|---|---|---|---|
| Q1 | **Does the analysis use annotated gene positions *within* chromosomes, or only the between-chromosome partition $f_i$?** | If only $f_i$, T6's empirical-density paragraph collapses to one sentence in T9. | `BLOCKS` T6 |
| Q2 | **$\pi_{\text{obs}}$ and a breeding-adult census $N$.** Still absent from the repo. | The only blocking unknown for the per-population diversity test. | open |
| Q3 | **Preprint scope.** Commit now to a preprint without per-population $\pi$ and $N$ — diversity side stated as the mechanism's ceiling against literature-reported deficits — or hold for the data? | Determines whether the end-of-month target is safe. Changes Results, not the Introduction. | open, time-sensitive |
| Q4 | **Which $\kappa$ model is primary** in the reported results, A or B? The code implements Model A. | T3 and every reported magnitude. | open |
| Q5 | **Which `main/` TIFF fills which figure slot.** Several `Theoretical_*.tiff` have no current producer, and both `SuppFig3.tiff` and `SuppFig3_Va_Deflation_Analysis.tiff` exist. Rule 8 says ask rather than guess. | Figure captions and `\includegraphics` at backport. | open |
| Q6 | **The verdict clause in the Introduction's final paragraph** — read as omitted, per directive v3. Confirm, or insert the labelled alternative. | One sentence. | assumed resolved |
| Q7 | **Were the P3 fixes carried into the final Introduction** — lifetime *breeding* success, two exemplar systems not three, Ram Mountain rather than "Alberta" bighorn, "composite lifetime measure" rather than "fitness itself"? | They were instructions in directive v3, not verified in output. | verify against final text |
---

## Theory subsections as drafted

Notes on T1 and T2 as they now stand in `scratch.tex` (committed at `68b19ad`). Both are accepted;
these are items for the whole-section pass.

| # | item | where | status |
|---|---|---|---|
| T-1 | **`\autoref{sec:linkage}` is a dangling reference.** T2's closing sentence forward-references it, but no `\label{sec:...}` exists anywhere in the file. It will compile to `??`. Add `\label{sec:linkage}` to the linked-constraint subsection. | `scratch.tex:61` | trivial, confirmed |
| T-2 | **"an invariant, parameter-sparse ceiling on the effective population size"** — the sense is right but the wording inverts. The equation gives the *most permissive* $N_e/N$ the model allows, since linkage only lowers it; "ceiling on the effective population size" reads as though $N_e$ could not exceed it for other reasons. Prefer "the most permissive case" or "an upper bound on retained diversity". Same distinction E1 turns on. | `scratch.tex:61` | wording |
| T-3 | **$I_A \equiv C^2$ is now asserted in both T1 and T2.** Consistent, but $I_A$ (Houle 1992) sits adjacent to the opportunity-for-selection argument that the settled framing struck. Decide once whether the $I_A$ equivalence stays as a named identity or whether $C^2$ alone carries it, and state it in one place only. | `scratch.tex:34`, `:59` | decision |
| T-4 | **Sweeps handled by a time-averaged $\bar V_A$** — an addition beyond the T2 spec, and a real refinement: it lets the unlinked baseline cover directional sweeps without stationarity. Confirm $\bar V_A$ is either used consistently downstream or explicitly confined to that clause, since no other subsection defines it. | `scratch.tex:61` | verify |
| T-5 | **T1 derives $Q^2 = 4$**, so T4 must not re-derive it, and T1's displayed equation needs a label if later subsections reference it. | `scratch.tex:41–43` | cohesion |
| T-6 | **T1's ">85\% achieved within two generations"** is 75% for two terms ($t = 0,1$) and 87.5% for three. Fix the phrasing or the figure. | `scratch.tex:44` | arithmetic |
| T-7 | **`ne_sexes` was changed to $N_e = 8N/(V_{km}+V_{kf}+2\,\mathrm{Cov}(k_m,k_f))$, and Appendix B uses neither this nor the form it replaced.** Appendix B derives $\kappa$ by summing the female and male *selective variance* components and factoring out $V_A$ — it never goes through a pooled-gametic-variance expression. The new form also disagrees with the previous $4N/(V_{km}+V_{kf})$ by a factor of two at $\mathrm{Cov} = 0$. It is attributed to Hill (1979) and Caballero (1994), so it must either be verified against those sources or dropped in favour of stating the covariance mechanism verbally. **This is the second unresolved factor of two in the manuscript** (see E3). | `scratch.tex:66` | **verify or drop** |
| T-8 | **"doubling the coefficient on $V_A$ relative to the panmictic baseline ($1+8V_A$)"** mislabels the parenthetical. The panmictic baseline is $\kappa = 1$, giving $1+4V_A$; $1+8V_A$ is the monogamous case being compared *to* it. | `scratch.tex:88` | error |
| T-9 | **"$V_A$ is the sex-specific additive genetic variance in relative fitness"** contradicts T1, which defines $V_A$ as the population-level mean-standardized additive variance, and contradicts what Bonnet et al. report. If $\kappa V_A$ takes a sex-specific quantity the equation takes a different input from `unlinked_baseline`. Almost certainly a loose word, but it changes what the equation consumes. | `scratch.tex:74` | error |
| T-10 | **"$\alpha \lesssim 0.2$" for the avian pedigrees needs a citation**, and should be checked against `data/species_EPP.csv` rather than asserted. | `scratch.tex:88` | citation |
| T-11 | **T3 is ~400 words against a 220–260 budget.** Acceptable if the Model B minimum is wanted in the main text, but the section total is being watched; the exemplar's whole Theory runs ~2,500. Also "a dioecious population with separate sexes" is redundant. | `scratch.tex:63–88` | budget |

---

## Modelling decisions worth preserving

Not errors and not open questions — deliberate choices that a reader, a referee, or a future session
could mistake for oversights. Each needs to survive into the manuscript at the point of use.

### M-1 · The homologous ($Q''$) associations are reassigned, not neglected

**The distinction.** Buffalo and Kern (2024) take the linked reduction over the haplotype variance
$V_h$ and state the reason directly in their supplement: "the factor of 1/2 is due to the fact that we
are ignoring the chance that the fitness background on the homologous chromosome recombines onto the
haplotype with the tracked neutral allele (i.e. due to the $Q''_t$ associations). In other words, only
half the fitness variation in a diploid can stay associated with the neutral allele through the
generations." They also note that when linkage is tight the dropped term "can be ignored as we will do
here, though it does impact background levels of neutral diversity (Santiago and Caballero 1995)."

**What this model does instead.** The homologous haplotype's share of the chromosome's selective
variance is not discarded. It is reassigned to the unlinked background, where it enters the Robertson
denominator alongside every other independently assorting locus — which is precisely the term Buffalo
and Kern identify as the one their approximation neglects. Hence `total_red`'s structure: an
exponential linked term in $v_h = v_i/2$ over a denominator carrying $V_A - v_i/2$.

**Why it is worth stating.** Without it, the $v_i/2$ in the exponent and the $V_A - v_i/2$ in the
denominator look like two unrelated adjustments; with it they are one partition of a single diploid
chromosome's variance, and nothing is dropped. It also makes the treatment marginally more complete
than the closest prior work at the point where that work says its approximation loses something.

**How to state it.** As a modelling choice, in one sentence, at the point of use in T4 with the
partition supplied in T5. **Not** as a claim of superiority over Buffalo and Kern, and not in the
Introduction or Abstract — it is a difference in bookkeeping, not a result, and inflating it is the
borrowed-significance failure mode `CLAUDE.md` warns about.

---

## Diversity data — coverage assessment, 2026-09-06

`data/lewin_eyre_walker_2026_data.xlsx` (Lewin and Eyre-Walker 2026) arrived. STable1 carries
`mean_pi`, a mutation rate with 95% bounds, and an $N_e$ for 131 species. STable5 carries
density × range census figures for 90 species, Buffalo-2021 style.

**Coverage against this project's populations is thin, and this is decisive for scope.**

| status | populations | species |
|---|---|---|
| exact species match with $\pi$ | BTR, BTP, BTM, CF, CSM | *Cyanistes caeruleus*, *Ficedula albicollis*, *Macaca mulatta* |
| congener or subspecies proxy only | RD, AB | *Cervus elaphus yarkandensis*; *Papio anubis* for our *P. cynocephalus* |
| absent from the workbook entirely | SSH, BHS, GTU, GTN, SV, NH, SFW, SSP, HT, HK, KS, MK | no *Ovis*, no *Parus*, no *Chionomys*, *Crocuta*, *Malurus*, *Melospiza*, *Notiomystis*, *Sciurus*/*Tamiasciurus*, *Suricata* |

**Against the eight-population linked-analysis set (RD, BHS, AB, SSH, CSM, GTU, CF, GTN): two exact
matches, two proxies, four absent.** Soay sheep, bighorn sheep and both great tit populations — four of
the eight — have no diversity estimate in this source. Great tit and Soay sheep are among the
best-studied vertebrate populations in the world, so their absence is a property of this compilation
rather than of the literature; other sources may cover them.

**Consequences.**

1. **A per-population $\pi_{\text{pred}}$ versus $\pi_{\text{obs}}$ test cannot carry the diversity
   side.** Two to four populations is not a comparative result.
2. **Q3 is effectively decided.** The diversity side is stated as the ceiling curve
   $V_{A,\max}(\delta)$ plus what the mechanism can remove at measured $V_A$, benchmarked against the
   deficit range the comparative literature reports. The per-population test becomes an illustration
   on whichever populations have data, not the result.
3. **The census problem is unchanged.** STable5's density × range figures are contemporary, which
   scope condition 4 explicitly deprioritises in favour of a long-term or historical census scaled by
   a breeder fraction.
4. **Worth one search before settling:** whether *Parus major* and *Ovis aries* diversity estimates
   exist elsewhere. Both are heavily sequenced and their absence here is surprising.

### M-2 · Nucleotide diversity compartment: genome-wide autosomal averages are acceptable

**Decided 2026-09-06**, from Lewin and Eyre-Walker (2026) directly.

**What their compilation does.** Of 131 species, the primary diversity estimate is genome-wide for 81,
4-fold degenerate for 16, synonymous for 15, silent for 4, unspecified for 9, and non-coding,
intergenic, neutral or heterozygosity for the remaining 6. Genome-wide is the modal choice by a wide
margin, and their sources are Leffler et al. (2012), Romiguier et al. (2014), Corbett-Detig et al.
(2015), Chen et al. (2017), Buffalo (2021) and the wider literature.

**Their justification, which is empirical rather than assumed.** "We find no significant difference
between genome-wide and synonymous site estimates in those species for which we have both (22 species;
geometric means of 0.0066 (genome-wide) and 0.0079 (synonymous))." Genome-wide therefore runs at about
84% of synonymous — a factor of 1.2.

**Why that is immaterial here.** The mechanism removes at most ~20-fold and the deficits under
discussion are $10^2$–$10^6$. A 20% compartment effect cannot move a conclusion at those magnitudes.

**What to do.**

1. Use whole-genome **autosomal** averages, matching both the source compilation and the model's
   autosome-only restriction. Mixing compartments across populations is acceptable; cite their
   equivalence test for it.
2. **Record the compartment per population** in the Methods table.
3. State the direction once: genome-wide $\pi$ includes constrained sites, so it sits below neutral
   $\pi$, lowering $\delta$ and widening the apparent deficit — the direction that flatters this
   paper's conclusion. Already a row in the bias table.
4. One clause acknowledging that $\pi_{\text{pred}}$ is a neutral prediction while genome-wide
   $\pi_{\text{obs}}$ is mildly depressed by selection at constrained sites. Same 20%, same
   immateriality, better stated than discovered.
5. **Do not pool per-individual "genome-wide heterozygosity" entries** with population $\pi$; two
   species in the compilation use that statistic and it is not the same quantity.

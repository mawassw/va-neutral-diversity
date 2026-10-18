# CLAUDE.md — project#3

This directory holds a theory + comparative-empirical manuscript in evolutionary genetics targeting
**GENETICS (GSA)**. It takes additive genetic variance in relative fitness ($V_A$) measured in wild
pedigrees and puts it through two independent equilibrium comparisons: propagated to neutral diversity
it is **too small** to explain the deficit these populations show, and set against
mutation–selection–drift balance it is **too large** to be maintained. See **Project framing** below —
that section governs, it is the *whole* framing, and it is **ahead of** `scratch.tex`'s current
Introduction (Rule 10).

The output is a set of publication TIFFs and summary CSVs, not a library or application: there is no
build system, no test suite, no package structure. The conventions below are enforced — follow them
when adding code, data, or figures.

## Project framing — SETTLED 2026-08-26. This is the whole framing; there is no other.

**On 2026-08-26 every earlier framing was deleted from this file**: the 2026-07-29 circularity framing,
the 2026-08-04 "anchor is variation in fitness" chain, and amendments F3 through F9c. They are
recoverable from git (`git log -p -- CLAUDE.md`) and from the tags `archive/prose-edit-scratch`,
`archive/f3-reframe-intro-discussion`, `archive/f3-structural-blueprint`. **Do not reconstruct them.**
If a claim is not in this section, it is not a claim of this paper.

### The claim

> **The additive genetic variance in fitness measured in wild pedigrees is too small to explain the
> neutral diversity these populations are missing, and too large to be maintained at
> mutation–selection–drift balance.**

That is the paper. One measured quantity, two equilibrium comparisons, opposite verdicts.

**How the background is organised (user, 2026-10-16).** The work is about the **effect** and the
**maintenance** of heritable variation in fitness, and the Introduction presents one literature for
each. Both tests have precedents. For the effect side these are Buffalo & Kern 2024 (humans) and
Buffalo & Coop 2019/2020 (*Drosophila*). For maintenance it is Charlesworth 2015 (*Drosophila*).
The originality has two parts. First, the same tests are applied to wild vertebrates with directly
measured total-fitness $V_A$. Second, the analysis centres on how a pedigree snapshot must be scaled,
$c = \bar V_A/\hat V_A$, to fit each model. Buffalo 2021 is comparative and about linked selection,
so it stays a locating citation for the deficit. Plan: `manuscript/INTRO_REDRAFT_PLAN.md`.
**Introduction rules (user, 2026-10-16):** before its last paragraph, the Introduction shows only
published derivations and results, and none of ours (no κ, $V_{A,\max}$, $s^*$, $c$). This paper's
results appear only in the last paragraph, GENETICS-style. Each background paragraph ends on the gap
it leaves for wild vertebrates. **Title (2026-10-16):** *Heritable variance in fitness in wild
vertebrates is too small to explain their missing neutral diversity and too large for
mutation–selection balance.* **Connallon & Czuppon 2026 is now verified** (*Evolution* 80:926). It
makes no quantitative comparison of Bonnet's $V_A$ with $U_ds$, so the vertebrate MSD shortfall had
been argued, not computed.

### Why it holds together

Three properties, and all three must survive any edit to the framing:

1. **Both comparisons target the same quantity** — the long-run equilibrium additive variance in
   relative fitness, $\bar w = 1$. Santiago–Caballero needs it sustained over $\sim 4N_e$ generations;
   mutation–selection–drift balance is a standing-variance-at-equilibrium statement. Same currency,
   same timescale class, so the two verdicts are commensurable.
2. **No single bias in the estimate reconciles both.** If measured $V_A$ is inflated, the MSD
   discrepancy shrinks and the diversity discrepancy grows; if it is underestimated, the reverse. The
   two move in opposite directions under any rescaling of $V_A$. **This is the paper's spine** — it is
   what makes the result robust to the standard criticism of pedigree $V_A$ (that the animal model
   absorbs environmental covariance among relatives).
3. **The two ends do not meet.** Accounting for a hundredfold diversity deficit needs
   $V_A \gtrsim 12$ at $\kappa = 2$ ($\gtrsim 25$ at $\kappa = 1$); MSD compatibility needs $V_A \lesssim 10^{-2}$. **No value satisfies both.** So the
   gap exists in the model independently of the measurement, and the measurement locates where reality
   sits inside it: one to two orders above the MSD end, and far short of the diversity end.
   **Wording decided 2026-10-14:** those 12–25 are the $G = 1$ formula extrapolated beyond its domain
   ($V_A \ll 1$), so the paper states the diversity end as *"no $V_A$ inside the formula's domain
   produces a hundredfold deficit; over the measured range the unlinked term gives 1.7× at the median
   and about 4.5× at the maximum"*. With $G = 1 - V_A$ (Appendix A), no $V_A < 1$ gives more than
   2× (3× under strict monogamy). The 12–25 may appear only labelled as the $G = 1$ extrapolation.
   **Present the snapshot problem through $c = \bar V_A/\hat V_A$** (Fig. 2): the diversity side needs
   $c \gtrsim 10^4$ on average, MSD needs $c \lesssim 0.07$, and no single $c$ satisfies both. The
   question is the relationship between the estimate and the long-run value, not either number alone.
   **D2:** because $N/N_e$ is linear in $V_A$ and $\pi$ reflects a harmonic-mean $N_e$ over $\sim 4N_e$
   generations, the target is exactly the time-averaged $\bar V_A$ over the coalescent window. Make
   that perspective evident to the reader. **Make explicit that the stationarity of $V_A$ the
   diversity side assumes is exactly what the MSD side tests.**

**Fisher's theorem is not part of the claim.** FTNS is single-generation — the partial change in mean
fitness attributable to selection equals $V_A/\bar w$ per generation (`scratch.tex` line 15 states it
correctly). It is satisfied by an instantaneous $V_A$ and requires no persistence, so it cannot referee
between two equilibrium comparisons. It is also escapable: mean fitness can stay flat while a real
directional $V_A$ is present, because Fisher's own deterioration-of-environment term absorbs the
increase. The diversity consequence is not escapable that way — the allele-frequency change still
happens and diversity still pays. **That asymmetry is the significance argument**, and it is why FTNS
appears in the Discussion as an interpretive point and never as a premise.

### The two comparisons, with the numbers in hand

**Diversity side — measured $V_A$ is too weak.** Unlinked, $N_e/N = 1/(1+4\kappa V_A)$ is *linear* in
$N_e$ and therefore caps the whole effect; there is no compounding over generations once at
equilibrium. From the 19 posterior modes in `alldistzip`, at the primary Model B $\kappa$ (κ = 1 without
a pair bond, $\kappa_B$ = 1.22–1.93 for the 11 socially monogamous populations; re-derived and
recomputed 2026-10-14 from `data/processed/`, columns `reduction_G1`, `reduction_Gsym`):

```
Va posterior modes, n = 19:  min 0.0029  Q1 0.0172  median 0.0997  Q3 0.2484  max 0.4970
  reduction 1 + 4 kappa Va, G = 1:      median 1.67x, max 4.48x (blue tit, Muro); upper 95% HPD 5.9x
  same with G = 1 - Va (sensitivity):   median 1.54x, max 2.59x;                  upper 95% HPD 2.75x
  (superseded 2026-10-13 values at kappa = 2 for non-monogamous: median 1.69x, max 4.58x hyena)
adding the linked term (Omega 0.1-0.85, computed at kappa = 1, macro only): ~20x -- TO RECOMPUTE
```

Observed deficits $1/\delta$, for the 9 populations with $\pi$ and a Buffalo $N_c$ (6 independent
species; 4 of the 9 use literature $\pi$ from another population, `data/pi_literature.csv`):
**230× to 38,000×**, so $V_{A,\max}$ = 29 to 6,000 against measured $V_A \le 0.5$.

**MSD side — measured $V_A$ is too large.** `scratch.tex` Appendix D (lines 616–698) derives this
correctly and labels the pieces: influx $V_m = U_d s^2$; standing variance
$V_A = 2N_eU_ds^2/(1+2N_es)$; strong-selection limit $V_A \approx U_d s$, hence $s^* = V_A/U_d$.
Computed 2026-08-26 from `data/species_EPP.csv` and summed `L_coding_bp` with the Methods' own
$U_d = 4\mu L_{\text{coding}}$:

```
U_d  = 0.69 - 1.19   (median 1.07)
s*   = 0.019 - 0.313 (median 0.145);  at the upper 95% CI on mu, median 0.092
  against vertebrate DFE mean heterozygous s ~ 1e-3 to 1e-2
read forward, V_A(MSD) = U_d*s:   s = 1e-3 / 5e-3 / 1e-2
  measured V_A is larger by        136x /   27x /  14x
```

**Superseded 2026-10-13** by the data layer (18 populations, autosomal $L_{\text{coding}}$, both μ):

```
U_d (direct mu) 0.34 - 1.26;  (phylo mu) 0.49 - 1.35
s* = V_A/U_d, direct mu: 0.006 - 0.78, median 0.16  (phylo: median 0.12)
P(s* > 0.01) > 0.89 in 17 of 18 posteriors (snow vole 0.71); P(s* > 0.001) > 0.96 in all 18
measured V_A / (U_d s), median:  s = 1e-3 / 5e-3 / 1e-2  ->  160x / 32x / 16x
2 N_e s* (N_e = pi/4mu, where pi exists) = 9,400 - 390,000: the strong-selection limit holds
```

**Both sides are in the same units and need no conversion.** Bonnet et al. 2022 fitted a zero-inflated
over-dispersed Poisson animal model (logit zero-inflation $l_1$, log conditional-Poisson $l_2$) to raw
`LBS`, then back-transformed with $V_A(w) = \mathbf{d}^\top\mathbf{G}\mathbf{d}$, where $\mathbf{d}$ is
the vector of average partial derivatives of mean **relative** fitness with respect to the two link
predictors. So the reported number is an observed-data-scale, mean-standardised additive variance in
relative fitness — exactly Santiago–Caballero's $C^2$ and exactly Appendix D's currency. **There is
nothing to rescale.** This also explains why `alldistzip` carries one scalar per component per draw
rather than a 2×2 link-scale $\mathbf{G}$: those posteriors are post-back-transformation.

### Scope conditions — these must appear in the manuscript, at the point of use

1. **$N_e/N = 1/(1 + Q^2 V_A)$ is exact, conditional on $V_A$ being the long-term equilibrium additive
   variance in relative fitness.** Say "exact under long-term equilibrium" where the equation is
   introduced, name the quantity it needs, and say what breaks otherwise. Observed at MWPG 2026 to be
   the one thing a competent reader could not infer from the poster.
2. **Bonnet's $V_A(w)$ is single-generation and environment-conditional by construction.** $\mathbf{d}$
   is an average partial derivative *evaluated at the observed population state* — integrated over the
   posterior for those cohorts, that environment, that mean fitness. Hold $\mathbf{G}$ fixed, change
   the environment, and $V_A(w)$ changes. Robertson's secondary theorem, which their bound rests on, is
   likewise single-generation. **The mismatch with the long-run quantity is visible in the definition
   of the estimator, not inferred from suspicion about bias.** State it that way; it is not a criticism
   of Bonnet et al., it is what their estimator is for.
3. **Two persistence windows, kept distinct.** $Q = 2$ needs the sign of the selective advantage to
   persist only ~2 generations, so the unlinked baseline applies under MSD balance, sweeps *and*
   fluctuating selection (`scratch.tex` line 40 is right). $\pi$ reaching a new equilibrium needs
   $\sim 4N_e$ generations, which is why the target quantity is the long-term equilibrium $V_A$.
4. **Census timescale mismatch** (raised by a faculty visitor at MWPG 2026; the only substantive
   methodological objection of the session). $\pi/(4\mu)$ is long-run coalescent; every available
   census $N$ is contemporary. **Prefer a long-term or historical census scaled by a breeder fraction
   over a Buffalo-style density × range estimate**, and record the instrument per population.
5. **Non-equilibrium populations are excluded, not explained.** Since
   $V_{A,\max} = (1-\delta)/(4\kappa\delta)$, any $\delta \ge 1$ gives $V_{A,\max} \le 0$: that is a
   failed model check, not a strong result. Report the trichotomy openly — uninformative
   ($\delta \ge 1$), violation, consistent — and say how many fell out.

**Bias directions, for the Methods table.**

| effect | on $\pi_{\text{obs}}$ | on $\delta$ | on the apparent diversity gap |
|---|---|---|---|
| $N_{eC}$ > contemporary $N$ (bottleneck, fragmentation) | ↑ | ↑ | narrows |
| cryptic immigration into the study area | ↑ | ↑ | narrows |
| census timescale mismatch (contemporary $N$ for a long-run $\pi$) | — | ∓ | either way; state the instrument |
| using total census $N_c$ rather than breeding adults (factor 2–10) | — | ↓ | widens |
| Buffalo's bird $N_c$: density from length-predicted mass (blue tit ~150 g vs 11 g), ~1.2 orders low | — | ↑ | narrows |
| background selection at the "neutral" sites used for $\pi$ | ↓ | ↓ | widens |
| $\mu$ misestimated | — | ∓ | either way; does not close the gap |

### Notation — use this without exception

| symbol | meaning | status |
|---|---|---|
| $N$ | number of **breeding adults** — the $N$ in Robertson / Santiago–Caballero | missing |
| $N_c$ | **total census size** (density × range, Buffalo 2021) | available for some species |
| $\pi$ | observed neutral autosomal nucleotide diversity | missing (Lewin & Eyre-Walker 2026) |
| $\mu$ | per-site per-generation mutation rate | ✅ `data/species_EPP.csv`, with 95% CI |
| $N_{eV}$ | **variance** effective size, per generation | model-side |
| $N_{eC}$ | **coalescent** effective size, what $\pi$ measures: $\pi = 4N_{eC}\mu$ | data-side |
| $\delta$ | $\pi_{\text{obs}}/(4\mu N)$ — **derived, not measured** | blocked on $\pi$ and $N$ |
| $V_A$ | additive variance in **relative** fitness, $\bar w = 1$ (S–C's $C^2$) | ✅ 19 posterior modes |
| $\kappa$ | mating-system scalar: 1 without a pair bond, $\kappa_B \in [9/8, 2]$ under social monogamy | ✅ from EPP |
| $G$ | fraction of additive variance surviving selection per generation; 1 in primary results | Appendix A |
| $r_{mf}$ | correlation of mates' breeding values (SC's $r$); 0 in primary results | Appendix A, B |

**Present effective-size results as $N_e/N$, never $N/N_e$ (user, 2026-10-16; field convention).**
Write $N_e/N = 1/(1 + 4\kappa V_A)$, not "$N/N_e = 1 + 4\kappa V_A$", and state bounds in that form:
"$N_e/N$ never falls below 1/2", not "the reduction never exceeds 2". "A twofold reduction" is fine as
prose. Applied throughout the manuscript and the Overleaf section files on 2026-10-16. The R columns
`reduction_G1`/`reduction_Gsym` are $N/N_e$ internally, so convert before quoting them.

Two distinct ratios are both called "$N_e/N$" and the project has slid between them before. The
**demographic** $N_{eV}/N$ (family-size variance, sex ratio) is 0.1–0.5. The **diversity**
$(\pi/4\mu)/N_c$ is $10^{-2}$–$10^{-5}$. **Every sentence containing "$N_e/N$" must say which.**
$\delta$ is the diversity one — `scratch.tex` fixes this and it is not a modelling choice.

Report the per-population test in $\pi$ units, not $\delta$ units: $\pi_{\text{pred}} =
4\mu N/(1+4\kappa V_A)$ against $\pi_{\text{obs}}$. Algebraically identical to $\delta$ vs
$1/(1+4\kappa V_A)$, but $\pi_{\text{obs}}$ is a measurement whereas $\delta$ is a composite of three
quantities, two uncertain. $\delta$ stays legitimate as the *x*-axis of the $V_{A,\max}(\delta)$ curve.

### Supporting results — real, and not the identity

These are the paper's machinery and its side-products. Each earns a section; none is the reason the
paper exists, and none should appear in the title or the first paragraph of the abstract.

- **$V_{A,\max}(\delta) = (1-\delta)/(4\kappa\delta)$** — the most reusable object in the paper:
  anyone with a diversity estimate reads their own ceiling off it, and any future sequence-based
  estimate of fitness variance has to come in under it. Publish it as a curve, not a defended point
  estimate. **Report honestly that it is not currently exceeded**: 0 of 19 populations at
  $\delta \le 0.3$, 5 of 19 at $\delta = 0.5$, 13 of 19 at $\delta = 0.9$ (those counts are at κ = 1).
  **Recomputed 2026-10-14 at the primary κ:** 0 of 19 at δ ≤ 0.2, 2 of 19 at δ = 0.25–0.3 (the Pirio
  and Muro blue tits, $V_A \approx 0.49$–0.50), 5 at 0.5, 15 at 0.9. Every observed δ is far below
  these, so the statement "not currently exceeded" stands for the populations with diversity data.
- **$\overline{Q^2}$ integrated along a Haldane map** — how the linked term is computed from empirical
  recombination maps and annotation-derived functional target sizes. Method, not finding.
- **$\kappa(\alpha)$, the mating-system scalar** — 1 without a pair bond, up to 2 under strict
  monogamy; the monogamous passerines in the data sit at 1.2–1.9. Its purpose (user, 2026-10-14) is not
  new theory but to make the $N_e/N$ calculation **consistent with Bonnet's single $V_A$ across sexes
  and across mating systems**, capturing mating-system differences through the pair bond, EPP and
  assortment. Built on Woolliams, Bijma & Villanueva 1999 and Santiago & Caballero 1995; cite, don't
  re-derive. Supplementary.
- **The DFE correction on the MSD side** — a leptokurtic DFE makes $s^*$ *less* plausible, not more, so
  it does not rescue MSD balance. Robustness check. **Mechanism corrected 2026-10-15:** in the
  strong-selection limit $V_A = U_d\bar s$ whatever the DFE's shape, so $s^*$ estimates the
  arithmetic mean. Shape enters only through nearly neutral mutations ($4N_es \lesssim 1$), which
  contribute less than $U_ds$; more leptokurtic at a fixed mean means lower sustainable $V_A$. It is
  *not* "large-effect alleles dominate $V_A$". The variance-weighted $E[s^2]/E[s]$ governs $V_m/V_A$
  and $Z$, not $s^*$.
- **Precedent for the MSD verdict — must be in the re-cut Introduction (user, 2026-10-15).**
  Charlesworth 2015 (PNAS 112:1662) already set observed $V_A$ in *Drosophila* fitness components
  against mutation–selection balance and concluded there is too much of it. A colleague raised the
  same point independently. The paper's MSD side is the application of that test to total-fitness
  $V_A$ in wild vertebrates, stated as $s^*$; Johnson & Barton 2005 is the related review. This is
  prior work on the same test, so acknowledge it plainly. Do not turn it into borrowed significance.
- **Independence of the inputs from diversity data** — $V_A$, $\alpha$, $M_i$, $f_i$ and $\mu$ each come
  from a separate body of data and none from observed $\pi$. This is a genuine methods strength and
  should be a short Methods subsection. **It is not the reason the paper matters** and must not be
  built into the Introduction as a gap being filled.

### What is deliberately NOT claimed — do not let these come back

Each was a live claim at some point and each is dead. Listed so they are recognisable if they reappear.

| retired claim | why it is dead |
|---|---|
| "The two routes fail in opposite directions" | borrowed significance; made the result depend on Buffalo 2021 |
| "The prediction overshoots observed diversity by 2–3 orders" | arithmetically impossible: the model can remove at most ~20× |
| "Published pedigree estimates exceed $V_{A,\max}$" | 0 of 19 at $\delta \le 0.3$ |
| "The bound binds only the *directional* component" | fluctuating selection still erodes diversity; a sign flip restores no heterozygosity |
| "Circularity of diversity-calibrated estimates is why this matters" | demoted to a Methods strength |
| Lewontin's paradox as the thesis; Buffalo 2021 as the foil | the field is moving off linked selection as *the* explanation; locating citations only |
| Balancing / fluctuating selection as an escape from the diversity ceiling | it is not; it belongs on the MSD side only, as an account of how large $V_A$ is *maintained* |
| The opportunity for selection $I$, and any $V_A \le I$ argument | never part of this framework; struck by the user 2026-08-26 |
| Fisher's theorem as co-requiring the long-run quantity | FTNS is single-generation |

**The recurring failure mode this table exists to prevent:** reaching for borrowed significance —
"position this work as the direct answer to someone else's open challenge." It has recurred at least
three times (Buffalo, Lewontin, Charlesworth/Connallon & Czuppon) and it recurs by default whenever a
tool is asked to connect this work to a literature. **Standing test:** remove Buffalo 2021, remove
Lewontin-as-thesis, remove Charlesworth 2026 — is it still interesting? Anything that fails is
decoration.

**On Connallon & Czuppon (2026) and Charlesworth (2026)** specifically: they explain *how* a large
$V_A$ can be maintained. This project does not try to explain the maintenance; it takes measured $V_A$
as an input and asks what it implies. They are not a competing resolution of our premise and were never
one. Neither is verified against Crossref or entered in `references.bib` — flag `% UNVERIFIED:` if used.

### What is missing

The observed side, and nothing else. Five numbers per population; three are in hand.

1. **$\pi_{\text{obs}}$ — missing.** Lewin & Eyre-Walker 2026 (Molecular Ecology).
2. **$N$, breeding adults — missing**, and subject to scope condition 4. Buffalo 2021 has census sizes
   for some species; for the rest, recover his density/body-size allometry.
3. $\mu$ ✅ · 4. $V_A$ ✅ · 5. $\kappa$ ✅

**Data decisions of 2026-10-10** (full record in `data/README.md`; the data layer is
`scripts/R/00_prepare_data.R` → `data/processed/`, read through `scripts/R/load_data.R`):

- **κ: Model B is primary for every population**, Model A the sensitivity bound. Non-monogamous
  systems have no measured α and sit at the α = 1 limit, κ = 2: in harem and dominance systems male
  success tracks male quality. **Superseded 2026-10-14 (merged 2026-10-15):** the re-derived
  Appendix B gives κ = 1 for non-monogamous systems and $\kappa_B = 2 - \tfrac32\alpha +
  \tfrac58\alpha^2$ for social monogamy. Model B stays primary. See the Rule 5 log entries of
  2026-10-14 and 2026-10-15.
- **μ: both estimates carried, not averaged** — `mu_phylo` (Wang & Obbard 2023 PGLMM) and
  `mu_direct` (Lewin & Eyre-Walker 2026, own species or closest relative). The PGLMM is fitted to
  the direct estimates, so they are not independent, and averaged CI bounds are not a CI.
- **$U_d$ is autosomal only.**
- **$N_c$ is Buffalo 2021's published value, own species only (10 of 19).** The reimplementation of
  his method for the rest is not pursued, and **no breeder-fraction or historical $N$ for the
  preprint.** State in the manuscript, where $N_c$ is used, that his bird densities come from
  length-predicted mass and are likely ~1.2 orders low, and that his *Ovis aries* value is domestic
  sheep, not Soay. This supersedes scope condition 4's preference for the preprint.

**Confirmed 2026-08-19 and still true: there is no diversity data anywhere in the repo.**
`science.abk0853_data_s1/` is the Bonnet et al. 2022 pedigree archive (19 populations, raw `LBS` plus
`Ainv_*`), not diversity.

**Analysis-set warning.** The three-way `Code` join (`df_va` ∩ EPP ∩ chromosome data) yields **8**
populations — RD, BHS, AB, SSH, CSM, GTU, CF, GTN — not 19. The 19 apply to $V_A$-only and unlinked
results; anything needing $U_d$, maps or annotations is on 8. Say which set each result uses.

### Venue, artifacts, prose authority

- **Target journal: GENETICS (GSA).** IF 6.5 (2025), 5-yr 5.0, CiteScore 8.7, #19/192 Genetics &
  Heredity; re-check at submission, it has risen steeply. Its scope names "population, evolutionary,
  and quantitative genetics … empirical and theoretical investigations" explicitly. **Am Nat was
  suggested at MWPG 2026 and assessed 2026-08-24: IF 2.7, #70/200 Ecology, Q2.** Keep it as first
  fallback. Evolution Letters is a plausible middle option (metrics not verified).
- **Preprint send list:** Aaron Ragsdale (UW–Madison), Arslan Zaidi (U Minnesota) — both asked at MWPG
  2026. Both are population geneticists, which is evidence for the GENETICS readership.
- **Poster** (`poster/`, MWPG 2026, 24 × 36) is **frozen**. It implements the previous forward-only
  framing and is now one framing behind this section; that is acceptable for a delivered artifact. Do
  not edit `poster/make_poster.py` or `scripts/R/poster_figs.R` without being asked.
- **Prose authority is `walid_authorial_style_guide.md`** (repo root; added 2026-08-20, untracked).
  Mechanism-first subjects,
  colon-delivered definitions, named systems rather than abstract categories, short punch after long
  setup, consequences rather than wrap-ups, and few em-dashes. No constraint jargon ("does not bind")
  — state the observation, not the property. **Generated sentences are scaffolding**
  (style guide Part 3); the one-sentence statement of the project is the user's to author. The claim
  above was approved by the user on 2026-08-26.

  **⚠ The style guide's Appendix is a VOICE benchmark, not a claims source.** Its confirmed-human
  reference sentences were written under the retired framing and four of them assert dead claims:
  "heritable and consistently directional", "two to three orders of magnitude above the upper limit",
  "the upper limit ... falls below what the 19 wild vertebrate populations' pedigree estimates
  require", and "Most fitness variance measured in the wild therefore cannot be the directional kind".
  **Mine the Appendix for rhythm and diction only.** Anything mined for content resurrects a claim in
  the retired-claims table above.

  **`talk/JOB_TALK_RULES.md` and `job_packet/` do not exist in this repo** — earlier references to them
  (Rule 12, and the poster notes) point outside the checkout. "The Cut and the Grain" is Part 2 of the
  style guide; the de-AI-ification checklist is Part 3; paragraph rhythm is Part 6.

### Open work, in order

1. **Get $\pi_{\text{obs}}$ and a census $N$** for as many of the 19 as possible, with scope condition 4
   applied and the instrument recorded per population. **This is the only blocking unknown**, and it
   sets the size of the deficit the diversity side is measured against.
2. **Re-cut `scratch.tex`'s Introduction and Discussion to the claim above.** The Introduction is
   several framings stale and line 25 asserts the retired 2–3 order claim. The Discussion carries the
   overshoot language. The salvaged prose (from `archive/prose-edit-scratch`, adopted 2026-08-26)
   improved the prose throughout but did not change the framing. **The Introduction must
   acknowledge Charlesworth 2015 as the precedent for the MSD verdict** (Supporting results, above).
   The Discussion still carries retired claims; the 2026-10-15 audit fixed only its math slips.
   **Introduction redrafted again 2026-10-17 (v3)** in `manuscript/introduction.tex`: order is
   measured V_A → maintenance (a requisite: which model explains it) → genome-wide consequence
   (Result 1) → linked consequence conditional on the maintenance model (Li & Berg there) → gap and
   timescale → this work, with results as magnitudes in words and GENETICS register (exemplar
   `iyag180.pdf`). Adds Charlesworth, Morgan & Charlesworth 1993. Voice is the author's to revise.
   Earlier: **Introduction redrafted 2026-10-16 and merged to `main`** (scaffolding; needs re-voicing;
   new citations web-checked, Crossref still due; see `manuscript/INTRO_REDRAFT_PLAN.md`).
   Discussion still to do.
3a. **Methods reviewer pass.** The user asked on 2026-10-15 for Theory and Methods to be updated
   together, and **Methods was rewritten that day** from the data layer (see the Rule 5 log entry of
   2026-10-15, "Theory and Methods updated"). A reviewer pass is still wanted. **Author flags left in
   Methods:**
   - per-population EPP sources, and whether α is the proportion of offspring or of broods;
   - whether the linkage maps are sex-averaged;
   - which $f_i$ partition is primary (coding bp, as the code does, or gene count, as the old Methods
     said).
3. ~~Fill Appendix D's `[XX]`~~ **Done 2026-10-15** for $U_d$ and $s^*$, and the $V_A$ range is fixed
   to the posterior modes in Theory, Methods and Appendix D. Only Appendix D's forward DFE
   prediction ($V_A^\text{DFE}$) still has an `[XX]`.
4. ~~Fill `scratch.tex:235`~~ **Done 2026-10-15:** Methods states that no standardization was
   applied, and why.
5. ~~Write the Methods independence-audit subsection~~ **Done 2026-10-15** ("Independence of the
   inputs from diversity data").
6. ~~Resolve the `chrom_reduc` / `total_red` factor of 2~~ **Resolved:** `chrom_reduc` no longer
   exists.
6a. **Rebuild the linked analysis on the data layer.** `data_gen.R` cannot run (line 479), carries its
   own `arch_map`, and computes $U_d$ as `2 * mu_1 * L_functional` with CNE multipliers, against
   Methods' $4\mu L_\text{coding}$. Methods now describes the intended pipeline: data-layer inputs,
   coding-bp $f_i$, Haldane quadrature, $\kappa_\text{cis}$, and the same $Z$ in both terms. Linked
   numbers (the "~20×", Ω) must be recomputed that way before they are published.
7. **Check Matheson & Masel (2025)** — logged as corroborating the unlinked component's importance,
   with one methodological question not yet identified. We quantify what they argue qualitatively:
   1.4× at the median reported $V_A$, ~3× at the maximum.
8. **The domain of the $N_e/N$ formula — open for Theory and Results (user, 2026-10-17).**
   $N_e/N = 1/(1+4\kappa V_A)$ is first order, valid for $V_A \ll 1$. Under the additive map its
   outer edge is $V_A < 1$, where $G = 1 - V_A$ reaches 0 and about 16% of individuals would have
   negative fitness. So **asking the formula "what $V_A$ gives a hundredfold deficit" is not
   legitimate.** The inversion $V_{A,\max} = (1-\delta)/(4\kappa\delta)$ returns 12–25 at $1/\delta =
   100$, outside the domain, and that number is not a prediction. The legitimate question is how much
   reduction the model can deliver inside its domain, compared with the observed deficit. Needed:
   - **Fig. 1:** show the "required by observed π" markers (29–6,000) as off-scale for the model, not
     as values.
   - **The $V_{A,\max}(\delta)$ curve** (`FigS_ceiling`): stop or grey it where $V_{A,\max}$ leaves the
     domain, below $\delta \approx 1/(1+4\kappa)$ (0.11–0.2).
   - **Property 3 of "Why it holds together":** drop "needs $V_A \gtrsim 12$" as a requirement.
   - **Theory, unlinked-baseline domain paragraph:** state this directly.
   - Depends on item 9: the right model class beyond first order may give a legitimate magnitude.
9. **Additive vs multiplicative fitness map — open, decides how item 8 is answered (2026-10-17).**
   Bonnet's $V_A(w) = \mathbf d^\top\mathbf G\mathbf d$ is the observed-scale *additive* variance, which
   is what the first-order formula needs, so there is no discrepancy for $V_A \ll 1$. Beyond first
   order the answer depends on the genotype → fitness map:
   - **Additive** ($w = 1 + a$): saturates, $N_e/N \ge 1/2$ (1/3 under strict monogamy).
   - **Multiplicative** ($w \propto e^{a}$, Bonnet's log-link structure; $G = 1$ exactly): a
     long-term-contribution heuristic gives $N_e/N \approx e^{-4\kappa V_A}$, unbounded.
   - **What the multiplicative form means for the data:** the Pirio and Muro blue tits get 26–32×
     rather than 4.3–4.5×. The nine populations with diversity data would need $V_A \approx 1.3$–1.7
     (against measured ≤ 0.5, upper HPD ≤ 0.70). So the verdict survives, with a margin of about 2–3×
     in $V_A$ for the blue tits.
   - **The exponential form was retired earlier for the wrong reason.** The user thought it required
     small $V_A$; the real difference is the fitness map. Do not reinstate it without the literature
     review (in progress 2026-10-17) or a derivation. Zero-inflation (Bonnet's logit part) is not yet
     included.
   - **Plan:** use both maps as a bracket, or the model class the literature supports, to get
     approximate magnitudes. The first SLiM test (once SLiM is installed on this machine) is additive
     vs multiplicative maps at $V_A$ = 0.01–1.5, measuring $N_e$ directly.

## The model in one screen

Three model layers, composed per chromosome:

1. **Unlinked baseline** — genome-wide $V_A$ depressing $N_e$ via independent assortment.
2. **Mating-system scalar $\kappa(\alpha)$** — modulates the unlinked term by extra-pair-paternity
   rate $\alpha$.
3. **Linked term** — chromosome-local variance $v_i$ interfering with itself over map length $M_i$
   (Morgans), through a position-averaged $\overline{Q^2}$.

## Canonical layout

```
project#3/
├── CLAUDE.md
├── Chicago_project#3.Rproj          # RStudio project; RestoreWorkspace: Default
├── .RData                           # 34 MB de-facto session state (GITIGNORED)
├── alldistzip                       # Bonnet et al. 2022 MCMCglmm posteriors (load()ed)
├── scripts/R/
│   ├── unlinked.R      → MainFig_Baseline_Constraint, SuppFig1–3, SuppTable1_*.csv
│   │                     (builds df_va; MUST run before data_gen.R)
│   ├── data_gen.R      → Omega sweeps, demographic deconstruction, μ sensitivity, V_A,max
│   │                     (line 479 BUG — not runnable from a clean session; Rule 5 log)
│   ├── data_gen_2.R    → data/raw/clean_chromosome_data.csv  (ABSOLUTE-PATH-BROKEN)
│   ├── supp_fig.R      → SuppFig3 / SuppFig4 (Q vs r, κ vs α, Z vs Vm)
│   ├── kappa.R         → κ, G and r_mf (Appendices A, B); sourced by every script that needs κ
│   ├── 00_prepare_data.R → data/processed/ (read via load_data.R)
│   ├── fig1_gap.R, fig2_rescaling.R → main/Fig1_gap, main/Fig2_rescaling
│   └── poster_figs.R   → poster/figs/PosterFig_A–D   (POSTER ONLY — Rule 12)
├── data/
│   ├── master_chromosome_recomb_data.csv   # genomic-architecture model input
│   ├── species_EPP.csv                     # per-Code mating system / EPP / Ud / mu_1
│   ├── recomb_data.csv                     # linkage-map cM per chromosome
│   └── raw/                                # SUPERSEDED result tables — archive, not input
├── genomic_data/<species>/ncbi_dataset/    # NCBI GTF/GFF + sequence_report.tsv (GITIGNORED)
├── main/, supp/                            # THE RESULTS FIGURES — from scripts/R/;
│                                           #   hand-placed. Results + some supplementary.
├── poster/                                  # MWPG 2026 poster — DERIVED, see Rule 12
│   ├── make_poster.py                       #   builds the .pptx; owns layout + copy
│   ├── figs/PosterFig_A–D.tiff              #   from scripts/R/poster_figs.R
│   ├── README.md                            #   δ numbers, data_gen bug, fill-ins
│   └── assets/, *.pdf                       #   GITIGNORED build products
└── manuscript/
    ├── _main.tex           # ROOT DOCUMENT (2026-10-17), same structure as
    │                        rmt-pca/main/_main.tex: \input{}s abstract.tex,
    │                        introduction.tex, theory_model.tex, methods_materials.tex,
    │                        results.tex, discussion.tex, add_info.tex and
    │                        supp/appendix_A–D.tex, paths from the repo root, biblatex +
    │                        manuscript/references.bib. Builds locally from the root:
    │                        `latexmk -pdf manuscript/_main.tex` (babel-english, csquotes,
    │                        biblatex, soul, todonotes installed 2026-10-16). Each section
    │                        file carries the \ifdefined\isMainDocument guard and compiles
    │                        standalone. Bodies were split VERBATIM from scratch.tex at
    │                        1eb0116. **Since 2026-10-17 (user) scratch.tex is STALE:**
    │                        the section files are the working copies; edit them
    │                        directly, not scratch.tex.
    ├── main.tex            # OLDER OVERLEAF ROOT (commit 8266aff), superseded by _main.tex;
    │                        inputs the same section files. Delete once Overleaf's main
    │                        document is switched to manuscript/_main.tex.
    ├── scratch.tex         # OPERATING DOC + AUTHORITATIVE — complete draft:
    │                        intro → theory/model → results → methods →
    │                        discussion → appendices. Outranks main.tex AND the R code.
    ├── scratch_review.tex  # HISTORICAL — agent review of a MUCH older scratch.tex;
    │                        its three named defects are believed fixed. Do not action.
    ├── scratch_ulises.tex  # PARKED side-derivation — rigorous MSD balance (see Rule 11)
    ├── references.bib      # shared, GROWING — extend, never replace (Rule 6)
    ├── rho_mf_derivation.tex     # SUPERSEDED — collaborator's earlier κ/EPP derivation
    └── figures/                  # SUPERSEDED — collaborator's figures for the above;
        └── make_figures.py       #   NOT the results pipeline. That is main/ + scripts/R/.
```

## Rules

1. **Source `unlinked.R` before `data_gen.R`, every session.** `unlinked.R` builds `df_va`
   (per-species posterior $V_A$ vectors from `alldistzip`) and loads `MCMCglmm`/`coda`. `data_gen.R`
   needs both and rebuilds neither — it re-runs `load("alldistzip")` but never rebuilds `df_va` and
   never libraries those packages. **Self-enforcing:** `data_gen.R` carries a `stop()` guard on
   `df_va`/`posterior.mode`/`as.mcmc`. Note the guard cannot catch the *dangerous* case — with
   `RestoreWorkspace: Default`, a **stale** `df_va` from `.RData` passes `exists()`. Re-source
   `unlinked.R` anyway.

2. **Run from the repo root.** The R scripts are written for interactive RStudio use from the root, not
   headless `Rscript`. Relative paths are inconsistent between scripts and assume the root as CWD:
   `unlinked.R` expects `species_EPP.csv` in the CWD, `data_gen.R` expects `data/species_EPP.csv`.

3. **Fix `data_gen_2.R`'s `root_dir` before running it.** It hardcodes
   `root_dir <- "G:/My Drive/Chicago_project/Chicago_project#3/genomic_data"`, which no longer matches
   this checkout (`G:/My Drive/UChicago_projects/project#3`). This is the `ABSOLUTE-PATH-BROKEN` tag in
   the layout. **Self-enforcing:** a `dir.exists(root_dir)` guard stops the script rather than letting
   it map over an empty species list and write a 0-row `clean_chromosome_data.csv`. The guard
   self-clears once the path is correct — no need to remove it.

4. **Figures are written to CWD, then moved by hand.** Every script emits its `tiff()` into the CWD;
   finished figures are moved into `main/` and `supp/` manually (**not** `manuscript/figures/` — that
   is superseded collaborator output, see Rule 8). Committed filenames therefore do not always match
   current scripts (e.g. `data_gen.R` writes `MainFig_Ud_Derivation_and_Total_Collapse.tiff`, which is
   not committed). Do not assume a committed TIFF traces to a same-named script output.

5. **`scratch.tex` outranks everything — `main.tex` *and* the R code.** It is a complete,
   heavily-edited draft (intro → theory/model → results → methods → discussion → appendices) and is
   the single source of truth for the theory. **Never propagate `main.tex` formulas into code** — it
   still carries $N_e/N = \exp(-4V_A\kappa)$ and the linear $\kappa \approx 2 - p$, both dead.

   **Where the R code and `scratch.tex` disagree, the code is stale** and gets updated to match
   `scratch.tex` — not the reverse. The **Model conventions** block below documents what the code
   *currently implements*, which is **not** a guarantee it matches the latest `scratch.tex`. Re-derive
   from `scratch.tex` before trusting any formula there. Same for the figures in `main/`/`supp/`: they
   were generated from the code, so they inherit its staleness.

   **Do not action `scratch_review.tex`.** It was an agent review of a much older `scratch.tex`; the
   three defects it named (the leading-order "master equation" missing $1/(1+\Lambda_u)$, the
   $\rho_{mf} = 1-p$ step, inconsistent $V_A$ units) are believed fixed by subsequent edits. Treat it
   as project history, and confirm against current `scratch.tex` before raising anything from it.

6. **Draft in `scratch.tex`; backport to `main.tex` deliberately.** `scratch.tex` is the operating
   document — **all** new derivation and every change to the math lands there first. Never draft new
   math directly in `main.tex`. `main.tex` is a downstream short-form rendering of *settled* results,
   and flow is **one-way** (`scratch.tex` → `main.tex`), never the reverse — the same direction Rule 5
   enforces for code.

   **`main.tex`'s current prose is disposable.** It is a stub to be overwritten wholesale, so there is
   **no** obligation to preserve, reconcile, or amend what is already in it. Do not treat divergence
   between the two files as debt to be tracked formula-by-formula — the whole file gets replaced as
   sections land. What *is* worth preserving is the machinery: the `natbib`/`references.bib` wiring,
   the `geometry`/package preamble, the title block.

   **The backport unit is one section — or one subsection.** Within a Results or Theory section, a
   single subsection is a legitimate unit of work. A backport is finished when that unit reads as final
   in `main.tex`: prose carried over, `\citet{}` conversions done and entries added to
   `references.bib`, and its figures actually `\includegraphics`'d (see Rule 8 — nothing is wired up
   yet).

   *Mechanical* edits to `main.tex` — packages, citations, typos, figure paths, formatting — stand
   alone and need no backport.

   **Citations — machinery vs. content.** Two things move in opposite directions; conflating them
   causes trouble. The *machinery* lives in `main.tex` only: `natbib` + `plainnat` + `\citet{}` against
   `manuscript/references.bib`. The *content* — which works are cited — flows **forward** with each
   backported section, since `scratch.tex` carries ~91 **prose** citations ("(Buffalo and Kern 2024)",
   ~60 unique works) against `main.tex`'s 7 wired entries.

   So **`references.bib` is a shared, growing artifact — extend it, never replace it.** Each backported
   section brings its citations along: convert them from prose to `\citet{}`/`\citep{}` at backport time
   and add missing entries in the established author-year key style (`robertson1961`, `santiago1995`,
   …), **verified against Crossref rather than written from memory**. If `scratch.tex` is ever wired up
   directly, that borrows the machinery from `main.tex` — permitted because it is **mechanical**, but
   **no formula, constant, result, or claim travels `main.tex` → `scratch.tex`, ever.**

7. **`data/raw/` and `manuscript/misc/` are archive, not input.** `data/raw/` holds superseded result
   tables from earlier iterations. Do not read from it as a live source.

8. **`main/` + `scripts/R/` is the results pipeline. `manuscript/figures/` is not.** The figures that
   become Results and some Supplementary all live in `main/` (plus `supp/`) and come from `scripts/R/`.
   **`manuscript/figures/` and `rho_mf_derivation.tex` are superseded project history** — a
   collaborator's earlier attempt to derive $\kappa$ and parameterize it by extra-pair paternity, with
   `make_figures.py` producing its three PDFs. The current `scratch.tex` treatment of $\kappa$ (in the
   main text and its internal appendices) supersedes it. Do not cite, extend, or mine that folder for
   results.

   **No figure is wired into any `.tex` file yet.** `main.tex` says "(Fig. 1)" in prose but contains no
   `\begin{figure}` or `\includegraphics` at all, and `scratch.tex`'s single `\caption` is a table. So
   there is **no** existing script → filename → figure-number mapping to inherit; it gets established
   as sections are backported. Until then, do not assume a `main/` filename implies a figure slot —
   several `Theoretical_*.tiff` there have no obvious current producer (see Rule 4), and both
   `SuppFig3.tiff` and `SuppFig3_Va_Deflation_Analysis.tiff` exist. **Ask which file is meant rather
   than guessing.**

9. **Target journal is GENETICS (GSA).** Format decisions default to its requirements. `main.tex`'s
   current `article` class, `12pt`, and `plainnat` bibliography are **placeholders**, not choices —
   expect to swap in the GSA template and its `.bst`, at which point `references.bib` entries may need
   fuller author lists (`bonnet2022` currently uses `and others` for a 41-author paper).

10. **Project framing outranks `scratch.tex`'s Introduction and Discussion — the one documented
    exception to Rule 5.** Both are several framings stale: the Introduction argues a superseded gap
    and line 25 asserts the retired "2–3 orders of magnitude" claim, and the Discussion carries
    overshoot language that the arithmetic does not support. Rewriting them to the settled claim is
    **open work item 2** — until it lands, read **Project framing** for intent and `scratch.tex` for
    the math. Rule 5 still holds for **everything else** in `scratch.tex`: the theory, model,
    equations, and appendices remain authoritative. **Every framing change this project has made has
    been framing and emphasis only — no equation has ever changed.**

11. **`scratch_ulises.tex` is parked, not dead.** A collaborator's diffusion-theory derivation of
    mutation-selection-drift balance. Its value is a **rigorous** route to additive variance in
    relative fitness, replacing what `scratch.tex` currently does — which is closer to a heuristic. It
    is **not** integrated and is not part of the current backport path; do not fold it in without being
    asked.

12. **`poster/` is derived, and it is NOT the results pipeline.** Added 2026-08-18 for the Midwest
    Population Genetics Meeting 2026 (UChicago). **Sheet is 24 × 36 in portrait** (changed from
    30 × 40 on 2026-08-19). Two-step build, from the repo root:

    ```sh
    Rscript scripts/R/poster_figs.R   # figures (~4 min; POSTER_SKIP_DATAGEN=1 skips the slow part)
    python  poster/make_poster.py     # the .pptx
    ```

    **Edit `make_poster.py`, never the `.pptx`** — it is overwritten on every build. Framing
    authority for its copy is **Project framing**, not `scratch.tex`'s Introduction
    (Rule 10). `poster/README.md` records the δ arithmetic, the `data_gen.R:479` bug, and the
    remaining `[FILL:` markers.

    **The figure-scale rule that makes it work:** the `main/` TIFFs are sized for a journal page and
    land at 0.54–0.65× inside a poster panel, which shrinks their axis type by the same factor.
    `poster_figs.R` renders each figure at **exactly its placed size**, so the scale is 1.00 and axis
    text lands at a known point size on the sheet. `make_poster.py` prints a placement table every
    build — **every row should read `scale 1.00`**; if a panel's text budget changes, update
    `DIM_A`…`DIM_D` in `poster_figs.R` and re-render. Two limits a bigger `base_size` cannot fix:
    19 rows in ~5.4 in caps species labels at ~14 pt, and over-long axis titles are **clipped, not
    shrunk** (hence the short-label overrides).

    **Changes of 2026-08-19 (all recorded in `poster/README.md`):**

    - **Resized to 24 × 36.** Type scale is now the agreed hierarchy × **1.6** (title 76, body 26,
      captions 18) rather than × 2. Geometry scaled with it. `DIM_A`…`DIM_D` re-derived from the new
      placement table; all four panels report `scale 1.00`.
    - **Copy re-cut under the Cut and the Grain** (style guide Parts 2 and 6) for a mixed
      pop-gen audience. Every panel headline is now a claim rather than a topic, and the jargon that
      was doing no compression is gone. ⚠ **This copy is generated scaffolding under §3 and has NOT
      been re-voiced by the user.** It must be rewritten in the user's diction before printing; the
      verdict lines especially are §2 step 2 and cannot be outsourced.
    - **δ is now defined on the sheet**, in the Panel B body and on its x axis. The old verdict
      "Exceeded once δ > 0.33" was opaque — see the new "What δ is, and what *exceeded* means"
      section of `poster/README.md`, which is the durable record of that arithmetic.
    - **Panel A lost its independence-audit badge**; the claim moved into `A_CAP`. A 5.2 in text
      column on the narrower sheet could not carry equation + body + verdict + badge.
    - **Panel B**: κ curves moved from inline labels to a right-hand legend, and the figure grew from
      6.94 × 2.46 to 10.06 × 2.79 — it had been height-bound inside a much wider region, with about a
      third of its panel width unused.
    - **Panel D**: legend keys go 2 × 2 with a title. One row of four overflowed the panel and
      clipped the last label, and bare percentages did not say what they were a percentage of.
    - **`poster/MWPG2026_poster_template.pdf` is now STALE** — it is the old 30 × 40 export.
      Re-export from PowerPoint before printing. Not deleted.
    - **`poster/TALK_SCRIPT.md`** holds the walk-up and full-tour spoken scripts (added 2026-08-19).
      Same caveat: scaffolding, not delivered prose. **Rewritten twice on 2026-08-21:** onto the
      forward-only framing the poster still carries, then re-voiced against the style guide. It now
      quotes the sheet's panel headers verbatim, so if a header changes the script must change with it.

    `poster_figs.R` does not modify the manuscript pipeline. It shims `read.csv` (Rule 2 path
    inconsistency), `tiff` and `write.csv` (diverts the sourced scripts' own outputs to scratch), and
    patches `data_gen.R:479` in a **temporary copy**.


## Model conventions (preserve when adding analyses)

Applied consistently across `data_gen.R` and `unlinked.R`. **Read Rule 5 first** — this documents what
the code implements, not necessarily what `scratch.tex` now specifies.

- **Exact form, not the exponential.** Unlinked part is $N_e/N = 1/(1 + 4\kappa V_A)$; only the linked
  part is exponential: `chrom_Ne_N <- linked_exp / (1 + 4 * kappa * (Va - v_i/2))`.
- **κ comes from `scripts/R/kappa.R` only** (Appendix B, re-derived 2026-10-14). κ = 1 without a pair
  bond. Social monogamy: $\kappa_B = 2 - 1.5\alpha + 0.625\alpha^2$ (primary) and the longer $\kappa_A$
  closed form; `kappa_pair(alpha, gamma, G, rho)` is the general form, `ne_ratio(..., G_correct =
  TRUE)` the $G = 1 - V_A$ sensitivity. `species_EPP.csv` codes no-pair-bond systems as EPP = 1, so
  `data_gen.R`'s `calc_kappa()` maps α ≥ 1 to κ = 1 and otherwise uses Model B (it used Model A, at
  the old formula, until 2026-10-14). Do not re-type the formulas in a new script; source `kappa.R`.
- **The linked term does not carry κ** (2026-10-15). It is
  `exp(-kappa_cis * (v_i/2) * Q2_bar) / (1 + 4*kappa*Va - 4*kappa_own*(v_i/2))`, with `kappa_cis =
  kappa_own = 1` under Model B and without a pair bond (`kappa_own()`, `kappa_cis()` in `kappa.R` for
  Model A). Before 2026-10-15 the code had `exp(-kappa * ...)` and `1 + 4*kappa*(Va - v_i/2)`.
- **$\overline{Q^2}$ is numeric under a Haldane map** (`integrand_avg_Q2` / `calc_avg_Q2_haldane`),
  with `Z` capped at 0.995 to avoid the singularity at perfect mutation-selection balance. The
  `main.tex` closed form is the linear-map approximation.
- **`Z <- pmax(0, 1 - Vm/Va)`** with `Vm = Ud * s_het^2`; `s_het` defaults to 0.01, sensitivity facets
  `c(0.005, 0.01, 0.02)`.
- **Variance allocation:** `f_i = L_coding_bp / L_coding_total` (coding bp, not physical length),
  `v_i = Va * f_i`, then halved (`v_i/2`) — a focal neutral allele is linked to only one homolog.
- **Filters:** autosomes only (drop X/Y/Z/W/MT), macrochromosomes only
  (`Physical_Length_bp >= 20e6`).
- **Genome-wide aggregation** weights chromosome $N_e/N$ by physical length (`L_weight`), not coding
  bp.
- **CNE multipliers** inflate coding to functional target: 2× birds, 4× mammals, 5× maximum-rescue.
  **The avian species list is hardcoded and duplicated across several `data_gen.R` blocks — update all
  copies together.**
- **`data_gen.R` is a linear script of independent blocks**, each redefining `arch_map`, `s_het`,
  `kappa_val` for itself. Run blocks in order or re-source the setup.
- `theme_Publication()` is redefined at the top of both plotting scripts with different `base_size` —
  intentional, not a bug.

## Known staleness & inconsistencies (Rule 5 log)

**Logged 2026-07-29.** Found by reading `scratch.tex` against the R code. **None of these are fixed.**
Resolve toward `scratch.tex`, not the code.

**Code stale vs. `scratch.tex` Methods:**

- **$f_i$ partition.** Methods specifies $\hat{f}_i = G_i/G_{\text{total}}$ from **annotated
  protein-coding gene counts**. The code uses `L_coding_bp / L_coding_total` (**coding bp**). Note
  `scratch.tex` itself argues the two are highly correlated, so this may be a deliberate
  simplification — **confirm before "fixing"**.
- **$U_d$.** Methods gives $U_d = 4\mu L_{\text{coding}}$ (i.e. $2\mu \times 2L_{\text{coding}}$,
  regulatory target ≈ exome length). The code uses `2 * mu_1 * L_functional` with **CNE multipliers**
  of 1×/2×(bird)/4×(mammal)/5×. Different parameterizations of the same quantity.
- **$s$ — the sharpest one.** Methods states explicitly that a point estimate of $s$ is **not** fixed;
  $s_d$ is **inferred** by solving $V_m = U_d s_d^2$ across the joint credible intervals of $V_A$ and
  $\mu$. The code **hardcodes `s_het <- 0.01`** (with a `c(0.005, 0.01, 0.02)` sensitivity grid).
  **The code implements the opposite logical direction to the current Methods.**
- **Macrochromosome filter.** The code drops chromosomes with `Physical_Length_bp < 20e6`. No such
  filter is described in Methods — and `scratch.tex` §Discussion leans **heavily** on avian
  **microchromosomes** as the regime of greatest sensitivity, which that filter excludes.

**Logged 2026-08-18** (found while building the MWPG 2026 poster).

- **`data_gen.R:479` — a real bug, and it breaks reproducibility.** That line reads
  `left_join(epp_data %>% select(Code, Ud, EPP, Species.y), by = "Code")` and is wrong twice.
  (a) `Species.y` is not a column of `data/species_EPP.csv` — that name only exists **after** a
  join collision with `chrom_data$Species`. (b) It drops `mu_1` / `X95ci_lower_1` /
  `X95ci_upper_1`, which the μ-sensitivity block at line 633 then reads off `sp_arch`. The two
  equivalent `arch_map` blocks at lines 73 (see line 86) and 304 both get it right.
  **Consequence: `data_gen.R` cannot run start-to-finish from a clean session, so the committed
  `main/MainFig_Empirical_Sensitivity_MutationRate.tiff` is not reproducible from scratch.**
  Interactively it survives on a leftover `arch_map` that still carries those columns — exactly
  the dangerous case Rule 1 describes. **The fix is one line:** make 479 match 86. **NOT APPLIED**
  — `scripts/R/poster_figs.R` patches it in a temporary copy so the manuscript pipeline stays
  untouched.
- **Reported $V_A$ range disagrees with the data.** `scratch.tex` §Results and Appendix D state
  reported $V_A \in [0.10, 0.30]$ ("typically 0.10–0.30"). The actual per-population posterior
  modes from `alldistzip` are min 0.0029, Q1 0.0172, **median 0.0997**, Q3 0.2484, max 0.4970 —
  so roughly half the populations fall outside the quoted range, and the range is asymmetric about
  it. This feeds Appendix D's implied-$s^*$ arithmetic ($s^* = V_A/U_d$) and every `[XX]` in the
  Abstract. Resolve toward the data.
- **`unlinked.R` writes `SuppTable1_Bayesian_Indices.csv` into the CWD**, not just TIFFs — so
  Rule 4's "figures are written to CWD, then moved by hand" applies to CSVs too. Sourcing it from
  the repo root drops a duplicate of `main/SuppTable1_Bayesian_Indices.csv` at the root.
  `poster_figs.R` shims `write.csv` to divert it.
- **Positive reproducibility check:** sourcing `unlinked.R` from a clean session regenerated
  `SuppTable1_Bayesian_Indices.csv` **byte-identical** to the committed `main/` copy. The
  `unlinked.R` half of the pipeline reproduces; only `data_gen.R` does not.

**Internal to `scratch.tex`:**

- **Logged 2026-08-21 — the linked exponential carries $v_i$ in one equation and $v_i/2$ in another.**
  `chrom_reduc` (line 113) gives the chromosome-level reduction as
  $\exp(-\kappa \overline{Q^2}_{\text{linked}} v_i)$, with no halving. `total_red` (line 149) gives the
  same linked term as $\exp(-\kappa (v_i/2) \overline{Q^2}_i)$. The prose at 144–148 justifies the
  halving explicitly — a focal neutral allele is linked only to selected loci on its own haplotype — so
  `total_red` looks correct and `chrom_reduc` looks like the pre-partition form stated without saying
  so. **The R code uses `v_i/2`, matching `total_red`.** That is a factor of 2 in the exponent and it
  sits directly on the linked magnitude — the "~20×" figure on the diversity side of the claim — so
  resolve it before the Theory section is backported: either label `chrom_reduc` as pre-partition or carry the halving into it.
  **RESOLVED (checked 2026-10-15):** `chrom_reduc` no longer exists; `eq:ne_chrom` and `total_red`
  both use $v_h = v_i/2$.

- **$\overline{Q^2}$ method contradiction.** §Theory states the integral is **evaluated numerically
  under the Haldane** function, and argues *against* the linear approximation for chromosomes > 0.5 M.
  But §Methods (Genetic Map Lengths) describes the $Q^2$ expressions as **closed-form under the linear
  approximation** $r \approx |x-y|$ and discusses its bias. **These cannot both describe what was
  run.** **Still open; deferred to the Methods reviewer pass (user, 2026-10-15).** Theory and Appendix
  C now say the Haldane integral has a closed form and the linear form is a lower bound.
- **Appendix cross-ref.** §Theory points to **Appendix A** for the closed-form linear-limit
  approximation; it is actually in **Appendix C**. Appendix A is the unlinked-baseline derivation.
  **RESOLVED** (now points to Appendix C).

**Blast radius — what these can and cannot move.** The hardcoded `s_het` and the 20 Mb filter
**can change the reported numbers**, and under the settled claim the tolerance is tighter than it used
to be, because the diversity side is now a *modest* magnitude (1.4× median, ~3× max unlinked, ~20× with
linkage) rather than a huge one. A factor of 2 mattered little against "2–3 orders"; it matters against
"20×". Both must be resolved before the diversity-side number is published. The **per-population
$V_{A,\max}$ comparison is likewise not insulated** — it is an inequality test, so a shifted prediction
can flip an individual population across the bound. The MSD side is unaffected by either: it uses
$U_d$, $\mu$ and the posterior $V_A$, none of which touch `s_het` or the chromosome filter.

**Logged 2026-10-14 — Appendix B's κ re-derived (merged to `main` as 3996e63; PROPAGATED
2026-10-15 on branch `worktree-kappa-propagate`, see the entry after this one).**

- **What was wrong.** The old Appendix B *summed* female and male selective variances. Santiago &
  Caballero 1995 combine the sexes as $1/N_e = 1/4N_{e,m} + 1/4N_{e,f}$, which is a *mean*. For
  non-monogamous systems that double-counted: κ = 2 should be **κ = 1** (Appendix A unchanged). Its
  female-limited story ("male has no own additive effect") was also inconsistent with its own κ(0) = 2.
  That story gives 0.625, and it is incompatible with Bonnet's single-variance, both-sexes estimand.
- **What replaced it.** It is built on Woolliams, Bijma & Villanueva 1999 (expected long-term
  contributions by sex, their Eq. 6b; PDF at repo root) and SC 1995 (two-sex combination; pair-mated
  base model). The social-monogamy model is nest productivity $= a_f + a_s$, shared by both partners.
  It gives $\kappa_B = 2 - \tfrac32\alpha + \tfrac58\alpha^2$ and a longer closed form for $\kappa_A$.
  κ(0) = 2 is SC's pair-family $C^2 = 2V_A$, not a double count. Per population, $\kappa_B$ =
  **1.22–1.93** for the 11 monogamous populations (α = 0.047–0.76; the "1.44–1.93" first written here
  inverted the old symmetric κ_B and mis-read fairy-wren α = 0.76 as 0.24) and 1 for the 8
  non-monogamous ones (old 2).
- **κ vs SC's $r$ (named $r_{mf}$ in Appendix A):** distinct. $r_{mf}$ is the correlation between
  mates' breeding values, zero under random pairing. κ comes from nest sharing, which SC carry in the
  family-level $C^2$. No double counting.
- **Stale until propagated:** the `kappa`/`kappa_A`/`kappa_B` columns from `00_prepare_data.R`,
  `scripts/R/fig1_gap.R` and `fig2_rescaling.R` outputs, `unlinked.R` / `data_gen.R` `calc_kappa()`,
  Model conventions' κ formulas, and every κ-dependent number in Project framing (median 1.69×, max
  4.58×, $V_A \gtrsim 12$ at κ = 2).
- **Simulation:** to be built in **SLiM** once it is installed (user decision 2026-10-14; not R). First
  test is monogamy + EPP under Models A and B, then $1/(1+4V_A)$ over $V_A$ = 0.01–1, measuring $G$.
- **Not yet checked:** Woolliams & Bijma 2000 (*Genetics*, ΔF from contributions). The nest-sharing
  term is an indirect genetic (partner) effect; check the IGE literature before claiming any novelty.

**Logged 2026-10-15 — G and $r_{mf}$ made explicit; κ propagated everywhere (branch
`worktree-kappa-propagate`).**

- **G (user, 2026-10-15): $G = 1$ needs $V_A \ll 1$, the measured modes are not uniformly ≪ 1, and the
  long-run $V_A$ the deficit needs is ≫ 1, so $G = 1$ must be stated as an assumption with its
  sensitivity.** Appendix A now gives the exact selected-parent variance for linear expected fitness,
  $G = 1 - b^2V_A + b\mu_3/V_A$. Symmetric additive: $G = 1 - V_A$, $Q = 2/(1+V_A)$, $N/N_e = 1 +
  4V_A/(1+V_A)^2 \le 2$ (≤ 3 at strict monogamy) over the domain $V_A < 1$. Multiplicative (log-link,
  Bonnet's Poisson part): $G = 1$ exactly. Right skew: $G > 1$. So **$G = 1$ is primary (an upper bound
  on the reduction unless strongly right-skewed) and $G = 1 - V_A$ the sensitivity bound.** Monte Carlo
  check: $G = 1 - V_A$ holds while $1 + a > 0$. At $V_A$ = 0.3–0.5, truncation at zero fitness pushes
  G back toward 1, so the Gaussian-additive form itself strains there (8% of $1 + a$ below 0 at 0.5).
- **$r_{mf}$ (user, 2026-10-15): it is a mating-system parameter, so it now appears in Appendix B.**
  General $\kappa(\alpha, \gamma, G, r_{mf})$, checked against SC exactly: α = 0 gives $1 + Q^2C^2$
  with $C^2 = 2V_A(1+r_{mf})$, and no pair bond gives $Q^2/4$. Set to 0 for want of estimates.
- **User's statement of Appendix B's purpose (2026-10-15):** not to derive anything new, but to make
  $N_e/N$ consistent with Bonnet's single $V_A$ across sexes and across mating systems, with EPP as one
  axis of mating-system difference. Nest sharing is what the user intended from the start. First-order
  accuracy is accepted.
- **Propagated:** `scripts/R/kappa.R` (new, single source), `00_prepare_data.R` → `data/processed/`
  (κ columns changed, `reduction_G1`/`G_sym`/`reduction_Gsym` added), `load_data.R`, `unlinked.R`
  (re-run; `main/SuppFig1`, `SuppFig2`, `SuppTable1` replaced; MainFig_Baseline and SuppFig3_Va_Deflation
  are κ = 1 throughout and unchanged), `supp_fig.R` (`main/SuppFig3.tiff` re-rendered), `data_gen.R`
  (`calc_kappa` → Model B with κ = 1 for EPP = 1; **not re-run**, line 479 bug), `fig1_gap.R` and
  `fig2_rescaling.R` (re-rendered; Fig. 2 gains the dashed G = 1 − V_A curve). Manuscript:
  `scratch.tex` plus the Overleaf section files `theory_model.tex`, `methods_materials.tex`,
  `supp/appendix_A.tex`, `supp/appendix_B.tex`.
- **Still stale:** every `data_gen.R` output in `main/` (Omega sweeps, μ sensitivity, V_A,max figure)
  carries the old Model A κ. `poster/` is frozen and keeps old κ by design. The `main.tex` ne_sexes
  equation $8N/(V_{km}+V_{kf}+2\mathrm{Cov})$ was removed from Theory: it gave $N_e = 2N$ for Poisson
  families (probably a dropped "+4"), and nothing referenced its label.
- **Fig. 2 numbers at the new κ:** ratio 1 at c = 0.073 (MSD) and 1.1 × 10⁴ (diversity); best
  compromise c = 27, ratio 373.

**Logged 2026-10-15 — audit of Appendices C and D (two independent reviewers, both checked against
the primary literature); fixes on branch `worktree-theory-fixes-cd`.**

- **Priority: neither appendix is mostly original, and both now say so.**
  - **Appendix C.** The kernel $1/(1-(1-r)Z)$ is SC 2016 and Buffalo & Kern 2024 (Eq. 3). With
    $Z = 1-s$ it is the background-selection kernel $1/(s + r(1-s))$ (Hudson & Kaplan 1995; Nordborg
    et al. 1996). The squared-and-halved exponential is B&K Eq. 2. The intermediate-M form $2/(M(1-Z))$
    is SC 1998 Eq. 8 and Barton 1995. What is ours: Haldane evaluation and position averaging, the
    closed forms, and the lower-bound proof.
  - **Appendix D.** $V_m = U_ds^2$ (Charlesworth 2015 Eq. 1); $U_ds$ (Mukai et al. 1972; Charlesworth
    2012); $2N_eV_m$ (Lynch & Hill 1986); interpolation (cf. Bürger et al. 1989); exact diffusion
    (Kimura 1969); $Q(s) = 2/(1+s)$ (Charlesworth 2012 Appendix; SC 1998). Ours is the application to
    wild-vertebrate total-fitness $V_A$ as $s^*$.
- **Fixed:**
  1. **κ no longer multiplies the linked term.** The partner's genes are never in cis. Appendix B now
     splits $\kappa = \kappa_\text{own} + \kappa_\text{partner}$ and defines $\kappa_\text{cis}$.
     The chromosome-level form is $\exp(-\kappa_\text{cis}\overline{Q^2}v_h)/(1 + 4\kappa V_A -
     4\kappa_\text{own}v_h)$, with $\kappa_\text{cis} = \kappa_\text{own} = 1$ under Model B and
     without a pair bond. Code: `kappa.R` (`kappa_own`, `kappa_partner`, `kappa_cis`) and `data_gen.R`
     (all 12 linked expressions). **`data_gen.R` not re-run** (line 479 bug), so its `main/` outputs
     are stale. The "~20×" linked figure was computed at κ = 1, so the linked magnitude is unchanged.
  2. **D.4 "equivalence with diffusion" replaced** by the exact $V_A = U_ds[1 - 4N_es/(e^{4N_es}-1)]$
     (Kimura 1969; equation number UNVERIFIED). The interpolation is up to 29% low at $4N_es \approx
     3$; irrelevant here, since $2N_es^* \ge 9{,}400$.
  3. **$Z \approx 1 - E[s^2]/E[s]$**, not $1 - \bar s$ (main text, Theory).
  4. **DFE mechanism corrected** (Appendix D, Discussion).
  6. **Limits stated on their real scales:** complete linkage needs $M \ll 1-Z$, free recombination
     $M \gg 1/(1-Z)$, real chromosomes sit near $2/(M(1-Z))$. Microchromosomes have map lengths of
     ≥ ~0.5 M (obligate crossover). Table 1 relabelled.
  7. **The Haldane $\overline{Q^2}$ has a closed form** (dilogarithm), matching quadrature to 10 digits.
  8. **Smaller fixes:**
     - "House of Cards" renamed.
     - Duplicate labels removed: Appendix labels `eq:C_haldane_avg`, `eq:D_VA_interp`.
     - `app:chromosapp` now defined in `scratch.tex`; zero undefined references.
     - Hard-coded "Equation (5)/(10)/(C.x)" replaced.
     - Discussion factor-of-2 slip fixed ($t/(1+t)^2$), and κ added.
     - `\phi(t), t, dt` typo fixed.
     - "Conservative" changed to "lower bound" in Appendix C.
     - `[XX]` in Appendix D §D.2 and the Discussion $s^*$ sentence filled from the data layer.
- **Error 5 — RESOLVED 2026-10-15 (user approved).** Ω ≤ 1 failed as written: the linked term used $Z$
  while the unlinked denominator used $Q = 2$. Over a 675-point grid, Ω > 1 in 136 cases, up to 1.08.
  **Decision: the composite model uses the same persistence in both terms**, with unlinked $Q_u =
  2/(2-Z)$ (the M → ∞ limit of $\overline{Q^2}$):
  $(N_e/N)_i = \exp(-\kappa_\text{cis}\overline{Q^2}v_h)/[1 + Q_u^2(\kappa V_A - \kappa_\text{own}v_h)]$.
  Ω ≤ 1 is then exact, with a two-line proof in Theory (max 0.99999 on the same grid). The headline
  unlinked-only result keeps $Q = 2$ ($G = 1$, the upper bound). Code: `Qu2()` in `kappa.R`;
  `data_gen.R`'s composite denominators and Ω baselines use it, but its line-505 headline baseline
  keeps 4. At the code's $s_\text{het} = 0.01$ the change is about 0.1%.
- **Unverified references flagged in the text:** SC 1998 Eq. 8 (taken from B&K S1); Kimura 1969
  equation number; Rettelbach et al. 2025 (not located; maybe 2019); whether Huber et al. 2017 /
  Kim et al. 2017 report homozygous $s$.

**Logged 2026-10-15 — Theory and Methods updated to everything settled since 2026-10-14 (user
request).** In `scratch.tex`, then regenerated into `theory_model.tex`, `methods_materials.tex` and
`supp/appendix_B–D.tex`, which are now line-identical to `scratch.tex` ignoring whitespace.

- **Theory, §"The quantity":**
  - Bonnet's $\mathbf d^\top\mathbf G\mathbf d$ estimand, so no rescaling.
  - **D2**: linearity plus the harmonic-mean $N_e$ make $\bar V_A$ over the coalescent window the
    target.
  - Scope condition 2, stated from the estimator's definition.
  - $c = \bar V_A/\hat V_A$, and that the two comparisons respond to $c$ in opposite directions.
  - **The stationarity the diversity side assumes is what the MSD side tests.**
  - The two $N_e/N$ ratios kept apart, and a notation table (`tab:notation`). The old "Table 1"
    reference pointed at the linked-limits table.
- **Theory, unlinked baseline:**
  - "Exact under long-term equilibrium" (scope condition 1), naming the quantity it needs.
  - Its domain ($V_A \ll 1$, $G = 1$).
  - The decided wording: "no $V_A$ inside the formula's domain produces a hundredfold reduction", with
    $\le 2\times$ at $G = 1 - V_A$.
- **Theory, MSD subsection rewritten:**
  - Kimura's exact $V_A$ is now `eq:VA_MSD`.
  - Lynch & Hill / Mukai / Charlesworth limits.
  - $s^*$ as the DFE arithmetic mean, with the corrected shape argument.
  - The Charlesworth 2015 precedent.
  - Weak branch: $N_e \ll U_d/(2V_A) \approx 3$ for the median population (range 0.6–81). The old
    "5–10" and Appendix D's "about 10" used different premises; both now use $2N_es \ll 1$.
  - $Z = 1 - E[s^2]/E[s]$.
- **Methods rewritten from the data layer:**
  - Bonnet posteriors (mode and HPD); mating system and κ; assemblies and autosomal $L_\text{coding}$
    with the hyena and hihi scaling; both μ estimates carried; $s^*$ over posterior draws; linked
    interference (curated map joins, song-sparrow orthology, 9 mapped populations, 20 Mb filter,
    coding-bp $f_i$, Haldane quadrature, $Z$ grid, consistent $Z$); π (Lewin & Eyre-Walker plus four
    literature values, with caveats) and Buffalo $N_c$ (with caveats).
  - The test in π units; the δ ≥ 1 trichotomy (none of the nine); the $c$ rescaling (Fig. 2); the
    independence audit.
  - Removed: the $M_i = \bar\rho L_i$ approximation, which the code does not do (unmapped chromosomes
    are excluded), and the circular "$s_d$ from $V_m = V_A(1-Z)$" step.
- **Build:** `scratch.tex` and the section files compile with zero errors and zero undefined
  references.

**Logged 2026-08-26** (found while settling the framing).

- **The analysis set is 8 populations, not 19, for anything needing $U_d$, maps or annotations.** The
  three-way `Code` join (`df_va` ∩ `species_EPP.csv` ∩ `master_chromosome_recomb_data.csv`) yields
  **RD, BHS, AB, SSH, CSM, GTU, CF, GTN**. The other eleven are silently dropped (Data flow, below).
  Every result must state which set it uses. For the 8, $V_A$ runs 0.014–0.360, median 0.146 — closer
  to `scratch.tex`'s quoted [0.10, 0.30] than the full 19 are, but still not equal to it.
- **`scratch.tex:235`'s standardisation placeholder is answerable and NOT YET FILLED.** Bonnet et al.
  2022 fitted a zero-inflated over-dispersed Poisson animal model and back-transformed with
  $V_A(w) = \mathbf{d}^\top\mathbf{G}\mathbf{d}$, so the published estimates are already
  observed-scale, mean-standardised additive variance in relative fitness. **No standardisation was
  required.** Say so and delete the placeholder.
- **Appendix D's `[XX]` are computable now and NOT YET FILLED.** From `data/species_EPP.csv` and summed
  `L_coding_bp` with the Methods' own $U_d = 4\mu L_{\text{coding}}$: $U_d = 0.69$–$1.19$ (median
  1.07), $s^* = V_A/U_d = 0.019$–$0.313$ (median 0.145), or median 0.092 at the upper 95% CI on $\mu$.
- **Positive note — Appendix D is internally correct.** Lines 616–698 derive and correctly *label* the
  influx ($V_m = U_ds^2$), the MSD standing variance ($2N_eU_ds^2/(1+2N_es)$) and its strong-selection
  limit ($U_ds$). An earlier note in this file claimed the code confuses $U_ds$ with $U_ds^2$; that
  overstated the problem and has been withdrawn. The remaining code/text divergence on this axis is the
  hardcoded `s_het` (logged 2026-07-29), not a scale error.

## Data flow

```
genomic_data/<species>/ncbi_dataset/...
   │  data_gen_2.R  (rtracklayer/GenomicRanges: physical length, reduce()d CDS bp, gene count)
   ▼
data/raw/clean_chromosome_data.csv
   │  inner_join recomb_data.csv on (Species_code, NCBI_Chromosome); Total_cM/100 → M_morgans
   ▼
data/master_chromosome_recomb_data.csv
   ├── unlinked.R  → unlinked-only Ne/N across κ models
   └── data_gen.R  → full linked+unlinked model
```

- **`Code` is the join key** across `df_va`, EPP data, and chromosome data; the analysis set is the
  `intersect()` of all three, so a species missing from any one is **silently dropped**.
  `recomb_data.csv` uses different `Code` values (`bsR` vs `BHS`) — the join that matters is on
  `Species_code`/`NCBI_Chromosome`.
- **`data_gen_2.R` falls back** to ranking largest coding scaffolds as pseudo-chromosomes when an
  assembly has no assembled molecules or GTF IDs don't match TSV accessions — check `Assembly_Level`
  before treating a row as a real chromosome.

## Build / run

R 4.6.0 (`Rscript`) and Python 3.14 are on PATH. **TinyTeX is installed** at `%APPDATA%\TinyTeX`
(TeX Live 2026) — `pdflatex`, `latexmk`, `bibtex` all work. **Restart the shell / RStudio after any
tlmgr install** to pick up PATH changes. Raw `pdflatex` does **not** auto-fetch missing `.sty` files —
install them explicitly, e.g. `tinytex::tlmgr_install("units")`, which is what supplies `nicefrac.sty`
(required by `main.tex` and **not** in TinyTeX's default set).

`manuscript/references.bib` covers `main.tex`'s 7 works (verified against Crossref), wired with
`natbib` + `plainnat` + `\citet{}`. **`scratch.tex` has ~91 prose citations and no `\bibliography`
block** — still unwired; its citations are plain prose, not `\cite` commands. They get converted to
`\citet{}` and folded into `references.bib` **as each section is backported** — see Rule 6 for the
machinery-vs-content split.

```sh
# R model (from repo root, interactively): source unlinked.R, then data_gen.R
cd manuscript/figures && python make_figures.py   # appendix PDFs (SUPERSEDED — see Rule 8)
cd manuscript && latexmk -pdf main.tex            # manuscript; runs bibtex itself
cd manuscript && latexmk -c                       # drop build intermediates
```

## Sign-off process

**Invocable as `/signoff`** (`.claude/skills/signoff/`), which points back here — this section stays the
source of truth.

**Run this at the end of every working session.** The point is that this project's durable memory is
**this file**, not the chat: decisions made in conversation are lost unless written down, and a
decision that changes framing or emphasis with no artifact yet is exactly the kind that vanishes. Work
through the checklist in order and **report each item explicitly** — including the ones that need no
action, so the user knows they were checked.

1. **Record decisions.** Any framing, scope, emphasis, or convention decision reached in conversation
   goes into the relevant section here (**Project framing**, **Rules**, **Model conventions**) with the
   date. **A decision that exists only in the transcript did not happen.**

2. **Record newly found staleness (Rule 5).** Any `scratch.tex` ↔ R code divergence, or internal
   inconsistency inside `scratch.tex`, discovered during the session gets written down — **even if not
   fixed**. Do not leave it in prose in the chat.

3. **State backport position (Rule 6).** Which section/subsection is in flight, what landed in
   `main.tex` this session, what is next.

4. **Check the manuscript still builds.** `cd manuscript && latexmk -pdf main.tex`, then confirm
   **zero** `Citation ... undefined` in `main.log`. Exit code 0 alone is **not** sufficient — a missing
   key still produces a PDF, just a wrong one. Then `latexmk -c`.

5. **Sync `references.bib`.** Every `\citet{}`/`\citep{}` added this session has an entry, and every
   new entry was **verified against Crossref**, not written from memory. Flag anything unverifiable
   with `% UNVERIFIED:` rather than inventing a volume or page range.

6. **Report git state.** `git status --short`. Do **not** commit unless asked. Call out untracked build
   products (`manuscript/*.pdf` is not gitignored) and any Google Drive `~$*` lock files or `* (1)*`
   conflict copies that appeared.

7. **Hand off the open thread.** Name the single next action and the blocking unknown, if any. Keep
   **Open work the pivot creates** current: strike what is done, add what the session surfaced.

## Filesystem notes

The repo lives inside a Google Drive folder. `~$*.xlsx`/`~$*.pptx` lock files and `* (1)*` conflict
copies appear routinely — the conflict copies are gitignored, the lock files are not. `.gitattributes`
routes `*.fna`/`*.gff` through Git LFS; large TIFFs (up to ~30 MB) are nonetheless committed under
`main/`, `supp/`, and `manuscript/figures/`. `.RData`/`.Rhistory`/`.Rproj` and LaTeX build artifacts
are gitignored. **Built PDFs (`manuscript/*.pdf`) are gitignored as of 2026-07-29** — reproducible from
source. That pattern matches direct children only, so the tracked `manuscript/figures/*.pdf` are
unaffected. `.claude/settings.local.json` is also gitignored (per-machine permission grants);
`.claude/skills/` **is** tracked. (`data/figures.tiff` was deleted 2026-07-29 as a confusing stray; do
not recreate it.)

## Git workflow

**Plan and execute in a worktree; merge only on the user's say-so** (changed 2026-10-14, replacing the
2026-07-29 commit-to-`main` rule). An agent may create a worktree under `.claude/worktrees/`, do the
work there and commit it on the worktree branch. Nothing reaches `main` until the user has reviewed it
and **explicitly** asks for it to be merged into `main` and checked out in the main checkout. Pushing
`main` still happens only when the user asks.

Two consequences to keep in mind, both from the 2026-08-26 lesson below:

- **One open worktree per thread of work, merged or abandoned promptly.** The failure mode was
  worktrees accumulating divergent `scratch.tex` edits that never merged. When a worktree is
  abandoned, tag its tip (`archive/<name>`) before deleting the branch.
- **Uncommitted changes in the main checkout block the merge.** If the worktree carries a file that is
  also modified in the main checkout (typically this file), say so in the hand-off. The main copy must
  be discarded or committed before `git merge` will run.

### Overleaf sync hazard — near-miss 2026-09-03

**Commit and push local work *before* syncing Overleaf with the GitHub remote.** On 2026-09-03 an
Overleaf sync commit arrived via `origin`; GitHub Desktop auto-stashed the entire working tree to make
room for the fast-forward, and the stash was then dropped. Because GitHub Desktop stages untracked
files, the stash swept up **everything uncommitted** — not just modified tracked files: this file's
settled framing (uncommitted for eight days), `walid_authorial_style_guide.md`, every planning document
under `manuscript/*.md`, the whole `poster/` tree, and `science.abk0853_data_s1/`.

Recovery worked only because the dropped stash commit had not yet been garbage-collected and its hash
had been captured minutes earlier. It is preserved as the tag **`recovery/stash-2026-09-03`**.

Three durable points:

- **A dropped stash is unreachable within seconds and invisible to `git stash list`.** If it happens
  again, get the hash from `git reflog` or `git fsck --lost-found` and **tag it immediately**, before
  anything else.
- **Restore surgically, never `git stash pop`.** The Overleaf commit was *ahead* of the stash for
  `manuscript/scratch.tex` (it carried the new Introduction and T1), so popping would have reverted
  real work. Restore file by file with `git checkout <tag> -- <paths>`, then `git reset -q` to unstage.
- **Long-lived uncommitted changes to this file are the standing risk.** It is the project's durable
  memory, and it is exactly what a routine pull takes.

### Worktree branches — resolved 2026-08-26

The three unmerged worktrees under `.claude/worktrees/` were disposed of on 2026-08-26. Their
`scratch.tex` versions were parallel edits of `f6a80fb`, not a sequence, so there was no single latest
copy. `worktree-prose-edit-scratch` touched every paragraph of the main body (intro → theory → methods
→ results → discussion) with **prose-only changes, no math**, and strictly superset the intro/discussion
coverage of the F3 re-cut; **its `manuscript/scratch.tex` was adopted onto `main`** and is the current
working copy. The other two were F3-framing work, and F3 is dead.

All three tips are preserved as tags — `archive/prose-edit-scratch`,
`archive/f3-reframe-intro-discussion`, `archive/f3-structural-blueprint` — because **deleting an
unmerged branch makes its commits unreachable; a tag keeps them.** The branches and worktrees are
gone. `origin/worktree-f3-structural-blueprint` still exists on the remote and was left alone.

**Lesson worth keeping:** three worktrees accumulated a month of divergent `scratch.tex` work that
never merged. The 2026-10-14 rule above permits worktrees again, but only with prompt merge-or-archive.

Also noted: `~$species.xlsx` and `~$unlinked.pptx` (Google Drive / Office lock files) are **tracked**
in git, not merely un-ignored. They should almost certainly be `git rm --cached`'d and added to
`.gitignore`. Not done — needs a decision.


# CLAUDE.md — project#3

Theory + comparative-empirical manuscript in evolutionary genetics targeting **GENETICS (GSA)**. It
takes additive genetic variance in relative fitness ($V_A$) measured in wild pedigrees and puts it
through two equilibrium tests: propagated to neutral diversity it is **too small** to explain the
deficit these populations show; set against mutation–selection–drift balance (MSDB) it is **too
large** to be maintained.

Outputs are publication figures, summary CSVs and the manuscript. No build system, no test suite.
History (old framings, dated session logs, superseded numbers) was cut from this file on 2026-10-27
and is recoverable with `git log -p -- CLAUDE.md`. **Do not reconstruct retired framings.**

## Project framing — settled. If a claim is not here, it is not a claim of this paper.

### The claim

> **The additive genetic variance in fitness measured in wild pedigrees is too small to explain the
> neutral diversity these populations are missing, and too large to be maintained at
> mutation–selection–drift balance.**

One measured quantity, two equilibrium tests, opposite verdicts.

**Title:** *Heritable variance in fitness in wild vertebrates is too small to explain their missing
neutral diversity and too large for mutation–selection balance.*

**Background organisation.** The work is about the **effect** and the **maintenance** of heritable
variation in fitness; the Introduction presents one literature for each. Precedents: effect —
Buffalo & Kern 2024 (humans), Buffalo & Coop 2019/2020 (*Drosophila*); maintenance — Charlesworth
2015 (PNAS 112:1662, *Drosophila*; acknowledge plainly, do not borrow significance; Johnson & Barton
2005 related). Originality: (1) the same tests applied to wild vertebrates with directly measured
total-fitness $V_A$; (2) the analysis centres on how a pedigree snapshot must be scaled,
$c = \bar V_A/\hat V_A$, to fit each model. Buffalo 2021 is a locating citation only. Connallon &
Czuppon 2026 (*Evolution* 80:926, verified) makes no quantitative comparison of Bonnet's $V_A$ with
$U_d s$.

**Introduction rules:** before the last paragraph, only published derivations and results (no κ,
$V_{A,\max}$, $s^*$, $c$). Results only in the last paragraph, GENETICS-style. Each background
paragraph ends on the gap it leaves for wild vertebrates. Fisher is not named before the Discussion.

### Why it holds together (all three must survive any edit)

1. **Both tests target the same quantity** — long-run equilibrium additive variance in relative
   fitness, $\bar w = 1$. Same currency, same timescale class.
2. **No single bias in the estimate reconciles both.** Inflated $V_A$ shrinks the MSD discrepancy and
   grows the diversity one, and vice versa. **This is the paper's spine** — robust to the standard
   criticism of pedigree $V_A$.
3. **The two ends do not meet.** Under the multiplicative bound, a deficit $1/\delta$ needs
   $V_A \ge \ln(1/\delta)/(4\kappa_\text{max})$: ~1.15 for 100×, ~2.3 for 10⁴× under random mating
   (half with a pair bond), **1.1–1.7 for the nine observed deficits**. MSD needs $V_A \lesssim 10^{-2}$.
   At measured values the small-variance form gives $N_e/N$ = 0.22–0.99 (median ~0.6); the
   multiplicative model agrees except where $\hat V_A > 0.25$. The first-order inversion's "12–25" /
   "29–6,000" is outside its domain and **must not be quoted**.
   **Present the snapshot problem through $c$** (Fig. 5; Table 1 `tab:c` reads $c$ as a diagnostic of
   non-equilibrium). Diversity needs $c \approx 9$ on average (2.4–80, median 14). MSD, evaluated at
   each population's assigned empirical $\bar s$ (`data/dfe_assignment.csv`), needs $c \lesssim 0.024$
   on average (0.0017–0.11): a gap of ~390× on average, 108–1,890× per population. No single $c$
   satisfies both.
   **D2:** $\pi$ reflects a harmonic-mean $N_e$ over ~$4N_e$ generations, so the target is the
   time-averaged $\bar V_A$ over the coalescent window (`eq:harmonic`; $1/N$-weighted if $V_A$ and
   $1/N$ covary). Under the exponential form Jensen makes a fluctuating $V_A$ remove at least as much
   diversity as its mean. **Make explicit that the stationarity the diversity side assumes is what
   the MSD side tests.**

**Fisher's theorem is not part of the claim.** FTNS is single-generation and escapable (the
deterioration-of-environment term can absorb the gain); the diversity consequence is not. That
asymmetry is a Discussion interpretive point, never a premise.

### Numbers in hand

**Diversity side.** 19 posterior modes of $V_A$ (`alldistzip`): min 0.0029, Q1 0.0172, median 0.0997,
Q3 0.2484, max 0.4970. Multiplicative exact $N_e/N$ median ~0.53, min 0.021 (Muro blue tit, 47×);
bound min 0.019. Observed deficits for the 9 populations with $\pi$ and Buffalo $N_c$ (6 species; 4
use literature $\pi$, `data/pi_literature.csv`): **230× to 38,000×**. Least $V_A$ needed 1.1–1.7,
above every upper 95% HPD (max 0.70); at the modes the bound falls short by 80× (bighorn) to 31,000×
(great tits, Hoge Veluwe). Per population: `scripts/R/tab_reduction.R` →
`manuscript/tables/tab_reduction.tex`.

**MSD side** (18 populations, autosomal $L_\text{coding}$, $U_d = 4\mu L_\text{coding}$, both μ):
$U_d$ 0.34–1.26 (direct μ). $s^* = V_A/U_d$ median 0.16 (phylo 0.115). $P(s^* > \bar s) \ge 0.89$ in
17 of 18 (snow vole 0.70); $s^*/\bar s$ median 18 (0.45–480); mode exceeds $U_d\bar s$ in 16 of 18,
median 21×. $2N_es^*$ = 2,900–320,000 (11 populations): strong-selection limit holds.

**Linked (assigned DFE, `linked.R`):** total $N_e/N$ at the mode — great tits 0.019 (Wytham), 0.44
(NL); song sparrow 0.077; collared flycatcher 0.68; mammals 0.24–0.48. Every population falls short
of its observed δ across its whole HPD. At $c = c_\text{MSD}$ linkage barely changes the prediction
(deficit ratio 4,240 vs 4,430). The linked term is a **hybrid**: kernel, $Z_k$, $\nu_k$ presuppose
MSD; the amount of variance is the **measured** $\hat V_A$ ($v_i = \hat V_A f_i$).

**Units.** Bonnet et al. 2022 fitted a zero-inflated over-dispersed Poisson animal model and
back-transformed with $V_A(w) = \mathbf d^\top\mathbf G\mathbf d$, so the estimate is observed-scale,
mean-standardised additive variance in relative fitness — exactly SC's $C^2$ (random mating) and
Appendix D's currency. **Nothing to rescale.**

### Scope conditions — state in the manuscript at the point of use

1. $N_e/N = 1/(1+Q^2V_A)$ needs **fixed additive effects**, and then only $\bar V_A$ enters. Breaks
   when an allele's effect depends on its own frequency (underdominance, stabilizing selection).
2. **Bonnet's $V_A(w)$ is single-generation and environment-conditional by construction** ($\mathbf d$
   evaluated at the observed state). The mismatch is visible in the estimator's definition — not a
   criticism of Bonnet et al.
3. **Two persistence windows.** $Q = 2$ needs the sign of advantage to persist ~2 generations (holds
   under MSD, sweeps, fluctuating selection); $\pi$ needs ~$4N_e$. SC's formula gives the *size* only
   under steady retention and **Barton's condition** (allele frequencies change little while an
   association persists; Barton 2000, `11127900.pdf`). That is not stationarity of $V_A$; the
   infinitesimal model meets it for any selection. MSDB uniquely adds a $V_A$ constant over the
   window. Fluctuating balanced polymorphisms may reduce diversity beyond inherited variance —
   **the one open route by which the diversity verdict could be too generous**, stated as an open
   question in the Discussion.
4. **Census timescale mismatch** (MWPG 2026): $\pi/4\mu$ is long-run, census $N$ is contemporary.
   Record the instrument per population.
5. **Non-equilibrium populations are excluded, not explained.** δ ≥ 1 is a failed model check.
   Report the trichotomy (uninformative / violation / consistent) and how many fell out.
6. **Stage of life.** Zero LBS is 53% (baboons) to 96% (Muro blue tits) of records. $N$, $Q$, $Z$
   refer to breeders. Heritable pre-breeding survival is **flagged, not analysed** (its $Q \approx 1$,
   so the mapping overstates it unless survival and fecundity are negatively correlated).

**Bias directions (Methods table).**

| effect | on $\pi_\text{obs}$ | on δ | apparent diversity gap |
|---|---|---|---|
| $N_{eC}$ > contemporary $N$ (bottleneck, fragmentation) | ↑ | ↑ | narrows |
| cryptic immigration | ↑ | ↑ | narrows |
| census timescale mismatch | — | ∓ | either way; state instrument |
| total $N_c$ instead of breeders (×2–10) | — | ↓ | widens |
| Buffalo bird $N_c$ (length-predicted mass, ~1.2 orders low) | — | ↑ | narrows |
| BGS at "neutral" sites | ↓ | ↓ | widens |
| μ misestimated | — | ∓ | does not close the gap |

### Notation — use without exception; one symbol, one meaning; never import another paper's notation

| symbol | meaning |
|---|---|
| $N$ | breeding adults (Robertson / SC's $N$) |
| $N_c$ | total census (Buffalo 2021) |
| $\pi$, $\mu$ | neutral autosomal diversity; per-site per-generation mutation rate |
| $N_{eV}$, $N_{eC}$ | variance effective size; coalescent effective size, $\pi = 4N_{eC}\mu$ |
| δ | $\pi_\text{obs}/(4\mu N)$, derived |
| $V_A$ | additive variance in relative fitness, $\bar w = 1$ |
| κ, κ(α), $\kappa_\text{max}$ | mating-system scalar: 1 random mating; $\kappa_B = 2 - \tfrac32\alpha + \tfrac58\alpha^2$ under social monogamy; $\kappa_\text{max}$ = 2 with pair bond, 1 without (Weissman & Barton 2012) |
| $V_{A,\max}$ | small-variance ceiling $(1-\delta)/(4\kappa\delta)$ (Appendix A.2) |
| $V_{A,\delta}$ | $\ln(1/\delta)/(4\kappa_\text{max})$, least variance that could explain δ |
| $Z$, $Z_k$ | retention (SC 1995's $G$, named once as theirs); $Z_k = 1 - s_k$ per class |
| $Q$ | unlinked transmission factor $2/[2 - Z(1+r_{mf})]$, = 2 at $Z = 1$ |
| $z$, $a$ | breeding value for log-fitness ($w \propto e^z$); $a = z - \bar z$ to first order |
| $R(z)$ | expected long-term contribution, $\exp[2(z-\bar z) - 2V_A]$ |
| $L_X$, $h_t$, $x_i$ | Appendix B/A quantities (first-order excess, carriers' breeding value, neutral frequency) |
| $\rho = (1-r)Z$ | linked persistence; kernel $1/(1-\rho)$ |
| $M$, $M_i$; $r$; $r_{mf}$ | map length (Morgans) only; recombination fraction only; mates' correlation (0 in primary) |
| $\overline{Q^2}_i$, $\overline{Q^2}(y)$ | position-averaged $Q^2$ on chromosome $i$ (not "interference", which reads as crossover interference); profile at $y$ (bare $Q^2$ = unlinked constant) |
| $s, s_k, \bar s, s^*$; $\varphi_k$; $\nu_k$ | heterozygous effect; DFE density/fractions; class share of $V_A$, $\varphi_ks_k/\bar s$ |
| $m'$, $f'$ | social partner (Appendix B) |
| Γ, η, ε; Λ; Ψ, χ, ξ, $m_X$; $n_i$ | Appendix C.2 constants; C.5 exponents; Appendix B coefficients; C.6 element count |
| $C^2$ | SC's family-fitness variance: $V_A$ random mating, $2V_A$ with a pair bond |

Retired: $Q_u$, $Q(s)$, $t$, $s_\text{het}$, $\overline{Q^2}_\text{linked}$, $\kappa_\text{mult}$ /
κ(0) (now $\kappa_\text{max}$), Woolliams/B&E symbols. No symbol for LD ($D$ unused).

**Selection regimes have three named axes.** "Strong/weak" = against drift only ($4N_es$). Purging
rate $s$ = "fast/slow purging". $V_A$ vs 1 = "small variance" / multiplicative. Never a bare
"strong/weak" for the other two.

**Ancestor-centered vs gene-centered perspectives** (American spelling; "perspectives", never
"readings") — point out where it helps.
Ancestor: $R(z)$ and drift from its variance (Robertson; Wray & Thompson 1990). Gene: a neutral
copy's association with its background summed over generations ($Q$). Barton & Etheridge 2011 is the
bridge citation. They coincide at unlinked sites (why the global $N_e$ is global) and part under
linkage, the homologous haplotype, and the social partner. Consequence: a pedigree supplies all the
global reduction needs; the local reduction needs segment inputs ($f_i$, $Z_k$), which is why MSDB is
required only there.

### Wording conventions — every section, figure, caption

- **$N_e/N$, never $N/N_e$**; bounds as "$N_e/N$ is at least 0.22". R columns `reduction_*` are
  $N/N_e$ — convert before quoting. Every "$N_e/N$" says which: **demographic** $N_{eV}/N$ (0.1–0.5)
  or **diversity** $(\pi/4\mu)/N_c$ ($10^{-2}$–$10^{-5}$; δ is this one).
- **"Test", never "comparison"**; passed where its ratio ≤ 1.
- **"Random mating"** (κ = 1) vs "social monogamy" / "strict monogamy" (α = 0). Pairing at random
  w.r.t. breeding value ($r_{mf} = 0$) keeps its own wording.
- Three forms: **small-variance approximation** $1/(1+4\kappa V_A)$; **multiplicative model** (exact
  under $w \propto e^z$); **multiplicative bound** $e^{-4\kappa_\text{max}V_A}$. Never "first order",
  "all orders", "upper bound on the reduction" in prose/captions/labels; in appendix derivations,
  "for small $V_A$".
- No "enter(s)" / "fall(s)". No constraint jargon ("does not bind").
- Cut sentences that only restate Methods or Theory.
- **Discussion: no figure citations.** Work as agent ("we", "our") at paragraph openings; mechanism
  in main clause, consequence in a so/which/because clause; **no mirrored sentence pairs**; no
  signpost/enumeration sentences; close paragraphs on an implication; at most one short punch
  sentence every two or three paragraphs.
- **Two levels of selection.** "Directional" only for phenotypes. Alleles: "purifying" / "positive".
  Never "directional sweeps". At MSDB, $U_d\bar s$ is the variance, the per-generation gain, and the
  mutational loss that cancels it.
- No footnote distinguishing our κ from Buffalo & Kern's.
- **LD:** the neutral–selected association is linkage disequilibrium, defined in Introduction ¶3
  (Barton 2000; applies to unlinked sites too) and Theory `sec:unlinked`. Use "LD" where its decay is
  the point; elsewhere "association".
- **No "clause: clause" colons** (semicolons fine). Colons for displayed equations, definitions,
  lists stay. Merge through syntax, not colons.
- Small-variance ceiling range: "a population that retains at least $1/(1+4\kappa)$ of its neutral
  expectation, about a fifth under random mating and a ninth under strict monogamy".
- Report the per-population test in π units ($\pi_\text{pred} = 4\mu N(N_e/N)_\text{pred}$ vs
  $\pi_\text{obs}$); δ stays as the x-axis of the ceiling curve.
- **Default to merging and compacting sentences rather than asking**; ask only about real content cuts.
- **Discussion vs Results (2026-10-27):** every number first appears in Results (or Theory, if
  derived); Results carry no literature-interpretive or summary sentences. Discussion order is fixed
  in the header comment of `discussion.tex`; each cited work in one paragraph; no figure or table
  citations; ~1,800 words (exemplar 1,184, wider audience).
- **Headings (2026-10-27):** sentence case everywhere, appendices included. Say "at unlinked / linked
  sites" in headings, not "global / local" (defined only inside Theory `sec:unlinked`). Ω is "the
  linked factor", never "penalty". "Long-term", never "long-run". Results headings are declarative
  findings; Methods names each test it runs ("Maintenance test", "… and the diversity test").
- **Diction (author's Overleaf pass, adopted 2026-10-27).** No "read" for "interpret" (or "read the
  other way"/"read forward"); no "run(s)" for ranges ("ranges from") or directions; name the noun
  rather than a distant "one"; "a single" for the determiner "one"; "requires" not "needs";
  "offset" not "cancel"; "amplifies" for linkage's effect (not "deepens"/"exacerbates"); "resolve"
  not "close" a gap; "predicted" wherever a model output could be read as observed. Results and
  Theory use $\hat V_A$ / $\bar V_A$ / $Z$ for the quantities; Discussion and Abstract keep words.
  The verdict wording is "too small" (never "too restricted"). Comma after an introductory phrase
  that precedes math.
- **"Biased toward passing"** is the one phrase for approximations chosen to favor a test (not
  "optimistic", "most favourable to explaining").
- **Captions:** bold first sentence stating the figure's claim (supersedes the 2026-10-23
  "descriptive caption" choice), then description; no formulas, equation refs or citations beyond
  what defines a plotted quantity. Fig. 3 / Fig. S4 linkage color is "green".
- **rmt-pca voice items adopted 2026-10-27:** a question opener at most once in Results
  (`sec:res_deficit`); graded plausibility diction ("large but not inconceivable"); an
  "Intuitively," sentence after a formal result; derived (not data) worked numbers allowed in
  Theory; underbraced factor names in `total_red`; "we" only in Results setup sentences; one
  forward bridge at the hinge between the two tests (end of `sec:res_ceiling`). Not imported:
  sentence-initial "Thus/However", "i.e./e.g.", formulas in captions.

### Supporting results — real, not the identity (never in title or abstract's first paragraph)

- **$V_{A,\max}(\delta)$ / $V_{A,\delta}$ curves** — reusable; publish as curves. Not currently
  exceeded: 0 of 19 at δ ≤ 0.2, 2 at 0.25–0.3, 5 at 0.5, 15 at 0.9; every observed δ is far below.
- **$\overline{Q^2}$ along a Haldane map** — closed form (dilogarithm). Method, not finding.
- **κ(α)** — makes $N_e/N$ consistent with Bonnet's single $V_A$ across sexes and mating systems.
  Built on Woolliams, Bijma & Villanueva 1999 and SC 1995. Supplementary.
- **DFE on the MSD side** — strong-selection $V_A = U_d\bar s$ whatever the shape, so $s^*$ estimates
  the arithmetic mean; leptokurtosis lowers sustainable $V_A$ only via nearly neutral classes. Not
  "large-effect alleles dominate $V_A$".
- **Independence of inputs from diversity data** — short Methods subsection; not a gap being filled.

**Novelty ledger (keep derivations only for these):** EPP bracket at all orders (Appendix B.4);
κ(α) Models A/B and the own/partner/cis split; Haldane position averaging, linear lower bound,
Ω ≤ 1, spatial result (Appendix C); `eq:compat` and the $c$ framework. Everything else is cited
(Robertson; SC 1995/1998; B&E 2011; W&B 2012; Wray & Thompson 1990; de Villemereuil 2016; Appendix D
sources).

### Retired claims — do not let these come back

| retired claim | why dead |
|---|---|
| "The two routes fail in opposite directions" (vs Buffalo 2021) | borrowed significance |
| "Prediction overshoots diversity by 2–3 orders" | model removes at most ~20× |
| "Published pedigree estimates exceed $V_{A,\max}$" | 0 of 19 at δ ≤ 0.3 |
| "The bound binds only the directional component" | fluctuating selection still erodes diversity |
| Circularity of diversity-calibrated estimates as the motivation | Methods strength only |
| Lewontin's paradox as thesis; Buffalo 2021 as foil | locating citations only |
| Balancing/fluctuating selection as an escape from the diversity ceiling | MSD side only |
| Opportunity for selection $I$, any $V_A \le I$ argument | struck by user |
| FTNS co-requiring the long-run quantity | FTNS is single-generation |
| "$N_e/N \ge 1/2$" ($G = 1 - V_A$) | additive-map artifact; Appendix A.4 remark only |
| "$V_{A,\max}$ = 29–6,000" / "needs $V_A \gtrsim 12$" | first-order inversion outside domain |

**Recurring failure mode:** borrowed significance — positioning the work as the answer to someone
else's open challenge (Buffalo, Lewontin, Charlesworth/Connallon & Czuppon). **Standing test:** remove
Buffalo 2021, Lewontin-as-thesis, Charlesworth 2026 — still interesting? If not, it is decoration.
Connallon & Czuppon and Charlesworth 2026 explain *how* large $V_A$ is maintained; this paper takes
$V_A$ as input. Not competitors.

### Data decisions

- **κ:** Model B primary, Model A sensitivity; κ = 1 for non-monogamous systems; κ_B 1.32–1.86 for
  socially monogamous populations. EPP rates and sources in **`data/epp_sources.csv`** (BTP 0.25 and
  BTM 0.18 per-site assignment unconfirmed; needs Charmantier et al. 2004).
- **μ:** both `mu_phylo` (Wang & Obbard 2023) and `mu_direct` (Lewin & Eyre-Walker 2026) carried, not
  averaged.
- **$U_d$ autosomal only.**
- **$N_c$:** Buffalo 2021 published values, own species only (10 of 19); no reimplementation, no
  breeder-fraction $N$ for the preprint. State the bird-density caveat and that his *Ovis aries* is
  domestic sheep.
- **DFE: one per population on both sides** (`dfe_assigned()` in `linked.R`,
  `data/dfe_assignment.csv`): collared flycatcher own; other passerines pied + collared flycatcher
  ($\bar s$ = 0.0013); bighorn, Soay, red deer, hyena, meerkat vaquita + fin whale (0.0195); macaque,
  baboon human (0.0139); rodents house mouse. Lin et al. 2026 $|s|$ is heterozygous.
- Linkage maps are sex-averaged; coding-bp $f_i$ is primary, gene count supplementary.
- **Analysis sets:** 19 for $V_A$-only/unlinked; "deficit set" (9, with π and $N_c$); "mapped set"
  for linked. Say which set each result uses.

### Missing / open work

1. **$\pi_\text{obs}$ and census $N$** for more populations — the only blocking unknown.
2. Re-voicing of all sections by the author (Introduction, Theory, Results, Discussion and Abstract
   are drafted scaffolding).
3. Methods reviewer pass.
4. **Citations are still prose** in every section; `references.bib` is built by the user. Pending
   Crossref-checked entries: Robertson 1966, Price 1970, Morrissey et al. 2010, Merilä et al. 2001,
   de Villemereuil et al. 2020, Wittmann et al. 2023, Charlesworth & Jensen 2022, Pannell &
   Charlesworth 2000, Whitlock & Barton 1997, Nei & Murata 1966, Woolliams et al. 1993. Unverified:
   Matheson & Masel 2024 (*GBE* 16:evae050), Murphy et al. 2023, Frankham 1995, McVicker et al. 2009,
   Johnson et al. 2026 (G3 version), Chen et al. 2019, EPP sources, Kruuk & Hadfield 2007, Stopher et
   al. 2012, Baud et al. 2022, Mawass & Milot 2025, Engen et al. 2005, SC 1998 Eq. 8, Kimura 1969
   equation number, and (added to the Discussion 2026-10-27, from memory) Burt 1995, Hendry et al.
   2018, Bürger & Lynch 1995, Lande & Shannon 1996. Barton 1998 not yet read.
5. **SLiM test** (once installed): additive vs multiplicative maps at $V_A$ = 0.01–1.5, measuring
   $N_e$ directly, fitness truncation; monogamy + EPP under Models A and B.
6. Supplementary figures `figS_gap.R`, `figS_rescaling_linked.R` not restyled to `theme_genetics.R`.
7. Author's own clause-colons in Theory not yet removed.

## Venue and prose authority

- **GENETICS (GSA)**; fallbacks Am Nat, Evolution Letters. Figures follow `scripts/R/theme_genetics.R`
  (lowercase panel letters, vector PDF, 7–8 pt Arial, colour-vision-safe, "Species (Location)" via
  `pop_label()`).
- **Preprint send list:** Aaron Ragsdale (UW–Madison), Arslan Zaidi (U Minnesota).
- **Poster** (`poster/`, MWPG 2026) is **frozen** and one framing behind. Do not edit
  `poster/make_poster.py` or `scripts/R/poster_figs.R` unless asked.
- **Prose authority: `walid_authorial_style_guide.md`** (repo root, untracked). Mechanism-first
  subjects, colon-delivered definitions, named systems, consequences not wrap-ups, few em-dashes.
  Generated sentences are scaffolding; the voice is the author's. **The style guide's Appendix is a
  voice benchmark, not a claims source** — several of its sentences assert retired claims.
- GENETICS exemplar: `iyag180.pdf`.

## The model in one screen

1. **Unlinked baseline** — genome-wide $V_A$ depressing $N_e$ (small-variance form and
   multiplicative model, one model family matching Bonnet's log link).
2. **Mating-system scalar κ(α)** — modulates the unlinked term by EPP rate α.
3. **Linked term** — chromosome-local variance $v_i$ over map length $M_i$, via position-averaged
   $\overline{Q^2}$; exponential composite
   $(N_e/N)_i = \exp\{-[\kappa_\text{cis}\overline{Q^2}_iv_h + Q^2(\kappa V_A - \kappa_\text{own}v_h)]\}$,
   so Ω ≤ 1 is immediate.

## Layout

```
project#3/
├── alldistzip                 # Bonnet et al. 2022 MCMCglmm posteriors (load()ed)
├── science.abk0853_data_s1/   # Bonnet pedigree archive (raw LBS, Ainv_*) — NOT diversity data
├── scripts/R/
│   ├── 00_prepare_data.R → data/processed/  (read via load_data.R)
│   ├── kappa.R           # κ, Q, N_e/N functions — single source, source it, never re-type
│   ├── linked.R          # linked analysis (DFEs, Haldane Q², ne_linked)
│   ├── theme_genetics.R  # figure style
│   ├── fig1_unlinked.R … fig5_rescaling.R → main/Fig1–5
│   ├── fig2_linked.R also → supp/FigS_omega, FigS_linked_fgene
│   ├── figS_gap.R, figS_rescaling_linked.R → supp/
│   ├── tab_reduction.R   → manuscript/tables/tab_reduction.tex
│   ├── unlinked.R, data_gen.R, data_gen_2.R, supp_fig.R   # LEGACY (see Rules)
│   └── poster_figs.R     # poster only
├── data/                  # species_EPP.csv, epp_sources.csv, dfe_assignment.csv,
│                          #   pi_literature.csv, master_chromosome_recomb_data.csv, processed/
│   └── raw/               # ARCHIVE, not input
├── genomic_data/          # NCBI annotations (gitignored)
├── main/, supp/           # results figures
├── poster/                # frozen
└── manuscript/
    ├── _main.tex          # ROOT. latexmk -pdf manuscript/_main.tex (from repo root)
    ├── abstract, introduction, theory_model, methods_materials, results,
    │   discussion, add_info .tex     # WORKING COPIES — edit these
    ├── supp/appendix_A–D.tex, notation.tex, supp_figures.tex
    ├── tables/, references.bib (shared, growing — extend, never replace)
    ├── main.tex           # old Overleaf root; delete once Overleaf points at _main.tex
    ├── scratch.tex        # STALE since 2026-10-17 — do not edit
    ├── scratch_ulises.tex # parked rigorous MSD derivation; do not fold in unless asked
    └── scratch_review.tex, rho_mf_derivation.tex, figures/, misc/   # history; do not action
```

## Rules

1. **The section files under `manuscript/` are authoritative**; `scratch.tex` is stale. Where R code
   and the manuscript disagree, the code is stale and is updated to match.
2. **Run R from the repo root.** Figure scripts write into CWD or `main/`/`supp/`; check before
   assuming a committed TIFF traces to a same-named script.
3. **Legacy scripts:** `data_gen.R` is not the linked pipeline and cannot run clean (line 479 drops
   `mu_1` and selects nonexistent `Species.y`; fix = match line 86). Its Z (`1 - Vm/Va`), hardcoded
   `s_het`, 20 Mb filter and CNE multipliers are stale. `unlinked.R` must be sourced before it.
   `data_gen_2.R` hardcodes a wrong `root_dir` (guarded).
4. **Figures are wired** in the `_main.tex` tree: Figs 1–5 in `results.tex`, S1–S4 in
   `supp/supp_figures.tex`, cited by `\ref`.
5. **Model conventions in code:** κ only from `kappa.R`. Any "V_A needed for a deficit" uses
   `vamax_mult` with `kappa_mult_bound` (= $\kappa_\text{max}$), never the first-order inversion.
   Code names differ from manuscript symbols: `G`/`G_correct`/`G_sym` mean $Z$; `Qu2()` is $Q^2$;
   `kappa_pair(..., rho)` is $r_{mf}$, its `Phi` is Ψ. `reduction_Gsym` is kept only for the A.4
   remark. $v_i = V_A f_i$, halved ($v_h$) for the focal haplotype.
6. **Never end an Edit insertion with a comment line in the middle of a paragraph** — it swallows
   the following prose into a LaTeX comment.
7. **Build check:** `latexmk -pdf manuscript/_main.tex`; confirm zero undefined references/citations
   in the log (exit 0 is not enough), then `latexmk -c`. Built PDFs are gitignored.

## Build / run

R 4.6.0 and Python 3.14 on PATH. TinyTeX at `%APPDATA%\TinyTeX`; install missing `.sty` explicitly
(`tinytex::tlmgr_install(...)`) and restart the shell afterwards.

## Git workflow

- **Work in a worktree under `.claude/worktrees/`, commit there; merge into `main` and push only when
  the user explicitly asks.** One worktree per thread, merged or abandoned promptly; tag abandoned
  tips `archive/<name>` before deleting.
- Uncommitted changes in the main checkout (typically this file) block merges — say so at hand-off.
- **Overleaf:** commit and push local work *before* syncing. Sequence that works: push from Overleaf
  → conflict branch → merge locally, push `main` → pull into Overleaf. On 2026-09-03 a GitHub Desktop
  auto-stash was dropped and swept up all uncommitted work (tag `recovery/stash-2026-09-03`). If it
  recurs: find the hash via `git reflog`/`git fsck --lost-found`, tag immediately, restore file by
  file (`git checkout <tag> -- <paths>`), never `stash pop`.
- Google Drive lock files (`~$*`) appear routinely; `~$species.xlsx` and `~$unlinked.pptx` are tracked
  and should probably be `git rm --cached` (needs a decision). Large TIFFs are committed; `*.fna`/`*.gff`
  go through LFS.

## Sign-off process (`/signoff`)

At the end of every session, report each item explicitly:

1. **Record decisions** here with the date — a decision only in the transcript did not happen.
2. **Record newly found staleness** (code ↔ manuscript, or internal), even if not fixed.
3. **State what changed** in the manuscript this session and what is next.
4. **Check the build** (Rule 7).
5. **`references.bib`:** new entries verified against Crossref; flag `% UNVERIFIED:` otherwise.
6. **Git state:** `git status --short`; do not commit unless asked; flag lock files and conflict copies.
7. **Hand off:** the single next action and blocking unknown; keep **Missing / open work** current.
   Keep this file compact: record the decision, not the session narrative.

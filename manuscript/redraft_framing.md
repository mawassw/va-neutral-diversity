# Redraft framing brief — `manuscript/scratch.tex` → GENETICS

**Purpose.** This document is the input to the editor agent. It specifies, paragraph by paragraph,
what each location in the manuscript must communicate and contain. It contains no prose to be copied;
every sentence in the manuscript is authored downstream from these briefs under
`walid_authorial_style_guide.md` (the Cut and the Grain, Part 2; paragraph rhythm, Part 6; the
de-AI-ification checklist, Part 3).

**Authority order for the editor agent.**

1. `CLAUDE.md` § *Project framing* — governs all claims, numbers, and what may not be said.
2. This document — governs paragraph function, order, and content at each location.
3. `scratch.tex` §Theory, §Methods, Appendices A–D — governs every equation and derivation.
4. `walid_authorial_style_guide.md` — governs diction, rhythm, sentence structure. **Mine its
   Appendix for voice only.** Four of its reference sentences assert retired claims.

**Drafted paragraphs are not final.** Issues found in accepted drafts are held in
`manuscript/intro_revision_log.md` and applied in a single pass over the whole Introduction. A
paragraph marked DRAFTED here still has open items there.

**Working cadence.** One paragraph at a time, in document order. Draft, return, then the next brief
is confirmed or amended against what the text actually did. A paragraph is finished when it fills the
slot the previous paragraph opened and opens the slot the next brief names.

---

## 1. The kill list — claims that must not survive the redraft

These are not stylistic objections. Each asserts something the arithmetic or the settled framing
rules out. Line numbers are the current `scratch.tex`.

| location | what dies | why |
|---|---|---|
| line 9 (title) | "predicts severe depletion of neutral diversity" | The model removes at most ~20x at measured $V_A$. The title asserts a magnitude the model cannot produce. |
| line 29 (Intro, final paragraph) | "The test fails, by a wide margin"; "two to three orders of magnitude beyond what wild vertebrate populations carry" | Arithmetically impossible. $N_e/N = 1/(1+4\kappa V_A)$ is linear in $V_A$ and caps the effect. |
| line 289 (Discussion opener) | "reported $V_A$ estimates violate that limit"; "For [X_OUT_OF_N] species the reported $V_A$ exceeds $V_{A,\max}$"; "two to three orders of magnitude above the predictions" | 0 of 19 populations exceed $V_{A,\max}$ at $\delta \le 0.3$. The violation never happened. |
| line 295 | "No bounding parameterization resolves the mismatch in any species, which establishes an incompatibility" | There is no established incompatibility on the diversity side. |
| lines 319, 321 (conclusion) | "published pedigree estimates sit two to three orders of magnitude above it"; "Most of the fitness variance measured in the wild cannot be of the directional, cumulative kind" | Both are the retired claim. |
| line 309 | reported $V_A \in [0.10, 0.30]$ | Actual posterior modes: 0.0029–0.4963, median 0.0997. Roughly half fall outside. |
| throughout | Lewontin's paradox as the thesis; Buffalo 2021 as the foil; Charlesworth 2026 / Connallon & Czuppon 2026 as a competing resolution; the opportunity for selection $I$; circularity of diversity-calibrated estimates as the motivation | All retired. See `CLAUDE.md` § *What is deliberately NOT claimed*. |

**Standing test the editor applies to every paragraph it writes:** remove Buffalo 2021, remove
Lewontin-as-thesis, remove Charlesworth 2026. Is the paragraph still interesting? Anything that fails
is decoration and gets cut.

**Placeholder discipline.** Two numbers are missing from the project entirely: observed $\pi$ per
population, and a breeding-adult census $N$. Every paragraph needing them is marked
**[DATA-BLOCKED]** below. The editor writes those paragraphs to the specified structure, using
`[PI_OBS]`, `[N_BREED]`, `[DELTA]`, `[N_POP]` as literal placeholders, and invents no magnitude.
Observed deficits of $10^2$–$10^6$ are attributed to the literature, never presented as computed here.

---

## 2. Title and abstract

### 2.1 Title

Must name one measured quantity and two verdicts, or the double-sided structure. No magnitude claim
on the diversity side. Candidates for the user, whose call this is:

- *Additive genetic variance in fitness is too small to explain missing diversity and too large to be
  maintained*
- *Two equilibrium tests of the fitness variance measured in wild pedigrees*
- *The fitness variance of wild vertebrate populations sits between two equilibria it cannot satisfy*

### 2.2 Abstract — one paragraph, ~250 words, five moves in order

1. **The quantity and its estimator.** Additive genetic variance in relative fitness measured by
   pedigree animal models in long-term wild vertebrate studies; 19 populations; median 0.10, range
   0.003–0.50 on the relative-fitness scale.
2. **Comparison 1.** Propagated through the Robertson / Santiago–Caballero machinery with empirical
   mating systems, recombination maps, and annotation-derived functional targets, the measured
   variance predicts a reduction in $N_e/N$ of 1.4x at the median and ~3x at the maximum unlinked,
   ~20x with linkage at the most extreme parameterization. The diversity deficits reported for these
   taxa are $10^2$–$10^6$. Too small.
3. **Comparison 2.** Against mutation–selection–drift balance, $V_A \approx U_d s$ with
   $U_d \approx 1$ implies $s^* \approx 0.15$, one to two orders above vertebrate DFE means; read
   forward, MSD balance sustains a $V_A$ 14–136x smaller than the measurement. Too large.
4. **The spine.** Both comparisons target the same quantity in the same units, and no rescaling of
   the estimate satisfies both: bias downward improves the maintenance verdict and worsens the
   diversity verdict. The thresholds do not meet — a hundredfold diversity deficit needs
   $V_A \gtrsim 25$, MSD compatibility needs $V_A \lesssim 10^{-2}$.
5. **What is delivered.** $V_{A,\max}(\delta)$ as a curve any diversity estimate can be read against;
   $\overline{Q^2}$ integrated along empirical Haldane maps; the mating-system scalar $\kappa(\alpha)$.

**Forbidden in the abstract:** the word *violate*; any count of populations exceeding $V_{A,\max}$;
Fisher's theorem; Lewontin.

---

## 3. Introduction — SUPERSEDED

**Drafted 2026-09-01 as I1–I6 and captured in `manuscript/intro_draft_v1.md`. The revision to a
publishable Introduction is governed by `manuscript/intro_revision_directive.md`, which collapses the
six paragraphs to five and is the operative document.** The briefs below are kept as the record of
what each paragraph was asked to carry; do not draft from them again.

## 3a. Introduction — original briefs (historical)

The Introduction's job is to make the double-sided comparison inevitable by the time the reader
reaches it. It builds in this order: the quantity has two consequences → the quantity is now
measured, in a specific currency → propagate it forward to diversity → ask backward what maintains
it → the two answers are commensurable and irreconcilable → what the paper delivers.

### I1 — One quantity, two ledgers — **DRAFTED, accepted**

**Debt deferred to I6.** The drafted paragraph converts a variance effective size into a coalescent
one in half a sentence ("The same reduction compresses the neutral coalescent"). That step is where
the paper's central scope condition lives, since it requires persistence over ~$4N_e$ generations.
Correct to leave unqualified in a background paragraph; I6 must pay it off explicitly.

**Function.** Establish that additive variance in relative fitness is not only the currency of
adaptation but a driver of drift, so a measured value carries commitments in two directions at once.
Background paragraph; no claim of this paper appears yet.

**Carries.**
- $V_A$ in relative fitness as the substrate of adaptive change. One clause on Fisher's theorem,
  explicitly per-generation and partial (Fisher 1930; Price 1972). **It is background, not a premise
  — the sentence must not imply persistence across generations.**
- The Robertson effect (Robertson 1961): heritable variance in reproductive success inflates
  family-size variance beyond the Poisson expectation, accelerates allele-frequency change at neutral
  sites, and depresses $N_e$ below $N$ (Wright 1938; Buffalo and Coop 2019).
- The consequence that makes the paper possible: a value of $V_A$ predicts a level of neutral
  diversity, so it can be checked against sequence data collected for other reasons.

**Opens.** *How large is that variance in real populations, and measured how?*

**Forbidden.** FTNS as a constraint requiring persistence. Any statement that adaptation and drift
"fail in opposite directions."

**Rhythm.** Short opening thesis → long mechanism sentence → short consequence.

### I2 — The measurement, and its currency — **DRAFTED, accepted with revisions**

**Verified population identifiers** (from `data/species_EPP.csv`; use these, do not invent others).
SSH = Soay sheep, St Kilda. GTU = great tits, Wytham Woods. GTN = great tits, Hoge Veluwe.
BHS = bighorn sheep, **Ram Mountain** (Alberta — but name it Ram Mountain, because **AB in this
dataset is yellow baboons at Amboseli**, not Alberta). RD = red deer, CF = collared flycatchers
(Gotland), CSM = rhesus macaques (Cayo Santiago). Also present in the 19: spotted hyenas
(Ngorongoro), song sparrows (Mandarte Island), snow voles, three blue tit populations, two hihi
populations, superb fairy wrens, red squirrels (Kluane), meerkats (Kalahari).

**Bridges from I1 as drafted.** I1 closes on "That prediction can be checked against sequence data
collected for other reasons." That opens two slots, not one: *checked how*, and *checked against what
value*. I2 answers the second, so its topic position must pick up the check before introducing the
estimate — old before new (style guide 1.6). Something to the effect that the check needs a number
in a particular currency, and the number now exists. Do not open I2 on the animal model as a topic.

**Function.** Put the number on the page and establish that it needs no conversion before either
comparison. This paragraph earns the right to use one estimate in two different equilibrium arguments.

**Carries.**
- The animal model made $V_A$ estimable in unmanipulated wild populations (Kruuk 2004; Wilson et al.
  2010); the synthesis across long-term studies (Postma 2014; Bonnet et al. 2022).
- The real distribution, replacing the retired "0.1–0.3": **19 populations, min 0.0029, Q1 0.0172,
  median 0.0997, Q3 0.2484, max 0.4963.** Median and range here; quartiles wait for Results.
- **The currency statement, as a fact about the estimator.** Bonnet et al. fitted a zero-inflated
  over-dispersed Poisson animal model to lifetime breeding success and back-transformed with
  $V_A(w) = \mathbf{d}^\top\mathbf{G}\mathbf{d}$, where $\mathbf{d}$ collects average partial
  derivatives of mean *relative* fitness. The published estimates are therefore observed-scale,
  mean-standardised additive variance in relative fitness — Santiago and Caballero's $C^2$, and the
  currency of the mutation–selection–drift calculation. **Nothing is rescaled anywhere in this paper.**
- One sentence, flat and non-accusatory, that the same estimator is single-generation and evaluated
  at the observed population state. Do not develop it; it is signposted here and paid off in I6 and D3.

**Opens.** *What does a variance of that size predict for neutral diversity?*

**Forbidden.** Any catalogue of upward biases in animal-model estimates. That material is D2, and
putting it here pre-loads the reader with a resolution the paper does not adopt. Delete the
line-17 bias catalogue from the Introduction.

### I3 — Comparison 1: propagate it forward, and it is too small

**Bridges from I2.** I2 ends by handing the machinery a number and leaving its magnitude unstated.
I3 opens by supplying the magnitude. Do not re-establish that $V_A$ predicts a diversity level —
I1 and I2 have both said it. Open on the computation or on the number that comes out of it.

**Function.** State the first verdict, and state why the verdict is robust: the mechanism is linear
in $V_A$ and therefore capped.

**Carries.**
- The machinery in one or two sentences: unlinked, $N_e/N = 1/(1+4\kappa V_A)$ (Robertson 1961;
  Santiago and Caballero 1995, 1998), with the linked contribution integrated along empirical
  recombination maps and functional targets apportioned by annotation.
- **The structural point, which is the paragraph's reason for existing:** the unlinked reduction is
  *linear* in $V_A$, so it caps the whole effect; there is no compounding across generations once at
  equilibrium. This is a ceiling on what the mechanism can do, not an estimate that might be revised
  upward.
- The magnitudes: at the median measured $V_A$, $N_e/N = 0.72$, a 1.4x reduction; at the maximum,
  0.34, a 3.0x reduction; adding the linked term at the most extreme genome-wide parameterization,
  ~20x total.
- The deficits these taxa show, $10^2$–$10^6$, **attributed to the comparative literature** (Leffler
  et al. 2012; Buffalo 2021; Lewin and Eyre-Walker 2026), not to this paper's computation.
- Verdict, short: the measured variance is orders of magnitude too weak to be the explanation.
- One sentence on Matheson and Masel (2025): they argue the unlinked component matters; the numbers
  above are what it comes to when quantified.

**Opens.** *If the variance is too small to have this consequence, is it a variance a population can
carry at all?*

**Forbidden.** "Overshoot", "severe depletion", and any framing of this as a resolution of the
diversity–census decoupling. The paragraph must not present linked selection as the paper's target.

### I4 — Comparison 2: ask what maintains it, and it is too large

**Bridges from I3 as drafted.** I3 closes "Yet a variance of that size still has to be maintained."
That is the slot; fill it directly. I4's first sentence answers *maintained by what*, and the answer
is mutation–selection–drift balance. Do not re-open with a transition — the pivot is already made.

**Function.** State the second verdict, in the same currency, from data that never touches diversity.

**Carries.**
- The question changes direction: not what the variance does, but what sustains it. Standing additive
  variance in fitness at mutation–selection–drift balance is $V_A = 2N_eU_ds^2/(1+2N_es)$, with
  strong-selection limit $V_A \approx U_d s$ (Turelli 1984; Bürger 2000; Appendix D).
- $U_d = 4\mu L_{\text{coding}}$ from published per-generation mutation rates and collapsed coding
  length: **$U_d$ = 0.69–1.19, median 1.07.**
- Inverted: $s^* = V_A/U_d$ = **0.019–0.313, median 0.145** (median 0.092 at the upper 95% CI on
  $\mu$), against vertebrate DFE mean heterozygous coefficients of $10^{-3}$–$10^{-2}$ (Eyre-Walker
  and Keightley 2007; Huber et al. 2017).
- **Read forward, which is the more legible statement:** at $s = 10^{-3}$, $5\times10^{-3}$ and
  $10^{-2}$, MSD balance sustains a $V_A$ that the measurement exceeds by 136x, 27x and 14x.
- Verdict, short: too large to be maintained.
- The logical direction, one sentence: $s^*$ is a consequence inferred from the reported variance, not
  an estimate of selection fitted to anything.

**Opens.** *Both verdicts concern one number — can either be dismissed?*

**Forbidden.** Presenting Connallon & Czuppon or Charlesworth as the competing account. They explain
maintenance; they are not a resolution of this premise, and they belong in D6 with `% UNVERIFIED:`
flags.

### I5 — The spine: no single bias reconciles them, and the two ends do not meet

**Bridges from I4 as drafted.** I4 closes "Two verdicts now rest on one number, which invites the
obvious objection that the number is wrong." That objection is the paragraph's opening move — take it
seriously and answer it, do not set it aside. Move 2 below is the answer.

**X1 applies, and in this paragraph's favour.** The two thresholds stay: they are properties of the
framework at a stated target, not empirical findings, and the argument does not exist without them.
Do not import the measured magnitudes from I3 and I4 — refer to the verdicts, not their arithmetic.

**Function.** The paragraph the paper stands on. Four moves, in this order.

**Carries.**
- **Move 1 — commensurability.** Both comparisons target the same quantity: the long-run equilibrium
  additive variance in relative fitness at $\bar w = 1$. Santiago–Caballero needs it sustained over
  ~$4N_e$ generations; MSD balance is a standing-variance-at-equilibrium statement. Same currency,
  same timescale class, so the verdicts are commensurable.
- **Move 2 — the opposite-direction argument.** If the measured value is inflated, the maintenance
  discrepancy shrinks and the diversity discrepancy grows; if it is underestimated, the reverse.
  **No rescaling of $V_A$ improves both.** Name what this buys: robustness to the standard criticism
  of pedigree $V_A$ — that the animal model absorbs environmental covariance among relatives —
  because that criticism moves the number in one direction only.
- **Move 3 — the ends do not meet.** Accounting for a hundredfold diversity deficit requires
  $V_A \gtrsim 25$ at $\kappa = 1$ (~12 under strict monogamy); MSD compatibility requires
  $V_A \lesssim 10^{-2}$. **No value satisfies both.** The gap is therefore a property of the model,
  not of the measurement. **Both thresholds are stated in the unlinked currency so the arithmetic is
  internally consistent; the linked amplification is reported separately in Results.**
- **Move 4 — where the measurement sits.** Inside that empty interval: one to two orders above the
  MSD end, two to three orders short of the diversity end. The measurement does not close the gap; it
  locates reality within it.

**Opens.** *What, concretely, does the paper hand the reader?*

**Forbidden.** Any suggestion that one verdict is the finding and the other a robustness check. They
are symmetric.

**Rhythm.** This paragraph carries the most logical load in the manuscript. Long dense sentence for
Move 2; short punch for "No value satisfies both."

### I6 — What the comparisons need, and what the estimator supplies

**Bridges from I5 as drafted.** I5 closes "It does not close the gap; it locates reality within it."
Open by putting pressure on *reality*: what the measurement locates depends on whether it estimates
the quantity the two comparisons need, and it does not, quite. The reader should feel that tension
arriving rather than be told a new topic has begun.

**Split from the original I6, decided after I1–I3 drafted.** Three debts have accumulated and one
paragraph cannot discharge them alongside a roadmap: I1 converted a variance effective size into a
coalescent one in half a sentence; I2 seeded that the estimator is single-generation and
environment-conditional; I3 introduced $1/(1+4\kappa V_A)$ without its conditional. I6 pays all three
and becomes a substantive paragraph. The roadmap moves to I7.

**Carries.**
- **The scope condition, at full strength.** $N_e/N = 1/(1+Q^2V_A)$ is exact, *conditional on* $V_A$
  being the long-run equilibrium additive variance in relative fitness. Name the quantity it needs
  and say what breaks otherwise. This was the one thing a competent reader at MWPG 2026 could not
  infer unaided; it is not optional.
- **The two persistence windows, kept distinct.** $Q = 2$ needs the sign of the advantage to persist
  only ~2 generations, so the unlinked baseline holds under MSD balance, sweeps and fluctuating
  selection alike; $\pi$ reaching a new equilibrium needs ~$4N_e$ generations. The second window is
  why the target quantity is the long-run variance.
- **The mismatch, stated definitionally rather than as suspicion.** $\mathbf{d}$ is an average partial
  derivative evaluated at the observed population state, so the published estimate is what it is by
  construction, not by error. Two sentences at most — D3 develops it.

**Opens.** *Given that, what does the paper actually deliver?*

**Forbidden.** Any hint that this invalidates the comparison. It scopes it.

### I7 — What the paper delivers

**Function.** Roadmap. Short — five or six sentences.

**Carries.**
- The deliverables, in document order: the mating-system-corrected unlinked baseline;
  $\overline{Q^2}$ integrated along empirical Haldane maps with annotation-derived functional
  partitions; $V_{A,\max}(\delta) = (1-\delta)/(4\kappa\delta)$ **as a curve, not a defended point
  estimate** — the object anyone with a diversity estimate reads their own ceiling from, and the value
  any future sequence-based estimate of fitness variance must come in under; the MSD inversion and its
  DFE robustness check.
- One sentence, phrased as a property of the design rather than a gap being filled: $V_A$, $\alpha$,
  $M_i$, $f_i$ and $\mu$ each come from a separate body of data and none from observed diversity, so
  the comparison meets diversity data only at the end. **Do not build the Introduction around this,
  and do not use the word circular.**

**Opens.** The Theory section.

**Forbidden.** A sequential "we first… we then… we finally…" cascade (style guide Part 3, Priority 1).
Name the objects, not the itinerary.

---

## 4. Theory and Model — framing-only edits

The equations stand. `scratch.tex` §Theory is authoritative and no derivation changes. Five local
edits:

1. **§Genome-wide Effect, after eq. `unlinked_baseline`.** Add the linearity-is-a-ceiling observation
   at the point of derivation: the reduction is linear in $V_A$, so the mechanism's total capacity is
   bounded. Currently the reader must notice this unaided, and the whole diversity verdict rests on it.
2. **Same location.** Keep the existing persistence-window distinction (line 40 is right: $Q = 2$
   needs sign persistence over ~2 generations, so the unlinked baseline holds under MSD balance,
   sweeps and fluctuating selection alike) and add that $\pi$ reaching a new equilibrium needs
   ~$4N_e$ generations. **Both windows named, kept distinct.**
3. **§The Upper Bound.** The subsection frames $V_{A,\max}$ as a test populations may fail, and its
   closing two paragraphs (the four-branch disjunction, and the branch-(i) mechanisms) pre-empt the
   Discussion. Recast: $V_{A,\max}$ is a ceiling function, published as a curve. Move the disjunction
   out; the Discussion owns it.
4. **§Total Reduction, eq. `chrom_reduc` vs eq. `total_red`.** Unresolved factor of 2 in the linked
   exponent ($v_i$ at line 113 vs $v_i/2$ at line 149). The R code uses $v_i/2$. **This sits directly
   on the ~20x figure and must be resolved before the Theory section is final** — either label
   `chrom_reduc` as pre-partition or carry the halving into it.
5. **§Integration of Linked Constraint, against §Methods.** The $\overline{Q^2}$ method contradiction
   stands: Theory says numerical Haldane, Methods §Genetic Map Lengths describes closed-form linear.
   Both cannot describe what was run; resolve toward numerical Haldane, which is what the code does.
   The cross-reference to "Appendix A" for the closed-form linear limit should point to Appendix C.

---

## 5. Results — architecture and paragraph briefs

The current §Results is one subsection long and reports no numbers. It has to be built. The order
below is the reading order: the input, then each comparison, then the object that makes them
commensurable.

**Analysis-set rule, applied in every subsection:** 19 populations for $V_A$-only and unlinked
results; **8** (RD, BHS, AB, SSH, CSM, GTU, CF, GTN) for anything requiring $U_d$, maps or
annotation. Each result states which set it uses. On the 8, $V_A$ runs 0.014–0.360, median 0.146.

### R0 — Opening paragraph, no subsection heading

**Function.** Name the input quantity, the two comparisons and the two analysis sets. Three or four
sentences. No verdicts.

### R1 — *The measured variance and its inputs*

**Carries.** The 19 posterior modes with full quartiles (0.0029 / 0.0172 / 0.0997 / 0.2484 / 0.4963);
$\kappa$ from published extra-pair paternity rates, bounded in $[1,2]$, with the monogamous
passerines that dominate the dataset near $\kappa = 2$; the three-way join reducing to 8, and the
$V_A$ distribution on that subset. One sentence on posterior width against between-population spread.
**Opens.** *What does that distribution predict?*

### R2 — *What heritable fitness variance can remove from neutral diversity*

**Carries.** Unlinked, across the 19: $N_e/N$ = 0.717 at the median $V_A$, a 1.39x reduction; 0.335 at
the maximum, a 2.99x reduction. State the corresponding values at $\kappa = 2$. Then the linked
amplification on the 8: genome-wide $\overline{\Omega}$ 0.1–0.85, giving ~20x total at the most
extreme parameterization. **The framing sentence:** these are the mechanism's ceiling at measured
$V_A$, not a central estimate, and the ceiling is set by the linearity in $V_A$.
**Opens.** *How does that compare with what these populations are missing?*
**Forbidden.** Any word implying collapse.

### R3 — *The per-population comparison* — **[DATA-BLOCKED]**

**Carries.** The test reported in $\pi$ units, not $\delta$ units:
$\pi_{\text{pred}} = 4\mu N/(1+4\kappa V_A)$ against $\pi_{\text{obs}}$. Say why: algebraically
identical to $\delta$ against $1/(1+4\kappa V_A)$, but $\pi_{\text{obs}}$ is a measurement whereas
$\delta$ is a composite of three quantities, two of them uncertain. Per-population table with the
**census instrument recorded for each row** — a long-term or historical census scaled by a breeder
fraction preferred over a density x range estimate. Report the trichotomy openly (uninformative
$\delta \ge 1$, violation, consistent) and how many populations fell into each.
**Editor instruction.** Write the structure with `[PI_OBS]` / `[N_BREED]` / `[DELTA]` placeholders and
no invented magnitudes. Flag in the draft that this is the one blocking unknown.

### R4 — *The ceiling on heritable fitness variance*

**Carries.** $V_{A,\max}(\delta) = (1-\delta)/(4\kappa\delta)$ as a curve over $\delta$, one line per
$\kappa$. **The honest count, stated plainly and without softening: 0 of 19 populations exceed the
ceiling at $\delta \le 0.3$; 5 of 19 at $\delta = 0.5$; 13 of 19 at $\delta = 0.9$.** Then the
sentence that makes this a result rather than a null: the ceiling is a reusable object, it is where
the diversity side becomes quantitative for any population with a diversity estimate, and it is the
value future sequence-based estimators must come in under.
**Forbidden.** "Exceeded", "violated", and any count framed as a positive finding.

### R5 — *What sustains a variance of this size*

**Carries.** On the 8: $U_d$ 0.69–1.19, median 1.07, from $U_d = 4\mu L_{\text{coding}}$ with the
$\mu$ 95% CIs propagated. $s^* = V_A/U_d$: 0.019–0.313, median 0.145; median 0.092 at the upper CI on
$\mu$. Comparison to vertebrate DFE means, $10^{-3}$–$10^{-2}$. Read forward: 136x / 27x / 14x at
$s = 10^{-3}$ / $5\times10^{-3}$ / $10^{-2}$. The weak-selection boundary fails for the complementary
reason: solving $V_A \approx 2N_eU_ds^2$ returns $N_es \gg 1$, contradicting the premise of the
approximation used to obtain it (Appendix D).
**Opens.** *Does any parameterization rescue MSD balance?*

### R6 — *Robustness of the maintenance verdict*

**Carries.** Three checks, each with its direction stated.
(i) A leptokurtic DFE makes $s^*$ *less* plausible, not more, because large-effect alleles dominate
$V_A$ under House-of-Cards balance — so the uniform-$s$ assumption understates the mismatch.
(ii) The large-effect correction to unlinked interference: per-locus interference scales as
$2t/(1+t)^2$ rather than $t$, so alleles of large heterozygous effect generate less genome-wide
interference per unit variance than the Robertson formula predicts (Charlesworth 2012; Rettelbach et
al. 2025). It relieves part of the predicted suppression and does not close the gap. **This bears on
the maintenance interpretation, not on the diversity comparison — say so.**
(iii) The permissive-$U_d$ parameterization (conserved regulatory target equal to the exome, $U_d$ at
its empirical maximum), which maximizes mutational replenishment and still does not reach the
measured $V_A$.
**Forbidden.** The retired $Z \to 1$ narrative as evidence of collapse. $Z$ is machinery here.

### R7 — *The two ends do not meet* — the payoff subsection

**Carries.** One axis, $V_A$ on a log scale: the MSD-compatible region ($V_A \lesssim 10^{-2}$), the
region required to account for a hundredfold diversity deficit ($V_A \gtrsim 25$ at $\kappa = 1$, ~12
at $\kappa = 2$), the roughly three orders of magnitude between them containing no admissible value,
and the 19 posteriors plotted where they actually fall. Then the two sentences that state the result:
the gap is a property of the model and exists independently of the measurement; the measurement
locates reality inside it, one to two orders above the MSD end and short of the diversity end by two
to three.
**Figure needed — does not exist.** See §8.

### R8 — *Intragenomic variation in reduction* — existing subsection, retargeted

**Carries.** Keep the existing analytic content: the unlinked term is effectively uniform across
chromosomes because $v_i/2 \ll V_A$, so predicted between-chromosome differences are driven by
linkage alone; the governing ratio is functional density to map length; the avian microchromosome
regime is where the prediction is most sensitive to $Z$ and hence to the DFE.
**Retarget.** Present as a prediction of the framework and a target for future sequence data, not as
evidence about the measured $V_A$. Demote below R7.
**Add.** The 20 Mb macrochromosome filter is applied in the code, undescribed in Methods, and excludes
precisely the avian microchromosomes this subsection leans on. Either the filter is described and
justified, or the subsection is scoped to macrochromosomes. Decide before submission.

---

## 6. Discussion — architecture and paragraph briefs

The Discussion's job: locate the two verdicts in the field's conversation, state the significance
argument, and draw the contours of what the claim rests on. It must not re-argue the Results.

### D1 — What the two verdicts establish

**Function.** Restate the result as two verdicts on one number, and say what that jointly rules out:
measured $V_A$ is neither the explanation for these populations' missing diversity nor a variance
mutation–selection–drift balance can sustain. Open, do not close.
**Forbidden.** "The test fails." There is no single test.

### D2 — Why the standard criticism does not dissolve the problem

**Carries.** The documented upward biases in pedigree $V_A$, stated fairly and in full: relatives
share environments and the basic animal model absorbs that covariance into the additive component
(Kruuk and Hadfield 2007; Stopher et al. 2012); indirect genetic effects in kin-structured
populations (Baud et al. 2022; Mawass and Milot 2025); unweighted LRS not discounting delayed
reproduction in age-structured populations (Sæther and Engen 2015; de Villemereuil et al. 2020);
shallow pedigrees lacking power to separate additive from non-additive variance (Wolak and Keller
2014). **Then the move that matters:** every one of these pushes the true value *down*, which improves
the maintenance verdict and worsens the diversity verdict. The criticism relocates the problem rather
than removing it. This is the spine restated in interpretive register, and it is the paper's answer to
its most likely referee objection.

### D3 — The estimator and the target quantity

**Carries.** Stated definitionally, not as suspicion. $\mathbf{d}$ in
$V_A(w) = \mathbf{d}^\top\mathbf{G}\mathbf{d}$ is an average partial derivative evaluated at the
observed population state — those cohorts, that environment, that mean fitness. Hold $\mathbf{G}$
fixed, change the environment, and $V_A(w)$ changes. Robertson's secondary theorem, on which the
bound rests, is likewise single-generation. Both comparisons in this paper need the long-run
equilibrium quantity. **The mismatch is visible in the definition of the estimator, not inferred from
bias.** One sentence making clear this is not a criticism of Bonnet et al. — it is what their
estimator is for. This is the largest scope condition on the result.

### D4 — Why diversity is a harder constraint than the trend in mean fitness

**Function.** The significance argument. The only place Fisher's theorem appears, and it appears as an
interpretive asymmetry, never as a premise.
**Carries.** FTNS is single-generation: the partial change in mean fitness attributable to selection
equals $V_A/\bar w$ per generation. It is satisfied by an instantaneous $V_A$ and requires no
persistence, so it cannot referee between two equilibrium comparisons. It is also escapable — mean
fitness can stay flat while a real directional $V_A$ is present, because Fisher's own
deterioration-of-environment term absorbs the increase. **The diversity consequence is not escapable
that way: the allele-frequency change still happens and diversity still pays.** That asymmetry is why
neutral diversity constrains a reported $V_A$ more tightly than any observed trend in mean fitness.

### D5 — Where this sits relative to linked selection and the diversity–census decoupling

**Carries.** Locate, do not borrow. The comparative observation that diversity varies far less than
census size (Lewontin 1974; Leffler et al. 2012; Buffalo 2021; Corbett-Detig et al. 2015) is the
literature this work reports into, and linked selection fitted to diversity data is its consensus
proximate mechanism (Comeron 2017; Buffalo and Kern 2024). **What this framework contributes:** a
quantitative-genetic route to the genome-wide unlinked component, computed from pedigrees, parentage,
maps and annotation rather than fitted to diversity, which quantifies what Matheson and Masel (2025)
argue qualitatively — 1.4x at the median reported $V_A$, ~3x at the maximum. **What it does not claim,
stated explicitly:** this is not a resolution of the diversity–census decoupling, and the mechanism
cannot be one, because at measured $V_A$ it removes at most ~20x against deficits of $10^2$–$10^6$.

### D6 — The maintenance literature

**Carries.** Work explaining how a large $V_A$ in fitness can be maintained — fluctuating selection,
balancing selection, and recent theoretical treatments (Connallon and Czuppon 2026; Charlesworth
2026) — addresses the maintenance question this paper's second comparison raises, and is not a
competing account of its premise. This paper takes measured $V_A$ as an input and asks what it
implies; those works ask how such a value could persist. The two are complementary, and the MSD
verdict is precisely the observation that motivates them.
**Editor instruction.** Neither citation is verified against Crossref or present in `references.bib`.
Flag both `% UNVERIFIED:` in the `.tex`.

### D7 — Scope conditions on the model side

**Carries.** (i) $N_e/N = 1/(1+Q^2V_A)$ is exact conditional on the long-run equilibrium quantity;
name what breaks otherwise. (ii) The two persistence windows kept distinct: $Q = 2$ needs sign
persistence over ~2 generations, so the unlinked baseline survives MSD balance, sweeps and fluctuating
selection; $\pi$ reaching a new equilibrium needs ~$4N_e$ generations, which is why the target
quantity is the long-run variance. (iii) Fluctuating and balancing selection belong on the maintenance
side, as accounts of how a large $V_A$ persists — **not** as an escape from the diversity ceiling,
because a sign flip restores no heterozygosity.

### D8 — Scope conditions on the observed side

**Carries.** The census timescale mismatch, credited as the substantive methodological objection raised
at MWPG 2026: $\pi/(4\mu)$ is long-run coalescent while every available census $N$ is contemporary.
State the preference for a long-term or historical census scaled by a breeder fraction over a
density x range estimate, and that the instrument is recorded per population. Then the bias-direction
table, as prose or as a Methods table cross-referenced here: $N_{eC}$ exceeding the contemporary
census, cryptic immigration, total census rather than breeding adults, background selection at the
sites used for $\pi$, and $\mu$ misestimation — with the direction each pushes the apparent gap and
the explicit statement that none of them closes it. Finally: **non-equilibrium populations are
excluded, not explained.** Because $V_{A,\max} = (1-\delta)/(4\kappa\delta)$, any $\delta \ge 1$
gives $V_{A,\max} \le 0$, which is a failed model check rather than a strong result; report how many
populations fell out that way.

### D9 — Structural approximations

**Carries.** Retain the existing line-317 paragraph nearly intact; it is well constructed and its
direction statements are correct. Uniform $s$ (understates the mismatch); discrete non-overlapping
generations against iteroparous life histories (Engen et al. 2005); autosome-only, with the
non-recombining Z in females at the complete-linkage limit; uniform spatial distribution of variance
per Morgan, with the Jensen's-inequality result and its reversal under enrichment of large-effect loci
in low-recombination regions; demographic and environmental stationarity. **Add the two unresolved
internal items** if they are still unresolved at submission: the factor of 2 in the linked exponent,
and the undescribed 20 Mb chromosome filter.

### D10 — Closing

**Carries.** What the reusable objects are for, and what measurement would settle the question. The
$V_{A,\max}$ curve as a value any estimate of fitness variance must come in under, whatever instrument
produces it. The measurement that would resolve the double verdict: an estimate of the *long-run*
variance in relative fitness, from temporal-genomic or other sequence-based estimators, rather than a
single-generation one. Close on the consequence, not a wrap-up: a reported $V_A$ carries commitments
about effective size and about what maintains it, and both can be checked.
**Forbidden.** "Most of the fitness variance measured in the wild cannot be…" and every variant of the
partition claim. Any closing sentence beginning "In summary" or "Taken together" (style guide Part 3,
Priority 6).

---

## 7. Methods — deltas required by the redraft

1. **§Empirical Pedigree Parameters, line 235 placeholder.** Answerable now: no standardisation was
   required, because Bonnet et al. report observed-scale, mean-standardised $V_A(w)$ via
   $\mathbf{d}^\top\mathbf{G}\mathbf{d}$. Write that and delete the placeholder.
2. **New subsection — independence audit.** Does not exist, and the Introduction's design claim
   currently rests on nothing in the manuscript. Short: $V_A$ from pedigrees, $\alpha$ from molecular
   parentage, $M_i$ from linkage maps, $f_i$ from annotation, $\mu$ from mutation-rate studies, and
   none from observed $\pi$. State it as a property of the design.
3. **§Empirical Nucleotide Diversity.** Still author-input. Must specify the source of $\pi$ (Lewin and
   Eyre-Walker 2026), the genomic compartment, the census instrument per population, and that the
   comparison is run in $\pi$ units. **[DATA-BLOCKED]**
4. **§Genetic Map Lengths.** Resolve the Haldane-versus-linear contradiction with §Theory.
5. **Analysis-set statement.** Add one paragraph making the 19-versus-8 split explicit, with the eight
   codes named.
6. **Bias-direction table.** Add as a Methods table, cross-referenced from D8.
7. **$s_{het}$ direction.** Methods states $s$ is inferred, not fixed; the code hardcodes
   `s_het = 0.01` with a sensitivity grid. Resolve toward the Methods, or describe what was run.

---

## 8. Figures and tables the redraft needs

No figure is currently wired into any `.tex` file, so the mapping is established here.

| slot | content | status |
|---|---|---|
| Fig. 1 | The two ends do not meet: $V_A$ on a log axis, MSD-admissible region, region required for a hundredfold deficit, the 19 posteriors located between them | **does not exist — must be built** |
| Fig. 2 | $V_{A,\max}(\delta)$ curve, one line per $\kappa$, with the 19 estimates overlaid | exists in substance (`main/MainFig_Baseline_Constraint`) — confirm the file |
| Fig. 3 | Unlinked and total $N_e/N$ per population, 19 and 8 sets distinguished | check `main/` for the current producer |
| Fig. 4 | $U_d$, $s^*$, and the DFE comparison | likely needs building |
| Fig. 5 | Intragenomic variation: $\Omega_i$ against functional density and map length | check `main/` |
| Table 1 | Per-population inputs: $V_A$, $\alpha$, $\kappa$, $\mu$, $L_{\text{coding}}$, $U_d$, analysis set | needs assembly |
| Table 2 | Bias directions on the observed side | from `CLAUDE.md` |
| Table 3 | Limiting values of $\overline{Q^2}_{\text{linked}}$ | exists (`tab:limits`) |

Per Rule 8: ask which file is meant rather than guessing when a caption is written.

---

## 9. Blocked items and decisions the user owns

1. **$\pi_{\text{obs}}$ and a breeding-adult census $N$.** The only blocking unknown. R3, D8 and
   §Methods *Empirical Nucleotide Diversity* cannot be finished without them, and the size of the
   deficit the diversity side is measured against is not fixed until they exist.
2. **Factor of 2 in the linked exponent** (`chrom_reduc` vs `total_red`). Sits on the ~20x figure.
3. **The 20 Mb macrochromosome filter** — undescribed in Methods, and it excludes the avian
   microchromosomes R8 depends on.
4. **Title.** Three candidates in §2.1; the one-sentence statement of the project is the user's to
   author.
5. **GSA template.** `article` / `12pt` / `plainnat` are placeholders; the class swap may require
   fuller author lists in `references.bib`.

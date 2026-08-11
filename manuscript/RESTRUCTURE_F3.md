# Structural blueprint — re-cutting `scratch.tex` under Amendment F3

**Date:** 2026-08-11
**Governing directive:** `CLAUDE.md` § *Project framing — CURRENT* + *Amendment F3 (2026-08-07, extended 2026-08-08)*
**Reference implementation of the target prose:** `job_packet/2026/misc/research_statement_3pages_genetics.docx`,
Past Work section 4 ("Most Fitness Variance Cannot Be the Directional Kind").
Note: CLAUDE.md cites this file as `research_statement_3pages_R4.docx`; that filename no longer exists.
The `_genetics` variant (most recently modified) carries the paragraph CLAUDE.md quotes. **Confirm the rename.**

**Scope of this document.** Section-by-section structural plan for `scratch.tex` (784 lines), plus a register of
logical gaps the new frame opens. Every recommendation is tagged **[CONTENT]** (changes what is claimed, proven,
or computed) or **[PRESENTATION]** (changes ordering, emphasis, length, or placement without changing the claim).
No equations were changed; F3 is explicitly a framing amendment, but — see Gap 1 — it *implies* one new derivation.

---

## Part 0 — The one-paragraph summary

F3 moves the paper's claim from *"measured `V_A` is inflated"* to *"the directionally consistent component of
`V_A` cannot be that large."* The manuscript can absorb the framing changes cheaply. It **cannot** absorb the
central claim cheaply, because the partition F3 announces has no representation anywhere in the model: every
equation from Eq. (1) onward takes a single undifferentiated scalar `V_A`. Without a derivation that exposes
which part of `V_A` enters the Robertson sum, F3 converts a *stated limitation* (current Discussion ¶11) into a
*claimed result* with no new mathematics behind it. That is the one gap that is not bookkeeping.

The good news, developed in Gap 1 below: the required derivation is already latent in Appendix A, and a
first-pass sketch suggests **F3 concedes more than it needs to**. The concession should be recalibrated, not
merely inserted.

---

## Part 1 — Section-by-section outline

### §0 Title and abstract

| Item | Current state | Change | Tag |
|---|---|---|---|
| Title | *"Empirically reported heritable fitness variance predicts severe depletion of neutral diversity in wild populations"* (L9) | Replace. States the contradiction, not the partition. R4's settled construction leads with C-content: the interpretation heads, the inequality supports. Target register: *"Most fitness variance in the wild cannot be the directional kind."* | [PRESENTATION] |
| Abstract | Does not exist in `scratch.tex`; `main.tex`'s abstract (L17) is three framings stale and argues the adaptive-potential-vs-drift duality | Write fresh against the F3 chain. Must contain: the bound, the partition, the two-branch disjunction, forward-compatibility. Must **not** contain Lewontin, Buffalo, or "opposite directions". | [CONTENT] |

### §1 Introduction — L14–25, six paragraphs

Rule 10 already declares this section superseded. Under F3 it is **three** framings stale. Full rewrite; the
paragraph-level disposition:

- **¶1 (L15) — KEEP, near-verbatim.** This paragraph already *is* the F3 anchor: `V_A` as the fundamental
  quantity, adaptation and drift as inseparable consequences of it. It was written under an older frame and
  survives the new one intact. [PRESENTATION]
- **¶2 (L17) — KEEP structure, CUT the last sentence.** The catalogue of animal-model estimates (0.1–0.3) is
  needed. But the closing clause — *"even if only a modest fraction of the reported variance is genuinely
  additive…"* — pre-commits the paper to branch A (estimates are inflated) in the second paragraph of the
  Introduction. F3 forbids defending one branch. Present the estimates; defer the interpretation. **[CONTENT]**
- **¶3 (L19) — KEEP, AMEND.** The Robertson mechanism. Must be amended to name *temporal autocovariance of
  relative fitness across generations* as the operative quantity, not "heritable fitness variance" flatly. This
  is where the directional/reversing distinction must first enter the paper, because everything downstream
  depends on the reader already holding it. **[CONTENT]**
- **¶4 (L21) — DELETE.** This is the pre-2026-07-29 gap: BGS theory wrongly treats independent assortment as a
  ceiling. Superseded twice over. Its one surviving asset is the Matheson & Masel citation, which relocates to
  Theory §2.5. **[CONTENT]**
- **¶5 (L23) — DEMOTE to a Theory preamble.** "The framework must be extended in three directions" is a
  methods-extension pitch. Under F3 the extensions (mating system, linked integration, annotation-based targets)
  are *machinery*, not motivation. The Jensen's-inequality sentence is content and belongs in §2.7.
  [PRESENTATION]
- **¶6 (L25) — REWRITE.** Currently: roadmap + the overshoot + a three-resolutions list. Replace with the F3
  chain, the two claims (the bound; the partition), and the forward-compatibility sentence. The three-resolutions
  list must not survive as a *conclusion*, because under F3 two of those three are the branches of the paper's
  own result and the third (cryptic immigration) attacks the bound rather than resolving it. **[CONTENT]**

**Target shape — five paragraphs:** (1) anchor: variance in fitness is the quantity; (2) we have pedigree
estimates of it and they are large; (3) mechanism: heritable fitness variance erodes diversity through
cross-generation autocovariance; (4) therefore diversity numerically bounds it — introduce the bound *and its
directional scope condition in the same breath*; (5) what we do, what we find (the partition), and what the bound
constrains going forward.

### §2 Theory and Model — L27–231

Current: six subsections. Target: seven, reordered so the dependency structure is visible — the headline object
depends only on §2.1–2.2 and needs no map and no annotation.

| # | Subsection | Disposition |
|---|---|---|
| 2.1 | Genome-wide effect (unlinked baseline), L28–40 | **KEEP + REWORK.** Must carry the autocorrelation parameter (Gap 1). Must fix the stationarity overclaim at L40 (Gap 3). **[CONTENT]** |
| 2.2 | **NEW — "The directional scope of the bound"** | **CREATE.** The partition derivation. Load-bearing. See Gap 1. **[CONTENT]** |
| 2.3 | Variance partitioning across sexes (κ), L42–69 | KEEP unchanged. Add one sentence: κ is a within-generation concentration factor and is therefore *independent* of the autocorrelation — so the partition is surgical, touching only the cross-generation amplification. **[CONTENT]**, one sentence |
| 2.4 | Linked constraint across the map (Q̄²), L71–141 | KEEP unchanged mathematically. Reframe as refinement, not headline. [PRESENTATION] |
| 2.5 | Total reduction and Ω, L143–174 | KEEP unchanged. Matheson & Masel citation lands here. [PRESENTATION] |
| 2.6 | **`V_A,max`**, L176–189 | **PROMOTE — move to immediately after 2.2.** It depends only on the unlinked baseline and κ; presenting it after the linked machinery hides the fact that the headline needs neither a linkage map nor a genome annotation. Reordering: [PRESENTATION]. Restating it in partitioned form: **[CONTENT]**. Recasting the (i)/(ii)/(iii) list at L187 as the two-branch disjunction: **[CONTENT]** — see Gap 5. |
| 2.7 | Infinitesimal / oligogenic architecture, L191–231 | KEEP unchanged. Supplementary. [PRESENTATION] |

### §3 Materials and Methods — L233–268

| Subsection | State | Action |
|---|---|---|
| 3.1 Pedigree parameters, L235 | Three `[author: …]` placeholders | Fill. Standardization procedure and multiple-estimate resolution rule are both undefined. **[CONTENT]** |
| 3.2 Mating system, L237–239 | Two `[author: …]` placeholders | Fill. The α-definition question (proportion of offspring vs. proportion of broods) is a real numerical issue, not a wording one. **[CONTENT]** |
| 3.3 Genomic architecture, L241–250 | Written | Text specifies `f̂_i = G_i/G_total` from gene counts; code uses coding bp. Known Rule 5 divergence. Under F3 this feeds only the *linked* term → **priority drops**. Resolve or document. **[CONTENT]** |
| 3.4 Genetic map lengths, L252–257 | Written | Contains the Haldane-vs-linear contradiction against §2.4 (known Rule 5 item). Also feeds only the linked term → **priority drops under F3**. **[CONTENT]** |
| 3.5 Mutational parameters / MSD test, L259–265 | Written | Survives; feeds Appendix D. Demoted in the main text, unchanged here. Note the standing divergence: Methods says `s` is *inferred*, code hardcodes `s_het = 0.01`. **[CONTENT]** |
| 3.6 Empirical nucleotide diversity, L267–268 | **Entirely a placeholder block** | **WRITE. This is now the single most load-bearing Methods subsection** and it does not exist. See Gap 4. **[CONTENT, blocking]** |
| 3.7 **Independence audit** | Does not exist | **CREATE.** CLAUDE.md retains it as a Methods strength under F3. Classify every input by whether it touches diversity data. **[CONTENT]** |

### §4 Results — L270–279

**Effectively does not exist.** One orphan subsection ("Intragenomic Variation in Reduction", L274–279), prose
only, zero numbers, and it describes a *supplementary* result. Proposed structure, ordered by the F3 triage:

1. **4.1 The unlinked bound.** No map, no annotation, no stationarity of the selected background. The reason to
   believe the direction. Load-bearing.
2. **4.2 Per-species `V_A,max` against observed `N_e/N`.** The headline test. **Hard dependency:** CLAUDE.md
   records that this comparison is *not* insulated from the hardcoded `s_het` or the 20 Mb macrochromosome
   filter — a shifted prediction can flip an individual species across the bound. Both must be resolved before
   this table is built.
3. **4.3 The partition.** How much of measured `V_A` can be directional. This is the section the new derivation
   (Gap 1) produces, and there is currently no analysis behind it.
4. **4.4 Robustness.** μ range, CNE multipliers, κ Model A vs. B, and the DFE correction currently buried in
   Appendix D.5 (see Gap 14).
5. **4.5 The linked refinement.** Ω, avian microchromosomes. Supplementary-facing; absorbs the current L274–279.

All `[XX]` in the Discussion are Results that have not been computed. Count before scheduling.

### §5 Discussion — L282–315, fourteen paragraphs → target ~nine

| Current ¶ | Line | Disposition |
|---|---|---|
| 1 | 283 | **REWRITE, partition-led.** Keep the numerical spine; change the verdict from irreconcilability to decomposition. **[CONTENT]** |
| 2 | 285 | KEEP. `Z → 1` robustness. [PRESENTATION] |
| 3 | 287 | KEEP. Ω ≤ 1. [PRESENTATION] |
| 4 | 289 | KEEP, compress. Avian microchromosomes. [PRESENTATION] |
| 5 | 291 | **DELETE.** The Lewontin-as-thesis paragraph. Replace with at most one locating sentence. **[CONTENT]** |
| 6 | 293 | **DELETE.** *"…reverses the standard theoretical gap"* — the withdrawn opposite-directions claim, verbatim. **[CONTENT]** |
| 7–9 | 295, 297, 299 | **COMPRESS 3 ¶ → 1.** This is branch A argued at length (common environment, IGEs, LRS bias, pedigree power). F3: *do not defend one branch against the other.* Three sustained paragraphs of animal-model critique is exactly that. **[CONTENT]** |
| 10–11 | 301, 303 | **KEEP, RELABEL.** Metapopulation gene flow / census. Critically, this is **neither branch** — it attacks the bound itself, via the soft observed side (`N`). Must be separated from the disjunction, not folded into it. **[CONTENT]** |
| 12–13 | 305, 307 | **PROMOTE AND INVERT.** Currently "resolution three" — an admission the model may not apply. Under F3 this is branch B of the result. Also contains a technical defect: see Gap 16. **[CONTENT]** |
| 14–15 | 309, 311 | **COLLAPSE to one sentence.** The MSD / implied-`s` strand. Charlesworth (2026) states this in print; it is corroboration, not a finding. Exception: the DFE correction referenced here belongs with the robustness results (Gap 14). **[CONTENT]** |
| 16 | 313 | KEEP. Limitations. **Add the autocorrelation scope condition** — under F3 it is a stated scope, not a hidden assumption. **[CONTENT]** |
| 17 | 315 | **REWRITE.** *"mutually irreconcilable"* and *"pedigree models likely capture a conflated mixture…"* both commit to branch A as the conclusion. **[CONTENT]** |
| — | new | **ADD: forward-compatibility.** *The bound sets a value any sequence-based estimate of fitness variance must come in under.* CLAUDE.md marks this load-bearing; it appears nowhere in the manuscript. Write it **without** citing the temporal-genomic literature (§1 borrowed significance). **[CONTENT]** |

**Target Discussion order:** (1) result, partition-led → (2) the disjunction, owned, neither branch defended →
(3) why the unlinked-only result is the robust core → (4) branch A, compressed → (5) branch B, compressed →
(6) the bound's own soft spot: census `N` and gene flow → (7) forward-compatibility → (8) limitations →
(9) conclusion.

### Appendices

- **A (L318–373) — REWRITE.** Now load-bearing: it is where the partition is proved. See Gaps 1 and 3.
- **B (L375–446) — unchanged.**
- **C (L448–614) — unchanged.** Supplementary. The §3.4 Haldane/linear contradiction is a mismatch between
  Methods and this appendix, not internal to it.
- **D (L616–783) — DEMOTE, with one extraction.** ~170 lines supporting a strand now reduced to one main-text
  sentence. Structurally fine as an appendix. **But D.5 "Strong-Selection Correction for Unlinked Interference"
  (L768–783) is misfiled** — see Gap 14.

---

## Part 2 — Gap register

Logical gaps introduced or sharpened by F3: premises now asserted without support, conclusions that no longer
follow, and internal contradictions the new emphasis exposes. Ordered by load.

### Gap 1 — The partition is announced but has no representation in the model *(critical)*

**The problem.** F3's claim is that the bound binds the *directionally consistent* component of `V_A`. Every
equation in the paper — Eq. (1) `N_e/N = 1/(1+4V_A)`, Eq. (5) with κ, Eq. (11), and `V_A,max = (1-δ)/(4κδ)` —
takes one undifferentiated scalar. There is no `V_A^dir`, no `V_A^fluc`, and no parameter that could separate
them. As the manuscript stands, F3 would be a sentence in the Discussion asserting a decomposition that the
mathematics does not perform. A referee will read that as a retreat dressed as a result.

**Where the derivation belongs.** Appendix A, L340–357, and it is already half-written. The load-bearing step:

```
Δp_total^sel = Σ_t (1/2)^t Δp^sel = 2 Δp^sel          (L348)
Var(Δp_total^sel) = 4 V_A · p(1-p)/(2N)               (L355)
```

The factor of 4 is 2², and the 2 comes from summing a displacement **that keeps its sign** across the geometric
decay. That sign-persistence *is* the directional assumption. It is currently invisible because it is never
named.

**Sketch of the fix.** Let ρ be the per-generation autocorrelation of the breeding-value effect on relative
fitness. The sum becomes `Σ_t (ρ/2)^t = 1/(1 - ρ/2)`, and the amplification factor generalizes:

```
N_e/N = 1 / (1 + κ · A(ρ) · V_A),     A(ρ) = [1/(1 - ρ/2)]²
A(1) = 4        (perfectly directional — recovers the current result)
A(0) = 1        (no cross-generation persistence)
A(-1) ≈ 0.44    (perfectly reversing)
```

`V_A,max` then reads `(1-δ)/(κ A(ρ) δ)`.

**Why this is a strengthening, not a concession.** The full range of `A(ρ)` across *every* autocorrelation
structure is roughly `[0.44, 4]` — a factor of about nine. The reported violation is two to three orders of
magnitude. **A factor of nine does not close it.** So the honest claim is stronger than F3 as written: the bound
does not merely bind the directional component; it binds total `V_A` under any autocorrelation structure, and
its most permissive form is only ~9× weaker than its strictest. That is a positive, quantitative, defensible
statement, and it is the "sharpen, do not retreat" move F3 asks for, executed harder.

**Caveat — verify before relying on this.** The step at L353 ("the variance of the cumulative effect scales with
the square of the cumulative sum") is heuristic as written; carrying a signed autocorrelation through it needs
doing properly rather than by analogy. The `[0.44, 4]` range is a first-pass sketch from the manuscript's own
machinery, not a result. Treat it as the derivation to attempt, not as one already in hand. If it survives,
recalibrate F3's concession in `CLAUDE.md`.

### Gap 2 — Fluctuating selection is being used twice, in opposite directions

Discussion ¶11 (L305–307) presents fluctuating selection as **resolution three**: a reason the discrepancy may be
an artifact. F3 wants the same mechanism as **branch B of the finding**: a component of the partition. These are
incompatible dispositions. If fluctuating selection dissolves the discrepancy, the discrepancy is not evidence
about `V_A`; if it is a branch of the partition, it is an outcome, not an escape.

The move that makes it a finding rather than an escape is precisely Gap 1's derivation: once the bound is shown
to hold *with a quantified weakening* across the whole autocorrelation range, fluctuating selection stops being
a way out and becomes a thing the bound measures. **Without Gap 1, Gap 2 has no resolution and F3 is
rhetorical.** This is the central exposure.

### Gap 3 — "No stationarity assumption" is claimed in the main text and contradicted in Appendix A

**Not in CLAUDE.md's Rule 5 staleness log. New.**

- Main text L40: *"…it requires no assumption regarding the temporal stationarity of the selective background.
  Consequently, [Eq. 1] applies universally regardless of the selective regime maintaining `V_A` — encompassing
  mutation-selection-drift balance, episodic selective sweeps, or fluctuating selection."*
- Appendix A L351: *"**Assuming `V_A` remains stationary under mutation-selection-drift equilibrium**, a new
  influx of selective variance … is generated each generation."*

Both cannot stand. The contradiction was survivable under earlier framings. Under F3 it is not, for two reasons:
the stationarity-free status of the unlinked result is one of three explicitly load-bearing items; and L40's
"encompassing … fluctuating selection" asserts exactly the universality F3's central claim denies.

**Root cause: two different assumptions share one word.** (a) Stationarity of the *composition of the selected
background* — what `Z` requires, what sweeps violate, and what the unlinked derivation genuinely does not need.
(b) Persistence of the *sign* of breeding-value effects across generations — what the geometric sum needs, and
what fluctuating selection genuinely does violate. Separate them by name in §2.1 and Appendix A. Gap 1's ρ is
the vocabulary for (b).

### Gap 4 — The observed side is now load-bearing and Methods §3.6 does not exist

`V_A,max` is evaluated at δ, the observed retained fraction of diversity, which requires π, μ, and a census `N`.
Under the historical frame the independence audit made the *predicted* side clean and named the *observed* side
as the soft one — a pre-empted weakness in a closing check. Under F3 the per-species bound is the headline, so
the observed side moved from closing check to load-bearing input, and §3.6 (L267–268) is still a bracketed
author-input note. The delivered R4 prose already asserts "two to three orders of magnitude" in a submitted
document; the manuscript has no Results section behind it.

This also relocates the paper's most exposed flank. Cryptic immigration and monitored-`N` uncertainty (current
Discussion ¶10, L301) now attack **the headline result** rather than a supporting comparison, and they attack
the *bound itself* — they are not one of the two branches. Keep that separation explicit or the disjunction
stops looking robust.

### Gap 5 — "Heritable **and** directional" is a conjunction the paper only half-supports

R4's settled claim bounds variance that is *"both heritable and consistently directional."* Negated, that is a
disjunction: not heritable **or** not directional. F3 is emphatic — own the disjunction, do not defend either
branch, because a result that cannot be defeated by establishing either one is what makes it robust.

The manuscript currently argues branch A across three paragraphs (L295, L297, L299) and treats branch B as a
threat (L305). That is the opposite disposition. Two consequences:

1. The Theory §2.6 list at L187 — conditions (i) non-equilibrium, (ii) cryptic immigration, (iii) animal-model
   bias — must be recast. It is a three-item menu of ways the model might fail; it needs to become a two-branch
   disjunction of what the bound establishes, with (ii) held out separately as an attack on the bound.
2. The Discussion's branch-A material must be cut to roughly a third of its length. Not for concision — because
   its current length constitutes an argument F3 forbids making.

### Gap 6 — The conclusion commits to branch A

L315: *"pedigree-based animal models likely capture a conflated mixture of stable Mendelian transmission and
environmentally structured covariance among relatives."* That is branch A stated as the paper's conclusion, in
the last paragraph. Also L283/L315's *"mutually irreconcilable"* — the partition frame says the two bodies of
data are reconcilable, and the reconciliation *is* the result.

### Gap 7 — κ and the amplification factor must be separated before the partition can be surgical

`V_A,max = (1-δ)/(4κδ)` compounds two distinct factors. κ (Appendix B) is a *within-generation* concentration of
heritable family-size variance across gametic pools; the 4 is the *cross-generation* amplification. Only the
latter carries the directional condition. Stating this makes the partition a clean operation on one factor
instead of a vague qualification on the whole bound — and it means the mating-system result survives the
partition untouched. One sentence in §2.3, one in §2.6.

### Gap 8 — Where Connallon & Czuppon and Charlesworth are cited determines whether F3 succeeds

The currency risk F3 was written to answer only closes if these are cited. But §1 (borrowed significance) forbids
citing them as the gap the paper fills, and CLAUDE.md is explicit: *"Do not cite them as the gap we fill."*

The one placement that satisfies both: **inside the paragraph that owns the disjunction**, as the mechanistic
content of branch B, cited neutrally — balancing selection under drift and fluctuating selection can maintain
substantial `V_A` for fitness. Not in the Introduction as motivation. Not as an open challenge being answered.
State what the bound does; the connection is then visible without being leaned on.

**Bibliography status:** neither is verified against Crossref and neither has a `references.bib` entry
(CLAUDE.md open item 2; sign-off item 5). Also unresolved: the manuscript cites *"Matheson and Masel 2025"* at
L21 and *"Matheson and Masel 2024"* at L153 — same work, two years, at least one wrong.

### Gap 9 — Results do not exist

Not introduced by F3, but F3 changes what they must show, and no re-cut of the Discussion can be finished
against `[XX]` placeholders. §4.2 additionally carries the hard dependency recorded in CLAUDE.md: the per-species
`V_A,max` test is **not** insulated from the hardcoded `s_het` or the 20 Mb macrochromosome filter, because a
shifted prediction can flip an individual species across the bound. The headline "2–3 orders of magnitude"
aggregate *is* insulated. The per-species table is not. Resolve both before building it.

### Gap 10 — Deleting the opposite-directions claim orphans its citations

Discussion ¶5–6 (L291, L293) carry Lewontin, Buffalo 2021, Corbett-Detig 2015, Comeron 2017 in service of the
withdrawn claim. Deleting the claim leaves them unhoused.

**Unsettled, and it is the user's call.** R4's end state is *absent entirely* — CLAUDE.md notes Lewontin and
Buffalo do not appear in the delivered statement at all, and calls that "the correct end state." CLAUDE.md's
emphasis triage separately permits *"locating only, one sentence each."* For a three-page research statement,
absent is right. For a GENETICS submission, a reader needs one sentence to know where the comparison sits, and
zero citations to Buffalo in a paper propagating `V_A` to π will read as an omission rather than a choice. **My
read: one locating sentence each, in Discussion, not the Introduction.** Flagging rather than deciding.

### Gap 11 — The forward-compatibility claim has no home, and needs one qualifier

CLAUDE.md marks it load-bearing and calls it "the most durable sentence in the framing." It appears nowhere in
`scratch.tex`. It needs a Discussion slot and probably an abstract clause.

One content check: as stated — *any sequence-based estimate of fitness variance has to come in under it* — it
inherits the same directional qualifier as the bound itself. A temporal-genomic estimator measuring reversing
variance is not bounded by the strict form. Write the qualifier in, or the claim overreaches exactly where it
is meant to be most durable.

### Gap 12 — The stated attenuation criterion is wrong for the unlinked term

L305: *"The critical requirement for this attenuation is that fitness reversals occur on a timescale comparable
to or shorter than `1/s` generations."*

That criterion governs the **linked** term, where association lifetime is set by `Z` and scales as `~1/s`. For
the **unlinked** term the geometric weights are `(1/2)^t` — memory of roughly one to two generations. Reversals
on a `1/s` timescale (`s = 0.01` → ~100 generations) are far too slow to attenuate it.

The consequence runs in the paper's favour and is currently unstated: **the load-bearing unlinked-only result is
nearly immune to branch B unless selection reverses sign on a one-to-two generation timescale.** This is the
same insight as Gap 1's `A(ρ)` range arriving from the other direction, and the two corroborate each other. It
belongs in the Discussion paragraph that owns the disjunction, and it is the strongest single sentence available
for calibrating how much F3 needs to concede.

### Gap 13 — F3's triage lowers the priority of two known staleness items

A consequence worth recording rather than a gap. The `f_i` gene-count-vs-coding-bp divergence (§3.3) and the
Haldane-vs-linear contradiction (§3.4 against §2.4 and Appendix C) both sit **entirely inside the linked term**,
which F3 demotes to supplementary. They still need resolving before submission; they no longer block the
headline. The `s_het` hardcoding and the 20 Mb filter do **not** get this reprieve — they reach the per-species
test (Gap 9).

### Gap 14 — Appendix D.5 is misfiled and should be promoted

CLAUDE.md's triage puts the whole MSD / implied-`s` strand in "supplementary, now demoted to *consistent with
Charlesworth 2026*." Correct for D.1–D.4. **D.5 (L768–783) is a different object.** It derives the DFE
correction to unlinked interference, `B_unlinked ≈ exp(-4U_d · t̄_eff)` with `t̄_eff < t̄`, showing the Robertson
formula *overstates* unlinked suppression at high implied selection coefficients — and that the correction fails
to rescue predicted `N_e` to observed levels.

That is not corroboration of Charlesworth. It is a robustness check on the **bound**, and it is one of the
strongest available, because it is the referee's most natural objection ("your Robertson factor is too crude at
these effect sizes") answered in advance. It should move to §4.4 Robustness, with the derivation staying in an
appendix, and should not be demoted alongside the MSD strand.

---

## Part 3 — Downstream consequences outside `scratch.tex`

- **`main.tex`** — wholesale replacement, per Rule 6. It is three framings stale *and* carries dead formulas
  (`N_e/N = exp(-4V_Aκ)`, linear `κ ≈ 2 - p`). Recommended backport order under F3: Theory §2.1 + new §2.2 +
  `V_A,max` first. That is the load-bearing spine, it carries the fewest citations, and it is the part whose
  prose is least likely to move again.
- **`references.bib`** — 7 entries against ~60 unique prose works. F3-critical additions: Connallon & Czuppon
  2026, Charlesworth 2026, Matheson & Masel (year unresolved). Crossref-verify or mark `% UNVERIFIED:`.
- **Figures** — no figure is wired into any `.tex` file. Under F3 the headline figure becomes per-species
  `V_A,max` vs. observed. `manuscript/figures/MainFig_Va_Max_Boundary.tiff` looks like the relevant artifact, but
  Rule 8 designates `manuscript/figures/` as superseded collaborator output and instructs asking rather than
  guessing when a filename is ambiguous. **Confirm which file is meant before wiring.**
- **`DECK_SCRIPT.md`** — out of scope here, but S28's "bracket" figure visualizes the withdrawn
  opposite-directions claim and S27 names the Robertson-autocovariance-vs-pedigree-`V_A` equation as attack
  surface #3. Under F3 that attack surface becomes the stated scope condition (Gap 1) and S28's centrepiece
  needs replacing. Both are downstream of decisions made here.

---

## Part 4 — Ordering

Dependencies, not a schedule.

1. **Gap 1** — attempt the ρ derivation. Everything F3 promises is downstream of it, and its outcome determines
   how much the framing needs to concede (Gaps 2, 3, 12 all resolve with it).
2. **Gap 3** — reconcile L40 against L351 in the same pass. Same root cause, same vocabulary.
3. **Methods §3.6** and the `s_het` / 20 Mb resolution — both block Results §4.2, which is the headline.
4. **Results** — build 4.1 and 4.2 first; they are the load-bearing pair.
5. **Discussion re-cut** — needs the numbers. Do the deletions (¶5, ¶6) and the compressions (¶7–9) first, since
   those need no results.
6. **Introduction rewrite** — last. It should describe a paper that exists. CLAUDE.md notes the Intro rewrite
   "can proceed without waiting," which was true under the historical pivot; under F3 the Introduction has to
   state the partition and the scope condition in ¶3–4, so it now waits on step 1.

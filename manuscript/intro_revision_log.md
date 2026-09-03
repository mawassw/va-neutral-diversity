# Introduction revision log

Issues found during paragraph-by-paragraph drafting, held for the whole-Introduction pass. Each
paragraph was accepted as drafted; nothing here has been applied. Companion to
`manuscript/redraft_framing.md`.

**Status key.** `MUST` = wrong or misleading as written. `SHOULD` = real cost, no error.
`OPTIONAL` = judgment call. `DEBT` = deferred on purpose, discharged elsewhere.

---

## Cross-cutting — decided 2026-09-01

### X1 `MUST` Reduce the empirical results carried by the Introduction

As briefed, the Introduction states nearly every number in the paper: the unlinked reductions, the
linked total, $U_d$, $s^*$, and the three fold-differences on the MSD side. That leaves Results with
nothing to deliver and commits four locations to numbers that are still provisional.

**The line to hold:** the Introduction carries *inputs* and *thresholds*; Results carries *measured
magnitudes*.

| stays in the Introduction | why | moves to Results |
|---|---|---|
| $V_A$ distribution: 19 populations, 0.003–0.50, median 0.10 | Bonnet et al.'s result, not ours — it is the paper's input | — |
| Diversity deficits $10^2$–$10^6$ | comparative literature, not ours | — |
| $V_A \gtrsim 25$ and $V_A \lesssim 10^{-2}$ | properties of the framework at a stated target, not empirical findings; I5's argument cannot be made without them | — |
| $U_d \approx 1$, as an order of magnitude | needed to derive the $10^{-2}$ threshold | $U_d$ = 0.69–1.19, median 1.07 |
| ~20-fold, as the mechanism's ceiling | the diversity verdict is not statable without it | 1.39x at median, 2.99x at max; $\overline{\Omega}$ 0.1–0.85 |
| "one to two orders above the DFE range" | qualitative, and the verdict | $s^*$ = 0.019–0.313, median 0.145; 136x / 27x / 14x |

Affects the drafted I3 and the briefs for I4 and I5. The Introduction still states both verdicts and
the empty interval — the finding is not withheld, only its arithmetic.

### X2 `DEBT` Three scope conditions deferred to I6

I1 converts a variance effective size to a coalescent one inside one clause; I2 seeds that the
estimator is single-generation; I3 introduces $1/(1+4\kappa V_A)$ without its equilibrium conditional.
All three are correctly deferred. I6 was split from the original combined brief to discharge them, and
the roadmap moved to I7. **Verify at the pass that I6 actually pays all three.**

### X4 `MUST` The Introduction reports rather than argues

Observed by the user at I6. Every paragraph so far is comprehensive: it delivers each item its brief
listed, in the order listed, roughly one sentence per item. The result reads as an inventory of the
project rather than an argument that makes the study necessary. A GENETICS introduction is a chain of
claims each of which the next paragraph is obliged to answer, not a summary of what the paper contains.

**Cause, partly upstream.** The briefs are written as bulleted inventories under **Carries**. An agent
drafting from an inventory produces an inventory. The bullets state what must be *true* of the
paragraph, not what must be *said*, in sequence — a standing rule to that effect has been added to
`editor_kickoff.md`, and later briefs should compress **Carries** into a claim plus its evidence.

**At the pass**, for each paragraph ask: what does this paragraph oblige the next one to do? Anything
present that does not create or discharge such an obligation is inventory, and comes out. Expect the
Introduction to lose material rather than gain it. X1 is one instance of this; X4 is the general case.

### X3 `SHOULD` $N$ versus $N_c$ throughout

$N$ is breeding adults; $N_c$ is total census; the diversity ratio $(\pi/4\mu)/N_c$ and the
demographic ratio $N_{eV}/N$ differ by 2–10x before anything else. Check every occurrence in the
finished Introduction, not just the one flagged in I3.

---

## I1 — accepted

- `OPTIONAL` "equals $V_A/\bar{w}$ in the generation in which it is measured" → "per generation".
  Six words, no loss: "and says nothing about the generation after" already carries the guard.
- `DEBT` The variance-to-coalescent conversion sits in the clause "The same reduction compresses the
  neutral coalescent." Correct for a background paragraph. See X2.

## I2 — accepted

- `MUST` **Closing sentence restates I1.** "A variance of that size, propagated through the Robertson
  effect, predicts a level of neutral diversity" repeats I1's "a given $V_A$ predicts a level of
  genome-wide neutral nucleotide diversity", putting old information in the paragraph's stress
  position. Recast so the unstated magnitude sits in stress position. Do not cut it — I3 needs the
  handoff.
- `MUST` **"Alberta bighorn sheep" → "Ram Mountain bighorn sheep."** The population is Ram Mountain,
  which is in Alberta, so the phrase is not false — but `AB` in this dataset is **yellow baboons at
  Amboseli**, and the collision will reach the Methods tables.
- `SHOULD` **Two of three exemplars are sheep.** The 19 span hyenas, baboons, macaques, meerkats,
  voles, red squirrels, red deer and eight passerine populations. Swap one sheep for Amboseli baboons
  or red deer so "wild vertebrate populations" earns its breadth.
- `SHOULD` **LRS / LBS inconsistency.** Sentence 2 says lifetime reproductive success, sentence 5 says
  lifetime breeding success. The data are LBS. This readership tracks the distinction.
- `SHOULD` **"the variance in fitness itself rather than in a component trait"** pre-commits against a
  caveat D2 must raise: unweighted lifetime breeding success does not discount delayed reproduction in
  age-structured populations and so overstates the additive variance in Fisherian fitness. Soften to a
  composite lifetime measure.
- Noted, not an issue: opened on the animal model as topic despite the brief. "That variance" at word
  five carries enough old material to read without a bump.

## I3 — accepted

- `MUST` **"The unlinked term is linear in $V_A$" is wrong.** $1/(1+4\kappa V_A)$ is a hyperbola in
  $V_A$. The true and more useful statement is the reciprocal: the fold-reduction
  $N/N_e = 1 + 4\kappa V_A$ is linear in $V_A$. Recasting also pre-wires I5, since
  $4\kappa V_A \approx 99$ is where $V_A \gtrsim 25$ comes from.
- `MUST` **"The deficits these taxa show against $4\mu N$".** Sentence 2 defined $N$ as breeding
  adults; the literature deficits are computed against census size. Use $N_c$. See X3.
- `SHOULD` **Matheson and Masel antecedent.** "Those figures are what it comes to once computed" sits
  after the 20-fold total, but refers to the unlinked figures two sentences earlier. Move the sentence
  to directly follow the unlinked numbers.
- `SHOULD` **Sentences 4–6 assert one point three times** (linearity caps it / no compounding remains
  / capacity not an estimate). Cut sentence 5; "remains to be recovered" is the murkiest phrase in the
  paragraph and sentence 4 in reciprocal form already carries it.
- `SHOULD` **"most permissive genome-wide parameterization"** — permissive toward what? Read as
  favourable to diversity, it inverts the meaning. Use "most extreme" or "most favourable to the
  mechanism".
- `OPTIONAL` **"a range taken from the comparative literature and not computed here"** — the citation
  already does this work, and saying it aloud is defensive. Keep as a marker while drafting; drop at
  backport once Methods states the source.
- `PROVISIONAL` The ~20-fold inherits the unresolved factor of 2 in the linked exponent
  (`chrom_reduc` $v_i$ vs `total_red` $v_i/2$). Draftable, not publishable. See brief §9.

## I4 — accepted

- `MUST` **"smaller than the median measurement by 136-fold, 27-fold and 14-fold" names the wrong
  median.** Those factors are computed against the **eight-population** median $V_A$ = 0.146
  ($0.146 / (1.07 \times 10^{-3}) = 136$), not the nineteen-population median 0.0997, which is the
  only median the reader has seen — I2 gave it as 0.10. Against 0.0997 the factors are 93 / 19 / 9.
  The eight-population pairing is the correct one, since $U_d$ exists only for those eight. Name the
  set explicitly wherever these factors appear, here and in Results.
- `MUST` **Apply X1.** Three number blocks move to Results: $U_d$ = 0.69–1.19 median 1.07;
  $s^*$ = 0.019–0.313, median 0.145, 0.092 at the upper CI; and the three fold-differences. What the
  paragraph keeps is the chain that produces I5's threshold — MSD sustains $V_A \approx U_d s$,
  $U_d$ is of order one, vertebrate DFEs put $s$ below $10^{-2}$, so MSD sustains
  $V_A \lesssim 10^{-2}$, one to two orders below the measurement. Stripping the arithmetic makes the
  derivation of the $10^{-2}$ end of I5's interval visible, which it currently is not.
- `SHOULD` **Keep $s^*$ as a named object without its numbers.** It is the paper's construct and
  sentence 7 ("a consequence read off the reported variance, not an estimate of selection fitted to
  anything") depends on it existing. State that the implied coefficient sits one to two orders above
  the DFE range; drop the range itself to Results.
- `SHOULD` **$s^*$ and the forward reading are the same fact stated twice.** Under X1 only one keeps
  numbers, and neither keeps them in the Introduction — so state the forward reading in a clause, not
  a sentence.
- `SHOULD` **"$U_d$ the deleterious mutation rate per genome per generation" → diploid.** Methods and
  Appendix D both say diploid, and the factor of 4 in $U_d = 4\mu L_{\text{coding}}$ embeds a
  regulatory target taken equal to the exome. A referee will ask why 4 rather than 2. Either say it
  in a clause or point at Methods.
- `JUDGMENT` **The 19 → 8 set transition first appears here**, three paragraphs after I2 established
  19. Decide at the pass whether the Introduction discloses the eight or defers the whole set question
  to Results. Asserting a verdict from eight populations without saying so is the worse option.
- `OPTIONAL` Sentence 2 gives the full MSD expression and sentence 3 collapses it. Keep — showing the
  general form makes the strong-selection assumption visible as an assumption rather than smuggling
  it.

## I5 — accepted

- `MUST` **Sentence 10 is a brief instruction that leaked into the manuscript.** "Both thresholds are
  stated in the unlinked currency so the arithmetic is internally consistent, and the linked
  amplification is reported separately in the Results" is bookkeeping addressed to the editor, not
  science addressed to a reader, and in an introduction it reads as defensive. Cut it. If the point
  needs making at all it belongs where the linked number is reported.
- `MUST` **The bridge from I4 is missing, and the brief is partly at fault.** I4 ends on the objection
  that the number is wrong; the brief told I5 to open by answering it, and also to lead with Move 1
  (commensurability). Those instructions conflict, because the opposite-direction answer is only
  available once both comparisons are shown to target one quantity. Resolve by making commensurability
  the *first step of the answer* rather than a detour: acknowledge the objection in the opening
  sentence and say that answering it requires knowing the two comparisons ask about one quantity.
  Amend the I5 brief accordingly at the pass.
- `SHOULD` **Sentence 6 runs 48 words and ends by restating sentence 5.** "...because a criticism of
  that kind moves the number in one direction only and one direction cannot serve both comparisons" —
  sentences 4 and 5 have already established this. Name the criticism, attach it, stop.
- `SHOULD` **Say why a hundredfold deficit.** Observed deficits run $10^2$–$10^6$, so 100 is the most
  forgiving end of the range. Unstated, the choice looks arbitrary; stated, it is a concession that
  strengthens the argument — even the easiest target needs $V_A \gtrsim 25$.
- `SHOULD` **"If the measured value is inflated"** reads ambiguously between "the estimate is too high"
  and "the value is large". "If the estimate is inflated" removes it. Direction of the argument is
  correct as written.
- `DEPENDENCY` **I5's $V_A \gtrsim 25$ is only derivable if I3's linearity sentence is fixed.** The
  threshold comes from $1 + 4\kappa V_A = 100$, which the reader can follow only once I3 states that
  the fold-reduction $N/N_e = 1+4\kappa V_A$ is linear in $V_A$. Fix both or neither.
- Correct as drafted and worth protecting: the direction of the opposite-direction argument; both
  order-of-magnitude placements (median 0.10 against $10^{-2}$ and against 25); "it is there before
  any pedigree is consulted", which lands the independence point without a methods brag; and the
  closer.

## I6 — **not accepted, redraft before I7**

The paragraph is I6 and I7 merged, with I7's material first. The scope condition — the entire reason
I6 was split out — gets the last three sentences of eight and arrives after a roadmap and an
independence audit. Sentences 1–4 are I7's content verbatim.

- `MUST` **Cut sentences 1–4 and hand them to I7.** The four-object inventory and the five-input
  independence list are the roadmap paragraph. I6 keeps "One condition governs all of it" onward and
  expands it into a full paragraph.
- `MUST` **Bridge ignored.** The brief asked I6 to open by putting pressure on *reality* in I5's
  closing sentence. It opens on "Locating a measurement in that interval takes four objects", which
  is a topic announcement.
- `MUST` **Two of the three deferred debts are undischarged.**
  (i) *The variance-to-coalescent conversion* (X2, from I1) is not paid, and the draft actually
  commits the slide it was meant to resolve: "The effective size of a population relative to its
  breeding adults, $1/(1+4\kappa V_A)$" is the demographic ratio $N_{eV}/N$, while "the $4N_e$
  generations neutral diversity needs to respond" is the coalescent side. One sentence moves between
  them unmarked. This is the paper's single most consequential step and it is the one place it must be
  explicit.
  (ii) *The two persistence windows* are not kept distinct. Only $4N_e$ appears. The brief requires
  both: $Q = 2$ needs the sign of the advantage to persist ~2 generations, so the unlinked baseline
  survives MSD balance, sweeps and fluctuating selection alike; $\pi$ needs ~$4N_e$. Without the first
  window a reader concludes the baseline requires equilibrium, which is exactly wrong and hands a
  referee an objection the theory already answers.
  (iii) *The estimator mismatch* seeded in I2 is discharged, and well.
- Worth keeping into the redraft: "One condition governs all of it" as the pivot, and the closing
  sentence — "the equation still returns a number, but nothing has accumulated over the $4N_e$
  generations neutral diversity needs to respond" is the concrete statement of what breaks that scope
  condition 1 demands. It is the best sentence in the paragraph. Build I6 around it.
- `NOTE` I7's bridge cannot be written until I6 is redrafted, since I7's content currently sits
  inside I6.

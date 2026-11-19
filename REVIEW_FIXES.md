# REVIEW_FIXES.md — fix list from the 2026-11-18 review

Written for an agent (or the author) to execute in order. Branch `worktree-review-fixes`,
worktree `.claude/worktrees/review-fixes`, cut from `main` at `115c3df`.

## Ground rules

- `CLAUDE.md` governs notation, wording and the build. Where this file changes a settled
  framing (Fixes 1, 3, 5), this file wins; update `CLAUDE.md` as each fix lands (see the
  "CLAUDE.md" line at the end of each fix).
- Line numbers refer to `115c3df`. They shift as soon as text moves, so **locate every edit by
  its quoted string**, not its line.
- New or changed manuscript text goes in `\claude{...}` (cite/ref commands outside the span,
  no span across a paragraph break). Cuts and moves are made outright.
- Draft sentences below are scaffolding in the Results/Discussion register. Keep the content,
  adjust the wording to the surrounding text.
- **All author decisions were given on 2026-11-18** and are recorded at the end of this file
  and inside each fix ("DECIDED"). Nothing in this list is waiting on the author; apply all
  of it. The Abstract draft in Fix 1.8 is still scaffolding that the author will revoice.
- Finish with the build check (CLAUDE.md Rule 7) and commit on this branch. Do not merge.

## Order of execution

1. Fix 6 (technical correction) and Fix 7c (small errors). Independent of everything else.
2. Fix 5 (ceiling to the supplement), then Fix 4 (cut the machinery). Structural moves first.
3. Fixes 1, 2, 3 (framing and claims) on the restructured text.
4. Fix 7a–b (register pass on Theory and Methods) last, on the text that survives, including
   any passage moved to the supplement.
5. R work (figures, table columns) listed under each fix; then the build check.

---

## Fix 1 — The sizing is the contribution; nobody expects fitness variance to explain the deficit

**Problem.** The diversity side is written as a test whose failure is a finding. Its outcome
is foregone: it sets a local pedigree's variance against a deficit defined by a species-range
census, Charlesworth & Jensen 2022 already put the effect at 16–55% from the mean estimate,
and Discussion ¶2 itself concludes that demography is the likeliest cause. A reviewer will say
the test defeats a claim nobody made. The contribution is the per-population **size** of each
effect.

**Principle for every edit.** State the expectation before the result ("not expected to
explain the deficit"), report the result as a size ("accounts for about twofold of a
230–38,000-fold deficit"), and never present the shortfall as a discovery. "Test" stays as the
name of the procedure (CLAUDE.md), and the title-level verdict "too small" stays true; what
changes is which sentence carries the emphasis.

### Edits

1. **Introduction ¶2** (`introduction.tex`). Replace
   "Heritable variance in fitness is a primary candidate for this deficit."
   with a sentence that makes it one contributor of known direction and unknown size, e.g.
   "Heritable variance in fitness is one of the processes that lower $N_e$ below the census
   size, and theory gives the size of its effect from the variance alone."

2. **Introduction ¶6** (the paragraph beginning "If wild populations truly harbor"). After the
   Charlesworth & Jensen sentence, state the expectation and the gap as a sizing gap, e.g.
   "A reduction of that size is far smaller than the deficits of Lewontin's paradox, so
   heritable variance in fitness is not expected to explain them. What has not been measured
   is the size of its contribution in each population, with that population's own estimate,
   mating system and linkage map, nor the size of the part that recurrent mutation maintains."
   Then cut "no study has yet evaluated how much of the diversity deficit this unlinked
   reduction explains in individual wild populations, nor how it compares alongside
   chromosome-scale linked selection", which the new sentences replace.

3. **Introduction, last paragraph.** Replace "We find that the measured $V_A$ is too small to
   explain the missing neutral diversity, and too large to be maintained at MSDB." with a
   sizing statement, e.g. "We find that each equilibrium accounts for a small share of what it
   is meant to explain." Then give the two sizes in this order: (a) the measured variance
   roughly halves the effective size of the median population under multiplicative effects,
   against deficits of hundreds to tens of thousands of fold; (b) recurrent mutation maintains
   about a twentieth of the measured variance in the median population, with the qualifier
   from Fix 2. Keep the "no single rescaling" sentence, amended per Fix 3.

4. **Results `sec:res_unlinked`.** Anchor the median to the published value where it is
   stated (CLAUDE.md wording check 5): after "a median of 0.53", add that this lies within the
   16–55% reduction obtained from the mean of the same estimates~\cite{charlesworth2022}.
   (This adds a second paragraph citing that work; record it as an accepted exception to the
   one-paragraph rule, or cite it here only as a pointer.)

5. **Results `sec:res_deficit`.** Open with the size, not the gap. The current second
   sentence onward leads with "predicted diversity exceeds observed diversity ... by a factor
   of 80 ... 31,000". Lead instead with what the variance accounts for, and give the shortfall
   as the remainder left to other processes. Add the two **shares** defined in item 7.

6. **Results heading.** `sec:res_deficit` "The predicted reduction is orders of magnitude
   smaller than the observed deficits" → a sizing heading, e.g. "Heritable variance in fitness
   accounts for a small share of each observed deficit".

7. **The two shares (DECIDED: adopted).** Each test yields a share, and reporting both makes
   the sizing explicit. Computed by `scripts/R/shares.R` → `data/processed/shares.csv` (point
   convention: $\hat V_A$ at its mode, point direct $\mu$):
   - **share of the measured variance that mutation maintains**, $U_d\bar s/\hat V_A$
     ($= c_\text{MSD}$), 18 populations: **median 4.7%** (quartiles 1.0–9.0%; range 0.17%
     in the Muro blue tits to 155% in snow voles); at or above 100% in 2 (snow voles, red
     squirrels); 50% in meerkats. Within the deficit set (9): 0.17–11%, median 1.4%.
   - **share of the deficit that the measured variance accounts for**, on a logarithmic
     scale, $\ln[1/(N_e/N)_\text{pred}]/\ln(1/\hat\delta)$, 9 populations: under the
     multiplicative model **median 6.9%** (quartiles 4.0–19.5%; range 1.1% in the great tits
     at Hoge Veluwe to 40% in the Muro blue tits); under the multiplicative bound, where it
     equals $\hat V_A/V_{A,\delta} = 1/c_\text{div}$, 1.3–41% (median 6.9%); under the
     small-variance approximation 1.0–15.5% (median 5.6%).
   The logarithmic scale is used because successive reductions multiply; say so in one
   sentence where the share is defined (Theory `sec:conditions`, next to $c_\text{div}$ and
   $c_\text{MSD}$, whose reciprocals and values they are). To apply:
   - add both as columns of `tab_reduction` (`scripts/R/tab_reduction.R`, reading
     `shares.csv` or recomputing), share of the deficit under the multiplicative model;
   - state the deficit share in `sec:res_deficit` and the maintained share in `sec:res_msd`,
     each with its median and range and the populations at the extremes;
   - use both in the Abstract (item 8) and, in words, in Discussion ¶1 ("about a fifteenth
     of each deficit on a logarithmic scale", "about a twentieth of the variance");
   - no new symbols: write them as ratios of defined quantities.

8. **Abstract** (limit 250 words; DECIDED: the maintenance claim is worded to match the
   results, with its conditions and the joint sensitivity). Replace the abstract with the
   draft below (about 260 words; trim to 250 while revoicing, keeping every number and
   condition). What it changes: the paper measures two shares instead of announcing two
   failed tests; the extensions are one subordinate clause (Fix 4); the halving is stated as
   the expected size; the maintenance sentence carries its inputs and the joint result (Fix
   2); the rescaling sentence says the conflict does not depend on the estimates (Fix 3);
   the last sentence is conditional.

   > Pedigree-based estimates show that wild populations carry substantial additive genetic
   > variance in lifetime fitness. Classical theory predicts that such variance reduces
   > neutral diversity and is maintained by recurrent deleterious mutation. It is not
   > expected to explain the diversity that abundant species are missing, but neither its
   > share of that deficit nor the share of the variance that mutation maintains has been
   > measured population by population. We measure both in 19 pedigreed populations of birds
   > and mammals (18 for maintenance, 9 for diversity), allowing for extra-pair paternity
   > and chromosome-scale linkage. If loci act multiplicatively on fitness, the measured
   > variance roughly halves the effective size of the median population, as expected from
   > the mean of the estimates. It accounts for a median 7% (1–40%) of observed deficits of
   > 230- to 38,000-fold on a logarithmic scale, and explaining them would require a
   > long-term variance above one, larger than any estimate. At measured mutation rates and
   > the mean deleterious effects estimated in related species, mutation--selection balance
   > maintains about a twentieth of the measured variance in the median population, and less
   > than all of it in 16 of 18. This excess persists in 12 populations when a larger
   > mutational target, undetected mutations of large effect and a twofold inflated estimate
   > are combined, and in 6 under larger departures. Because a variance that
   > mutation--selection balance can maintain removes at most 5% of neutral diversity at
   > unlinked sites, no rescaling of the estimates fits both equilibria, whatever the
   > estimates are. On current estimates, most of the measured variance is maintained by
   > other processes, and most of the missing diversity has other causes.

9. **Discussion ¶1.** Keep "both equilibria leave most of what they are meant to explain to
   other processes" (author's sentence; it is the sizing claim). Replace "Compared against the
   diversity each population has lost, however, it explains only a small part of each deficit"
   with a sentence that removes the surprise, e.g. "No account of the missing diversity relies
   on heritable variance in fitness alone, and against the diversity each population has lost
   this halving is a small part." Charlesworth & Jensen stay cited in ¶2 only.

10. **Discussion ¶2.** The paragraph already opens on the 16–55% anchor. Change its closing
    sentence so that demography is the expected explanation, not a consequence drawn from our
    test.

11. **Figure captions.** Fig. 2 and Fig. 3 bold sentences currently state the shortfall
    ("in no population does the predicted reduction reach the observed deficit"). Rephrase to
    the size ("... accounts for a small part of each observed deficit, with or without
    linkage").

12. **Title (DECIDED: change it; the author asked for the most accurate title if the current
    one is not).** The first half of the current title is accurate. The second half, "too
    large for mutation--selection balance", is an unqualified verdict that the results
    support for 16 of 18 populations at the primary inputs and for 6 under the stronger joint
    scenario (Fix 2), so it claims more than we show. New title:

    > **Heritable variance in fitness in wild vertebrates accounts for a small share of
    > their missing neutral diversity and exceeds what recurrent mutation is estimated to
    > maintain**

    "A small share" is the median 7% (at most 40%) of Fix 1.7; "is estimated to" carries the
    dependence on borrowed mutational effects and target size. Apply in
    `manuscript/_main.tex` (l.72) and `CLAUDE.md` ("Title"). Leave `scratch.tex`,
    `INTRO_REDRAFT_PLAN.md` and the poster as they are (stale or frozen).

**CLAUDE.md.** Under "The claim", add that the diversity verdict is expected (Charlesworth &
Jensen 2022) and that the contribution on that side is the per-population size; add the two
shares to "Numbers in hand" once recomputed.

---

## Fix 2 — The maintenance result: joint sensitivity, explicit caveat, weaker claims

**Problem.** The maintenance side is the new result and has the softest inputs. (a) The test
depends on the arithmetic mean $\bar s$, the feature of a gamma DFE inferred from
site-frequency spectra that the data constrain least (the mean is set by the tail; this is
why the wolf DFEs were excluded). (b) $\bar s$ is borrowed across large distances: two
flycatchers for every passerine, two cetaceans for ruminants and carnivores, human for both
primates. (c) The target, the tail and the estimate were each varied alone, and a skeptic
will vary them together. (d) Pedigree estimates can be inflated by shared environments.

**New analysis (done 2026-11-18).** `scripts/R/sens_maintenance_joint.R` →
`data/processed/maintenance_joint_sensitivity.csv` (per scenario) and `..._bypop.csv`.
Ratio $= (\hat V_A/k)/[U_d(\zeta)\,\bar s(p)]$, failed where > 1, for the 18 populations:

- target: current ($4\mu L_\text{coding}$), or annotation plus a fraction $\zeta$ of
  unannotated sequence (0, 3, 8, 15%);
- tail: a fraction $p$ of new mutations with heterozygous effect 0.5, hidden from the
  spectra, so $\bar s(p) = (1-p)\bar s + 0.5p$ (adds 0.0025, 0.005, 0.01, 0.025 to the mean
  at $p$ = 0.5, 1, 2, 5%), applied to the whole target, which is biased toward passing;
- inflation: the estimate overstates the long-term variance $k$-fold ($k$ = 1, 2, 3, 5, 10).

Populations still failing out of 18, point convention ($\hat V_A$ at its mode, point $\mu$):

| target | k | p = 0 | 0.5% | 1% | 2% | 5% |
|---|---|---|---|---|---|---|
| current | 1 | 16 | 16 | 16 | 16 | 14 |
| ζ = 8% | 1 | 15 | 15 | 14 | 14 | 11 |
| ζ = 15% | 1 | 15 | 14 | 13 | 11 | 9 |
| current | 2 | 16 | 15 | 15 | 14 | 12 |
| ζ = 8% | 2 | 14 | 13 | 12 | 11 | 8 |
| ζ = 15% | 2 | 14 | 12 | 10 | 8 | 4 |
| current | 3 | 15 | 15 | 14 | 13 | 12 |
| ζ = 8% | 3 | 14 | 12 | 10 | 9 | 4 |
| ζ = 15% | 3 | 10 | 7 | 7 | 6 | 3 |
| ζ = 15% | 5 | 9 | 7 | 5 | 3 | 2 |
| ζ = 15% | 10 | 6 | 5 | 3 | 2 | 0 |

Reading:

- Baseline reproduces the text: 16 of 18 fail, median ratio 21.5.
- No single input passes most populations even at its extreme (15 fail at ζ = 15%, 14 with a
  5% tail, 14 with a tenfold inflation).
- Moderate joint scenario (ζ = 8%, 1% tail, twofold inflation): **12 of 18 still fail** (7
  birds, 5 mammals), but the median ratio is 1.9, and only 7 populations fail with posterior
  probability ≥ 0.95.
- Stronger joint scenario (ζ = 15%, 2% tail, threefold inflation): **6 fail** (blue tits at
  Rouvière, Pirio and Muro, hihi at Tiritiri Matangi, great tits at Wytham Woods, spotted
  hyenas); the median population passes (ratio 0.63).
- All 18 pass only at the corner (ζ = 15%, 5% tail, tenfold inflation). The two Corsican blue
  tit populations are the last to pass.
- Mammals other than hyenas fail by 9–22× at baseline (meerkats by 2.0×) and by 2–5× at
  ζ = 8% (meerkats pass); their verdict depends on the target and the estimate. Birds fail by 10–590× at baseline because
  $\bar s$ = 0.0013; their verdict depends on the tail (a 1% tail raises $\bar s$ fivefold).

**Supportable claim.** The maintenance discrepancy is firm where the measured variance is
large (about six populations) and holds for the median population against each input varied
alone, but for the median population it is within a factor of about two under a moderate
joint scenario. Write to that.

### Edits

1. **Methods, new short subsection** after `sec:meth_maintenance`: "Joint sensitivity of the
   maintenance test". Procedure only, past tense: the three inputs, their grids, the point and
   posterior conventions, the script. No symbols beyond ζ; describe the tail in words.

2. **Methods `sec:dfe_methods`.** State the caveat explicitly where the DFE is assigned: the
   test depends on the arithmetic mean of the DFE; in a gamma DFE fitted to site-frequency
   spectra the mean is determined by the tail of large effects, which the spectra constrain
   least; and the assigned means come from species as distant as cetaceans for ruminants and
   carnivores. Keep the existing sentence that a different $\bar s$ moves the two tests in
   opposite directions.

3. **Results `sec:res_msd`.** Keep the "about 30% of new mutations had a heterozygous effect
   of 0.5" sentence, and follow it with a paragraph that reports the joint analysis: the
   count failing and the median ratio at baseline, at the moderate joint scenario and at the
   stronger one, which populations remain, and the contrast between birds (tail) and mammals
   (target and estimate). Plain mechanism sentence for that contrast.

4. **Supplementary figure** `FigS_maintenance_joint` (heat map of populations failing, target
   × tail, one panel per inflation; `theme_genetics.R`). Extend the script to draw it; cite it
   from the new Results paragraph. Optional per-population panel of the inflation each
   population requires to pass.

5. **Weaken these statements** (search for each string):
   - Abstract (DECIDED): the maintenance sentences are those of the draft in Fix 1.8, which
     states the inputs, the share maintained, the count failing (16 of 18) and the joint
     result (12, then 6), and makes the last sentence conditional ("On current estimates").
     The 16% required effect moves out of the Abstract; it stays in Results and Discussion.
   - Discussion ¶1: "the same variance is more than an order of magnitude larger than
     mutation--selection--drift balance can maintain" and "most of the measured variance must
     be maintained by forces other than recurrent mutation" → remove "must"; state the
     condition (mean effects from related species, the annotated target).
   - Discussion ¶3: "recurrent mutation maintains about a twentieth of the variance measured
     in wild pedigrees" → "about a twentieth at the primary target and about a quarter at the
     largest target we considered".
   - Discussion ¶4: add the joint result and the caveat of edit 2 explicitly, e.g. "The mean
     effect on which this result depends is the feature of a distribution of fitness effects
     that site-frequency spectra constrain least, and we took it from related species. When
     the target, the mean effect and the estimate vary together, the discrepancy persists in
     12 of 18 populations under moderate values and in 6 under larger ones, so the result is
     firm where the measured variance is largest and provisional for the median population."
   - Discussion ¶6: "would have to shift a result by about two orders of magnitude" is true of
     reconciling the two tests (the factor of at least 108). Say so, and add that the
     maintenance test alone is within a factor of about two for the median population under
     the moderate joint scenario.
   - Fig. 4 caption bold sentence: "far above those of the empirical DFEs" → "above the mean
     effects assigned from related species".
   - Results heading `sec:res_msd` can stay (it states the 16%).

6. **Do not** describe the maintenance failure as robust without naming the scenario. Do not
   write "cannot be maintained by mutation" unqualified anywhere.

**CLAUDE.md.** Add the joint-sensitivity numbers to "Numbers in hand (MSD side)"; add
"maintenance verdict firm for ~6 populations, within ~2× for the median under the moderate
joint scenario" to "Why it holds together"; add the script to "Layout".

---

## Fix 3 — Say explicitly what the compatibility condition does and does not show

**Problem.** `eq:compat` does not involve the pedigree estimate. The "no single rescaling
passes both tests" result is therefore the statement that variance maintained by recurrent
mutation removes at most a few percent of diversity at unlinked sites, evaluated per
population with measured inputs. That is known in principle (Charlesworth 2012). The rescaling
argument protects against errors of scale in the estimate, but if the estimate were inflated
by the roughly fortyfold the maintenance test requires, the paper would reduce to the known
half. There is no analysis that removes this; it has to be stated, once, at each of three
homes.

### Edits

1. **Theory `sec:conditions`**, after `eq:compat`. Replace the sentences from "Whether the two
   equilibrium models can be reconciled ... is therefore predetermined by" through
   "$\hat V_A$ merely determines which of the two tests a population passes or fails at
   $c = 1$" with, in substance:
   "Condition~\eqref{eq:compat} does not involve the pedigree estimate. It restates, for a
   population with a measured mutation rate, DFE and diversity, the known result that variance
   maintained by recurrent mutation removes little diversity at unlinked sites
   ~\cite{charlesworth2012}. The pedigree estimate adds where the population lies relative to
   the two thresholds, the share of $\hat V_A$ that mutation maintains and the share of the
   deficit that $\hat V_A$ accounts for. If $\hat V_A$ overstated the long-term variance by a
   factor $1/c_\text{MSD}$, the maintenance discrepancy would vanish and only the known result
   would remain."

2. **Results `sec:res_rescaling`**, second paragraph. Extend "The conflict between the two
   tests therefore does not depend on the pedigree estimates" with one sentence giving the
   consequence: the gap of 108 to 1,890 between the two requirements is set by $U_d\bar s$
   and $\hat\delta$, and the estimates determine only on which side of each threshold a
   population lies and by how much.

3. **Discussion ¶6** (no single bias). After "so no error that scales the estimate up or down
   lets it pass both", add the limit of the argument in words, e.g. "This protects the two
   results from errors of scale in the estimate without making them equally new. Were the
   estimates inflated by the roughly fortyfold that the maintenance test requires, mutation
   would maintain the variance, and the diversity result would reduce to one already known,
   that such a variance removes almost no neutral diversity."

4. **Discussion ¶8** already opens on the condition; keep, and make sure it does not claim
   that the pedigree estimates create the conflict.

5. **Abstract.** The sentence "No single rescaling of the estimates makes them congruent with
   the equilibrium models, because ..." already gives the mechanism. Keep it; do not present
   it as a separate third finding. If words are short, this sentence is the one to compress.

**CLAUDE.md.** In "Why it holds together" item 2, replace "This is the paper's spine" with the
narrower statement: the argument protects against scale errors in the estimate; its content is
`eq:compat`, which is independent of the estimate; the paper says so in Theory, Results and
Discussion ¶6.

---

## Fix 4 — Cut the machinery so the verdict leads

**Problem.** The mating-system scalar, the Haldane position averaging and the linked factor
change no verdict (κ moves an exponent by at most twofold against gaps of two to four and a
half orders of magnitude; linkage lowers the required variance from 1.1–1.7 to 0.28–1.06, still
above every interval). They take roughly half of Theory and a third of Results. The linked
term also applies the measured variance with a purging kernel that, by the maintenance
result, could not carry it.

**Principle.** Main text: each extension gets its definition, one displayed result, the size
of its effect on the verdict, and a pointer. Derivations, comparisons with other authors'
approximations and results that concern the model's internals go to the appendices or the
supplement. Nothing is deleted from the paper; the novelty-ledger items keep their
derivations in Appendices B and C.

### Theory (now ~6,000 words by `wc`, tables included; target about 3,500)

Reorder so that the verdict-bearing material comes first:

1. `sec:quantity` (keep; apply Fix 6).
2. `sec:msdb` (keep).
3. `sec:unlinked` + `sec:onemodel` (keep the three nested forms, the harmonic-mean paragraph
   and the finite-population limit). Trim the duplicate account of the ancestor-centered and
   gene-centered perspectives, which the Introduction ¶3 already gives; keep one sentence and
   the pointer to Barton & Etheridge.
4. `sec:conditions` (the two tests as limits on $c$, `tab:c`, `eq:compat` with Fix 3).
   **Move this up, directly after the unlinked forms**, so that the reader reaches the tests
   before the extensions.
5. One subsection, "Extensions: mating system and linkage" (merging `sec:mating` and
   `sec:linkage`), about 500 words:
   - mating system: the definition of κ in one sentence, `eq:kappaB`, its range, the limits
     κ = 2 and 9/8, and the statement that the bound uses $\kappa_\text{max}$. Everything else
     (separate sexes, Model A, the proportional-siring assumption's rationale) → Appendix B,
     where it already is; cut the duplicate.
   - linkage: what a pedigree does not supply ($f_i$, $Z_k$), the hybrid nature of the term
     stated plainly in one sentence, `total_red`, the definition of $\Omega_i$ and
     $\overline\Omega \le 1$. Move to Appendix C: the Haldane-versus-linear discussion,
     `eq:haldane_avg` (it is derived there as `app:C_kernel`), the comparison with Buffalo &
     Kern's and Santiago & Caballero's averages, the cis/trans and own/partner bookkeeping
     (Appendix B `app:B_split`), the $M_i \to \infty$ limit.
6. `sec:approx` (keep; it is about the verdict). Shorten each bullet to one line.

`tab:models` (the theories as computations of $R$) → supplement (DECIDED), as a
supplementary table in `supp/supp_tables.tex`, cited once from `sec:unlinked`. Keep one
sentence in
`sec:unlinked` that all cited theories compute $R$ and differ in its dependence on breeding
value.

Check every `\autoref`/`\ref` to `sec:mating`, `sec:linkage`, `eq:haldane_avg`,
`linked_penalty`, `eq:genome_linked` after the move (Methods, Results, appendices, captions).

### Results

Target order: unlinked sizing → share of the deficit (Fig. 3, after Fix 5) → linkage (short)
→ maintenance → joint sensitivity (Fix 2) → no single long-term variance (Fix 3).

`sec:res_linked`, from five paragraphs to at most two:

- Keep: genome-wide $N_e/N$ with linkage (ranges), the shortfall at the mode (53- to
  15,000-fold) and across the interval, the narrowest margins (bighorn sheep, song sparrows),
  the required variance with linkage (0.28–0.41 in birds, about 1.0 in bighorn sheep and
  rhesus macaques; moved here from `sec:res_ceiling`, Fix 5), and the one sentence that at
  $s^*$ the linked factor is 0.97–0.99.
- Move to the supplement (a short "Supplementary results: linkage" note, or the captions of
  Figs S_omega / S_linked_fgene / S_noncoding_linked): the bird–mammal paragraph ("In our
  predictions, the contrast between birds and mammals does not follow the recombination maps
  ..."), the Wytham Woods / Hoge Veluwe nonlinearity paragraph, the chromosomes-on-one-curve
  sentence, and the two partition sensitivities.
- State once, in plain words, that the linked term is an upper limit on what linkage adds,
  because it gives the measured variance to alleles purged as slowly as the assigned DFE
  implies, although such alleles could not maintain that variance (cite `sec:approx`).

`Fig. 2` (DECIDED): keep panel (a) as the main figure; move panels (b) and (c) into
`FigS_omega`. R: `scripts/R/fig2_linked.R`. Discussion ¶3's prediction about
macrochromosomes and microchromosomes then points to a supplementary result; keep one Results
sentence so that the Discussion does not introduce it.

`sec:res_unlinked`: keep the single mating-system sentence; no further κ detail in Results.

### Introduction and Abstract

- Abstract: "We extend the models of the reduction in effective population size to extra-pair
  paternity and to linked sites at a chromosomal level, and compute ..." → one subordinate
  clause ("allowing for extra-pair paternity and chromosome-scale linkage").
- Introduction, last paragraph: "We first generalize ... We then incorporate linked sites ...
  Finally, we ask ..." → lead with the question and the two sizes (Fix 1); name the two
  extensions in one sentence after the findings.
- Introduction ¶4 (linked sites) can lose its last two sentences on fine-scale maps, which
  Theory repeats.

### Methods

Methods must stay complete, so procedures remain. Move to the supplement only the comparison
with the linear-map midpoint approximation in `sec:linked_methods` ("We avoided the linear-map
midpoint approximation ... (Figure S_maps)"), keeping one clause and the figure pointer.

**CLAUDE.md.** Update "The model in one screen" and the word counts in "Missing / open work"
3a; record that `sec:mating` and `sec:linkage` are merged and where each moved passage went.

---

## Fix 5 — Move the small-variance ceiling to the supplement

**Problem.** `sec:res_ceiling` treats diversity as an upper limit on the variance
($V_{A,\max}$), in the middle of Results that otherwise treat the variance as a floor for the
deficit ($V_{A,\delta}$). The ceiling is outside its domain at every observed $\hat\delta$ and
its result is a non-result (0 of 19 exceed it).

### Edits

1. **`results.tex`.** Delete the subsection `sec:res_ceiling` as a main-text subsection.
   - Its first paragraph (ceiling; "None of the 19 estimates does so at δ ≤ 0.2, two do at
     ... five at δ = 0.5 ...") → supplement, as a short note with its own figure (item 3).
   - Its second paragraph (required variance with linkage, 0.28–0.41 and about 1.0) → merge
     into `sec:res_linked` (Fix 4).
   - Its last sentence (the forward bridge, "Small as it is against the deficits, the measured
     variance is, as we show next, far larger than recurrent mutation can maintain") → end of
     the section that now precedes `sec:res_msd`, reworded per Fix 2 (no "far larger").
2. **Fig. 3** stays in the main text as the figure of the least variance each deficit
   requires, placed in `sec:res_deficit`. Remove the purple band (small-variance ceiling), the
   horizontal dashed line at $V_A = 1$ and the two vertical dashed lines. Keep the orange
   band, teal lines, points, ticks. Label `fig:ceiling` can stay to avoid breaking references,
   or be renamed `fig:required` with every `\ref` updated. R: `scripts/R/fig3_ceiling.R`.
   Caption: delete the sentences on the purple band and the dashed lines.
3. **New supplementary figure** `FigS_ceiling`: the purple band alone with the points and the
   counts, written by the same script. Add to `supp/supp_figures.tex` with a bold claim
   sentence ("No pedigree estimate exceeds the small-variance ceiling that its population's
   diversity implies").
4. **Theory `sec:conditions`.** Reduce "By contrast, inverting the small-variance
   approximation yields a valid threshold, $V_{A,\max}$ ... one-ninth under strict monogamy)"
   to one clause pointing to Appendix `app:A_first`, where `eq:vamax` already lives.
5. **Methods `sec:pi_methods`**, last paragraph: "We report $\hat\delta$ strictly as the axis
   scaling for the $V_{A,\max}$ and $V_{A,\delta}$ curves. (Any population yielding
   $\hat\delta \ge 1$ would imply $V_{A,\max} \le 0$ ...)" → drop $V_{A,\max}$ from the first
   sentence; keep the model check, stated as "$\hat\delta \ge 1$ would be a failed model
   check".
6. Check the forward bridge and `\ref{fig:ceiling}` in `sec:res_linked`, the notation table
   (`supp/notation.tex` keeps $V_{A,\max}$ as an appendix quantity) and `add_info.tex`.

**CLAUDE.md.** "Supporting results" ($V_{A,\max}$ curve is supplementary); close open item 11
("Results `sec:res_ceiling` still leads with the small-variance ceiling"); update Rule 4
(figure wiring).

---

## Fix 6 — Technical correction: the observed-scale variance under a log link

**Verified** against de Villemereuil et al. 2016 (`genetics1281.pdf`, repo root), pp.
1285–1287:

- Eq. 15: $\Psi = \mathbb E[\mathrm d g^{-1}(\ell)/\mathrm d\ell]$, the average derivative.
- Eq. 16: $V_{A,\text{obs}} = V_{A,\text{exp}} = \Psi^2 V_{A,\ell}$.
- For a log link the derivative of the inverse link equals the expected value (p. 1287), so
  $\Psi = \lambda$, the mean, and the mean-standardized additive variance is
  $V_{A,\text{obs}}/\lambda^2 = V_{A,\ell}$ **exactly**.
- $\lambda^2[\exp(V_{A,\ell}) - 1]$ is the **total genotypic** variance $V(\mathbb E[z|a])$,
  the numerator of the broad-sense Eq. 28. It is not the additive variance.

So the manuscript's "$V_A = e^{\sigma_z^2} - 1$ [Equations 15–16]" attributes the total
genotypic variance to the additive one. Bonnet et al.'s $\mathbf d^\top\mathbf G\mathbf d$ is
the multivariate form of Eq. 16, so under a pure log link $\hat V_A = \sigma_z^2$ with no
approximation. No number in the paper changes (the code already uses $\hat V_A$ as
$\mathrm{Var}(z)$).

### Edits

1. **`theory_model.tex` l.134** (`sec:onemodel`). Replace "Under a pure log link, the exact
   variance in relative fitness on the observed scale is $V_A = e^{\sigma_z^2}-1$, where ...
   For small variances, $V_A \approx \sigma_z^2$; for large variances, $V_A > \sigma_z^2$,
   meaning any lower bound derived for $\sigma_z^2$ serves as an even stricter lower bound for
   $V_A$." with, in substance:
   "Under a log link, the additive variance in relative fitness on the observed scale equals
   the latent variance, $V_A = \sigma_z^2$ with $\sigma_z^2 = \mathrm{Var}(z)$, because the
   average derivative of expected fitness with respect to $z$ is mean
   fitness~\cite[Equations~15--16]{devillemereuil2016}. The total genetic variance in relative
   fitness, $e^{\sigma_z^2} - 1$, is larger, and the excess is non-additive on the observed
   scale. The pedigree estimate $\hat V_A$ is therefore the variance of $z$ that the
   multiplicative model requires, exactly for the log-link component of the animal model and
   approximately once its zero-inflation component is included."
2. **l.136.** "(treating $\sigma_z^2 \approx V_A$; Appendix~\ref{app:A_R})" →
   "(with $\sigma_z^2 = V_A$; Appendix~\ref{app:A_R})".
3. **l.47** (`sec:quantity`). "Barton and Etheridge's log-fitness variance is approximately
   $V_A$ (since $\mathrm{Var}_A(\ln w)\approx V_A(w)$ for small $V_A$; ...)" → "equals $V_A$
   under the log link of the animal model (\autoref{sec:onemodel})".
4. **Results `sec:res_unlinked`** already explains $e^{4V_A} - 1$ versus $4V_A$; check that
   nothing there calls $\hat V_A$ an approximation to the latent variance.
5. Grep the appendices and `supp/notation.tex` for "\approx V_A", "to first order" next to
   $z$ (the notation table has "$a = z - \bar z$ to first order", which concerns the
   small-variance expansion and can stay) and for any second use of $e^{\sigma^2}-1$.

**CLAUDE.md.** Extend the "Units" paragraph: under a log link $\hat V_A = \mathrm{Var}(z)$
exactly (de Villemereuil 2016 Eqs 15–16); $e^{\sigma^2}-1$ is total genotypic variance (their
Eq. 28); the zero-inflation component makes this approximate.

---

## Fix 7 — Prose: Theory and Methods in the register of Results and Discussion

Results and Discussion are plain: no intensifiers, no em-dashes, one claim per sentence, the
verb states what happens. Theory and Methods carry a different register. Bring them to the
first. The Introduction is the author's own pass and is **not** touched.

### 7a. Rules for the pass (both files, and any passage moved to the supplement)

- Delete sentence-opening "Crucially,", "Notably,", "Importantly,"; if the sentence then
  lacks a connective, use "However,", "Consequently,", "Because ...," or none.
- Delete intensifiers and certifiers: seamlessly, vastly, wildly, perfectly, inherently,
  inevitably, overwhelmingly, heavily, strictly, entirely, exclusively (→ "only" where
  restriction is meant), explicitly, directly, simply, merely, fully, properly, smoothly,
  mathematically, theoretically, formally, immediately, systematically, deliberately, massive,
  robust, rigorous, novel, true, exact (unless the result is exact in the technical sense).
- No em-dashes (`---`) and no `--` used as a dash. Use commas, parentheses or two sentences.
- No "enter(s)/entering", "fall(s)", "captures", "dictates", "leverages", "possesses",
  "serves as", "represents" where "is" is meant.
- "conservative" → "biased toward passing" (the one phrase, CLAUDE.md), or name the direction.
- No "i.e.", "e.g."; no clause-colon-clause.
- Methods: procedure in the past tense, no justification that Theory already gives.
- Keep every symbol, equation, citation and number unchanged.

### 7b. Misused or overclaiming terms (replace wherever found)

| found | where | replace with |
|---|---|---|
| "the macro-evolutionary timescale of coalescence" | Theory `sec:unlinked` (l.107) | "the roughly $4N_e$ generations of the genealogy" |
| "true macro-evolutionary variation among species rather than within-population estimation noise" | Methods `sec:rescaling_methods` (l.104) | "variation among species and not among populations that share a species' $\pi$ and $N_c$" |
| "the topological effect of the linkage maps from the biological assumptions of the DFE" | Methods `sec:linked_methods` (l.72) | "the effect of the linkage maps from that of the DFE" |
| "a rigorous out-of-sample prediction rather than a curve fit" | Methods `sec:independence_methods` (l.110) | "a prediction from inputs measured independently of $\pi_\text{obs}$, not a fit to it" |
| "recombination vastly outpaces purging" (at an unlinked site) | Theory `sec:unlinked` (l.103) | "independent assortment removes the association far faster than purging does" |
| "a robust upper bound" | Theory l.103 | "an upper bound" |
| "the absolute maximum variance" | Theory `sec:msdb` (l.72) | "the most variance" |
| "both boundary conditions are seamlessly satisfied" | Theory l.72 | "both hold in a large enough population" |
| "$V_A$ may fluctuate wildly" | Theory l.107 | "$V_A$ may change" |
| "a novel mating-system scalar" | Theory `sec:mating` (l.123) | "a mating-system scalar" |
| "the massive empirical diversity deficits" | Theory `sec:onemodel` (l.132) | "the observed diversity deficits" |
| "a heterogeneous local topography" style phrasing | check moved text | "a reduction that varies along the genome" |
| "the pure effect of linked selection" | Theory `sec:linkage` (l.193) | "the effect of linkage" |
| "collapses smoothly to" | Theory l.193 | "reduces to" |
| "the ancestor-centered and gene-centered perspectives ... formally diverge" | Theory l.187 | "... part" |
| "a conservative upper bound on the linked reduction" (male-only map) | Methods l.70 | "an overestimate of the linked reduction, which is biased toward passing the diversity test" |
| "the conservative bound pairing" | Methods l.72 | "the pairing biased toward passing" |
| "fully self-consistent prediction" | Methods l.104 | "the prediction of MSDB with background selection" |
| "To empirically verify the strong-selection assumption" | Methods l.67 | "To check the strong-selection assumption" |
| "artificially widening the apparent gap" | Methods l.78 | "which widens the apparent gap" |
| "upwardly revises ... likely substantial underestimates" | Methods l.78 | "raises ... so Buffalo's bird census sizes are probably too low" |
| "no population possesses a direct empirical count" / "possess empirical estimates" | Methods l.78, l.101 | "has a count" / "have estimates" |
| "where they could potentially change the biological interpretation" | Methods l.107 | "where they could change a verdict" |

Sentence-level rewrites that the rules alone do not settle (Theory):

- l.72 "Notably, assuming selection is strong relative to drift ... seamlessly satisfied." →
  "Selection that is strong relative to drift ($N_es \gg 1$) is compatible with the small
  variance ($V_A \ll 1$) and small effects ($s \ll 1$) that the models of the reduction in
  $N_e$ assume, because both hold in a large enough population."
- l.81 "Let us track a neutral gene copy originating in an ancestor" → "We follow a neutral
  gene copy from an ancestor".
- l.85 "Crucially, the pedigree estimate $\hat{V}_A$ captures only the variance of the initial
  $t = 0$ factor---the ancestor's own variance in relative fitness. All subsequent terms are
  theoretically extrapolated from Mendelian inheritance" → "The pedigree estimate $\hat{V}_A$
  is the variance of the $t = 0$ factor alone, the ancestor's own relative fitness. The later
  terms follow from Mendelian inheritance". Same paragraph: "add exactly as much to its
  long-term genetic footprint as the ancestor's own initial reproductive success" → "add as
  much to its long-term contribution as its own breeding success".
- l.91 "This term represents the exact inflation of long-term reproductive variance driven by
  inherited fitness differences beyond the neutral Poisson expectation" → "This term is the
  variance in long-term contributions that inherited fitness differences add to the Poisson
  baseline".
- l.93 "Shifting from ... $(z - \bar{z})/2^t$ mathematically represents" → "In the
  gene-centered perspective, $(z - \bar{z})/2^t$ is"; "$Q$ is simply this association
  integrated" → "$Q$ is this association summed"; "perfectly mirrors" → "matches"; "seamlessly
  accounts for" → "extends to".
- l.99 "This mathematical identity explains why" → "This is why".
- l.105 "stabilizes within roughly ten generations---and overwhelmingly within the first
  two---because" → "is settled within about ten generations, and mostly within the first two,
  because"; "The infinitesimal model inherently satisfies this latter condition" → "The
  infinitesimal model meets the second condition".
- l.107 opening → "These conditions apply only to the few generations over which a single
  ancestor's contribution is settled, not to the roughly $4N_e$ generations of the genealogy
  (\autoref{sec:quantity}), over which $V_A$ may change."
- l.111 "This linearity demonstrates that ... responds strictly to the arithmetic mean
  $\bar{V}_A$---the explicit target of Equation~\eqref{eq:c}---and, assuming a constant $Z$,
  is entirely insensitive to the temporal trajectory of $V_A$." → "Because this expression is
  linear in $V_A(t)$, under the small-variance approximation neutral diversity depends only on
  the arithmetic mean $\bar{V}_A$, the quantity defined in Equation~\eqref{eq:c}, and, for a
  constant $Z$, not on how $V_A$ varied over time." Same paragraph: "disproportionately
  dictate both" → "contribute most to both".
- l.146 "Crucially, this exponential reduction relies heavily on the unbounded upper tail" →
  "The exponential reduction depends on the unbounded upper tail"; "inevitably truncate" →
  "truncate".
- l.176 "$\hat{V}_A$ dictates the magnitude of the local reduction whereas the DFE dictates
  its decay kernel" → "$\hat{V}_A$ sets the size of the local reduction and the DFE sets how
  long associations persist"; "than pure MSDB" → "than MSDB alone"; "entering through" →
  "through".
- l.136 "$Q = 2$ enters in the exponent" → "$Q = 2$ appears in the exponent".
- l.244 "is entirely independent of" → "does not involve" (and see Fix 3).
- l.247 → "We chose approximations biased toward passing each test, so a failed test, and the
  result that no single variance passes both ($c_\text{div} > 1 > c_\text{MSD}$), does not
  depend on them."
- l.264 "and we detail each explicitly" → cut.

Sentence-level rewrites (Methods):

- l.39 "refer strictly to breeding adults" → "refer to breeding adults"; "given we cannot
  partition the two components with the immediately available data" → "because the available
  data do not let us partition the two components".
- l.51 "The assumption we make here by treating every mutation across this combined target
  (including synonymous coding sites) as deleterious deliberately biases the maintenance test
  toward passing" → "Treating every mutation in this combined target as deleterious,
  synonymous sites included, is biased toward passing the maintenance test".
- l.63 "Crucially, however, shifting $\bar{s}$ moves our two tests in opposite directions: a
  smaller $\bar{s}$ ..." → "However, a different $\bar{s}$ moves the two tests in opposite
  directions. A smaller $\bar{s}$ ..." (also removes the clause-colon).
- l.67 "so that both sources of uncertainty were fully propagated" → "so that both sources of
  uncertainty were propagated".
- l.72 "drops as low as $0.41$ of the true average" → "is as low as $0.41$ of the average".
- l.76 "restricted strictly to neutral autosomal sites—and even fourfold and synonymous sites
  experience linked selection—" → "restricted to neutral autosomal sites, and fourfold and
  synonymous sites are themselves affected by linked selection,".
- l.101 "We report $\hat{\delta}$ strictly as the axis scaling" → see Fix 5.
- l.104 "a formulation that conservatively biases the diversity test toward passing across
  all magnitudes of $\bar{V}_A$" → "which is biased toward passing the diversity test at every
  $\bar{V}_A$"; "the exact amount sustainable by that DFE" → "the variance that DFE
  maintains".
- l.107 "was fully propagated through every analytical step" → "was propagated through every
  step"; "reflect exclusively" → "reflect only".
- l.110 "$\pi$ is invoked downstream strictly to verify" → "$\pi$ is otherwise used only to
  check"; "derives entirely from" → "comes from".

Remaining instances (the greps below list them) follow the rules in 7a:

```
grep -n -o -E "Crucially|Notably|seamlessly|vastly|wildly|robust|inherently|inevitably|perfectly|mathematically|explicitly|strictly|simply|entirely|exclusively|overwhelmingly|heavily|naturally|properly|smoothly|merely|dictat|captures|enter(s|ing)|falls?|novel|pure |---|fully|true |directly|immediately|systematically|deliberately|formally|conservative|i\.e\.|e\.g\." manuscript/theory_model.tex manuscript/methods_materials.tex
```

At `115c3df` this returns about 85 hits in Theory and 45 in Methods. Target after the pass:
zero, apart from technical uses ("a pure log link" may stay as "a log link"; "exact" where a
result is exact).

**Fisher (DECIDED: may be named before the Discussion).** Theory l.49 ("Fisher's Fundamental
Theorem") and Introduction ¶1 stay as written, apart from lower-casing "fundamental theorem"
in Theory to match the Introduction. The rule "Fisher is not named before the Discussion" is
removed from CLAUDE.md (done on this branch). The rule that the theorem is not a premise of
the claim stands.

### 7c. Small errors (apply first)

| file, line | found | fix |
|---|---|---|
| `theory_model.tex` l.217 | `When $c\text{MSD} < 1$` | `When $c_\text{MSD} < 1$` |
| `theory_model.tex` l.221 | `When $c\text{div} > 1$` | `When $c_\text{div} > 1$` |
| `theory_model.tex` l.125 | "ensuring it weighs on his total breeding success as much as a female's breeding value weighs on hers--a necessary condition when applying a single variance to both sexes requires." | "so that it contributes to his total breeding success as much as a female's breeding value contributes to hers, as a single variance for both sexes requires." |
| `theory_model.tex` l.129 | "becomes increasing decoupled from his social partner's breeding value and more reliant on his own" | "depends less on his social partner's breeding value and more on his own" |
| `theory_model.tex` l.119 | "both partner's breeding value" | "both partners' breeding values" |
| `theory_model.tex` l.123 | `both sexes--matching the empirical estimates of Bonnet et al.~\cite{bonnet2022}--and` | commas in place of the two `--` |
| `theory_model.tex` l.247 | `fails either test--and that ... --is conservative`, "i.e." | rewritten in 7b |
| `theory_model.tex` l.211 | "only when $\bar{V}_A \le 1$—that is, for" (literal em-dash) | removed by Fix 5 |
| `methods_materials.tex` l.63 | "For a gamma DFE with shape $\alpha$ and scale $\beta$, ... shape $\alpha + 1$ and scale $\beta$" ($\alpha$ is the extra-pair paternity rate; CLAUDE.md: gamma DFE in words) | "For a gamma DFE, the variance weights $\nu_k = \varphi_ks_k/\bar{s}$ (\autoref{sec:linkage}) follow a gamma density on $s$ with the same scale and a shape larger by one." |
| `methods_materials.tex` l.78 | `~\cite{lewin2026}.Because` | space after the period |
| `methods_materials.tex` l.76, l.110 | literal en/em dashes ("sites—and", "parent–offspring") | commas; `parent--offspring` |
| `results.tex` l.97 | paragraph begins with a stray leading space (" A tail of large effects") | remove |
| `CLAUDE.md` Layout | lists `manuscript/supp/appendix_A–D.tex` | the appendices are in `supp/` at the repo root |

---

## Fix 8 — Give the linked factor $\Omega_i$ an intuitive meaning where it is defined

**Problem (checked 2026-11-19).** Nowhere does the paper say in plain words what $\Omega_i$
is. Theory `sec:linkage` defines it only as a ratio and a formula (`linked_penalty`), and
calls it "the chromosome-specific linked multiplier"; every other place calls it "the linked
factor" (Results, notation table, Appendix `app:omega`, captions; CLAUDE.md fixes that name).
Results `sec:res_linked` uses $\overline\Omega$ without restating what it measures. Appendix
`app:omega` proves $\Omega_i \le 1$ algebraically and gives no reason a reader could state
in words. The closest thing to a plain definition is the caption of Figure `fig:S_omega`.

### Edits (apply together with Fix 4, which shortens `sec:linkage`; this sentence stays in the main text)

1. **Theory `sec:linkage`**, at the definition of $\Omega_i$. Use one name, "the linked
   factor", and follow the equation with an "Intuitively," sentence (allowed after a formal
   result, CLAUDE.md), in substance:
   "Intuitively, $\Omega_i$ is the fraction of its neutral diversity that a site on
   chromosome $i$ keeps relative to a site that assorts independently of every selected
   locus. Selected alleles on the site's own haplotype stay associated with it until
   recombination separates them or selection removes them, which takes longer than the
   generation or two that an unlinked association lasts, so the variance on that haplotype
   counts for more than the same variance elsewhere in the genome. $\Omega_i$ equals one on a
   freely recombining chromosome and decreases as a chromosome carries more selected
   variance per Morgan and as that variance is purged more slowly."
2. **Same place, the bound.** Give the reason before the pointer to the appendix: linkage can
   only lengthen an association ($\overline{Q^2}_i \ge Q^2$), so the haplotype's variance
   never counts for less than it would at an unlinked site, and $\Omega_i \le 1$.
3. **Results `sec:res_linked`**, first use of $\overline\Omega$: restate it in a clause
   ("the linked factor $\overline\Omega$, the genome-wide $N_e/N$ with linkage relative to
   its value without") so that Results do not depend on the reader having read Theory.
4. **Appendix `app:omega`**: open with the same one-sentence reason as item 2 before the
   algebra.

---

## Author decisions (all given 2026-11-18)

1. Fix 1.7: the two shares are adopted. Numbers from `scripts/R/shares.R`.
2. Fix 1.12: the title changes to the one given there, because "too large for
   mutation--selection balance" claims more than the joint sensitivity supports.
3. Fix 2.5 / Fix 1.8: the Abstract's maintenance claim is reworded to match the results
   (draft in Fix 1.8).
4. Fix 4: `tab:models` and Fig. 2 panels (b) and (c) go to the supplement.
5. Fix 7: Fisher may be named before the Discussion.

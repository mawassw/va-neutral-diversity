# Introduction directive — v3

**Operative document. Supersedes v1 and v2.** v1 kept the verdicts and thresholds in the
Introduction; v2 removed them but was still calibrated to a PLoS Biology introduction, at 700–800
words across five paragraphs built by cutting an existing draft. v3 is calibrated to a 2026 GENETICS
theory paper (`iyag180.pdf`, Lee and Terhorst, *Parameterizing the genetic architecture under
stabilizing selection*): four paragraphs, ~450–500 words, no numbers, no findings.

**This is a fresh draft, not a cut-down.** `manuscript/intro_draft_v1.md` is a source of
already-approved sentences to reuse where they fit (Part D), not a template to compress. Rationale for
the architecture is in `manuscript/intro_outline.md`.

**Target: five paragraphs, 650–800 words.** The exemplar manages four; this paper needs five because
it draws on two independent bodies of established theory rather than one. Word budget above 650 may
buy **orientation only** — a reader who has never met the Robertson effect being brought up to speed —
and never additional claims.

---

## Part A — The one rule

**No object this paper produced appears before P5.** Not a number, and not a construct. Author
decisions of 2026-09-03 permit exactly two exceptions, both named in Part C: one structural remark
about a displayed equation, and one parenthetical magnitude from the published literature.

| established — usable as background, cited | this paper's — P5 in words only, forms in Theory |
|---|---|
| FTNS, per generation (Fisher 1930; Price 1972) | $\kappa(\alpha)$, Models A and B |
| $V_k \approx 2$, $N_e \approx N$ (Wright 1938) | $\overline{Q^2}$ integrated along empirical Haldane maps |
| the Robertson effect (Robertson 1961) | the $f_i$ / $v_i$ partition by functional target |
| $N_e/N = 1/(1+Q^2V_A)$; $Q^2 = 4$ unlinked; $C^2$ at $\bar w = 1$ (Santiago and Caballero 1995, 1998) | the combined linked + unlinked expression |
| quantitative-genetic background selection (Santiago and Caballero 2016; Buffalo and Kern 2024) | $\Omega_i$, $\overline{\Omega}$ |
| the unlinked component is omitted from that accounting, argued qualitatively (Matheson and Masel 2025) | $V_{A,\max}(\delta) = (1-\delta)/(4\kappa\delta)$ |
| fitness autocovariance across generations (Buffalo and Coop 2019) | the Jensen's-inequality bound |
| animal model in the wild (Kruuk 2004; Wilson et al. 2010) | $U_d$ and $s^*$ for these species |
| the estimates themselves (Postma 2014; Bonnet et al. 2022) | every magnitude: 1.4x, 3.0x, ~20x, 136/27/14 |
| diversity far below census expectation (Lewontin 1974; Leffler et al. 2012; Buffalo 2021) | the thresholds 25 and $10^{-2}$ |
| $\pi = 4N_e\mu$ | that the two comparisons move oppositely under rescaling |
| House of Cards, $V_A \approx U_d s$ (Turelli 1984; Bürger 2000) | |
| vertebrate DFE inference (Eyre-Walker and Keightley 2007; Huber et al. 2017) | |

## Part B — Register

Take **scope, length, and what may be claimed** from the exemplar. Take **sentence construction and
diction** from `walid_authorial_style_guide.md`. A sentence of the author's inside the exemplar's
paragraph budget is the target.

Two things not to import from the exemplar: its flatness, and its way of chaining prior work
("Another study used this framework to…"). Two things to import: the numbered display equation in the
Introduction, and the plain gap statement — "to our knowledge this comparison has not been made" is
the genre's normal move and needs no apology.

---

## Part C — The five paragraphs

### P1 — The quantity, and what it is used for · 60–80 words

Name the object, say what its magnitude governs, cite broadly, stop. The exemplar's opener is two
sentences; do not exceed three.

Additive genetic variance in relative fitness as the immediate currency of adaptive change — Fisher's
theorem, one clause, per generation and partial (Fisher 1930; Price 1972). Its magnitude bounds the
rate of adaptation and the scope for evolutionary rescue, which is why estimating it in natural
populations has been a long-standing aim (Crow 1958; Lande 1982).

**Forbidden.** Any implication that FTNS requires persistence across generations. Stake-setting
rhetoric of the form "understanding X is critical for Y".

### P2 — The established second consequence, with the equation · 160–200 words

The paragraph that brings a non-specialist up to speed, and the reason a reader can follow the rest of
the paper. This is where the extra word budget goes.

1. In a neutral Wright–Fisher population family size is Poisson-distributed and $N_e \approx N$
   (Wright 1938).
2. Heritable variance in reproductive success violates that: successful parents transmit the alleles
   responsible, family sizes overdisperse beyond the Poisson expectation, and effective size falls
   below the number of breeding adults (Robertson 1961; Buffalo and Coop 2019). Name it — the
   Robertson effect.
3. **The displayed, numbered equation.** Santiago and Caballero (1995, 1998) give the closed form,
   $N_e/N = 1/(1 + Q^2 V_A)$, with $Q^2 = 4$ for a neutral site assorting independently of every
   selected locus, and their $C^2$ being additive variance in relative fitness at $\bar w = 1$.
4. **Permitted exception 1 — the structural remark, one sentence.** Written as the reciprocal:
   $N/N_e = 1 + Q^2V_A$ is linear in $V_A$, so the reduction the mechanism can impose is bounded
   rather than open-ended. **Do not write "the unlinked term is linear in $V_A$" — $1/(1+Q^2V_A)$ is a
   hyperbola and a referee will say so.**
5. Because $\pi = 4N_e\mu$, a value of $V_A$ implies a level of genome-wide neutral diversity — and
   the diversity wild populations carry is independently measured, and sits well below what census
   sizes predict (Lewontin 1974; Leffler et al. 2012; Buffalo 2021).
6. What has been built on the equation, mirroring the exemplar's second paragraph: development into a
   quantitative-genetic account of background selection (Santiago and Caballero 2016; Buffalo and Kern
   2024), and Matheson and Masel's (2025) recent argument that the genome-wide unlinked component is
   omitted from the usual accounting.

**Forbidden.** Presenting $Q^2 = 4$ as a result. Any evaluated magnitude. Framing the diversity
deficit as a paradox this paper will resolve, or Buffalo 2021 as a foil — locating citations only, per
the retired-claims table in `CLAUDE.md`.

### P3 — What the field now supplies as input · 100–120 words

The incumbent-literature paragraph, in the exemplar's third position: the standard approach, where it
came from, what it yields.

The animal model made $V_A$ estimable in unmanipulated wild populations by partitioning phenotypic
variance over a known pedigree (Kruuk 2004; Wilson et al. 2010). Applied to decades of individual
monitoring in long-term study systems, it has produced a body of estimates for lifetime breeding
success and other composite lifetime fitness measures, and syntheses report abundant heritable
variance in relative fitness across a broad range of taxa (Postma 2014; Bonnet et al. 2022). Name one
or two systems. State that the estimates are reported on the relative-fitness scale — P5 depends on it.

**Permitted exception 2 — the one number.** A single parenthetical magnitude, of order 0.1 on the
relative-fitness scale, attributed to Bonnet et al. A reader who has just seen the displayed equation
then performs the arithmetic unaided. **One parenthetical only.** The range, the quartiles and the
per-population values are Results.

**Fix, carried from the log.** Lifetime *breeding* success, not reproductive success. Two exemplar
systems, not three, and not two sheep — Soay sheep on St Kilda and great tits at Wytham Woods are
verified; if a third is wanted it is **Ram Mountain** bighorn sheep, because `AB` in this dataset is
yellow baboons at Amboseli. Do not write that the estimates capture "the variance in fitness itself
rather than in a component trait" — say a composite lifetime measure, which leaves the Discussion free
to raise the LBS weighting caveat.

**Forbidden.** The catalogue of upward biases in animal-model estimates. That is Discussion material,
and stating it here pre-empts the paper's own argument.

### P4 — The second established constraint on the same quantity · 90–110 words

No counterpart in the exemplar; it exists because this paper makes two comparisons.

Standing additive variance in fitness is also constrained from the mutational side. At
mutation–selection–drift balance it is set by the deleterious mutation rate and the distribution of
fitness effects, reducing under strong selection to $V_A \approx U_d s$ (Turelli 1984; Bürger 2000).
Both inputs are independently estimated for vertebrates — deleterious mutation rates per diploid
genome per generation, and mean heterozygous selection coefficients from DFE inference (Eyre-Walker
and Keightley 2007; Huber et al. 2017). There is therefore an established expectation for the
magnitude of standing fitness variance, arrived at without reference to diversity data.

**Forbidden.** Values of $U_d$ or $s$, this paper's or the literature's. Say the inputs are
independently estimated; do not state them.

### P5 — The gap, and what this work does · 170–220 words

The exemplar's closing move, in the same position and shape: gap → "in this work we" → what the
framework yields.

1. **The gap.** Two established frameworks constrain one quantity — one through the coalescent, one
   through mutation–selection balance — and the estimates the pedigree literature now supplies have
   not been evaluated against either. Plain register; to our knowledge this comparison has not been
   made.
2. **Why it is addressable now, one sentence.** The pedigree estimates are observed-scale,
   mean-standardised additive variance in relative fitness, which is Santiago and Caballero's $C^2$
   and the currency of House-of-Cards balance alike, so a single estimate enters both without
   conversion.
3. **The condition, one or two sentences.** Both frameworks concern the long-run equilibrium variance,
   whereas an animal-model estimate is single-generation and conditioned on the observed population
   state — by construction, not by error. What is compared is therefore what a measured variance would
   imply were it the long-run quantity. Salvage D6's closing sentence here (Part D).
4. **What the paper builds** — the first appearance of any object of this work, **named in words, no
   formulae**: the Robertson baseline corrected for the social mating system through the extra-pair
   paternity rate; the linked contribution integrated along empirical recombination maps, with fitness
   variance apportioned by annotation-derived functional target size; and the inversion of the
   baseline into a ceiling on the fitness variance compatible with a given level of retained diversity.
5. **What it is applied to.** Published estimates for 19 monitored wild vertebrate populations, put
   through both comparisons.

**No verdicts.** End on what the paper evaluates, not on what it found. The abstract carries the
result. Do not write "too small", "too large", "opposite", "incompatible", or any synonym.

> **Labelled alternative, author's option — insert only if instructed.** One clause, no magnitudes,
> stating that the two comparisons return opposite verdicts. It is a one-sentence addition at the end
> of item 5 and changes nothing else.

**Forbidden.** A "we first… we then… finally…" itinerary. No $V_{A,\max}$ formula, no $\kappa$
expression, no $\overline{Q^2}$ integral. The exemplar names what its framework yields and gives no
expression; do the same.

---

## Part D — Sentences worth salvaging from `intro_draft_v1.md`

Approved prose, reusable where the new structure has a place for it. Fit them to the paragraph; do not
bend the paragraph to fit them.

| from | text | to |
|---|---|---|
| D1 | the opening thesis, and the Fisher clause with its non-persistence guard | P1 |
| D1 | the Robertson mechanism sentence — "Because successful parents transmit the alleles responsible for their success, family sizes overdisperse…" | P2, item 2 |
| D1 | "That is the Robertson effect." | P2, item 2 |
| D2 | the animal-model sentence — "a mixed model partitions phenotypic variance over a known pedigree, and decades of individual monitoring supply the pedigree" | P3 |
| D3 | "Yet a variance of that size still has to be maintained." | bridge into P4 |
| D4 | "What maintains it is a question about mutation, not about diversity." | P4, opener |
| D6 | "the equation still returns a number, but nothing has accumulated over the $4N_e$ generations neutral diversity needs to respond" | P5, item 3 |

## Part E — Checks on the finished Introduction

1. **650–800 words, five paragraphs.** Report the count and the per-paragraph counts.
2. **Object audit.** Nothing from the right-hand column of Part A appears before P5, and in P5 only in
   words. $\kappa$, $\overline{Q^2}$ and $V_{A,\max}$ appear as no symbol anywhere in the Introduction.
3. **Number audit.** Exactly two numerals of substance: $Q^2 = 4$ (Santiago and Caballero's) and the
   single parenthetical of order 0.1 (Bonnet et al.'s). Anything else has escaped from Results.
4. **Verdict audit.** Zero. No synonym of "too small" or "too large" anywhere.
5. **The equation.** $N_e/N = 1/(1+Q^2V_A)$ is displayed and numbered in P2, and the structural remark
   is written in reciprocal form.
6. **$N$ versus $N_c$.** Every occurrence says which; the diversity ratio and the demographic ratio are
   never both called $N_e/N$.
7. **Kill list.** No survivor from §1 of `redraft_framing.md`.

## Part F — Where the removed material lives

Nothing is discarded; each item is briefed downstream in `redraft_framing.md`.

| removed | home |
|---|---|
| ~20-fold ceiling; 1.4x and 3.0x | Results R2 |
| $U_d$, $s^*$, the 136/27/14 comparison | Results R5 |
| the thresholds 25 and $10^{-2}$, and the interval between them | Results R7 |
| the opposite-direction argument | Discussion D2 |
| Matheson and Masel as corroboration of a result | Discussion D5 |
| the back-transformation and $\mathbf{d}^\top\mathbf{G}\mathbf{d}$ | Methods; Discussion D3 |
| the five-input independence audit | Methods, own subsection |
| the animal-model bias catalogue | Discussion D2 |

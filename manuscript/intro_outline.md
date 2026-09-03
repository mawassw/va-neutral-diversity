# Introduction outline — v2, calibrated to GENETICS

**Supersedes v1 (2026-09-02), which was 850–950 words and still stated both verdicts.** v1 was
calibrated against a PLoS Biology introduction — seven paragraphs, heavy on field context. The
GENETICS exemplar (`iyag180.pdf`, Lee and Terhorst 2026, *Parameterizing the genetic architecture
under stabilizing selection*) is a different instrument: **four paragraphs, ~450–500 words, and not a
single number.** Target here: **five paragraphs, 550–650 words.**

## What the exemplar does, structurally

| ¶ | move | length |
|---|---|---|
| 1 | names the general object (a fitness landscape), says what it is used for, cites broadly. No stake-setting, no "this is critical for" | 2 sentences, ~60 words |
| 2 | gives the canonical formal model **as a numbered display equation in the Introduction**, then reviews in sequence what has been built on it — three named studies | ~140 words |
| 3 | introduces the incumbent phenomenological approach and where it came from | ~110 words |
| 4 | the incumbent's deficiency → the gap ("to the best of our knowledge, … has yet to be developed") → "In this work, we fill that gap by…" → what the framework yields → what it does better than the incumbent | ~140 words |

**Observations that govern the outline below.**

- **No numbers at all.** Not theirs, not the literature's. Every magnitude lives in the abstract, the
  results, or the figures.
- **No findings, only capabilities.** The closing paragraph uses *yields*, *enables*, *allows*,
  *can estimate*. "Accurately recovers" and "generally improves" appear in the abstract and are absent
  from the Introduction.
- **The Introduction names the objects the Theory section will use** — FGM, the marginal selection
  coefficient, the α-model, $\Sigma_\beta$ — so the Theory section opens straight into derivation with
  no motivational preamble.
- **Register is plain and declarative.** Active "we", short sentences, no rhetorical punch, no
  aphorism. "To the best of our knowledge" is used without hedging apology.

**On voice.** The exemplar's register is flatter than `walid_authorial_style_guide.md` describes.
Resolve this by level: take **scope, length, and what may be claimed** from the exemplar; keep
**sentence construction and diction** from the style guide. A Walid sentence inside a Lee-and-Terhorst
paragraph budget is the target. Do not import the exemplar's flatness, and do not import its habit of
listing prior studies as "Another study used this framework to…".

---

## The five paragraphs

### P1 — The quantity, and what it is used for

**Achieves.** Names the object and establishes that its magnitude is consequential. Mirrors the
exemplar's opener: name, purpose, broad citations, stop.

**Communicates.** Additive genetic variance in relative fitness is the immediate currency of adaptive
change: under Fisher's theorem the partial change in mean fitness attributable to selection equals
$V_A/\bar{w}$ per generation (Fisher 1930; Price 1972). Its magnitude therefore bounds the rate of
adaptation and the scope for evolutionary rescue, which is why estimating it in natural populations has
been a long-standing goal (Crow 1958; Lande 1982).

**Length.** 2–3 sentences, 60–80 words. Resist expanding this.

**Forbidden.** Any implication that FTNS requires persistence across generations. No stake-setting
rhetoric ("understanding X is critical for Y").

### P2 — The established second consequence, with the equation

**Achieves.** Puts the machinery on the page as cited background, so a reader who has never met the
Robertson effect can follow the rest of the paper. This is the paragraph that does the work you
described your Theory section doing, done once and briefly.

**Communicates.** In a neutral Wright–Fisher population family size is Poisson-distributed and
$N_e \approx N$ (Wright 1938). Heritable variance in reproductive success violates that: successful
parents transmit the alleles responsible, family sizes overdisperse, and effective size falls below the
number of breeding adults (Robertson 1961). Santiago and Caballero (1995, 1998) give the closed form
**as a numbered display equation**,

$$\frac{N_e}{N} = \frac{1}{1 + Q^2 V_A}$$

with $Q^2 = 4$ for a neutral site assorting independently of every selected locus, and their $C^2$
being additive variance in relative fitness at $\bar w = 1$. Because $\pi = 4N_e\mu$, a value of $V_A$
implies a level of genome-wide neutral diversity — and the diversity wild populations carry is
independently measured, and is well below what census sizes predict (Lewontin 1974; Leffler et al.
2012; Buffalo 2021). Then, mirroring the exemplar's review of what has been built on its equation: this
framework has been developed into a quantitative-genetic account of background selection (Santiago and
Caballero 2016; Buffalo and Kern 2024), and Matheson and Masel (2025) recently argued that the
genome-wide unlinked component of that reduction is omitted from the usual accounting.

**Length.** 140–160 words plus the equation.

**Forbidden.** The number 4 as a *result*; it is $Q^2$ under free assortment and it is Santiago and
Caballero's. No evaluated magnitudes. Do not frame the diversity deficit as a paradox this paper will
resolve, and do not make Buffalo 2021 a foil — locating citations only.

**Judgment call, flagged.** Whether to state that the fold reduction $N/N_e = 1+Q^2V_A$ is linear in
$V_A$ and therefore bounded. It is a property of the displayed equation, not a computation, and it
prepares the reader for a Results section whose diversity-side answer is a modest number. The exemplar
would omit it. Recommend including it as one short sentence.

### P3 — What the field now supplies as input

**Achieves.** The incumbent-literature paragraph, in the exemplar's third position: here is the
standard approach, here is where it came from. It is what the paper's comparison is performed on.

**Communicates.** The animal model made $V_A$ estimable in unmanipulated wild populations by
partitioning phenotypic variance over a known pedigree (Kruuk 2004; Wilson et al. 2010). Applied to
decades of individual monitoring in long-term study systems, it has produced a substantial body of
estimates for lifetime breeding success and other composite fitness measures, and syntheses across
those datasets report abundant heritable variance in relative fitness across a broad range of taxa
(Postma 2014; Bonnet et al. 2022). Name one or two systems. State that the estimates are reported on
the relative-fitness scale, since P5 depends on it.

**Length.** 100–120 words.

**Judgment call, flagged — the one number.** Whether to give a single parenthetical magnitude
("estimates of order 0.1 on the relative-fitness scale"). It is Bonnet's result, not ours, and with it
a reader who has just seen the displayed equation performs the arithmetic unaided — the nod you asked
for. Strictly the exemplar carries no numbers at all. **Recommend: include it, once, as a
parenthetical, attributed.** Everything else — the range, the quartiles, the per-population values —
is Results.

**Forbidden.** The catalogue of upward biases in animal-model estimates. That is Discussion material
and stating it here pre-empts the paper's own argument.

### P4 — The second established constraint on the same quantity

**Achieves.** Introduces the maintenance question as standard, independent theory, so the paper's
second comparison is motivated before it is performed. This paragraph has no counterpart in the
exemplar; it exists because this paper makes two comparisons rather than one.

**Communicates.** Standing additive variance in fitness is also constrained from the mutational side.
At mutation–selection–drift balance it is set by the deleterious mutation rate and the distribution of
fitness effects, reducing under strong selection to $V_A \approx U_d s$ (Turelli 1984; Bürger 2000).
Both inputs are independently estimated for vertebrates — deleterious mutation rates per diploid genome
per generation, and mean heterozygous selection coefficients from DFE inference (Eyre-Walker and
Keightley 2007; Huber et al. 2017). There is therefore an established expectation for the magnitude of
standing fitness variance, reached without reference to diversity data.

**Length.** 90–110 words.

**Forbidden.** $U_d$ or $s$ values, ours or the literature's. Say the inputs are independently
estimated; do not state them.

### P5 — The gap, and what this work does

**Achieves.** The exemplar's closing move, in the same position and the same shape: deficiency → gap →
"in this work we" → what the framework yields.

**Communicates, in order.**

1. **The gap.** Two established frameworks constrain the same quantity — one through the coalescent,
   one through mutation–selection balance — and the estimates the pedigree literature now supplies
   have not been evaluated against either. State it in the exemplar's register: to our knowledge this
   comparison has not been made.
2. **Why it is addressable now.** Commensurability, in one sentence. The pedigree estimates are
   observed-scale, mean-standardised additive variance in relative fitness, which is Santiago and
   Caballero's $C^2$ and the currency of House-of-Cards balance alike, so a single estimate enters both
   without conversion.
3. **The condition, one sentence.** Both frameworks concern the long-run equilibrium variance, whereas
   an animal-model estimate is single-generation and conditioned on the observed population state. What
   is compared is therefore what a measured variance would imply were it the long-run quantity. Stated
   once here; developed in the Theory section and the Discussion.
4. **What the paper builds** — the first appearance of any object of ours: the Robertson baseline
   corrected for the social mating system through the extra-pair paternity rate; the linked
   contribution integrated along empirical recombination maps, with fitness variance apportioned by
   annotation-derived functional target size; and the inversion of the baseline into a ceiling on the
   fitness variance compatible with a given level of retained diversity.
5. **What it is applied to.** Published estimates for 19 monitored wild vertebrate populations, put
   through both comparisons.

**Length.** 160–190 words.

**Recommended: no verdicts.** The exemplar states none — its closing paragraph is capabilities only,
and the findings live in the abstract. Ending on *what the paper evaluates* rather than *what it found*
is the stricter and more idiomatic choice, and it costs nothing because the abstract carries the
result. **Alternative, if you want the reader to know where it lands:** one clause, no magnitudes,
saying the two comparisons return opposite verdicts. Decide before drafting.

**Forbidden.** A "we first… we then… finally…" itinerary. The exemplar names what the framework
yields, not the order of operations. Also: no $V_{A,\max}$ formula, no $\kappa$ expression, no
$\overline{Q^2}$ integral — name these objects in words, and let Theory give their forms.

---

## Decisions needed before drafting

1. **P2's linearity sentence** — include (recommended) or omit?
2. **P3's single parenthetical magnitude** — include (recommended) or hold everything numeric for
   Results?
3. **P5's verdicts** — omit entirely (recommended) or one clause without magnitudes?
4. **Total budget** — 550–650 words. Confirm, since this is roughly 40% of what has been drafted so
   far.

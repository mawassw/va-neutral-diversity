# Theory and Model — section outline

Calibrated to `iyag180.pdf` (Lee and Terhorst 2026, GENETICS), whose **Theory and model** runs five
subsections over ~2.5 journal pages with equations numbered continuously to (20).

**Target: nine subsections, 2,400–2,800 words plus equations and one table.** The existing
`scratch.tex` §Theory is authoritative for every derivation and most of it survives intact. This
outline reorders it, adds two subsections, and names three things that must be fixed first.

---

## What the exemplar does

| ¶ | subsection | job |
|---|---|---|
| 1 | Diffusion approximation for stabilizing selection | the established population-genetic engine, derived compactly |
| 2 | Connecting evolution to mixed-effects models | the bridge to the statistical machinery, and the incumbent model as an equation |
| 3 | Fitness effect and its influence on a focal trait | the new derivation |
| 4 | Approximate genetic architecture | the closed form that actually gets estimated |
| 5 | Framework breakdown | the derivation as replaceable modules — what can be swapped, and at what cost |

**Register.** Equations carry the argument; prose is functional and short. Assumptions are announced
plainly at the point of use ("Assuming that individual fitness follows the FGM (1)…"). Algebra is
deferred by pointing at a source or an appendix rather than by apologising. Nothing is motivated —
motivation was the Introduction's job and is not repeated.

**The one thing to import above all others:** the section is organised around *what will be computed*.
Every subsection ends closer to a quantity the Results section evaluates.

---

## Findings that must be settled before drafting

### F1 — The Jensen direction is stated backwards outside the derivation. **Material.**

The derivation in §Theory is correct:
$\mathbb{E}_{x_0}[\exp(-\tfrac{\kappa v_i}{2}Q^2(x_0))] > \exp(-\tfrac{\kappa v_i}{2}\overline{Q^2}_i)$.
The left side is the expected $N_e/N$ for one randomly placed locus; the right side is $N_e/N$ under
the uniform density. So **the uniform (infinitesimal) assumption yields the *lower* $N_e/N$ — the
larger reduction** — than randomly positioned large-effect loci would.

Two summary statements invert this:

- `scratch.tex:23` (Introduction): "predictions under that assumption are upper bounds on $N_e/N$."
  It is a **lower** bound on $N_e/N$. *Moot — Jensen leaves the Introduction entirely under the new
  framing.*
- `scratch.tex:317` (Discussion): "uniform distribution minimizes local interference relative to
  randomly positioned large-effect loci and yields an upper bound on $N_e/N$." Wrong twice. Uniform
  does not minimise interference — it supplies the *mean* interference, and $N_e/N$ is convex in
  $\overline{Q^2}$, which is the whole content of the inequality. And the bound on $N_e/N$ is from
  below.

**Why this matters, and why it is good news.** Under the retired framing the paper wanted a
*conservative* model — one that did not overstate the depletion — and the word "conservative" was
attached accordingly. Under the settled claim the useful direction is the opposite one, and it is the
direction the algebra actually gives: the spatial assumption is **the one most favourable to the
mechanism**, so a statement that the mechanism removes at most a given amount survives its own most
generous spatial assumption. State it that way in T6 and in the Discussion.

**The caveat stands as written in `scratch.tex`:** this holds for loci positioned at random with
respect to the recombination landscape. Enrichment in regions of suppressed recombination reverses the
inequality.

### F2 — Mutation–selection–drift balance has no Theory subsection. **Structural.**

It exists only as Appendix D. Under the settled framing the two comparisons are co-equal, so a reader
of the main text currently meets one engine and not the other. **T8 below is new**, and it is the
single largest addition this section needs. Appendix D already contains the algebra; T8 states the
result, the inversion, and the self-consistency check, and points there.

### F3 — Three known defects inside the material T4 and T5 are built from

1. **The factor of 2 in the linked exponent.** `chrom_reduc` (line 113) carries $v_i$; `total_red`
   (line 149) carries $v_i/2$; the prose at 144–148 justifies the halving and the R code implements it.
   Resolve toward $v_i/2$ and label `chrom_reduc` as pre-partition, or carry the halving into it. **It
   sits on the linked magnitude the Results report.**
2. **$\overline{Q^2}$ method contradiction.** §Theory says the integral is evaluated numerically under
   Haldane and argues against the linear approximation; §Methods describes closed-form expressions
   under the linear approximation. Both cannot describe what was run. Resolve toward numerical
   Haldane, which is what the code does.
3. **Appendix cross-reference.** §Theory points to Appendix A for the closed-form linear limit; it is
   in Appendix C. Appendix A is the unlinked baseline.

---

## The nine subsections

### T1 — The quantity, and the two equilibria that constrain it · NEW · ~200 words + notation

**Job.** Orient the reader and fix notation once, so every subsection downstream can be terse. The
exemplar has no equivalent because it needs only one engine; this paper needs a reader to hold two.

**Carries.** $V_A$ defined as additive genetic variance in relative fitness at $\bar w = 1$ — Santiago
and Caballero's $C^2$. The statement that both engines require the **long-run equilibrium** value of
that quantity, and why: the coalescent needs it sustained while $\pi$ approaches a new equilibrium,
and mutation–selection–drift balance is an equilibrium statement.

**The two persistence windows, distinguished here and nowhere else.** $Q = 2$ requires the sign of the
selective advantage to persist only ~2 generations; $\pi$ reaching a new equilibrium requires ~$4N_e$.

**The crossing, marked explicitly.** The derivation produces a *variance* effective size — a
per-generation statement about family-size variance — while $\pi$ measures a *coalescent* effective
size. Name both, say they are equated under long-run equilibrium, and use the notation consistently
thereafter: $N$ breeding adults, $N_c$ total census, $N_{eV}$, $N_{eC}$, $\pi$, $\mu$, $\delta$. **A
short notation table is worth the space.** Two ratios in this literature are both written $N_e/N$ and
the distinction is load-bearing.

### T2 — Effective size under heritable fitness variance · existing §1, tightened · ~250 words

**Carries.** The Wright–Fisher Poisson baseline, $V_k \approx 2$, $N_e \approx N$. The Robertson effect
as the violation. The geometric sum over generations, with the halving of association under free
assortment. The displayed result, $N_e/N = 1/(1+4V_A)$.

**Defers.** The summation to Appendix A, in one clause.

**Scope condition, at the point of derivation.** Because the result depends only on the halving of
associations, it needs no stationarity of the selected background: it holds under
mutation–selection–drift balance, episodic sweeps, and fluctuating selection alike. The one thing it
does require is that the variance persist in sign across the generations over which associations
decay. `scratch.tex` states this correctly already; keep it.

### T3 — Separate sexes and the social mating system · existing §2 · ~250 words

**Carries.** $N_e = 4N/(V_{km}+V_{kf})$ (Hill 1979; Caballero 1994). The partition of male gametic
variance into within- and extra-pair components as a function of the extra-pair paternity rate
$\alpha$. Both scalars — $\kappa = 1+(1-\alpha)^2$ under extra-pair siring independent of breeding
value, $\kappa = 2(1-\alpha+\alpha^2)$ under proportional siring — and that both reach $\kappa = 2$
under strict monogamy. The displayed result, $N_e/N = 1/(1+4\kappa V_A)$.

**Defers.** The partition to Appendix B.

**Note.** State plainly that $\kappa = 2$ under monogamy is a doubling of the exponent, and that the
monogamous passerines dominate the dataset. That single fact does more work in the Results than the
derivation does.

### T4 — Linked interference along the genetic map · existing §3 · ~450 words + table

**Carries.** $N_e/N = 1/(1+Q^2V_A)$ and what $Q$ is. The survival parameter $Z = 1 - V_m/V_A$ and the
fact that defining it presupposes a stationary selected background — so, unlike T2, everything from
here on is conditional on stationarity. Say that explicitly; `scratch.tex` does and it is one of the
section's best moves. The Haldane mapping and why not the linear approximation. The position-specific
profile and the chromosome-averaged integral. The limits table.

**Blocked on F3.1 and F3.2.** Do not draft this subsection until the factor of 2 and the
Haldane-versus-linear question are settled.

### T5 — Total reduction and genomic architecture · existing §4 · ~300 words

**Carries.** The partition $v_i = V_A f_i$ by functional target size, and the halving for a focal
allele linked to one homolog. The combined expression: exponential linked term over the Robertson
denominator. $\Omega_i$, the relative linkage effect, and why its second factor exceeds one — moving
variance into the linked term relieves the global unlinked interference slightly. The length-weighted
genome-wide expectation, and $\overline{\Omega}$.

**Ends closer to what Results computes.** $\overline{\Omega}$ is the quantity R2 reports; make the
subsection land on it.

### T6 — The spatial distribution of selective variance · existing §6, tightened · ~250 words

**Carries.** An arbitrary density $g(x)$; the reduction of the double integral by Fubini to
$\overline{Q^2}(g) = \int g(x)Q^2(x)dx$; recovery of the infinitesimal case; the oligogenic case as a
discrete mean; the observation that $Q^2(x)$ peaks at the chromosome midpoint. Then the Jensen
inequality and **its direction as corrected in F1**: the uniform assumption predicts a larger
reduction than randomly positioned large-effect loci, so it is the assumption most favourable to the
mechanism. Then the reversal condition — enrichment of causal loci in regions of suppressed
recombination.

**Defers.** The proof and the Jensen-gap expression to an appendix.

**Cut.** The empirical-density paragraph (annotated gene positions, $\hat g_i$) unless the analysis
actually uses it. If it does not, it is a stated extension and belongs in T9.

### T7 — The ceiling on heritable fitness variance · existing §5, stripped · ~200 words

**Carries.** Inverting the unlinked baseline at a retained-diversity threshold $\delta$ gives
$V_{A,\max} = (1-\delta)/(4\kappa\delta)$. Why the unlinked baseline is the right thing to invert:
$\Omega_i \le 1$, so no arrangement of recombination or architecture restores diversity above the
unlinked expectation, which makes this the most permissive ceiling. That $\kappa = 2$ halves it, and
what that means biologically.

**Cut, and hand to the Discussion.** The four-branch disjunction (non-transmissible variance, sign
reversal, cryptic immigration, non-equilibrium demography) and the branch-(i) mechanisms. Both
currently sit here and both pre-empt the Discussion. Theory states the ceiling; the Discussion
adjudicates what a comparison against it means.

**Frame as a curve, not a test.** The retired framing made this an inequality populations might fail.
It is a ceiling function, published over $\delta$.

### T8 — The variance sustainable at mutation–selection–drift balance · NEW · ~350 words

**Job.** Supply the second engine in the main text. See F2.

**Carries.** Mutational influx $V_m = U_d s^2$. The balance between influx, purging by selection, and
erosion by drift, giving standing variance $V_A = 2N_eU_ds^2/(1+2N_es)$. The strong-selection limit
$V_A \approx U_d s$, and the House-of-Cards regime it corresponds to (Turelli 1984; Bürger 2000). The
inversion that the Results use: $s^{*} = V_A/U_d$, the mean heterozygous coefficient a reported
variance implies. That $U_d = 4\mu L_{\text{coding}}$, with the factor of four stated as a diploid rate
over a regulatory target taken equal to the exome. The weak-selection branch, and that solving
$V_A \approx 2N_eU_ds^2$ returns $N_es \gg 1$ and so contradicts its own premise.

**Defers.** The derivation and both self-consistency checks to Appendix D, which already contains them
and is internally correct.

**State the logical direction explicitly.** $s^*$ is a consequence read off a reported variance, not
an estimate of selection fitted to any data. This is the sentence that stops a reader treating T8 as a
DFE inference method.

**Also state the connection to $Z$.** Under this balance $V_m/V_A \approx s$, so $Z \approx 1-s$ —
which is what T4 needs and currently assumes without a home in the main text.

### T9 — Framework breakdown · NEW, after the exemplar · ~200 words

**Job.** Two short paragraphs decomposing the framework into modules and naming what each could be
replaced with. Not a caveat list — the Discussion owns caveats. This says what the framework *is made
of*.

**Carries.**

1. **The two engines are independent and rest on different conditions.** The diversity engine needs
   only sign persistence across the generations over which associations decay, and no stationarity for
   its unlinked component; its linked component needs a stationary background through $Z$. The
   maintenance engine needs equilibrium and a single $s$ across deleterious loci. Neither borrows an
   assumption from the other, which is why the two comparisons are independent tests of one quantity.
2. **What is replaceable, and at what cost.** The uniform spatial density can be replaced by an
   empirical one wherever physical-to-genetic maps allow (this is where T6's cut paragraph goes). The
   single $s$ can be replaced by a full distribution of fitness effects, and the direction that moves
   the result should be stated — a leptokurtic DFE makes the implied coefficient less plausible, not
   more, so the uniform-$s$ treatment understates the mismatch. The census $N$ can be replaced by a
   historical or breeder-scaled estimate, and the instrument matters.

**Register.** Follow the exemplar closely here: short, plain, "an alternative model can be adopted by
replacing this component." No hedging.

---

## Decisions needed before drafting

1. **F3.1, the factor of 2** — blocks T4 and propagates to T5 and the Results. Resolve first.
2. **F3.2, Haldane versus linear** — blocks T4 and a Methods subsection.
3. **F1, the Jensen direction** — confirm the corrected reading before T6 is written, and note that
   the Discussion sentence at `scratch.tex:317` needs the same fix.
4. **T6's empirical-density paragraph** — does the analysis use annotated gene positions within
   chromosomes, or only the between-chromosome partition $f_i$? If only the latter, the paragraph
   becomes one sentence in T9.
5. **Equation numbering** — the exemplar numbers continuously through Theory and refers back by number.
   `scratch.tex` uses `\autoref` with named labels, which is better practice; keep it.
6. **All three of F1–F3 belong in CLAUDE.md's Rule 5 log** at the next sign-off.

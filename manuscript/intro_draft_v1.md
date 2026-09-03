# Introduction — draft v1 (six paragraphs, as generated)

Captured verbatim. This is the target the revision directive operates on. Do not edit in place;
the revised Introduction is written fresh under `manuscript/intro_revision_directive.md` and lands
in `scratch.tex` when approved.

---

## D1 (brief I1) — accepted

Additive genetic variance in relative fitness, $V_A$, is the substrate of adaptive change and a driver
of drift. Fisher's theorem names the first role: the partial change in mean fitness attributable to
selection equals $V_A/\bar{w}$ in the generation in which it is measured, and says nothing about the
generation after (Fisher 1930; Price 1972). Because successful parents transmit the alleles
responsible for their success, family sizes overdisperse beyond the Poisson variance of a neutral
Wright-Fisher population, allele frequencies at neutral sites move faster than drift alone would carry
them, and $N_e$ falls below the number of breeding adults, $N$ (Wright 1938; Buffalo and Coop 2019).
That is the Robertson effect (Robertson 1961). The same reduction compresses the neutral coalescent,
so a given $V_A$ predicts a level of genome-wide neutral nucleotide diversity. That prediction can be
checked against sequence data collected for other reasons.

## D2 (brief I2) — accepted with revisions

The animal model made that variance estimable in populations no one manipulates: a mixed model
partitions phenotypic variance over a known pedigree, and decades of individual monitoring supply the
pedigree (Kruuk 2004; Wilson et al. 2010). Applied to lifetime reproductive success, it estimates the
variance in fitness itself rather than in a component trait (Postma 2014; Bonnet et al. 2022). Across
19 wild vertebrate populations, among them Soay sheep on St Kilda, Alberta bighorn sheep, and great
tits at Wytham Woods, the posterior modes of $V_A$ run from 0.003 to 0.50, with a median of 0.10. No
conversion stands between those values and the arguments that follow. Bonnet et al. fitted a
zero-inflated overdispersed Poisson animal model to raw lifetime breeding success and back-transformed
with $V_A(w) = \mathbf{d}^\top\mathbf{G}\mathbf{d}$, where $\mathbf{d}$ collects the average partial
derivatives of mean relative fitness with respect to the logit and log link predictors. What they
report is an observed-scale, mean-standardised additive variance in relative fitness: Santiago and
Caballero's $C^2$, and the same standing variance that mutation-selection-drift balance predicts.
Nothing is rescaled anywhere in this paper. That estimator however is single-generation, and its
partial derivatives are evaluated at the population state those cohorts were observed in. A variance
of that size, propagated through the Robertson effect, predicts a level of neutral diversity.

## D3 (brief I3) — accepted with revisions

The unlinked part of that prediction needs no linkage map and no annotation. For a neutral site
assorting independently of every selected locus, the effective size falls to $1/(1+4\kappa V_A)$ of
the number of breeding adults, where the mating-system scalar $\kappa$ runs from one under random
mating to two under strict monogamy (Robertson 1961; Santiago and Caballero 1995, 1998). Physical
linkage adds to that baseline, integrated here along empirical recombination maps with the heritable
variance apportioned across chromosomes by annotated functional target size. The unlinked term is
linear in $V_A$, and that linearity caps the whole effect. At equilibrium no compounding across
generations remains to be recovered, so the size of the variance fixes what the mechanism can remove.
What follows is the mechanism's capacity, not an estimate a better measurement might raise. At the
median of the 19 estimates and $\kappa = 1$, that ratio is 0.72, a 1.4-fold reduction; at the largest,
0.34, a 3.0-fold reduction. Strict monogamy and the linked term at its most permissive genome-wide
parameterization take the total to roughly 20-fold. Matheson and Masel (2025) argue that this unlinked
component has been left out of the accounting; those figures are what it comes to once computed. The
deficits these taxa show against $4\mu N$ run from $10^{2}$ to $10^{6}$, a range taken from the
comparative literature and not computed here (Leffler et al. 2012; Buffalo 2021; Lewin and Eyre-Walker
2026). The measured variance is orders of magnitude too weak to account for them. Yet a variance of
that size still has to be maintained.

## D4 (brief I4) — accepted with revisions

What maintains it is a question about mutation, not about diversity. At mutation-selection-drift
balance the standing additive variance in relative fitness is $2N_eU_ds^2/(1+2N_es)$, with $U_d$ the
deleterious mutation rate per genome per generation and $s$ the mean heterozygous effect (Turelli
1984; Bürger 2000; Appendix D). When selection is strong relative to drift the expression collapses to
$V_A \approx U_d s$. Taking $U_d = 4\mu L_{\text{coding}}$ from published per-generation mutation rates
and collapsed coding length gives 0.69 to 1.19 across the eight populations with both a mutation rate
and an annotated coding length, median 1.07. Inverting the limit returns the selection coefficient the
reported variance implies, $s^{*} = V_A/U_d$: 0.019 to 0.313, median 0.145, or 0.092 at the upper 95\%
confidence limit on $\mu$. Vertebrate distributions of fitness effects put the mean heterozygous
coefficient between $10^{-3}$ and $10^{-2}$ (Eyre-Walker and Keightley 2007; Huber et al. 2017). That
$s^{*}$ is a consequence read off the reported variance, not an estimate of selection fitted to
anything. Read in the other direction, the variance mutation-selection-drift balance can sustain at
$s = 10^{-3}$, $5\times10^{-3}$ and $10^{-2}$ is smaller than the median measurement by 136-fold,
27-fold and 14-fold. The measured variance is too large to be maintained. Two verdicts now rest on one
number, which invites the obvious objection that the number is wrong.

## D5 (brief I5) — accepted with revisions

Both comparisons ask about the same quantity. That quantity is the long-run equilibrium additive
variance in relative fitness at $\bar{w} = 1$: Santiago and Caballero need it sustained across the
roughly $4N_e$ generations in which neutral diversity approaches a new equilibrium, and
mutation-selection-drift balance is a statement about standing variance at equilibrium. Same currency,
same timescale class, so the verdicts can be set against each other. If the measured value is
inflated, the maintenance discrepancy shrinks and the diversity discrepancy grows; if it is an
underestimate, the reverse. No rescaling of $V_A$ improves both. That buys robustness against the
standard criticism of pedigree estimates, that relatives share environments and the animal model
absorbs the resulting covariance into the additive component, because a criticism of that kind moves
the number in one direction only and one direction cannot serve both comparisons. Accounting for a
hundredfold deficit in diversity requires $V_A \gtrsim 25$ at $\kappa = 1$, and about 12 under strict
monogamy; compatibility with mutation-selection-drift balance requires $V_A \lesssim 10^{-2}$. No
value satisfies both. The gap is therefore a property of the model rather than of the measurement, and
it is there before any pedigree is consulted. Both thresholds are stated in the unlinked currency so
the arithmetic is internally consistent, and the linked amplification is reported separately in the
Results. The measurement falls inside that empty interval, one to two orders of magnitude above the
mutation-selection-drift end and two to three orders short of the diversity end. It does not close the
gap; it locates reality within it.

## D6 (brief I6) — not accepted

Locating a measurement in that interval takes four objects: the unlinked baseline corrected for mating
system, $\overline{Q^2}$ integrated along empirical Haldane maps with heritable variance partitioned
by annotated functional target, the ceiling $V_{A,\text{max}}(\delta) = (1-\delta)/(4\kappa\delta)$,
and the mutation-selection-drift inversion together with its robustness to a leptokurtic distribution
of fitness effects. The ceiling is a curve rather than a defended point estimate, so a population with
a diversity estimate reads its own value off it, and any future sequence-based estimate of fitness
variance has to come in under that value. None of the inputs comes from observed diversity. $V_A$
comes from pedigrees, $\alpha$ from molecular parentage, $M_i$ from linkage maps, $f_i$ from
annotation, and $\mu$ from mutation-rate studies, so the prediction meets diversity data only at the
end. One condition governs all of it. The effective size of a population relative to its breeding
adults, $1/(1+4\kappa V_A)$, is exact conditional on $V_A$ being the long-run equilibrium additive
variance in relative fitness, and the same condition carries to the linked extension. Supply a
single-generation variance instead and the equation still returns a number, but nothing has
accumulated over the $4N_e$ generations neutral diversity needs to respond.

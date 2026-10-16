# Introduction redraft — plan, 2026-10-16

The redraft is in `manuscript/scratch.tex` (§Introduction) and mirrored in
`manuscript/introduction.tex`. Branch `worktree-intro-redraft`. **Generated scaffolding (style guide
Part 3): re-voice before submission.** The verdict sentence in ¶6 is the author's to write.

## The organising idea (author, 2026-10-16)

The paper is about the two classical questions you can ask of heritable variation in fitness:
**what it does** (its effect on neutral diversity) and **what maintains it** (mutation–selection–drift
balance). The background should therefore be two literatures, one per question. Each literature has
answered its question quantitatively, but only in humans or *Drosophila*. This paper's contribution
has two parts:

1. **The taxa and the measurement.** It puts the same two tests to wild vertebrates, using
   total-fitness $V_A$ measured directly by pedigree. The precedents use $V_A$ inferred from diversity
   (Buffalo & Kern) or variance in fitness components (Charlesworth).
2. **The scaling.** Pedigree $V_A$ is a snapshot over a few generations. Both models need the
   long-run value. The analysis is built on how a snapshot has to be scaled,
   $c = \bar V_A/\hat V_A$, to fit each model.

This is compatible with the settled claim in CLAUDE.md, which this plan leaves unchanged. It also
replaces the old Introduction's way of locating the gap ("not evaluated against either constraint")
with a precedent-first one.

## Paragraph map

| ¶ | job | content | citations |
|---|---|---|---|
| 1 | The two questions | Heritable fitness variance has two separable consequences: it depletes neutral diversity, and it must be resupplied. One quantity governs both: $V_A$ in relative fitness. Both questions have been answered, in humans and *Drosophila*. | Robertson 1961 |
| 2 | Background: **effect** | Santiago–Caballero unlinked form (equation kept, with scope condition 1 at the point of use: "exact when $V_A$ is the long-run equilibrium variance"). Linear, so the effect is modest. Linkage adds the exponential BGS term. **Precedents:** Buffalo & Kern 2024 (humans: diversity → equilibrium fitness variance + DFE); Buffalo & Coop 2019, 2020 (*Drosophila*, temporal). The direction is diversity → $V_A$. Deficits are general across species; the unlinked term has largely been left out of the accounting. | SC 1995, 1998, 2016; Hudson & Kaplan 1995; Nordborg et al. 1996; Buffalo & Kern 2024; Buffalo & Coop 2019, 2020; Leffler 2012; Buffalo 2021; Lewin & Eyre-Walker 2026; Matheson & Masel 2025 |
| 3 | Background: **maintenance** | MSD balance, $V_m = U_ds^2$, $V_A \approx U_d\bar s$. **Precedent:** Charlesworth 2015 (*Drosophila* fitness components: too much variance for MSB; balancing selection). Stated plainly as prior work on the same test. Both inputs are now measured in vertebrates, and neither comes from diversity. | Mukai et al. 1972; Crow 1970; Charlesworth 2015; Johnson & Barton 2005; Sharp & Agrawal 2018; Bergeron et al. 2023; Eyre-Walker & Keightley 2007; Huber et al. 2017 |
| 4 | The vertebrate measurement | Animal model; lifetime breeding success as "a composite lifetime measure"; Bonnet et al. 2022: 19 populations, 15 species; $\mathbf d^\top\mathbf G\mathbf d$ = the currency of both models, so nothing is rescaled; modes 0.003–0.50, median 0.10 (fixes E6's wrong range). | Henderson 1975; Kruuk 2004; Wilson et al. 2010; Postma 2014; Bonnet et al. 2022 |
| 5 | **The scaling** (the originality) | A pedigree $V_A$ is a snapshot: $\mathbf d$ is evaluated at the observed state (scope condition 2, stated as what the estimator is for and not as a criticism). Diversity responds to $\bar V_A$ over ~$4N_e$ generations (D2: linear $N/N_e$ + harmonic-mean $N_e$). MSD needs the stationary value. Hence $c$. The stationarity the diversity side assumes is what the MSD side tests. The paper's spine: the two requirements move in opposite directions, so no common bias reconciles them. | — |
| 6 | Here we + result | Methods in one sentence each: κ (stated as consistency with Bonnet's single $V_A$, with no claim of new theory), linked map term, $V_{A,\max}(\delta)$ as a curve, $s^*$. Verdict = the approved claim. Numbers: 1.7× median, ~4.5× max (inside the domain, per the 2026-10-14 wording rule) vs. 230–38,000× deficits; $s^* \approx 0.16$ vs. DFE $10^{-3}$–$10^{-2}$; maintenance needs $c \lesssim 0.07$, while diversity needs $c$ beyond the formula's domain. No single $c$ satisfies both. | SC 1995; Woolliams et al. 1999 |

About 1,200 words, close to the length of the old version.

## What was removed, and why

- **The Fisher's-theorem opener.** FTNS is not part of the claim (CLAUDE.md); it belongs in the
  Discussion as the escapability asymmetry. ¶1 now opens on the two consequences.
- **"Evolutionary rescue / rate of adaptation" motivation** (Crow 1958; Lande 1982; Gomulkiewicz &
  Holt 1995). This is significance borrowed from a different question. Restore one clause if you want
  it.
- **"which in wild populations remains orders of magnitude below census expectations" + Lewontin
  1974 as framing.** Kept only as locating citations (Leffler, Buffalo 2021, Lewin & Eyre-Walker).
  Lewontin is dropped from the Introduction.
- **$I_A$.** Resolves OPEN_ITEMS T-3 in favour of $C^2$ alone; $I_A$ sits next to the
  opportunity-for-selection argument, which is retired.
- **"To our knowledge … not evaluated against either constraint."** Replaced by precedent-first
  framing: the tests exist, in other taxa and with other measurements.
- **"systematic discordance among …"** in the closing sentence. Replaced by the claim itself.
- Model detail (EPP, functional annotations) shortened to one clause each.

## Correction to the premise as stated

**Buffalo (2021) is not a humans/*Drosophila* study.** It is comparative across 172 taxa. It asks
whether linked selection, at the strongest published parameter estimates, can explain why diversity
varies so little with census size. It does not use $V_A$. In the redraft it is a **locating citation
for the diversity deficit**, as CLAUDE.md requires ("Buffalo 2021 as the foil" is retired). The
**effect-side precedents** in humans and *Drosophila* are Buffalo & Kern 2024 and Buffalo & Coop
2019/2020.

## New citations to verify against Crossref before backport (Rule 6)

Not in the old Introduction. Each was checked only by web search on 2026-10-16 or not at all:

- Buffalo & Coop 2019, *Genetics* (linked-selection signature in temporal data). **Unverified.**
- Buffalo & Coop 2020, *PNAS* (genome-wide contribution of selection to temporal allele-frequency
  change). **Unverified.** (2020 was already cited in the old intro.)
- Sharp & Agrawal 2018, *Proc. R. Soc. B*: an experimental test of MSB for fitness components in
  *Drosophila*. Search-confirmed (author PDF); **volume/pages unverified.**
- Mukai et al. 1972; Hudson & Kaplan 1995; Nordborg et al. 1996; Woolliams et al. 1999: already
  cited elsewhere in `scratch.tex`.
- Buffalo & Kern 2024, *PLoS Genet.* 20(3):e1011144: search-confirmed.
- Charlesworth 2015, *PNAS* 112:1662–1669: search-confirmed. **Note that it carries a March 2015
  correction to two numerical statements**; do not quote numbers from it without checking the
  correction.

**Candidate, not used:** Li & Berg 2026, *PNAS* 123:e2513613123, "Background selection in recombining
genomes and its consequences for the maintenance of variation in complex traits" (UChicago). It
couples the effect and maintenance questions for complex traits, so it could take one clause in ¶1
or the Discussion. The author should decide.

## Decisions for the author

1. **The verdict sentence in ¶6.** OPEN_ITEMS Q6 recorded an earlier directive to omit it. The
   redraft includes the approved 2026-08-26 claim verbatim, because a GENETICS Introduction normally
   states its result. Delete it if Q6 still holds.
2. **¶6's numbers** come from CLAUDE.md's 2026-10-13/14 values. The phrase "beyond the formula's
   domain" follows the uncommitted `fig2_rescaling.R` change in the main checkout, which stops the
   diversity curve at the domain edge. If that change is dropped, use "$c \gtrsim 10^4$, as the
   $G = 1$ extrapolation" instead.
3. **Named systems** in ¶4: Soay sheep (St Kilda) and great tits (Wytham Woods), two exemplars
   following Q7.
4. **The title (E13) still asserts a retired claim.** This plan does not touch it.

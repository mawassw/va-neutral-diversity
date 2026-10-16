# Introduction redraft — plan, 2026-10-16 (v2)

The redraft is in `manuscript/scratch.tex` (§Introduction) and mirrored in
`manuscript/introduction.tex`. Branch `worktree-intro-redraft`. **Generated scaffolding (style guide
Part 3): re-voice before submission.** The verdict sentence in ¶6 is the author's to write.

## The organising idea (author, 2026-10-16)

The paper is about the two classical questions you can ask of heritable variation in fitness:
**what it does** (its effect on neutral diversity) and **what maintains it** (mutation–selection–drift
balance). The background is therefore two literatures, one per question. Each literature has answered
its question quantitatively, but only in humans or *Drosophila*, and with a variance that was inferred
from sequence data or measured on fitness components. This paper's contribution has two parts:

1. **The taxa and the measurement.** It puts the same two tests to wild vertebrates, using
   total-fitness $V_A$ measured directly by pedigree.
2. **The scaling.** Pedigree $V_A$ is a snapshot over a few generations. Both theories need the
   long-run value. The paper asks how the snapshot must be scaled to fit each.

## Rules the Introduction follows (author, 2026-10-16)

- **¶1–5 contain only published results and derivations.** None of this paper's derivations appear
  there: no κ, no $V_{A,\max}(\delta)$, no $s^* = V_A/U_d$, no $c$, no time-average argument, and no
  posterior-mode summary of Bonnet's estimates. The equations used are Santiago–Caballero's
  $N_e/N$, $V_m = U_ds^2$, $V_A \approx U_d\bar s$, Bonnet's $\mathbf d^\top\mathbf G\mathbf d$, and
  $\pi = 4N_e\mu$.
- **This paper's results appear only in ¶6**, GENETICS-style: aims, methods in words, then the
  verdict and its numbers.
- **The citations build toward the gap.** Each background paragraph ends on what the literature
  leaves open for wild vertebrates, and ¶6's aims answer those gaps one for one.

## Paragraph map

| ¶ | job | gap it ends on | citations |
|---|---|---|---|
| 1 | Two consequences of heritable fitness variance, one quantity; the two questions are coupled | Both tested only in humans and *Drosophila*, with $V_A$ inferred or measured on components | Robertson 1961; **Li & Berg 2026** |
| 2 | **Effect**: SC equation (with its equilibrium condition and $N$ = breeding adults), BGS, inference from diversity in humans and from temporal change in *Drosophila* | These studies run from diversity to $V_A$; the comparative deficit is unexplained; the unlinked term is largely ignored | SC 1995, 1998, 2016; Hudson & Kaplan 1995; Nordborg et al. 1996; Buffalo & Kern 2024; **Buffalo & Coop 2019**, 2020; Leffler et al. 2012; Lewin & Eyre-Walker 2026; Buffalo 2021; Matheson & Masel 2025 |
| 3 | **Maintenance**: $V_m$, $U_d\bar s$; Charlesworth's test; the experimental test; the inputs are now measured in vertebrates | Tests are in *Drosophila*; vertebrate inputs exist and are independent of diversity | Mukai et al. 1972; Crow 1970; Charlesworth 2015; Johnson & Barton 2005; **Sharp & Agrawal 2018**; Bergeron et al. 2023; Eyre-Walker & Keightley 2007; Huber et al. 2017; Lin et al. 2026 |
| 4 | **The vertebrate measurement**: animal model, Bonnet's 19 populations, same currency as both theories | **The central gap.** Maintenance has been argued only qualitatively (Connallon & Czuppon, with *Drosophila*-like parameters). Diversity has not been computed per population | Henderson 1975; Kruuk 2004; Wilson et al. 2010; Postma 2014; Bonnet et al. 2022; **Connallon & Czuppon 2026** |
| 5 | **Time**: pedigree $V_A$ is a snapshot; heritability shifts with environment; both theories take the long-run variance | Any comparison assumes a scaling, and the two theories need not agree on it | Bonnet et al. 2022; **Charmantier & Garant 2005; Wilson et al. 2006**; Wright 1938; Lynch & Hill 1986 |
| 6 | **Here we**: aims → methods in words → verdict → numbers → the opposite-direction argument | (answers ¶2, ¶4 and ¶5) | SC 1995; Woolliams et al. 1999 |

## Title

Old (asserted a retired claim, OPEN_ITEMS E13): *Empirically reported heritable fitness variance
predicts severe depletion of neutral diversity in wild populations.*

New: **Heritable variance in fitness in wild vertebrates is too small to explain their missing neutral
diversity and too large for mutation–selection balance.**

Alternatives if the author wants the scaling in the title:
- *Pedigree estimates of fitness variance cannot be scaled to fit both neutral diversity and
  mutation–selection balance*
- *Too small for diversity, too large for mutation: heritable fitness variance in wild vertebrates*

## Citation status (checked by web search 2026-10-16; Crossref check still due at backport)

| work | details found | note |
|---|---|---|
| Buffalo & Kern 2024 | *PLoS Genet.* 20(3):e1011144 | |
| Buffalo & Coop 2019 | *Genetics* 213:1007–1045 | |
| Buffalo & Coop 2020 | *PNAS* 117 (doi 10.1073/pnas.1919039117) | |
| Charlesworth 2015 | *PNAS* 112:1662–1669 | has a March 2015 correction to two numbers |
| Sharp & Agrawal 2018 | *Proc. R. Soc. B* 285:20181864 | MSB sufficient for larval viability, not for male mating success or female fecundity |
| Li & Berg 2026 | *PNAS* 123:e2513613123 | |
| Connallon & Czuppon 2026 | *Evolution* 80(5):926 | **Checked:** no quantitative comparison of Bonnet's estimates with $U_d s$; the mutation-shortfall statements are qualitative, citing Charlesworth 2015. Cited as context, **not** as a competing resolution (CLAUDE.md). |
| Wilson et al. 2006 | *PLoS Biol.* 4:e216 | Soay sheep; environment-dependent maternal genetic variance in birth weight |
| Charmantier & Garant 2005 | *Proc. R. Soc. B* 272:1415–1425 | heritability higher in favourable conditions; significant for morphometric traits **but not for traits close to fitness**, hence "at least for morphological traits" |
| Lin et al. 2026 | *PLoS Biol.* | source of `data/dfe_reference.csv` (verified in `data/README.md`) |

## Decisions for the author

1. **The verdict sentence in ¶6.** It is included verbatim from the approved 2026-08-26 claim. This
   supersedes OPEN_ITEMS Q6 (omit), following the author's "results in the last paragraph"
   instruction of 2026-10-16.
2. **"More than the theory's domain allows"** follows the uncommitted `fig2_rescaling.R` change in
   the main checkout. If that change is dropped, use "$c \gtrsim 10^4$, as the $G = 1$
   extrapolation".
3. **The Discussion still carries retired claims** (E14). It is untouched here.

# CLAUDE.md — project#3

This directory holds a theory + comparative-empirical manuscript in evolutionary genetics targeting
**GENETICS (GSA)**. It uses additive genetic variance in relative fitness ($V_A$) from wild pedigrees
as a **diversity-free** estimator of linked selection, to test the consensus claim that linked
selection explains Lewontin's paradox. See **Project framing** below — that section governs, and it is
**ahead of** `scratch.tex`'s current Introduction (Rule 10).

The output is a set of publication TIFFs and summary CSVs, not a library or application: there is no
build system, no test suite, no package structure. The conventions below are enforced — follow them
when adding code, data, or figures.

## Project framing — CURRENT (agreed 2026-08-04, amended 2026-08-07/08; supersedes the 2026-07-29 framing below)

**From Jeremy's feedback on the 2026-08-04 lab presentation. This section governs. The 2026-07-29
framing that follows it is retained as project history — read it for the circularity argument's
details, which survive as a *methods strength*, not as the project's reason to exist.**

**The anchor is variation in fitness.** Additive genetic variance in fitness is the fundamental
quantity, and it is the core research interest this project must connect to. Everything else is
downstream of that.

**The chain, in order:**

1. Linked selection is, at bottom, about **genetic variance in fitness** — that is the quantity doing
   the work.
2. Pedigree $V_A$ in relative fitness is **one estimate of that fundamental quantity**, obtained
   independently of sequence.
3. Use it to ask how strong linked selection is **across species**, given a direct estimate of the
   underlying quantity rather than a diversity-calibrated one.
4. Translate that into an **expectation for neutral diversity**, and compare to observed $\pi$. This
   tests whether $V_A$ measures for these species yield good estimates of observed $\pi$.
5. **If not — why not?** That is the interesting question, and it is a question about $V_A$ as an
   estimate of variance in fitness.

**What changed, explicitly:**

- **Lewontin's paradox is demoted from thesis to venue.** It is where the comparison happens, not
  what the project is about. The field is moving away from linked selection as *the* explanation for
  the paradox; do not hitch the project to a receding claim. Linked selection remains worth
  understanding — that is a separate and still-live interest.
- **Buffalo 2021 / Corbett-Detig et al. 2015 / Chen et al. 2017 are the *tradition*, not the foil.**
  Step 4 above is where that connection legitimately lives — it is not the heart of the project. Cite
  them to locate the comparison. Do **not** position this paper as the other side of Buffalo 2021.
- **"The two routes fail in opposite directions" is WITHDRAWN.** That was the old headline and it is
  exactly the Buffalo-mirroring being corrected. It made the project's significance depend on someone
  else's result.
- **The circularity argument is demoted, not deleted.** Independence from diversity data is a genuine
  virtue of the estimator and the **independence audit stays** as a Methods strength. It is no longer
  the reason the project matters.
- **$V_{A,\max}$ survives and gets stronger.** It is an inequality on a phenotypic quantity — i.e.
  directly about variance in fitness — so it fits this framing better than the old one. Still the most
  citable object in the paper.
- **The MSD / implied-$s$ contradiction gets more load, not less.** It bears directly on whether
  reported $V_A$ is a credible estimate of variance in fitness, which is now the central question,
  and it reaches that conclusion without diversity data at all.
  **⚠ REVERSED 2026-08-07 — see Amendment F3 below.** Charlesworth (2026) now states this in print,
  so it is corroboration rather than a finding of ours, and it cannot carry weight.

**The cut (draft — REWRITE IN OWN WORDS before use).** Per `talk/JOB_TALK_RULES.md` §2 step 2, the
one-sentence statement of the project must be authored by the user, not generated. Two drafts to push
against, both currently over-long:

- *Pedigree estimates of additive genetic variance in fitness give a sequence-independent handle on
  the strength of linked selection across species; propagated to neutral diversity they do not
  reproduce observed $\pi$, which bounds how much of measured $V_A$ can be transmissible.*
- *Additive genetic variance in fitness is the quantity linked selection is made of, and the pedigree
  estimates we have of it are too large to be compatible with the diversity those same populations
  carry.*

### Amendment F3 (2026-08-07, extended 2026-08-08) — the bound binds the *directional* component

**This amends the 2026-08-04 framing above; it does not supersede it.** The anchor is unchanged and
the five-step chain still governs. What changes is the claim made at step 5 and the load carried by
the MSD strand. Still no equation changes.

**Cause.** Not external feedback — a currency check the user ran pre-emptively, out of the guard
established on 2026-08-04 ("don't lose the project's identity to someone else's paper"). Recent
variance-in-fitness literature was pulled from Zotero into
`job_packet/2026/misc/new_connections.txt` and screened for claims that would make ours evidently
wrong. Two findings:

1. **The LLM-generated "bridges" in that file were the Buffalo pattern again** — "position your
   program as the direct answer to this open challenge." Discarded. The knowledge summaries were
   kept. Recorded here because the failure mode recurs whenever a tool is asked to connect this work
   to a literature: it reaches for borrowed significance by default.
2. **A real currency risk.** Connallon & Czuppon (2026) show balancing selection under drift and
   fluctuating selection maintains substantial $V_A$ for fitness, overturning the classical
   zero-at-equilibrium result. Charlesworth (2026), commenting on it, states that mutation–selection
   balance is mathematically insufficient to explain observed $V_{Aw}$, especially wild estimates.

**Why that matters.** That is *our* premise, and the field now has a **competing resolution of it
that does not require the estimates to be wrong**: the variance is real and reflects non-equilibrium
displacement, not measurement inflation. It carries Brian Charlesworth's endorsement. Not lethal —
but asserting inflation without acknowledging the alternative reads as not having read the year's
most-discussed result on our own premise. That is Grain failure mode one
(`talk/JOB_TALK_RULES.md` §6) and the same failure Jeremy flagged over Lewontin.

**The resolution — sharpen, do not retreat.** The claim moves from *"measured $V_A$ is inflated"* to
*"the **directionally consistent** component of $V_A$ cannot be that large."* Fitness variance that
fluctuates in sign — as balancing and fluctuating selection generate — does not erode diversity
cumulatively, so the bound does not bind it. The bound binds the directional part, which is what
pedigree estimates are normally read as measuring.

**Three consequences:**

- **The result becomes a partition, not a contradiction.** Instead of "your number is wrong," the
  finding is a decomposition of measured $V_A$ into a directional component with a hard diversity-set
  ceiling and a fluctuating component without one. That is a positive claim and it is testable.
- **It aligns the claim with the mathematics, and converts the paper's weakest point into its stated
  scope.** Robertson's result is about the *autocovariance of relative fitness across generations* —
  i.e. the directional component. Equating that with a single-generation pedigree $V_A$ is the
  project's largest unstated assumption (flagged as attack surface #3 in
  `UChicago_projects/DECK_SCRIPT.md` S27). Under F3 it is no longer hidden; it is the scope
  condition.
- **The bound is INDIFFERENT to the competing explanation — it holds either way.** *(Strengthened
  2026-08-08 from R4; this supersedes the weaker "boundary condition" wording originally recorded
  here.)* The violation admits two branches: part of measured $V_A$ is not heritable at all (relatives
  share environments as well as alleles, and the animal model counts that resemblance as genetic), and
  part may be real but reversing (the sort balancing and fluctuating selection maintain). **The bound
  does not say which, and holds either way.** Do not defend one branch against the other — owning the
  disjunction is what makes the result robust, because it cannot be defeated by establishing either
  one. Connallon & Czuppon / Charlesworth argue qualitatively that much fitness variance is
  non-equilibrium and non-directional; we supply the quantitative ceiling on how much of it *must* be.
  **Do not cite them as the gap we fill** — that is §1 borrowed significance. State what the bound
  does; the connection is then visible without being leaned on.

**What F3 costs.** The MSD / implied-$s$ strand loses its novelty (see the ⚠ above). Under F2 it
gained load; under F3 it is corroboration of a published position and cannot be a headline. The
originality therefore concentrates on the **diversity-side bound** — $V_{A,\max}$ — which remains
ours alone.

**Standing test for this project, from `talk/JOB_TALK_RULES.md` §1.** Remove Buffalo 2021: still
interesting. Remove Lewontin-as-thesis: still interesting. Remove Charlesworth / Connallon & Czuppon:
still interesting. What survives all three removals is the load-bearing object — *sequence diversity
places a numerical ceiling on a phenotypic quantity, and measured values sit 2–3 orders of magnitude
above it.* Anything that fails this test is decoration.

**Emphasis triage under F3** (supersedes the F2 list where they differ):

- **Load-bearing:** $V_{A,\max}$; the unlinked-only result (no map, no annotation, no stationarity —
  the reason to believe the direction); the directional / non-directional partition; the per-species
  test; **the forward-compatibility claim** (added 2026-08-08, see below).
- **Load-bearing — the forward-compatibility claim.** *"It also sets a value that any sequence-based
  estimate of fitness variance has to come in under, as the field moves off pedigrees."* Added from
  R4. This is the answer to the strongest available dismissal — *"so pedigree estimates are biased;
  the field is leaving them behind anyway"* — and it converts $V_{A,\max}$ from a critique of one
  measurement technique into a standing constraint on **any** estimate of fitness variance, including
  the temporal-genomic route (Geeta Arun et al. 2026). It also locates the work relative to that
  literature **without citing it or leaning on it**, which is §1 executed correctly. Treat this as the
  most durable sentence in the framing: it is what keeps the result alive after pedigrees stop being
  the standard instrument.
- **Supplementary:** $\kappa(\alpha)$; the Haldane $\overline{Q^2}$ machinery; the independence audit
  (Methods strength); the MSD / implied-$s$ check, now demoted to "consistent with Charlesworth
  2026."
- **Locating only, one sentence each:** Lewontin, Buffalo, Corbett-Detig, Chen.

**The cut under F3 — SETTLED, no longer a draft (2026-08-08).** These were recorded here as drafts to
push against. The user has since authored the delivered prose in
`job_packet/2026/misc/research_statement_3pages_R4.docx`, and the two sentences below survived
essentially intact. They are now the project's working cut, in the A-claim / C-content construction
the user chose for research-statement Aim 3 on 2026-08-07:

- **The claim (A).** *Neutral diversity sets a ceiling on how much of a population's fitness variance
  can be both heritable and consistently directional, and published pedigree estimates sit two to
  three orders of magnitude above it.*
- **The content (C).** *Most of the fitness variance we measure in the wild cannot be the directional
  kind, because the diversity these populations carry would not survive it.*

**Reference implementation — `research_statement_3pages_R4.docx`, Past Work 3.** That paragraph is the
first place this framing exists as finished prose, and it is ahead of this file rather than behind it.
Read it before re-cutting the manuscript. Three things it settles:

- **The section header is C, not A.** "Most Fitness Variance in the Wild Is Not the Directional Kind"
  — the partition is the headline; the bound is the lead sentence that supports it. Note the direction
  of that choice: the *interpretation* leads and the *inequality* backs it up.
- **Lewontin and Buffalo are absent entirely.** Not demoted to a sentence — absent. Linked selection
  appears exactly once, as mechanism ("heritable variation in fitness is what linked selection is made
  of"), never as a contested explanation being adjudicated. This is further than F2 required, and it
  is the correct end state.
- **The MSD check is one sentence**, phrased as a second route to the same conclusion. Correctly
  sized; do not re-inflate it.

**Open under F3:**

1. **Add the directional caveat wherever the bound is stated.** ✅ **Done in the research statement**
   (R4, 2026-08-08) — and done better than the draft caveat recorded here, by owning both branches
   rather than carving out an exception. **Still open for the manuscript**: `scratch.tex` states the
   bound without it. Port R4's two-branch sentences rather than the older draft.
2. **`references.bib`:** Connallon & Czuppon (2026) and Charlesworth (2026) are **not yet verified
   against Crossref** and have no entries. Verify before use; flag `% UNVERIFIED:` otherwise
   (Rule 6 / sign-off item 5).
3. **Check Matheson et al. (2025)** — logged as corroborating, with one open methodological question
   not yet identified.
4. **`scratch.tex` §Discussion** now needs the partition framing, not just the removal of
   opposite-directions.

**Consequences still to work through:** `scratch.tex`'s Introduction is now **three** framings stale
(it still argues the pre-2026-07-29 two-claim gap). The Discussion's opening paragraphs lean on the
opposite-directions framing and on Lewontin-as-thesis; both need re-cutting, and under F3 they need
the partition framing rather than only the removal of opposite-directions. No equation changes —
this is framing and emphasis only, same as the previous pivots.

---

## Project framing — HISTORICAL (agreed 2026-07-29) — superseded by the section above

**Problem.** Lewontin's paradox: neutral diversity spans ~3 orders of magnitude across taxa while
census sizes span more than 8. The consensus proximate explanation is linked selection — background
selection plus sweep interference — suppressing $N_e$ relative to $N$.

**Gap (the circularity).** That explanation has never been tested with data independent of the
phenomenon it explains. **Every** quantitative estimate of linked-selection strength is calibrated *on
observed diversity*: B-maps, DFE inference from site-frequency spectra, sweep-parameter fitting.
Diversity goes in, selection parameters come out, and those are then used to predict diversity.
Buffalo (2021, eLife) showed linked selection so estimated is **insufficient** to explain the
decoupling — but a negative result obtained from inside the circle cannot distinguish "linked
selection is too weak" from "our diversity-calibrated estimates of it are too small." Breaking the
deadlock needs a measurement of selective interference that never touches sequence diversity.

**Solution.** Pedigree $V_A$ is exactly that — demographic and phenotypic, not molecular.
Santiago–Caballero maps $V_A$ → $N_e/N$, making the two commensurable. Parameterize end-to-end from
diversity-independent data: empirical $V_A$; published linkage maps for $M_i$; genome annotations for
functional target size, from which $Q^2$ is integrated continuously along each chromosome. Then
confront the prediction with observed $\pi$.

**What it shows.** The prediction **overshoots by 2–3 orders of magnitude**. Diversity-calibrated
estimates are too *weak* to explain the paradox; an independently parameterized estimate is far too
*strong* to be compatible with any observed diversity — **the two routes fail in opposite
directions**, which brackets the answer and localizes the error. The unlinked component alone — which
needs **no** stationarity assumption and is therefore the most robust piece — already exceeds what
observed diversity permits. Inverting gives $V_{A,\max}$; reported estimates violate it. A
diversity-free corroboration: reported $V_A$ cannot be sustained at mutation-selection-drift balance
under empirical $\mu$ and vertebrate DFEs.

**The referee objection to pre-empt.** The escape hatch is the quantity we conclude is unreliable — if
$V_A$ is biased, the independent estimator is independent but wrong. **Answer: do not claim $V_A$
*measures* linked selection; claim it *bounds* what any valid $V_A$ can be.** The paper's object is a
**consistency condition between two independent empirical domains**, and the finding is that it is
violated — informative whichever side is wrong. Note where residual diversity-dependence actually
sits: the *predicted* side is clean ($s$ is inferred by solving $V_m = U_d s^2$, not read off
diversity); the **soft side is the *observed* side**, since $\pi \to N_e/N$ needs $\mu$ and a census
$N$ — and monitored $N$ is exactly what the cryptic-immigration objection attacks. State this in the
paper; pre-empting beats being caught.

**Emphasis triage under this framing** (changed from the old framing):

- **$\kappa(\alpha)$ — DEMOTE.** Bounded in $[1,2]$, not load-bearing. Modelling detail /
  supplementary. Do **not** delete: it is a factor of 2 in the exponent for the monogamous passerines
  that dominate the data.
- **$V_{A,\max}$ — PROMOTE.** It *is* Lewontin's paradox stated in quantitative-genetic terms: a
  testable inequality on a phenotypic quantity. Single most citable object in the paper; it is the
  thesis in one line, not a side-result.
- **Demographic/MSD contradiction — KEEP** as an *independence check*. Its value *changed*, not
  vanished: a second contradiction reaching the same conclusion **without invoking diversity data at
  all** directly reinforces a framing built on escaping circularity. Short section.

**Working title options.**

- *Heritable fitness variance provides a diversity-free estimate of linked selection and overshoots
  Lewontin's paradox*
- *An independent test of linked selection as the explanation for Lewontin's paradox*

### Open work the pivot creates

1. **Independence audit — NEW, does not exist.** A Methods subsection classifying **every** input by
   whether it touches diversity data. This is the methodological core of the new claim; without it the
   circularity argument is rhetoric rather than demonstration.

2. **Move Buffalo (2021) into the Introduction.** Currently cited three times in passing, for $\pi$
   and $N_e$ ranges. Under the pivot it is **the paper being answered**. The circularity critique needs
   the specific diversity-calibrated methods named as such (McVicker et al. 2009; Elyashiv et al. 2016;
   Comeron 2017; Corbett-Detig et al. 2015).

3. **Observed data — the pivot RAISES the cost of this gap.** $\pi$ moves from a closing check to
   **the test itself**, and Methods §Empirical Nucleotide Diversity is currently **entirely an
   author-input placeholder**. The plan:
   - **Diversity / $N_e$:** Lewin & Eyre-Walker 2026 (Molecular Ecology) datasets.
   - **Census $N$:** Buffalo (2021) has inferred census sizes for *some* of the species in the dataset.
   - **Missing species:** recover the coefficients Buffalo used to infer census size from **density and
     body size** (an allometric scaling law) and apply them.
   - **NEW RESULT to build:** because Lewin & Eyre-Walker give diversity-derived $N_e$ *per species*,
     compute a **species-specific $V_{A,\max}$** and compare it head-to-head against that species'
     pedigree $V_A$. This turns $V_{A,\max}$ from an aggregate diagnostic into a per-species test —
     expected to be a headline result.

## The model in one screen

Three model layers, composed per chromosome:

1. **Unlinked baseline** — genome-wide $V_A$ depressing $N_e$ via independent assortment.
2. **Mating-system scalar $\kappa(\alpha)$** — modulates the unlinked term by extra-pair-paternity
   rate $\alpha$.
3. **Linked term** — chromosome-local variance $v_i$ interfering with itself over map length $M_i$
   (Morgans), through a position-averaged $\overline{Q^2}$.

## Canonical layout

```
project#3/
├── CLAUDE.md
├── Chicago_project#3.Rproj          # RStudio project; RestoreWorkspace: Default
├── .RData                           # 34 MB de-facto session state (GITIGNORED)
├── alldistzip                       # Bonnet et al. 2022 MCMCglmm posteriors (load()ed)
├── scripts/R/
│   ├── unlinked.R      → MainFig_Baseline_Constraint, SuppFig1–3, SuppTable1_*.csv
│   │                     (builds df_va; MUST run before data_gen.R)
│   ├── data_gen.R      → Omega sweeps, demographic deconstruction, μ sensitivity, V_A,max
│   └── data_gen_2.R    → data/raw/clean_chromosome_data.csv  (ABSOLUTE-PATH-BROKEN)
├── data/
│   ├── master_chromosome_recomb_data.csv   # genomic-architecture model input
│   ├── species_EPP.csv                     # per-Code mating system / EPP / Ud / mu_1
│   ├── recomb_data.csv                     # linkage-map cM per chromosome
│   └── raw/                                # SUPERSEDED result tables — archive, not input
├── genomic_data/<species>/ncbi_dataset/    # NCBI GTF/GFF + sequence_report.tsv (GITIGNORED)
├── main/, supp/                            # THE RESULTS FIGURES — from scripts/R/;
│                                           #   hand-placed. Results + some supplementary.
└── manuscript/
    ├── main.tex            # STUB — to be OVERWRITTEN WHOLESALE, section by section
    ├── scratch.tex         # OPERATING DOC + AUTHORITATIVE — complete draft:
    │                        intro → theory/model → results → methods →
    │                        discussion → appendices. Outranks main.tex AND the R code.
    ├── scratch_review.tex  # HISTORICAL — agent review of a MUCH older scratch.tex;
    │                        its three named defects are believed fixed. Do not action.
    ├── scratch_ulises.tex  # PARKED side-derivation — rigorous MSD balance (see Rule 11)
    ├── references.bib      # shared, GROWING — extend, never replace (Rule 6)
    ├── rho_mf_derivation.tex     # SUPERSEDED — collaborator's earlier κ/EPP derivation
    └── figures/                  # SUPERSEDED — collaborator's figures for the above;
        └── make_figures.py       #   NOT the results pipeline. That is main/ + scripts/R/.
```

## Rules

1. **Source `unlinked.R` before `data_gen.R`, every session.** `unlinked.R` builds `df_va`
   (per-species posterior $V_A$ vectors from `alldistzip`) and loads `MCMCglmm`/`coda`. `data_gen.R`
   needs both and rebuilds neither — it re-runs `load("alldistzip")` but never rebuilds `df_va` and
   never libraries those packages. **Self-enforcing:** `data_gen.R` carries a `stop()` guard on
   `df_va`/`posterior.mode`/`as.mcmc`. Note the guard cannot catch the *dangerous* case — with
   `RestoreWorkspace: Default`, a **stale** `df_va` from `.RData` passes `exists()`. Re-source
   `unlinked.R` anyway.

2. **Run from the repo root.** The R scripts are written for interactive RStudio use from the root, not
   headless `Rscript`. Relative paths are inconsistent between scripts and assume the root as CWD:
   `unlinked.R` expects `species_EPP.csv` in the CWD, `data_gen.R` expects `data/species_EPP.csv`.

3. **Fix `data_gen_2.R`'s `root_dir` before running it.** It hardcodes
   `root_dir <- "G:/My Drive/Chicago_project/Chicago_project#3/genomic_data"`, which no longer matches
   this checkout (`G:/My Drive/UChicago_projects/project#3`). This is the `ABSOLUTE-PATH-BROKEN` tag in
   the layout. **Self-enforcing:** a `dir.exists(root_dir)` guard stops the script rather than letting
   it map over an empty species list and write a 0-row `clean_chromosome_data.csv`. The guard
   self-clears once the path is correct — no need to remove it.

4. **Figures are written to CWD, then moved by hand.** Every script emits its `tiff()` into the CWD;
   finished figures are moved into `main/` and `supp/` manually (**not** `manuscript/figures/` — that
   is superseded collaborator output, see Rule 8). Committed filenames therefore do not always match
   current scripts (e.g. `data_gen.R` writes `MainFig_Ud_Derivation_and_Total_Collapse.tiff`, which is
   not committed). Do not assume a committed TIFF traces to a same-named script output.

5. **`scratch.tex` outranks everything — `main.tex` *and* the R code.** It is a complete,
   heavily-edited draft (intro → theory/model → results → methods → discussion → appendices) and is
   the single source of truth for the theory. **Never propagate `main.tex` formulas into code** — it
   still carries $N_e/N = \exp(-4V_A\kappa)$ and the linear $\kappa \approx 2 - p$, both dead.

   **Where the R code and `scratch.tex` disagree, the code is stale** and gets updated to match
   `scratch.tex` — not the reverse. The **Model conventions** block below documents what the code
   *currently implements*, which is **not** a guarantee it matches the latest `scratch.tex`. Re-derive
   from `scratch.tex` before trusting any formula there. Same for the figures in `main/`/`supp/`: they
   were generated from the code, so they inherit its staleness.

   **Do not action `scratch_review.tex`.** It was an agent review of a much older `scratch.tex`; the
   three defects it named (the leading-order "master equation" missing $1/(1+\Lambda_u)$, the
   $\rho_{mf} = 1-p$ step, inconsistent $V_A$ units) are believed fixed by subsequent edits. Treat it
   as project history, and confirm against current `scratch.tex` before raising anything from it.

6. **Draft in `scratch.tex`; backport to `main.tex` deliberately.** `scratch.tex` is the operating
   document — **all** new derivation and every change to the math lands there first. Never draft new
   math directly in `main.tex`. `main.tex` is a downstream short-form rendering of *settled* results,
   and flow is **one-way** (`scratch.tex` → `main.tex`), never the reverse — the same direction Rule 5
   enforces for code.

   **`main.tex`'s current prose is disposable.** It is a stub to be overwritten wholesale, so there is
   **no** obligation to preserve, reconcile, or amend what is already in it. Do not treat divergence
   between the two files as debt to be tracked formula-by-formula — the whole file gets replaced as
   sections land. What *is* worth preserving is the machinery: the `natbib`/`references.bib` wiring,
   the `geometry`/package preamble, the title block.

   **The backport unit is one section — or one subsection.** Within a Results or Theory section, a
   single subsection is a legitimate unit of work. A backport is finished when that unit reads as final
   in `main.tex`: prose carried over, `\citet{}` conversions done and entries added to
   `references.bib`, and its figures actually `\includegraphics`'d (see Rule 8 — nothing is wired up
   yet).

   *Mechanical* edits to `main.tex` — packages, citations, typos, figure paths, formatting — stand
   alone and need no backport.

   **Citations — machinery vs. content.** Two things move in opposite directions; conflating them
   causes trouble. The *machinery* lives in `main.tex` only: `natbib` + `plainnat` + `\citet{}` against
   `manuscript/references.bib`. The *content* — which works are cited — flows **forward** with each
   backported section, since `scratch.tex` carries ~91 **prose** citations ("(Buffalo and Kern 2024)",
   ~60 unique works) against `main.tex`'s 7 wired entries.

   So **`references.bib` is a shared, growing artifact — extend it, never replace it.** Each backported
   section brings its citations along: convert them from prose to `\citet{}`/`\citep{}` at backport time
   and add missing entries in the established author-year key style (`robertson1961`, `santiago1995`,
   …), **verified against Crossref rather than written from memory**. If `scratch.tex` is ever wired up
   directly, that borrows the machinery from `main.tex` — permitted because it is **mechanical**, but
   **no formula, constant, result, or claim travels `main.tex` → `scratch.tex`, ever.**

7. **`data/raw/` and `manuscript/misc/` are archive, not input.** `data/raw/` holds superseded result
   tables from earlier iterations. Do not read from it as a live source.

8. **`main/` + `scripts/R/` is the results pipeline. `manuscript/figures/` is not.** The figures that
   become Results and some Supplementary all live in `main/` (plus `supp/`) and come from `scripts/R/`.
   **`manuscript/figures/` and `rho_mf_derivation.tex` are superseded project history** — a
   collaborator's earlier attempt to derive $\kappa$ and parameterize it by extra-pair paternity, with
   `make_figures.py` producing its three PDFs. The current `scratch.tex` treatment of $\kappa$ (in the
   main text and its internal appendices) supersedes it. Do not cite, extend, or mine that folder for
   results.

   **No figure is wired into any `.tex` file yet.** `main.tex` says "(Fig. 1)" in prose but contains no
   `\begin{figure}` or `\includegraphics` at all, and `scratch.tex`'s single `\caption` is a table. So
   there is **no** existing script → filename → figure-number mapping to inherit; it gets established
   as sections are backported. Until then, do not assume a `main/` filename implies a figure slot —
   several `Theoretical_*.tiff` there have no obvious current producer (see Rule 4), and both
   `SuppFig3.tiff` and `SuppFig3_Va_Deflation_Analysis.tiff` exist. **Ask which file is meant rather
   than guessing.**

9. **Target journal is GENETICS (GSA).** Format decisions default to its requirements. `main.tex`'s
   current `article` class, `12pt`, and `plainnat` bibliography are **placeholders**, not choices —
   expect to swap in the GSA template and its `.bst`, at which point `references.bib` entries may need
   fuller author lists (`bonnet2022` currently uses `and others` for a 41-author paper).

10. **Project framing outranks `scratch.tex`'s Introduction — the one documented exception to Rule 5.**
    `scratch.tex` §Introduction still argues the **old** two-claim gap (that BGS theory wrongly treats
    independent assortment as a ceiling, plus three under-modelled dimensions). **That gap is
    superseded.** The agreed gap is the **circularity** of diversity-calibrated linked-selection
    estimates. Rewriting the Intro to match is **pending** — until it lands, read **Project framing**
    for intent and `scratch.tex` for the math. Rule 5 still holds for **everything else** in
    `scratch.tex`: the theory, model, equations, and appendices remain authoritative and are **not**
    affected by the pivot. The pivot changes **framing and emphasis, not results** — no equation
    changes.

11. **`scratch_ulises.tex` is parked, not dead.** A collaborator's diffusion-theory derivation of
    mutation-selection-drift balance. Its value is a **rigorous** route to additive variance in
    relative fitness, replacing what `scratch.tex` currently does — which is closer to a heuristic. It
    is **not** integrated and is not part of the current backport path; do not fold it in without being
    asked.

## Model conventions (preserve when adding analyses)

Applied consistently across `data_gen.R` and `unlinked.R`. **Read Rule 5 first** — this documents what
the code implements, not necessarily what `scratch.tex` now specifies.

- **Exact form, not the exponential.** Unlinked part is $N_e/N = 1/(1 + 4\kappa V_A)$; only the linked
  part is exponential: `chrom_Ne_N <- linked_exp / (1 + 4 * kappa * (Va - v_i/2))`.
- **$\kappa$ is quadratic in $\alpha$** (`manuscript/rho_mf_derivation.tex`): Model A (EPP independent
  of breeding value) $= 1 + (1-\alpha)^2$; Model B (proportional) $= 2(1-\alpha+\alpha^2)$.
  `calc_kappa()` in `data_gen.R` is Model A.
- **$\overline{Q^2}$ is numeric under a Haldane map** (`integrand_avg_Q2` / `calc_avg_Q2_haldane`),
  with `Z` capped at 0.995 to avoid the singularity at perfect mutation-selection balance. The
  `main.tex` closed form is the linear-map approximation.
- **`Z <- pmax(0, 1 - Vm/Va)`** with `Vm = Ud * s_het^2`; `s_het` defaults to 0.01, sensitivity facets
  `c(0.005, 0.01, 0.02)`.
- **Variance allocation:** `f_i = L_coding_bp / L_coding_total` (coding bp, not physical length),
  `v_i = Va * f_i`, then halved (`v_i/2`) — a focal neutral allele is linked to only one homolog.
- **Filters:** autosomes only (drop X/Y/Z/W/MT), macrochromosomes only
  (`Physical_Length_bp >= 20e6`).
- **Genome-wide aggregation** weights chromosome $N_e/N$ by physical length (`L_weight`), not coding
  bp.
- **CNE multipliers** inflate coding to functional target: 2× birds, 4× mammals, 5× maximum-rescue.
  **The avian species list is hardcoded and duplicated across several `data_gen.R` blocks — update all
  copies together.**
- **`data_gen.R` is a linear script of independent blocks**, each redefining `arch_map`, `s_het`,
  `kappa_val` for itself. Run blocks in order or re-source the setup.
- `theme_Publication()` is redefined at the top of both plotting scripts with different `base_size` —
  intentional, not a bug.

## Known staleness & inconsistencies (Rule 5 log)

**Logged 2026-07-29.** Found by reading `scratch.tex` against the R code. **None of these are fixed.**
Resolve toward `scratch.tex`, not the code.

**Code stale vs. `scratch.tex` Methods:**

- **$f_i$ partition.** Methods specifies $\hat{f}_i = G_i/G_{\text{total}}$ from **annotated
  protein-coding gene counts**. The code uses `L_coding_bp / L_coding_total` (**coding bp**). Note
  `scratch.tex` itself argues the two are highly correlated, so this may be a deliberate
  simplification — **confirm before "fixing"**.
- **$U_d$.** Methods gives $U_d = 4\mu L_{\text{coding}}$ (i.e. $2\mu \times 2L_{\text{coding}}$,
  regulatory target ≈ exome length). The code uses `2 * mu_1 * L_functional` with **CNE multipliers**
  of 1×/2×(bird)/4×(mammal)/5×. Different parameterizations of the same quantity.
- **$s$ — the sharpest one.** Methods states explicitly that a point estimate of $s$ is **not** fixed;
  $s_d$ is **inferred** by solving $V_m = U_d s_d^2$ across the joint credible intervals of $V_A$ and
  $\mu$. The code **hardcodes `s_het <- 0.01`** (with a `c(0.005, 0.01, 0.02)` sensitivity grid).
  **The code implements the opposite logical direction to the current Methods.**
- **Macrochromosome filter.** The code drops chromosomes with `Physical_Length_bp < 20e6`. No such
  filter is described in Methods — and `scratch.tex` §Discussion leans **heavily** on avian
  **microchromosomes** as the regime of greatest sensitivity, which that filter excludes.

**Internal to `scratch.tex`:**

- **$\overline{Q^2}$ method contradiction.** §Theory states the integral is **evaluated numerically
  under the Haldane** function, and argues *against* the linear approximation for chromosomes > 0.5 M.
  But §Methods (Genetic Map Lengths) describes the $Q^2$ expressions as **closed-form under the linear
  approximation** $r \approx |x-y|$ and discusses its bias. **These cannot both describe what was
  run.**
- **Appendix cross-ref.** §Theory points to **Appendix A** for the closed-form linear-limit
  approximation; it is actually in **Appendix C**. Appendix A is the unlinked-baseline derivation.

**Blast radius — what these can and cannot move.** The hardcoded `s_het` and the 20 Mb filter **can
change the reported numbers**. The headline "**2–3 orders of magnitude**" claim is insulated: the
margin is far too large for either to close it. The **per-species $V_{A,\max}$ comparison is NOT
insulated** — it is a per-species inequality test, so a shifted prediction can flip an individual
species across the bound. **Resolve both before building that table**; the Introduction rewrite can
proceed without waiting.

## Data flow

```
genomic_data/<species>/ncbi_dataset/...
   │  data_gen_2.R  (rtracklayer/GenomicRanges: physical length, reduce()d CDS bp, gene count)
   ▼
data/raw/clean_chromosome_data.csv
   │  inner_join recomb_data.csv on (Species_code, NCBI_Chromosome); Total_cM/100 → M_morgans
   ▼
data/master_chromosome_recomb_data.csv
   ├── unlinked.R  → unlinked-only Ne/N across κ models
   └── data_gen.R  → full linked+unlinked model
```

- **`Code` is the join key** across `df_va`, EPP data, and chromosome data; the analysis set is the
  `intersect()` of all three, so a species missing from any one is **silently dropped**.
  `recomb_data.csv` uses different `Code` values (`bsR` vs `BHS`) — the join that matters is on
  `Species_code`/`NCBI_Chromosome`.
- **`data_gen_2.R` falls back** to ranking largest coding scaffolds as pseudo-chromosomes when an
  assembly has no assembled molecules or GTF IDs don't match TSV accessions — check `Assembly_Level`
  before treating a row as a real chromosome.

## Build / run

R 4.6.0 (`Rscript`) and Python 3.14 are on PATH. **TinyTeX is installed** at `%APPDATA%\TinyTeX`
(TeX Live 2026) — `pdflatex`, `latexmk`, `bibtex` all work. **Restart the shell / RStudio after any
tlmgr install** to pick up PATH changes. Raw `pdflatex` does **not** auto-fetch missing `.sty` files —
install them explicitly, e.g. `tinytex::tlmgr_install("units")`, which is what supplies `nicefrac.sty`
(required by `main.tex` and **not** in TinyTeX's default set).

`manuscript/references.bib` covers `main.tex`'s 7 works (verified against Crossref), wired with
`natbib` + `plainnat` + `\citet{}`. **`scratch.tex` has ~91 prose citations and no `\bibliography`
block** — still unwired; its citations are plain prose, not `\cite` commands. They get converted to
`\citet{}` and folded into `references.bib` **as each section is backported** — see Rule 6 for the
machinery-vs-content split.

```sh
# R model (from repo root, interactively): source unlinked.R, then data_gen.R
cd manuscript/figures && python make_figures.py   # appendix PDFs (SUPERSEDED — see Rule 8)
cd manuscript && latexmk -pdf main.tex            # manuscript; runs bibtex itself
cd manuscript && latexmk -c                       # drop build intermediates
```

## Sign-off process

**Invocable as `/signoff`** (`.claude/skills/signoff/`), which points back here — this section stays the
source of truth.

**Run this at the end of every working session.** The point is that this project's durable memory is
**this file**, not the chat: decisions made in conversation are lost unless written down, and a
decision that changes framing or emphasis with no artifact yet is exactly the kind that vanishes. Work
through the checklist in order and **report each item explicitly** — including the ones that need no
action, so the user knows they were checked.

1. **Record decisions.** Any framing, scope, emphasis, or convention decision reached in conversation
   goes into the relevant section here (**Project framing**, **Rules**, **Model conventions**) with the
   date. **A decision that exists only in the transcript did not happen.**

2. **Record newly found staleness (Rule 5).** Any `scratch.tex` ↔ R code divergence, or internal
   inconsistency inside `scratch.tex`, discovered during the session gets written down — **even if not
   fixed**. Do not leave it in prose in the chat.

3. **State backport position (Rule 6).** Which section/subsection is in flight, what landed in
   `main.tex` this session, what is next.

4. **Check the manuscript still builds.** `cd manuscript && latexmk -pdf main.tex`, then confirm
   **zero** `Citation ... undefined` in `main.log`. Exit code 0 alone is **not** sufficient — a missing
   key still produces a PDF, just a wrong one. Then `latexmk -c`.

5. **Sync `references.bib`.** Every `\citet{}`/`\citep{}` added this session has an entry, and every
   new entry was **verified against Crossref**, not written from memory. Flag anything unverifiable
   with `% UNVERIFIED:` rather than inventing a volume or page range.

6. **Report git state.** `git status --short`. Do **not** commit unless asked. Call out untracked build
   products (`manuscript/*.pdf` is not gitignored) and any Google Drive `~$*` lock files or `* (1)*`
   conflict copies that appeared.

7. **Hand off the open thread.** Name the single next action and the blocking unknown, if any. Keep
   **Open work the pivot creates** current: strike what is done, add what the session surfaced.

## Filesystem notes

The repo lives inside a Google Drive folder. `~$*.xlsx`/`~$*.pptx` lock files and `* (1)*` conflict
copies appear routinely — the conflict copies are gitignored, the lock files are not. `.gitattributes`
routes `*.fna`/`*.gff` through Git LFS; large TIFFs (up to ~30 MB) are nonetheless committed under
`main/`, `supp/`, and `manuscript/figures/`. `.RData`/`.Rhistory`/`.Rproj` and LaTeX build artifacts
are gitignored. **Built PDFs (`manuscript/*.pdf`) are gitignored as of 2026-07-29** — reproducible from
source. That pattern matches direct children only, so the tracked `manuscript/figures/*.pdf` are
unaffected. `.claude/settings.local.json` is also gitignored (per-machine permission grants);
`.claude/skills/` **is** tracked. (`data/figures.tiff` was deleted 2026-07-29 as a confusing stray; do
not recreate it.)

## Git workflow

**Commit directly to `main`** (confirmed 2026-07-29). This is a solo research repo; branch-per-change
adds friction and risks leaving work unmerged and invisible. Do **not** create a branch unless asked.
Still applies: **commit and push only when the user asks.**

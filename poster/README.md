# poster/ — Midwest Population Genetics Meeting 2026

Generated artifacts, not hand-edited source. Two steps, in order:

```sh
Rscript scripts/R/poster_figs.R     # figures  (~4 min; sources unlinked.R + data_gen.R)
python  poster/make_poster.py       # the deck
```

| file | what it is |
|---|---|
| `../scripts/R/poster_figs.R` | builds the four panel figures at poster scale |
| `make_poster.py` | builds the deck — single source of truth for layout and copy |
| `figs/PosterFig_*.tiff` | the four panel figures, rendered at their exact placed size |
| `MWPG2026_poster_template.pptx` | **24 × 36 in** portrait, true print size |
| `MWPG2026_poster_template.pdf` | print-ready export — **send this, not the .pptx**. ⚠ **STALE**: the committed copy is the old 30 × 40 export. Re-export from PowerPoint after any build. |
| `assets/panel_*.png` | PNGs the deck embeds (regenerated each build) |
| `assets/render_full.png` | flat proof render, for eyeballing the layout |

Edit the content constants near the bottom of `make_poster.py` (`A_BODY`, `B_CAP`,
`Z3_TAKEAWAY`, …) rather than the `.pptx`, which is overwritten on each build.

## The figure-scale problem, and how it is solved

The TIFFs in `main/` are rendered for a journal page (7–12.6 in wide). Placed in a
poster panel they landed at **0.54–0.65×**, which shrinks their axis type by the
same factor — that is what made them hard to read on the wall.

`poster_figs.R` renders each figure at **exactly the size it occupies on the
poster**, so the placement scale is 1.00 and axis text lands at a known point size
on the printed sheet. `make_poster.py` prints a placement table every build; every
row should read `scale 1.00`. If a panel's text budget changes, the figure slot
changes with it — re-read the table and update `DIM_A`…`DIM_D` in `poster_figs.R`
to match, then re-render.

Two constraints that cannot be fixed by raising `base_size`:

- **19 rows in ~5.4 in gives ~0.28 in per row**, so species labels in Panels A and
  D cannot exceed ~14 pt. Bigger labels need a taller panel — and on the 24 × 36
  sheet the panel is as tall as the zone division allows, so the only lever left is
  cutting body copy so the figure region grows.
- **Long axis titles and legend labels get clipped, not shrunk.** The manuscript
  labels are written for a wide figure; the poster versions override them with
  short forms (`LAB_NE`, the Panel C titles, the Panel D legend), and the panel
  captions carry the detail they drop.

`poster_figs.R` touches nothing in the manuscript pipeline. It shims `read.csv`
(so `unlinked.R` finds `data/species_EPP.csv` — the Rule 2 path inconsistency) and
`tiff` (so the sourced scripts' own manuscript TIFFs go to a scratch dir), and it
patches `data_gen.R` in a temporary copy — see the next section.

## A real bug this surfaced: `data_gen.R:479`

That line reads

```r
left_join(epp_data %>% select(Code, Ud, EPP, Species.y), by = "Code")
```

and is wrong twice. `Species.y` is not a column of `data/species_EPP.csv` — that
name only exists *after* a join collision with `chrom_data$Species`. And it drops
`mu_1` / `X95ci_lower_1` / `X95ci_upper_1`, which the μ-sensitivity block at line
633 then reads off `sp_arch`. The equivalent block at line 73 (see line 86) has
the correct, complete select.

Consequence: **`data_gen.R` cannot run start-to-finish from a clean session**, so
the committed `MainFig_Empirical_Sensitivity_MutationRate.tiff` is not
reproducible from scratch. Interactively it survives on a leftover `arch_map` that
still carries those columns — the dangerous case CLAUDE.md Rule 1 describes.

`poster_figs.R` fixes it in a temp copy so the pipeline stays untouched. **The
real fix is one line**: make `data_gen.R:479` match line 86. Not applied here
because it is the manuscript pipeline.

## What the numbers actually say — read before presenting

Computed from the 19 posterior modes in `alldistzip` (printed on every run):

```
Va posterior modes, n = 19:  min 0.0029  Q1 0.0172  median 0.0997  Q3 0.2484  max 0.4970
kappa = 1 ceiling exceeded once delta >  0.715 (median pop) | 0.335 (highest Va) | 0.989 (lowest Va)
median population: a 100x excess needs delta > 0.9960 ; 1000x needs delta > 0.9996
```

`δ` is the retained fraction of neutral diversity, i.e. observed `Ne/N`. Three
things follow, and they matter for how the claim is stated:

1. **The excess is conditional on δ, and the condition is not soft.** At
   `δ ≈ 0.1–0.3` — the range conservation genetics routinely reports for wild
   vertebrates — the unlinked ceiling is **not** exceeded at the median reported
   `V_A`. It is exceeded for the highest-variance populations once `δ > 0.33`.
2. **"Two to three orders of magnitude" is not supportable from the unlinked
   baseline.** For the median population it requires `δ > 0.996`. That phrase was
   therefore removed from the hero claim in this deck (it now reads "…exceed it").
   If the magnitude comes from the full linked model rather than the baseline, say
   so explicitly — and note that this puts the headline magnitude on the *map- and
   annotation-dependent* part of the analysis, not the assumption-free part.
3. **The ceiling is crossed exactly when `δ > 1/(1 + 4κV_A)`**, which is the
   unlinked prediction for `Ne/N` itself. So Panel B is Panel A in other
   coordinates, and "the bound is exceeded" means precisely "observed `Ne/N`
   exceeds predicted `Ne/N`". Stating it that way keeps the claim in the natural
   units of the comparison instead of in the hyperbolically-inflated `V_A` units.

Panel B plots the ceiling against δ for this reason: it reports the δ a violation
requires instead of asserting a fixed number of orders of magnitude.

## What δ is, and what "exceeded" means

Written out because the short verdict lines on the earlier draft ("exceeded once
δ > 0.33") were opaque even to us, and a poster viewer has no chance with them.

**δ is the share of its neutral diversity a population still has** — observed
`Ne/N`. δ = 1 means no diversity lost relative to a neutral population of the same
census size; δ = 0.1 means nine tenths of it is gone.

**The ceiling runs the other way from the intuition.** `V_A,max = (1 − δ)/(4κδ)`
*falls* as δ rises. A population that has lost most of its diversity is compatible
with a large `V_A`; a population that kept most of its diversity is only compatible
with a tiny one. So the populations that look genetically healthy are the hard ones
to reconcile with a large `V_A`, not the depleted ones.

**"Exceeded" means: reported pedigree `V_A` > `V_A,max` at that population's own δ.**
The excess is the ratio of the two. Nothing else is being exceeded — there is no
second measurement involved.

**The crossing has a closed form, and it is the prediction itself.** Reported `V_A`
exceeds the ceiling exactly when

```
delta  >  1 / (1 + 4 * kappa * V_A)
```

and the right-hand side *is* the unlinked prediction for `Ne/N`. So "the bound is
exceeded" means precisely **"the population kept more diversity than the model says
it should have."** That is the honest way to say it, and it is why the poster now
states the threshold as a condition on δ rather than as a number of orders of
magnitude: the `V_A`-scale version is that same fact pushed through a hyperbola
near its singularity.

**Read off the current numbers, κ = 1:**

| population | reported `V_A` | its estimate is allowed only if |
|---|---|---|
| most variable | 0.497 | δ < 0.335 (must have lost ⅔ of its diversity) |
| median | 0.0997 | δ < 0.715 (must have lost ~29%) |
| least variable | 0.0029 | δ < 0.989 |

**The consequence to be honest about.** Panels A and C both show the predicted
`Ne/N` landing in roughly 0.3–1.0 — never near 0.1. So on the unlinked baseline the
model predicts a *modest* diversity reduction, and a violation requires observed δ
to be **high**. At the `Ne/N ≈ 0.1–0.3` that conservation genetics usually quotes
for wild vertebrates, the unlinked ceiling is **not exceeded at all** at the median
reported `V_A`. This is Amendment F4 Finding 1 and it is why the magnitude claim was
pulled from the hero line.

**Settled 2026-08-19 — see CLAUDE.md Amendment F5.** Four things that were loose here:

1. **δ is derived, not measured:** `δ = π_obs / (4 μ N)` with **N = breeding adults**.
   Observed π alone tests nothing, because the model predicts a dimensionless *factor*
   and testing a factor needs the counterfactual `4μN`. A census N is unavoidable.
2. **Lewin & Eyre-Walker's `Ne` is not a shortcut.** Their `Ne` *is* `π/(4μ)` — the same
   number in other units, not a ratio. The denominator is always ours to supply.
3. **Report `π_obs` vs `π_pred = 4μN/(1+4κV_A)` per population**, not δ. Same test,
   but it keeps μ and N visible instead of hiding them inside one symbol. δ stays as the
   *x* axis of Panel B, where it is the argument of a function rather than a measurement.
4. **Screen on δ ≥ 1.** That gives `V_A,max ≤ 0` and is a *failed model check*, not a
   strong result: the population holds more diversity than neutral equilibrium at its
   census size allows, before selection enters. Report the trichotomy
   (uninformative / violating / consistent) and say how many fell out.

The timescale question — coalescent `Ne` from π versus the model's `Ne` — resolves in
π's favour: π registers only *sustained* fitness variance, which is exactly the
component the bound binds. That is the feature, not a defect. F5 has the argument.

## Framing

Authority is `CLAUDE.md` **Amendment F8 (the forward framing)**, not `scratch.tex`'s
Introduction (Rule 10) and no longer F3. Baked in; do not "fix" back:

- **The claim is forward, not inverse.** Take reported V_A, propagate it, report how
  much diversity it removes: at most ~20x, one to four orders short of the deficit.
  **Do not** write that published estimates exceed the ceiling — at realistic delta
  they do not (F6 Finding 4: 0/19 at delta <= 0.3).
- **V_A,max is the citable object, the forward magnitude is the finding.** Panel B
  reports the ceiling honestly as not yet binding.
- **The two-branch disjunction is WITHDRAWN** (F7). A sign flip does not restore lost
  heterozygosity, so "not directional" was never an escape. The surviving branches are
  `scratch.tex`'s own three: not at equilibrium, census too small, or the animal model
  absorbed non-additive / environmentally structured covariance.
- **Fluctuating and balancing selection explain how high V_A is *maintained*.** That is
  a different question from what V_A *implies*. Do not present them as a competing
  resolution of our premise.
- **Lewontin and Buffalo appear only in the reference strip.** The result lands in
  Buffalo's direction but is not positioned against it — report the magnitude and let
  the arithmetic speak.
- **Panel C is MAP-DEPENDENT, not SUPPORTING**, because it now carries the headline
  magnitude. Panel A remains the assumption-free floor (1.4x median, 3x max).
- **FTNS is a discussion point, not a claim.** No strawman; name nobody.
- **Register:** Santiago-Caballero, Q^2 and kappa are not prerequisites for reading the
  sheet. Attribution lives in the footer strip.

## Fill-ins before printing

Search the deck for `[FILL:` — four remain. Two are **yours to type**, two are
**unfinished analysis**:

| # | marker | kind | what it needs |
|---|---|---|---|
| 1 | affiliation line | **you type it** | Department / committee name. Nothing to compute. |
| 2 | observed δ per population (Panel B caption) | **analysis, not done** | π and `Ne` from Lewin & Eyre-Walker 2026, census `N` from Buffalo 2021 plus an allometry for the species Buffalo lacks. Then δ = observed `Ne/N` per population. |
| 3 | `V_A,max` at observed δ (Zone 3 verdict) | **falls out of #2** | Once δ exists, `V_A,max = (1 − δ)/(4κδ)`. No new data. |
| 4 | QR / preprint link, bottom right | **you type it** | Or delete the line if there is no preprint yet. |

**#2 is the blocking one, and it decides which version of the claim you can make**
(see the δ section above). #3 is one line of arithmetic downstream of it. Neither
figure breaks without them — the poster is printable as-is, because Panel B reports
the δ a violation *would* require instead of asserting that one occurred.

## Layout notes

Text heights are **measured**, not guessed: `make_poster.py` reads the real font
metrics through PIL, wraps bold-aware (a `**bold**` span is wider than the same
text at regular weight and will otherwise gain a line), and stacks blocks with a
flow cursor; figures contain-fit what is left. The build prints a layout report —
`layout check: clean` means every block fits its region. Body copy autoshrinks
from 33 pt when a panel is tight, and each autoshrink is logged, so a panel
reading small is visible rather than silent.

Two PowerPoint gotchas encoded here, both of which caused real overlaps:

- `line_spacing` as a **float** is a multiple of the *font's* line height
  (~1.2 × em), not of the point size, so it renders ~20% taller than the point
  size implies. This sets **exact** spacing in points instead.
- python-pptx cannot embed fonts. The deck renders correctly on a machine with
  Inter / Source Sans 3 / Latin Modern Math installed; send the **PDF** to the
  printer.

Type scale is the agreed hierarchy × **1.6** for true **24 × 36**: title 76,
authors 37, section heads 34, body 26, callouts 32, captions 18. (It was × 2 at
30 × 40; the sheet lost 20% of its width, so the type came down with it.) Panels C
and D autoshrink their body to 24 pt, which is still inside the normal poster
range. The autoshrink floor is 18 pt — if the build ever reports that, cut copy
rather than shipping it.

**Geometry for 24 × 36:** margin 1.00, top 0.90, gutter 0.60, column 10.70, card
padding 0.32, zone gap 0.40, Zone 3 ends at 34.00, footer 34.45–35.10.

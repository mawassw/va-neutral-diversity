# Open items register

Every error and unanswered question raised during the redraft, as of 2026-09-03. Errors are defects
in existing files; questions need an author decision. **Nothing here has been applied.** Items marked
`BLOCKS` prevent specific drafting work from starting.

All of E1–E10 belong in CLAUDE.md's *Known staleness & inconsistencies (Rule 5)* log at the next
sign-off; E1 and E2 are new findings of 2026-09-03 and are not recorded anywhere else.

---

## Errors in existing files

| # | item | where | status |
|---|---|---|---|
| E1 | **Jensen direction stated backwards.** The derivation is right: the uniform density yields the *lower* $N_e/N$, i.e. the larger reduction. The summary says uniform "minimizes local interference … and yields an upper bound on $N_e/N$" — wrong twice. Under the settled claim the correct direction is favourable: the spatial assumption is the one most generous to the mechanism. | `scratch.tex:317`; also `:23`, moot once the Introduction lands | **new 2026-09-03** |
| E2 | **Mutation–selection–drift balance has no main-text presence.** It exists only as Appendix D, though it carries one of the paper's two comparisons. | §Theory | **new 2026-09-03**; T8 fixes it |
| E3 | **Factor of 2 in the linked exponent.** `chrom_reduc` carries $v_i$, `total_red` carries $v_i/2$, the prose justifies the halving, the R code implements it. Sits on the linked magnitude the Results report. | `scratch.tex:113` vs `:149` | `BLOCKS` T4 |
| E4 | **$\overline{Q^2}$ method contradiction.** §Theory says numerical Haldane and argues against the linear approximation; §Methods describes closed-form linear expressions. Both cannot describe what was run. Resolve toward numerical Haldane. | §Theory vs §Methods | `BLOCKS` T4 |
| E5 | **Appendix cross-reference.** §Theory points to Appendix A for the closed-form linear limit; it is in Appendix C. Appendix A is the unlinked baseline. | §Theory | trivial |
| E6 | **Reported $V_A$ range wrong.** States $V_A \in [0.10, 0.30]$; posterior modes are 0.0029–0.4963, median 0.0997. | `scratch.tex:309` | not fixed |
| E7 | **Standardisation placeholder is answerable.** No standardisation was required — Bonnet et al. report observed-scale $V_A(w)$ via $\mathbf{d}^\top\mathbf{G}\mathbf{d}$. Say so and delete it. | `scratch.tex:235` | not fixed |
| E8 | **Appendix D `[XX]` placeholders are computable now.** $U_d$ = 0.69–1.19 (median 1.07); $s^*$ = 0.019–0.313 (median 0.145), or 0.092 at the upper CI on $\mu$. | Appendix D | not fixed |
| E9 | **The 20 Mb macrochromosome filter is undescribed in Methods** and excludes precisely the avian microchromosomes the Discussion leans on. Either describe and justify it, or scope those claims to macrochromosomes. | code vs §Methods | not fixed |
| E10 | **`s_het` hardcoded at 0.01** in the R code while Methods states $s$ is inferred, not fixed. The code implements the opposite logical direction to the Methods. | `data_gen.R` vs §Methods | not fixed |
| E11 | **The 136/27/14 factors are computed against the eight-population median $V_A$ = 0.146**, not the nineteen-population median 0.0997. Against 0.0997 they are 93/19/9. Name the set wherever they appear. | Results R5 as briefed | flagged before drafting |
| E12 | **The four-branch disjunction and the branch-(i) mechanisms sit in §Theory**, pre-empting the Discussion. | `scratch.tex` §Upper Bound | T7 removes them |
| E13 | **Title asserts the retired claim** — "predicts severe depletion of neutral diversity". | `scratch.tex:9` | not fixed |
| E14 | **Discussion carries retired claims throughout** — "violate that limit", "exceeds $V_{A,\max}$", "two to three orders of magnitude". | `scratch.tex:288–321` | briefed, not drafted |
| E15 | **Results is one subsection long and reports no numbers.** It is a build, not a redraft. | `scratch.tex:276–286` | briefed, not drafted |
| E16 | **No figure is wired into any `.tex` file**, and the payoff figure (the two thresholds with the posteriors between them) does not exist. | `main/`, `scratch.tex` | not built |

---

## Questions needing an author decision

| # | question | why it matters | status |
|---|---|---|---|
| Q1 | **Does the analysis use annotated gene positions *within* chromosomes, or only the between-chromosome partition $f_i$?** | If only $f_i$, T6's empirical-density paragraph collapses to one sentence in T9. | `BLOCKS` T6 |
| Q2 | **$\pi_{\text{obs}}$ and a breeding-adult census $N$.** Still absent from the repo. | The only blocking unknown for the per-population diversity test. | open |
| Q3 | **Preprint scope.** Commit now to a preprint without per-population $\pi$ and $N$ — diversity side stated as the mechanism's ceiling against literature-reported deficits — or hold for the data? | Determines whether the end-of-month target is safe. Changes Results, not the Introduction. | open, time-sensitive |
| Q4 | **Which $\kappa$ model is primary** in the reported results, A or B? The code implements Model A. | T3 and every reported magnitude. | open |
| Q5 | **Which `main/` TIFF fills which figure slot.** Several `Theoretical_*.tiff` have no current producer, and both `SuppFig3.tiff` and `SuppFig3_Va_Deflation_Analysis.tiff` exist. Rule 8 says ask rather than guess. | Figure captions and `\includegraphics` at backport. | open |
| Q6 | **The verdict clause in the Introduction's final paragraph** — read as omitted, per directive v3. Confirm, or insert the labelled alternative. | One sentence. | assumed resolved |
| Q7 | **Were the P3 fixes carried into the final Introduction** — lifetime *breeding* success, two exemplar systems not three, Ram Mountain rather than "Alberta" bighorn, "composite lifetime measure" rather than "fitness itself"? | They were instructions in directive v3, not verified in output. | verify against final text |

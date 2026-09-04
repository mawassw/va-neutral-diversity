# Editor session kickoff — `scratch.tex` redraft

Paste the block below to open a drafting session in this repo. Then request paragraphs one at a
time. Nothing here is prose for the manuscript; it is the standing contract for the session.

---

## The paste block

> You are drafting prose for a manuscript targeting GENETICS (GSA). Read, in this order:
>
> 1. `manuscript/redraft_framing.md` — the paragraph-by-paragraph brief. This governs what each
>    paragraph must contain and where it sits.
> 2. `walid_authorial_style_guide.md` — governs diction, sentence structure, paragraph rhythm. Mine
>    its Appendix for **voice only**; four of its reference sentences assert claims this project has
>    retired.
> 3. The *Project framing* section of `CLAUDE.md` — governs every claim and number. Its
>    retired-claims table is a hard constraint.
>
> `manuscript/scratch.tex` holds the current draft. Its Theory, Methods and Appendices are
> authoritative for every equation. Its Introduction and Discussion are several framings stale and
> are being replaced; read them only where a brief tells you to retain or adapt existing text.
>
> Work one paragraph at a time. Draft only the paragraph I name. Return the prose in chat — do not
> edit any file. After the prose, give me two lines: the sentence-length sequence, and the slot you
> believe the closing sentence opens.
>
> Start with brief I1.

---

## Standing rules for every paragraph

1. **Fill the slot, open the slot.** Each brief names the question the previous paragraph left open
   and the question this one must leave open. A paragraph that opens a different slot than its brief
   names is wrong even if every sentence is true.
2. **Numbers come from the brief, never from memory or from `scratch.tex`.** Several numbers in the
   current draft are stale — most notably $V_A \in [0.10, 0.30]$, which is wrong.
3. **Placeholders stay placeholders.** Where a brief says **[DATA-BLOCKED]**, write the structure with
   `[PI_OBS]`, `[N_BREED]`, `[DELTA]`, `[N_POP]` and invent no magnitude.
4. **Citations stay in prose form** — "(Robertson 1961)" — not `\citet{}`. Conversion happens at
   backport, against Crossref. Flag anything you are unsure of with `% UNVERIFIED:`.
5. **Say which $N_e/N$.** The demographic ratio ($N_{eV}/N$, family-size variance, 0.1–0.5) and the
   diversity ratio ($(\pi/4\mu)/N_c$, $10^{-2}$–$10^{-5}$) are different quantities. $N$ is breeding
   adults; $N_c$ is total census. This project has slid between them before.
6. **No borrowed significance.** Do not position the work as answering Lewontin's paradox, Buffalo
   2021, or anyone else's open challenge. Standing test: remove those references — is the paragraph
   still interesting?
7. **The kill list in §1 of the brief is absolute.** If a sentence you are about to write resembles
   one of those, stop.
8. **A brief's bullets state what must be true of the paragraph, not what must be said, in order.**
   Do not write one sentence per bullet. A paragraph is an argument that obliges the next paragraph to
   answer it, not an inventory of its contents. If a bullet's content is already implied by a sentence
   you have written, it is covered — do not restate it to discharge the bullet. Fewer, heavier
   sentences beat complete coverage.
9. **Do not transcribe the brief's reasoning into the manuscript.** Notes about why the paper is
   arranged as it is, which currency a number is stated in, or what is reported where, are addressed
   to you and not to a reader. One such sentence has already reached a draft.

## When to escalate rather than resolve

Come back to me instead of deciding, if:

- A brief seems to contradict `scratch.tex`'s math, or two briefs seem to contradict each other.
- A paragraph cannot be written without a number the brief does not supply.
- You think a constraint in the brief is wrong. Several are counter-intuitive and were set for
  reasons the brief does not record — for instance, both thresholds in I5 are stated in unlinked
  currency on purpose, because mixing unlinked and linked figures makes the interval arithmetic
  inconsistent.

## Theory pass — T8 (use a FRESH session)

> You are writing one subsection of the Theory and Model section of a manuscript targeting GENETICS
> (GSA). Write **T8 only**. **It is new** — there is no existing text to revise.
>
> **The live Theory section is `manuscript/theory_model.tex`.** T8 is appended after its current final
> subsection, "The coalescent ceiling on heritable fitness variance". `manuscript/scratch.tex` holds a
> stale duplicate of the section — **do not read or edit it.**
>
> Read, in this order:
>
> 1. `manuscript/theory_model.tex` — all of it. T1–T7 precede T8.
> 2. `supp/appendix_D.tex` — **authoritative for every step of this derivation.** T8 states results and
>    points there; it reproduces nothing.
> 3. `manuscript/theory_outline.md` — T8 is specified there; the instructions below take precedence.
> 4. `walid_authorial_style_guide.md` — sentence construction and diction; Appendix for voice only.
>
> **Why T8 exists.** The paper puts one measured quantity through two independent equilibrium
> comparisons. The first — propagation to neutral diversity — occupies T2 through T7. The second, what
> mutation and selection can sustain, currently appears nowhere in the main text; it lives only in
> Appendix D. A reader of the Theory section presently meets one engine and not the other. T8 supplies
> the second.
>
> **An obligation T8 must discharge.** T4 forward-references `\autoref{msdb}`, which resolves to
> nothing — it is the only dangling reference left in the manuscript. **Put `\label{msdb}` on this
> subsection.**
>
> **It must carry:**
>
> 1. The three fluxes acting on standing additive variance in fitness, named and given in one line
>    each rather than derived: mutational influx $V_m = U_d s^2$; depletion by purifying selection;
>    depletion by drift at rate $1/(2N_e)$. Point to Appendix D for the derivation.
> 2. The stationary solution, displayed: $V_A = 2N_eU_ds^2/(1 + 2N_es)$.
> 3. The strong-selection limit, displayed: when selection overwhelms drift the expression collapses to
>    the House-of-Cards form $V_A \approx U_d s$ (Turelli 1984; Bürger 2000).
> 4. **The inversion, which is what the Results use.** Solving for the coefficient a reported variance
>    implies. Note that Appendix D gives the exact positive root, and that under strong selection it
>    reduces to $s^{*} = V_A/U_d$, the form carried forward.
> 5. **The logical direction, explicitly.** $s^{*}$ is a consequence read off a reported variance, not
>    an estimate of selection fitted to sequence, site-frequency or diversity data. Without this
>    sentence a reader takes T8 for a DFE inference method.
> 6. $U_d = 4\mu L_{\text{coding}}$, with the factor of four accounted for: $2\mu$ for a diploid rate,
>    and a further doubling because the regulatory target is taken equal in length to the annotated
>    exome. State it as the diploid deleterious mutation rate. A referee will ask why four and not two.
> 7. **The weak-selection branch, and that it fails on its own terms.** Solving the near-neutral
>    relation and evaluating it returns $N_es \gg 1$, contradicting the premise of the approximation
>    used to obtain it. One or two sentences; Appendix D has the check.
> 8. **The connection back to $Z$, which closes a loop T4 left open.** Under this balance
>    $V_m/V_A \approx s$, so the per-generation survival of selective variance is $Z \approx 1-s$ —
>    the parameterization T4 used and forward-referenced here.
>
> **Length: 320–380 words plus the three displayed equations.**
>
> **Forbidden.** Any empirical value: no $U_d$ range, no $s^{*}$ range, no comparison against
> vertebrate DFE estimates, and no statement about whether the implied coefficient is plausible. All of
> that is the Results section, and stating it here converts a derivation into a verdict. Re-deriving
> anything Appendix D derives. Restating T1's equilibrium requirement or the two persistence windows.
> The distribution-of-fitness-effects generalisation — mention that Appendix D treats it, in at most a
> clause, and stop.
>
> **Register.** Functional and declarative; equations carry the load. Announce each assumption where it
> is used. Open on substance — the subsection's first sentence should be about what sustains standing
> fitness variance, not about what the section is going to do.
>
> **Note for the author, not for the prose.** Appendix D currently quotes pedigree $V_A$ as "typically
> 0.10–0.30" and an implied $s^*_{\text{strong}} \approx 0.10$–$0.30$. Both are stale against the actual
> posterior modes. Flag this in your return; do not fix the appendix.
>
> Do not edit any file. Return: the prose and equations; the word count; confirmation that
> `\label{msdb}` is present and that no empirical magnitude appears; and the list of places where you
> pointed to Appendix D rather than deriving.

## Theory pass — T7 (use a FRESH session)

> You are writing one subsection of the Theory and Model section of a manuscript targeting GENETICS
> (GSA). Write **T7 only**.
>
> **The live Theory section is `manuscript/theory_model.tex`.** T7 replaces its final subsection, "The
> Upper Bound of Heritable Variance in Relative Fitness". `manuscript/scratch.tex` holds a stale
> duplicate of the whole section — **do not read or edit it.**
>
> Read, in this order:
>
> 1. `manuscript/theory_model.tex` — all of it. T1–T6 precede T7.
> 2. `CLAUDE.md` §*Project framing*, in particular the *Supporting results* entry on
>    $V_{A,\max}(\delta)$ and the *What is deliberately NOT claimed* table.
> 3. `walid_authorial_style_guide.md` — sentence construction and diction; Appendix for voice only.
>
> **What T7 is.** The inversion of the unlinked baseline into a ceiling on heritable fitness variance,
> published **as a curve over $\delta$** — the most reusable object in the paper, because anyone with a
> diversity estimate reads their own limit off it and any future sequence-based estimate of fitness
> variance has to come in under it.
>
> **What T7 is not, and this is the substantive change.** It is not a test that populations pass or
> fail. The existing subsection frames it that way — "a diagnostic limit", and a paragraph beginning
> "If a pedigree-based animal-model estimate … exceeds $V_{A,\max}$ … the ecological measurements are
> irreconcilable". That framing is retired: **no population in the analysed set exceeds the ceiling at
> a plausible diversity threshold**, and presenting the object as a violation test invites a reader to
> expect violations that are not there. Present a ceiling function; let the Results section evaluate it.
>
> **Two things to cut, and hand to the Discussion.**
>
> - **The three-branch disjunction** — non-equilibrium transient loss, cryptic immigration, and
>   non-additive or environmentally structured covariance. It pre-empts the Discussion, which is
>   briefed to adjudicate exactly this.
> - **The whole final paragraph on animal-model mechanisms** — indirect genetic effects, kin-structured
>   interactions, spatially autocorrelated environments, pedigree-structure sensitivity. Same reason.
>   Theory states the ceiling; the Discussion argues about what a comparison against it means.
>
> **One error to fix.** The subsection currently says a population exceeding the bound is
> "irreconcilable with the expectations of a rigorous theoretical model **at stable
> mutation-selection-drift equilibrium**". That contradicts T2, which establishes that the unlinked
> baseline requires no stationarity of the selected background and holds under
> mutation–selection–drift balance, sweeps and fluctuating selection alike. Since $V_{A,\max}$ is
> derived from that baseline, it inherits the same freedom. **Say so explicitly** — the ceiling carries
> no equilibrium assumption about the selected background. It is one of the object's strengths and the
> current text gives it away.
>
> **It must carry:**
>
> 1. The inversion: setting the unlinked expectation equal to a retained-diversity threshold
>    $\delta \in (0,1)$ and solving for the variance. $\delta$ is defined in T1's notation; use it
>    consistently and do not redefine it.
> 2. Why the unlinked baseline is the right thing to invert: $\Omega_i \le 1$, so no arrangement of
>    recombination or functional architecture restores diversity above the unlinked expectation. The
>    ceiling is therefore the most permissive case, and a population with linked chromosomes reaches
>    any given reduction at less variance.
> 3. The displayed result, $V_{A,\max} = (1-\delta)/(4\kappa\delta)$. **Give it a label** —
>    `\label{eq:vamax}` — because the Results section references it.
> 4. That it depends on nothing but $\delta$ and $\kappa$, and that $\kappa = 2$ halves it relative to
>    $\kappa = 1$, with the biological reading: pairing concentrates the heritable component of
>    family-size variance across both gametic pools at once.
> 5. One sentence that the ceiling is reported as a curve over $\delta$ rather than a single defended
>    value, and that it is evaluated against the published estimates in the Results.
>
> **Length: 200–240 words plus the equation.** The existing subsection runs near 600; the two cuts
> account for most of the difference.
>
> **Say which $N_e/N$.** The manuscript distinguishes the variance effective size from the coalescent
> one, and two different ratios in this literature are both written $N_e/N$. Where $\delta$ is
> introduced as "equivalent to a target $N_e/N$", make clear it is the diversity-derived ratio.
>
> **Also.** Drop "severe" from "the severe coalescent consequences of social pairing" — the magnitude
> is a Results matter and the adjective belongs to a superseded framing.
>
> **Forbidden.** Any count of populations above or below the ceiling, any empirical $\delta$, $\kappa$
> or $V_A$ value, and any verdict — all Results. Mutation–selection–drift balance as a premise of this
> subsection (T8 owns it). The Discussion material named above.
>
> **Register.** Functional and declarative; the equation carries the load. Open on substance.
>
> Do not edit any file. Return: the prose and equation; the word count; confirmation that
> `\label{eq:vamax}` is present, that the equilibrium claim is corrected, and that both cut paragraphs
> are gone; and a one-line note of what you removed, so it can be checked against the Discussion brief.

## Theory pass — T6 (use a FRESH session)

> You are writing one subsection of the Theory and Model section of a manuscript targeting GENETICS
> (GSA). Write **T6 only**.
>
> **The manuscript has been restructured.** `manuscript/main.tex` now `\input`s separate section
> files. **The live Theory section is `manuscript/theory_model.tex`.** T6 replaces its final
> subsection, "The Architecture of Variance: Infinitesimal and Oligogenic Limits". `manuscript/scratch.tex`
> still holds a byte-identical duplicate of the whole Theory section — **do not read it or edit it.**
>
> Read, in this order:
>
> 1. `manuscript/theory_model.tex` — all of it. T1–T5 precede T6.
> 2. `supp/appendix_C.tex` — authoritative for the $\overline{Q^2}$ integration; do not reproduce it.
> 3. `manuscript/theory_outline.md` — T6 is specified there; the instructions below take precedence.
> 4. `walid_authorial_style_guide.md` — sentence construction and diction; Appendix for voice only.
>
> **Two mechanical fixes T6 must make.**
>
> - **Notation.** T5 established $v_h = v_i/2$ as the haplotype variance. The current subsection writes
>   $v_i/2$ or $v_i g(x)/2$ in five places, including three times inside the Jensen inequality. **Use
>   $v_h$ throughout**, including in the Jensen's-gap expression, which becomes proportional to
>   $(\kappa v_h)^2\,\mathrm{Var}_x[Q^2(x)]$.
> - **A dangling reference.** The subsection cites `\autoref{average_linked}`; T4's rewrite renamed
>   that label. The chromosome-averaged integral is now `\label{eq:haldane_avg}`. Fix the reference.
>
> **A question that has been resolved, and which changes what this subsection may claim.** The analysis
> evaluates the chromosome-averaged interference under the **uniform density only**: the pipeline calls
> a single Haldane-average routine at every call site and never evaluates $Q^2$ at annotated gene
> positions. Therefore:
>
> - **Cut the final two paragraphs and their equation** — the empirical-density substitution
>   $\overline{Q^2}_i(\hat g_i) = G_i^{-1}\sum_j Q^2(x_j^{(i)})$, and the discussion of annotated gene
>   counts versus coding length. That machinery is derived but never applied, and it belongs in the
>   closing "framework breakdown" subsection as a stated extension. Do not write it here.
> - **Say plainly, in one sentence, that the reported predictions use the uniform density**, so a
>   reader knows which member of the continuum was actually evaluated.
>
> **On the direction of the Jensen result — read carefully, because it is easy to get backwards.** The
> subsection's existing direction statements are **correct** and should be kept: the uniform density
> yields the *lower* $N_e$, so a randomly placed causal locus produces a higher average $N_e$ than
> spreading the same variance uniformly. What is missing is what that is good for.
>
> - **Replace the word "conservative".** It is used without saying conservative about what, and it
>   carried a different meaning under a superseded framing. State the content directly: the uniform
>   assumption maximises the predicted reduction.
> - **Add the consequence, in one sentence.** Because the uniform density is the spatial assumption
>   most favourable to the mechanism, a bound on how much neutral diversity heritable fitness variance
>   can remove is obtained under the arrangement most generous to it. That is what makes this result
>   load-bearing rather than a technical aside.
>
> **Keep, in this order:** the infinitesimal assumption named and located against the empirically
> unresolved architecture of fitness (Barton and Keightley 2002); the arbitrary density $g(x)$ and the
> position-specific profile; the Fubini reduction to $\overline{Q^2}(g) = \int g(x)Q^2(x)dx$, keeping
> `\label{general_g}`; recovery of the infinitesimal case and the oligogenic discrete mean, keeping
> `\label{oligogenic_mean}`; that $Q^2(x)$ peaks at the chromosome midpoint and is least at the
> telomeres, with the reason; the Jensen inequality and its corrected reading; the gap expression; and
> the reversal condition — enrichment of causal loci in regions of suppressed recombination
> (Kirkpatrick and Barton 2006; Yeaman 2013) closes the gap and can reverse it.
>
> **Length: 280–330 words plus the equations.** The existing subsection runs near 800. Cutting the
> empirical-density material recovers most of that; the rest comes from tightening.
>
> **Two small fixes while you are here.** "here, the symmetry of the kernel" begins a sentence and
> needs a capital. "However, the true genetic architecture…" opens with a sentence-initial "however";
> the style guide places it after the subject.
>
> **Forbidden.** Reproducing Appendix C. $V_{A,\max}$ (T7). $U_d$, $s^*$ or mutation–selection–drift
> (T8). The empirical-density substitution, per above. Any magnitude, species value, or verdict.
>
> **Register.** Functional and declarative; equations carry the load. Open on substance.
>
> Do not edit any file. Return: the prose and equations; the word count; confirmation that no bare
> $v_i/2$ remains and that `\autoref{eq:haldane_avg}` replaced `\autoref{average_linked}`; and the one
> sentence you would put in the framework-breakdown subsection to carry the cut empirical-density
> material.

## Theory pass — T5 (use a FRESH session)

> You are writing one subsection of the Theory and Model section of a manuscript targeting GENETICS
> (GSA). Write **T5 only**.
>
> Read, in this order:
>
> 1. `manuscript/scratch.tex` — read all of §Theory and Model. **T1–T4 are written and precede T5.**
>    T5 replaces "Total Reduction in Diversity and Genomic Architecture". Its existing text is sound
>    and most of it survives; the work is connecting it to T4's notation and cutting its length.
> 2. `manuscript/theory_outline.md` — T5 is specified there; the instructions below take precedence.
> 3. `manuscript/OPEN_ITEMS.md` §*Modelling decisions worth preserving*, item **M-1**. T5 is where M-1
>    is discharged.
> 4. `walid_authorial_style_guide.md` — sentence construction and diction; Appendix for voice only.
>
> **Three obligations T5 inherits from T4.**
>
> - T4 ends with `\autoref{variance_partitioning}`, which resolves to nothing. **Put
>   `\label{variance_partitioning}` on this subsection.**
> - T4 introduced $v_h$, the selective variance on the focal haplotype, and deferred its value here.
>   **T5 must supply it explicitly: $v_h = v_i/2$, where $v_i = V_A f_i$ is the diploid chromosome's
>   share of the genome-wide additive variance.** State the identity once, in that form.
> - T4 promised that the homologous haplotype's variance is *reassigned* rather than dropped. **T5
>   completes that accounting** — the unlinked background carries $V_A - v_h$, and the homologous half
>   is inside it. Say so in one sentence; it is what makes the equation a partition of one chromosome's
>   variance rather than two unrelated adjustments.
>
> **Use $v_h$ throughout, not $v_i/2$.** Define $v_i = V_A f_i$ and $v_h = v_i/2$ once, then write the
> exponent as $\exp(-\kappa\,\overline{Q^2}_i\,v_h)$ and the denominator as $1 + 4\kappa(V_A - v_h)$.
> The existing equations spell out $v_i/2$ in five places; that is the notation drift T4 was written to
> end.
>
> **It must carry:**
>
> 1. The partition: $V_A$ apportioned among chromosomes by functional target size, $v_i = V_A f_i$;
>    then $v_h = v_i/2$ on the focal haplotype, with the remainder in the unlinked background.
> 2. Why the two components combine multiplicatively and in different functional forms — the linked
>    component as a product of survival probabilities along the map, the unlinked component retaining
>    the Robertson geometric series of `unlinked_mating` — under the stated approximation that
>    cross-chromosomal interference is negligible.
> 3. The displayed combined result, keeping the label `total_red`.
> 4. $\Omega_i$, the relative linkage effect, with label `linked_penalty`, and the subtlety worth
>    keeping: its second factor always exceeds one, because moving $v_h$ out of the unlinked background
>    slightly relieves genome-wide interference, so $\Omega_i$ is the balance between minor global
>    relief and local interference (Charlesworth et al. 1993).
> 5. The length-weighted genome-wide expectation, and $\overline{\Omega}$ as the length-weighted mean
>    of $\Omega_i$. State plainly what $\overline{\Omega} = 1$ would mean. **End the subsection on
>    $\overline{\Omega}$** — it is the quantity the Results section reports.
> 6. Keep the existing sentence restricting the treatment to autosomes and deferring sex chromosomes to
>    the Discussion.
>
> **Length: 300–360 words plus the four equations.** The existing subsection runs near 700. T3 and T4
> both overran; the section is tracked against ~2,500 words and this is where the slack is.
>
> **Cut.** The restatement of $\pi = 4N_e\mu$ — T1 established it. "Our theoretical framework directly
> predicts $N_e$, from which neutral diversity can be inferred" and any similar self-reference to the
> framework. The long final sentence of the $\Omega_i$ paragraph can lose about half its length without
> losing the idea.
>
> **Fix while you are here.** The subsection cites "Matheson and Masel 2024"; elsewhere the manuscript
> cites Matheson and Masel 2025. Use 2025 and flag it `% UNVERIFIED:` if you cannot confirm the year.
>
> **Flag, do not resolve.** The text says $f_i$ is the fraction of total functional sequence, while
> §Methods defines $\hat f_i = G_i/G_{\text{total}}$ from annotated gene counts. These are different
> quantities. Write T5 using the functional-sequence definition and note the discrepancy in your
> return; it is a Methods fix, not a T5 fix. Likewise the clause promising the assumption is "relaxed
> by incorporating conserved non-coding elements" — say it only if you can point to where that is done.
>
> **Forbidden.** Jensen or oligogenic architecture (T6). $V_{A,\max}$ (T7). $U_d$, $s^*$ or
> mutation–selection–drift (T8). Any empirical magnitude, species value, or verdict.
>
> **Register.** Functional and declarative; equations carry the load. Open on substance.
>
> Do not edit any file. Return: the prose and equations; the word count; confirmation that
> `\label{variance_partitioning}` is present, that $v_h = v_i/2$ is stated once, and that no bare
> $v_i/2$ remains in any equation; and any discrepancy you were told to flag rather than fix.

## Theory pass — T4 (use a FRESH session)

> You are writing one subsection of the Theory and Model section of a manuscript targeting GENETICS
> (GSA). Write **T4 only**. It is the most technical subsection in the paper.
>
> Read, in this order:
>
> 1. `manuscript/scratch.tex` — read all of §Theory and Model. **T1, T2 and T3 are written and precede
>    T4.** T4 replaces "Integration of Linked Constraint Across the Genetic Map". **Appendix C** is
>    authoritative for the integration and must not be reproduced.
> 2. `manuscript/theory_outline.md` — T4 is specified there; the instructions below take precedence.
> 3. `walid_authorial_style_guide.md` — sentence construction and diction; Appendix for voice only.
> 4. `CLAUDE.md` §*Project framing* — current as of commit `6f9721e`.
>
> **What precedes T4 and must not be repeated:** $V_A$'s definition and the $N_{eV} = N_{eC}$ bridge
> (T1); the derivation of $Q = \sum_t (1/2)^t = 2$ and hence $Q^2 = 4$ (T1); the Wright–Fisher benchmark
> and the Robertson mechanism (T2); `unlinked_baseline` and its scope condition (T2); $\kappa(\alpha)$,
> both models, and `unlinked_mating` (T3).
>
> **Two obligations T4 inherits.**
>
> - T2 forward-references `\autoref{sec:linkage}`, which currently resolves to nothing. **Put
>   `\label{sec:linkage}` on this subsection.**
> - T2 promised that everything from here on needs stationarity assumptions it did not need. **T4
>   discharges that promise**, via the survival parameter. Make it read as the discharge of a promise,
>   not as a fresh caveat.
>
> **It must carry:**
>
> 1. $Q$ generalized. T1 derived it under free assortment; present $Q$ here as the temporal scaling
>    factor summing the per-generation covariance between a neutral locus and its selected background,
>    weighted by the joint survival of the physical association and the selective variance, giving
>    $N_e/N = 1/(1+Q^2V_A)$ — of which T1's $Q^2 = 4$ is the free-recombination limit. **Do not
>    re-derive $Q^2 = 4$.**
> 2. The survival parameter $Z = 1 - V_m/V_A$, and that defining it presupposes a stationary selected
>    background — satisfied under mutation–selection–drift balance, violated by episodic sweeps
>    (Barton 2000). One clause that under House-of-Cards balance $V_m/V_A \approx s$ and so
>    $Z \approx 1-s$, with a forward reference to the mutation–selection–drift subsection. **Do not
>    derive House of Cards here.**
> 3. The Haldane mapping $r(\ell) = \tfrac12(1-e^{-2\ell})$ and why not the linear approximation: the
>    integration runs over whole chromosomes, many exceeding 0.5 M, where a linear map inflates the
>    contribution of distant sites; Haldane saturates correctly at $r \to 1/2$.
> 4. The joint single-generation survival $(1-r(\ell))Z$, the geometric sum, the position-specific
>    profile $Q^2(y)$, and the chromosome-average $\overline{Q^2}_{\text{linked}}$ reduced to a single
>    integral over pairwise distances. **State that this integral is evaluated numerically for each
>    chromosome.** The closed form under the linear approximation is in **Appendix C** — a validation
>    check only. Cite Appendix C, not Appendix A.
> 5. **The haplotype variance, with its own symbol.** Write the chromosome-level reduction as
>    $\exp(-\kappa\,\overline{Q^2}_{\text{linked}}\,v_h)$, where $v_h$ is the selective variance
>    residing on the **focal haplotype**. Justify it here, because it is a fact about linkage and not
>    about the partition: a focal neutral allele is physically linked only to selected loci on its own
>    haplotype, and associations with the homologous background arise only through recombination.
>    Buffalo and Kern (2024) put it directly — only half the fitness variation in a diploid can stay
>    associated with a neutral allele across generations. **One sentence on the difference in
>    treatment, as a modelling choice and not a claim of superiority:** they neglect the homologous
>    ($Q''$) associations, whereas here that variance is reassigned to the unlinked background rather
>    than dropped. **Defer the value of $v_h$ to T5**, which supplies $v_h = v_i/2$ with $v_i = V_A f_i$
>    the diploid-chromosome variance. Do not write $v_i$ or $v_i/2$ in this subsection.
> 6. The limits table: $\overline{Q^2} \to (1-Z)^{-2}$ as $M \to 0$ and $(1-Z/2)^{-2}$ as
>    $M \to \infty$, under strong ($Z = 1-s$) and weak ($Z \to 1$) selection, with the resulting local
>    $N_e/N$. Keep the existing table; update its notation to $v_h$.
> 7. The asymmetry the table establishes, in two sentences: linked interference is sensitive to the
>    strength of purifying selection on short chromosomes and converges toward the Robertson baseline
>    on long ones. One sentence that avian microchromosomes fall below the saturation scale — **and no
>    stronger claim**, because the analysis pipeline currently applies a 20 Mb chromosome filter that
>    excludes them. Do not assert that microchromosomes drive the result.
>
> **Length: 400–460 words plus the table.** T3 came in near 400 against a 250 budget; the section is
> tracked against ~2,500 words and T4 is the last place that can absorb overrun.
>
> **Forbidden.** Reproducing Appendix C's integration. The partition $v_i = V_A f_i$, $\Omega_i$, or
> genome-wide aggregation (T5). Jensen or oligogenic architecture (T6). $V_{A,\max}$ (T7). $U_d$,
> $s^*$, or the House-of-Cards derivation (T8). Any empirical magnitude, species value, or verdict.
>
> **Register.** Functional and declarative; equations carry the load. Announce each assumption where it
> is used. Open on substance, not on a statement of intent.
>
> Do not edit any file. Return: the prose and the table; the word count; what you referenced from
> T1–T3 and how; every forward reference you created with the label it needs; and confirmation that
> `\label{sec:linkage}` is present and that $v_h$ appears without $v_i$.

## Theory pass — T1 (use a FRESH session)

> You are writing one subsection of the Theory and Model section of a manuscript targeting GENETICS
> (GSA). Write **T1 only**.
>
> Read, in this order:
>
> 1. `manuscript/theory_outline.md` — the section outline. **T1 is specified there;** read the whole
>    file so you know what the eight subsections after it will carry, and do not write any of it.
> 2. `manuscript/scratch.tex` §Theory and Model — authoritative for every equation and derivation in
>    this paper. T1 is new and sits before its current first subsection.
> 3. `walid_authorial_style_guide.md` — sentence construction and diction. Mine its Appendix for voice
>    only; four of its reference sentences assert retired claims.
> 4. The *Notation* and *Scope conditions* subsections of *Project framing* in `CLAUDE.md` — binding on
>    every symbol T1 defines.
>
> **T1's job.** Orient a reader who must hold two independent equilibrium arguments, and fix notation
> once so the eight subsections after it can be terse. It is the only orienting subsection in the
> section; everything after it opens straight into derivation.
>
> **It must carry, in this order:**
>
> 1. $V_A$ defined as additive genetic variance in relative fitness at $\bar w = 1$, equivalently
>    Santiago and Caballero's $C^2$.
> 2. That both arguments developed below require the **long-run equilibrium** value of that quantity,
>    and why each does: the coalescent argument needs it sustained while $\pi$ approaches a new
>    equilibrium, and mutation–selection–drift balance is an equilibrium statement.
> 3. **The two persistence windows, kept distinct.** $Q = 2$ requires the sign of the selective
>    advantage to persist only about two generations; $\pi$ reaching a new equilibrium requires about
>    $4N_e$. This is the only place in the paper they are contrasted.
> 4. **The crossing, marked explicitly.** The derivations below produce a *variance* effective size — a
>    per-generation statement about family-size variance — whereas $\pi$ measures a *coalescent*
>    effective size, $\pi = 4N_{eC}\mu$. Name both, and say they are equated under long-run
>    equilibrium. Two ratios in this literature are both written $N_e/N$ and this paper depends on
>    keeping them apart.
> 5. **A compact notation table**, nine rows: $N$ (breeding adults), $N_c$ (total census), $N_{eV}$,
>    $N_{eC}$, $\pi$, $\mu$, $\delta$, $V_A$, $\kappa$. Symbol, meaning, one line each.
>
> **Length: 180–230 words of prose, plus the table.**
>
> **Forbidden.** Any derivation — T2 onward do that. Any result, magnitude, or verdict. Any motivation
> or restatement of why the question matters; the Introduction did that and repeating it is the
> section's most likely failure. The functional form of $\kappa(\alpha)$ (T3), $Q^2$ or $Z$ (T4),
> $V_{A,\max}$ (T7), or $U_d$ and $s$ (T8) — T1 may name $\kappa$ in the table as a mating-system
> scalar bounded in $[1,2]$ and no more.
>
> **Register.** Functional and declarative. Equations and the table carry the load; prose is short.
> Announce assumptions plainly at the point of use. No rhetorical closing sentence — the subsection
> ends when the notation is fixed.
>
> Do not edit any file. Return: the prose and the table; then the word count; then a list of every
> symbol T1 defines, so it can be checked that nothing is redefined downstream.

## Revision pass, one-shot — the paste block (use a FRESH session)

> You are writing the Introduction of a manuscript targeting GENETICS (GSA). Write all five
> paragraphs in one pass.
>
> Read, in this order:
>
> 1. `manuscript/intro_revision_directive.md` — **v3, the operative document.** Part A is the one rule
>    and the ledger of what counts as established background versus what this paper produced; Part B
>    register; Part C the five paragraph specifications with word budgets; Part D approved sentences
>    available for reuse; Part E the checks; Part F where excluded material lives. **If you find
>    yourself reasoning from v1 or v2, you have misread it** — v3 is calibrated to a published GENETICS
>    theory paper and is far more restrictive than either.
> 2. `manuscript/intro_outline.md` — the rationale for that architecture, including what the GENETICS
>    exemplar does structurally. Read it for calibration, not for instructions.
> 3. `walid_authorial_style_guide.md` — sentence construction and diction. Mine its Appendix for voice
>    only; four of its reference sentences assert claims this project has retired.
> 4. The *Project framing* section of `CLAUDE.md` — governs every claim.
>
> Also available: `manuscript/intro_draft_v1.md` holds an earlier six-paragraph draft — **a quarry for
> approved sentences, per Part D, not a template to compress.** `manuscript/intro_revision_log.md`
> lists the defects found in it. §1 of `manuscript/redraft_framing.md` holds the kill list.
> `manuscript/scratch.tex` holds the rest of the manuscript — its Theory, Methods and Appendices are
> authoritative for every equation; its current Introduction is stale, so ignore it.
>
> Five constraints override any local judgment about what reads well:
>
> - **Five paragraphs, 650–800 words**, to the per-paragraph budgets in Part C. Budget above 650 buys
>   reader orientation only, never additional claims.
> - **Nothing this paper produced appears before P5**, and in P5 only in words. No $\kappa$, no
>   $\overline{Q^2}$, no $V_{A,\max}$ — not the symbols, not the formulae.
> - **Two numerals of substance in the whole Introduction:** $Q^2 = 4$, which is Santiago and
>   Caballero's, and one parenthetical of order 0.1, which is Bonnet et al.'s. Nothing else.
> - **No verdicts anywhere.** The Introduction ends on what the paper evaluates. No synonym of "too
>   small" or "too large".
> - **$N_e/N = 1/(1+Q^2V_A)$ is displayed and numbered in P2**, and the remark about boundedness is
>   written in reciprocal form, $N/N_e = 1 + Q^2V_A$.
>
> Do not edit any file. Return, in this order: the five paragraphs; then Part E's seven checks answered
> explicitly, one line each, with the total and per-paragraph word counts; then anything the directive
> excluded that you judge should stay, with your reason — or "none".

**Per-paragraph alternative,** if incremental work is wanted instead:

## Revision pass, incremental — the paste block (use a FRESH session)

> You are revising the Introduction of a manuscript targeting GENETICS (GSA). It has been drafted, and
> it is accurate and well-voiced, but it reports the project rather than arguing for it. Your job is to
> cut and reshape that draft, not to write a new one.
>
> Read, in this order:
>
> 1. `manuscript/intro_revision_directive.md` — the operative instructions. Part A says what is wrong,
>    Part B fixes which numbers may appear, Part C gives per-paragraph instructions, Part D gives the
>    checks to run at the end.
> 2. `manuscript/intro_draft_v1.md` — the six drafted paragraphs you are revising.
> 3. `walid_authorial_style_guide.md` — diction, sentence structure, paragraph rhythm. Mine its
>    Appendix for voice only; four of its reference sentences assert claims this project has retired.
> 4. The *Project framing* section of `CLAUDE.md` — governs every claim and number.
>
> Also available: `manuscript/intro_revision_log.md` records the specific defects found in each drafted
> paragraph, and §1 of `manuscript/redraft_framing.md` holds the kill list. `manuscript/scratch.tex`
> holds the rest of the manuscript — its Theory, Methods and Appendices are authoritative for every
> equation, and its current Introduction is stale, so ignore it.
>
> Six paragraphs and about 1,450 words become five paragraphs and 750–850 words. The work is mostly
> subtractive. Where the directive says cut, cut — do not compress and retain.
>
> Work one paragraph at a time. Draft only the paragraph I name. Do not edit any file. Return the
> prose in chat, then three lines:
>
> - word count
> - the obligation this paragraph leaves for the next one, in one sentence
> - anything the directive told you to cut that you judged should stay, and why — or "none"
>
> Start with P1.

**Per-paragraph follow-up:** `Draft P[n] per Part C. The previous paragraph ended: "[last sentence]".
Amendments to the directive: [none | ...].`

## Per-paragraph request template

> Draft brief `[ID]`. The previous paragraph ended: "`[last sentence]`". Amendments to the brief:
> `[none | ...]`.

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

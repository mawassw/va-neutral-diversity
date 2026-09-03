# Authorial Style Guide: Walid Mawass — Scientific Writing for Faculty Applications

## Purpose

This document encodes the rules and heuristics for writing in Walid Mawass's authorial voice and for de-AI-ifying prose in his research materials. It is written for use by any agent or editor working on Walid's faculty application documents — research statements, cover letters, and related materials — without requiring access to prior conversation context.

The rules come from three sources:
1. **Gopen and Swan** — principles from "The Science of Scientific Writing" (American Scientist, 1990)
2. **The Cut and the Grain** — economy and flow principles applied at the sentence level
3. **Direct corpus analysis** — comparing Walid's confirmed human-written paragraphs (Intro and Past Work sections of his research statement, scored 100% human by AI detectors) against AI-flagged prose in the same document, and extracting what distinguishes them

---

## Part 1: Gopen and Swan — Structural Sentence Rules

These rules govern where information sits within a sentence. Violations are the most common source of unclear scientific prose.

### 1.1 Stress Position
The end of a sentence is where readers place the most emphasis. Put the **new, important, or surprising information** there — never end on a filler phrase.

- **Wrong:** "The bias is worst where structure is strongest in terms of detection difficulty."
- **Right:** "The bias is worst not when structure is strongest but **where structure first becomes detectable.**"

Test: Cover the last five words of each sentence. If nothing is lost, the stress position is wasted.

### 1.2 Topic Position
The beginning of a sentence is where readers expect **old, contextualizing information** that connects backward. The topic position links to what came before; the stress position introduces what comes next.

- The topic position should almost always echo a key word or concept from the previous sentence.
- When the topic position introduces something entirely new, readers feel disoriented.

**Example of correct topic-position chaining:**
> "Neutral diversity **sets an upper limit** on how much of a population's fitness variance can be heritable and consistently directional. **Linked selection creates this limit** as fitness variance depletes the neutral diversity near it. **The limit constrains** the autocovariance of relative fitness across generations..."

Each sentence opens by picking up the key term from the previous sentence's stress position.

### 1.3 Subject–Verb Proximity
Do not bury the verb. A reader needs the subject and verb close together to hold the sentence in working memory.

- **Wrong:** "The deficit of beneficials, which outweighs the accumulation of load at the population size where gains and losses in fitness balance, can drive collapse."
- **Right:** "The deficit of beneficials **outweighs** the accumulation of load at the population size where gains and losses in fitness balance."

### 1.4 Action in the Verb
The main action of a sentence should live in the **verb**, not in a nominalized noun.

- **Wrong:** "There was a depletion of neutral diversity by fitness variance." (action = depletion, buried in noun)
- **Right:** "Fitness variance **depletes** neutral diversity." (action = depletes, in the verb)

Watch for: *-tion*, *-ment*, *-ance*, *-ence* nominalizations that replace active verbs. Common offenders: *estimation*, *correction*, *accumulation*, *identification*.

### 1.5 One Claim Per Clause
Each subordinate clause should carry at most one factual, precise claim. Multiple claims in one clause force the reader to hold too many things at once and create the appearance of hedging.

When two claims are genuinely inseparable (mechanism + consequence), they may share a sentence — but they must be in **logically ordered clauses**: cause before effect, old before new.

### 1.6 Old Before New
Within a sentence, present familiar ground before new information. This applies at every level: clause order within a sentence, sentence order within a paragraph, paragraph order within a section.

---

## Part 2: The Cut and the Grain

### 2.1 The Cut — Economy
Every word must earn its place. Apply these tests in order:

1. **Does cutting this word change the meaning?** If no, cut it.
2. **Does cutting this phrase break the logical chain?** If no, cut it.
3. **Is this word doing work that the surrounding words already do?** If yes, cut it.

Common cuttable phrases:
- "In order to" → "to"
- "due to the fact that" → "because"
- "at this point in time" → "now"
- "the fact that X" → "that X" or just the claim
- "both X and Y" when the "both" is implied → "X and Y"
- "in the meantime" when temporal sequence is already clear → cut
- "in other words" when the restatement adds nothing new → cut or replace with the new content
- "It is worth noting that" → just state it
- "This [aim/result/finding] [shows/demonstrates/establishes] X" → state X directly

### 2.2 The Grain — Logical Flow
Writing "with the grain" means each sentence creates a slot — an expectation — that the next sentence fills. The reader should never have to backtrack.

Test: After reading each sentence, ask: what question does this sentence make me want answered? The next sentence should answer it.

**Slot-and-fill example (from Walid's confirmed human text):**
> "The bias is worst not when structure is strongest but **where structure first becomes detectable.**" [Slot: what is special about that regime?]
> "At this point, the confounded structure is strong enough to distort associations, too weak for the sample principal components to capture it." [Fills the slot.]

If a sentence creates a slot and the next sentence fills a different slot, insert a bridge sentence or reorder.

---

## Part 3: De-AI-ification Checklist

Run every draft through these checks in order of priority. Each is a pattern that AI generates reliably and that Walid's human-written text avoids.

### Priority 1 — Sequential "I will" sentences
**The AI pattern:** Multiple standalone future-plan sentences in sequence.
> "I will build a model in which... I will apply the same partition to... I will produce a precise statement of..."

**Why it reads as AI:** Each sentence announces a method as a separate plan. Human scientific writers state a result or prediction first and embed the method as what the test requires.

**The fix:** Predict first; method becomes what the prediction demands or how you will test it — as a subordinate clause, relative clause, or participial phrase.

- "I will build a model in which X... I predict Y" → "Y is the prediction; testing it requires a model in which X..."
- "I will apply X to Y. I will produce Z." → "Applying X to Y will produce Z."
- "I will test whether A... I will model B..." → "A should follow from B, which I will test by modeling..."

**PW reference:** "The deficit of beneficials outweighs the accumulation of load at the population size where gains and losses in fitness balance, **which I established by applying** a perturbation analysis around that point and confirming it in whole genome simulations." — method in a relative clause, result in the main clause.

### Priority 2 — Signpost openers
**The AI pattern:** Sentences that announce a claim is coming rather than making it.
> "The key prediction is that..."
> "The critical prediction involves..."
> "The main outcome is a precise statement of..."
> "The comparative prediction is temporal, not merely cross-sectional:"
> "Two data types can test the prediction:"

**Why it reads as AI:** A table-of-contents entry in place of a sentence. The announcement wastes a sentence; the content should be the sentence.

**The fix:** Cut the signpost and state the claim directly. Move any methodological qualification to a dash-appositive at the end.

- "The key prediction is that X" → "X"
- "The comparative prediction is temporal, not merely cross-sectional: X should predict Y" → "X, measured immediately after a decline, should predict Y — a temporal claim, not merely an associational one."

### Priority 3 — "A population..." abstract-subject triplets
**The AI pattern:** Two or three consecutive sentences opening with "A [adjective] population..."
> "A population adapting to changing conditions is under consistent directional selection..."
> "A continuously adapting population always runs a compensation deficit..."
> "A population at its optimum accrues a larger deficit..."

**Why it reads as AI:** AI generates abstractions systematically. Human scientific writers ground abstractions in mechanisms or named observations. Three consecutive abstract-entity openers in a paragraph is a reliable AI signal.

**The fix:** Start at least one sentence from the mechanism rather than the actor. Change "A population adapting... is under directional selection, generating sweeps" → "Consistent directional selection in an adapting population generates sweeps..."

### Priority 4 — Perfect parallel pairs
**The AI pattern:** Two sentences with identical grammatical structure presenting a contrast.
> "A continuously adapting population always runs a compensation deficit and offsets it. A population at its optimum accrues a larger deficit — yet appears the healthier of the two by trait tracking alone."

**Why it reads as AI:** Perfectly parallel contrasts are AI's preferred output for presenting two-sided arguments. Human writers break the symmetry.

**The fix:** Merge into one sentence using a semicolon and a pronoun for the second subject, or fold one into a subordinate clause of the other.
- "A continuously adapting population always runs a compensation deficit and offsets it; one at its optimum accrues a larger deficit while appearing the healthier by trait tracking alone."

### Priority 5 — "They do so because..." repair connective
**The AI pattern:** A sentence that describes an action, followed by a repair sentence explaining why.
> "These sweeps concurrently offset the accumulating load. They do so because each mutation carries both a trait effect and a function-degrading effect."

**Why it reads as AI:** "They do so because" is a constructed answer to an imaginary reader's "why?" question. Walid's prose never uses this connective. The PW text handles causality by embedding "because" in the original sentence.

**The fix:** Collapse into one sentence with an embedded "because" clause.
- → "These sweeps concurrently offset the accumulating load because each mutation couples a trait effect to a function-degrading one."

### Priority 6 — Wrap-up closing sentences
**The AI pattern:** An aim or section closes by announcing what it accomplishes.
> "This aim identifies which populations carry that gap."
> "This aim supplies what practitioners should measure..."
> "This result demonstrates the value of..."

**Why it reads as AI:** Walid's PW sections close on **consequence statements** or **forward-pointing observations**, not on announcements of what the work does.

**The fix:** Replace with a declarative consequence, a sharp implication, or a question that pulls forward.

- "This aim identifies which populations carry that gap." → "The populations this gap is widest in are the ones currently classified as stable."
- "This aim supplies what practitioners should measure to know whether added variation will align with selection or work against it." → "Genetic rescue and assisted gene flow are already underway; what practitioners need to measure is whether added variation aligns with selection or works against it."

**PW reference:** "Aim 1 asks how far beneficial supply can fall short before the deficit becomes detectable." — the closing sentence of Mutational Drought names a question, not an accomplishment.

### Additional checks (lower priority but present in Walid's text)

**Evaluative passive:** "is positioned for", "are ideally suited to", "is well-suited for" — AI evaluates its own work; Walid states what the work is and lets the fit be inferred, or uses an active construction: "NSF DEB's Evolutionary Processes program is the natural home for this work."

**Uniform sentence length:** If three or more consecutive sentences are within 4 words of each other in length, the paragraph needs a short punch or one long dense sentence to vary the rhythm.

**Abstract categories over named systems:** "crash-documented monitoring programs" → name one. "Wild vertebrate populations" → name the systems if known. Walid names systems whenever he can: "Soay sheep on St Kilda, Alberta bighorn sheep... the historical French-Canadian populations."

---

## Part 4: Walid's Voice — Positive Patterns

These are features Walid's human-scored text exhibits reliably. Use them when drafting or revising.

### 4.1 The naming sentence
Walid names things with a short sentence that arrives after the argument has built up enough to make the name feel earned. Structure: long setup → short punch with the name.

> "Mutational meltdown is considered the primary genetic driver of extinction in small populations. **I identified a second driver, mutational drought.**"

> "Selection was measurable, the trait was heritable, a response occurred, and it did not recur — **the paradox of stasis.**"

The name arrives as an appositive after a dash, or as the entire predicate of a short sentence. The name is introduced once and used throughout. When a key concept in an aim has been described but not named, introduce the name this way.

### 4.2 The "not X but Y" inversion
Walid frequently states a contrast by negating the expected claim before asserting the actual one. This is different from "X; however, Y" — the negation and the assertion are in the same sentence.

> "The bias is worst **not** when structure is strongest **but** where structure first becomes detectable."
> "The usual explanations... explain why the predictions fail **without questioning the measure itself.**"
> "pedigree size and depth which positively affect **precision but not accuracy** of these estimates"

### 4.3 Mechanism-first openers
When making a claim about what a mechanism does to a population or system, start with the mechanism, not the population.

- Not: "A population adapting to changing conditions is under consistent directional selection, resulting in sweeps."
- Yes: "Consistent directional selection in an adapting population generates sweeps."
- Yes: "Linked selection creates this limit as fitness variance depletes the neutral diversity near it."
- Yes: "Drift carries rare alleles toward intermediate frequency where variance from dominance and epistasis appears as additive."

### 4.4 Adversative "Yet" at sentence start
Walid opens counterexample sentences with "Yet" — not "However" at sentence start, not "Nevertheless." "Yet" is short, punchy, and followed immediately by the contradiction.

> "**Yet** populations with plenty of it, as diverse as island birds, wild sheep, and laboratory fly populations, exhibit stasis or go extinct."
> "**Yet** two populations with identical additive variance in fitness can differ in every one of these factors."

### 4.5 "Because" at sentence start for causal chains
When a causal statement is important enough to merit its own sentence, Walid opens with "Because" rather than embedding the cause as a subordinate clause.

> "**Because** mutations arise in individuals, a shrinking population's total mutational supply diminishes each generation."

This gives the cause more weight than "since" or a relative clause.

### 4.6 Colon-delivered definitions and lists
Definitions arrive after a colon, immediately. Lists arrive after a colon with no preamble. The colon is the only punctuation Walid uses to announce content — everything else is just stated.

> "Both processes draw from the same finite budget: **reproductive excess.**"
> "Demographic bottlenecks modulate these factors in specific ways: **selection becomes inefficient... drift pushes... and trait correlations are realigned.**"

### 4.7 The participial opener for methods
When a method must be stated (especially in future objectives), Walid uses a participial phrase that makes the method the agent of the result, not the writer.

> "**Adding recombination maps and functional target sizes** at a chromosome level only tightens the discrepancy."
> "**Applying the same partition** to the long-term vertebrate records... will produce a precise statement of when..."

This removes "I will" and embeds the method into the consequence it produces.

### 4.8 The compound short sentence for listing evidence
When multiple parallel observations support one conclusion, Walid lists them in accelerating short clauses separated by commas, then delivers the named conclusion after a dash.

> "Selection was measurable, the trait was heritable, a response occurred, and it did not recur — the paradox of stasis."

The rhythm accelerates (short clauses → shorter clauses → longer one) and the dash-landing crystallizes the argument.

### 4.9 Specificity: numbers and named systems
Walid is specific when the specificity is meaningful:
- Exact counts: "the **19** wild vertebrate populations"
- Exact percentages: "approximately **38%** of the total additive genetic variance"
- Orders of magnitude: "**two to three orders of magnitude** above the upper limit"
- Named systems: "**Soay sheep on St Kilda**, **Alberta bighorn sheep**, and the historical French-Canadian populations"

Abstract categories ("wild vertebrate populations", "crash-documented programs") are used only when no named system is yet available. Named systems are always preferred.

### 4.10 The forward pointer as a closing move
Walid closes past-work sections not with a summary but with a single sentence that names what the observation demands — usually naming a future aim.

> "**Aim 1 asks** how far beneficial supply can fall short before the deficit becomes detectable."
> "**That is the observation Aim 2 explains.**"
> "**Aim 3 uses the same mathematical framework** to ask when a small population's heritable variation stops lining up with selection."

These are short (8-15 words), name an aim explicitly, and are always a question or a pointer — never a summary of what was just said.

---

## Part 5: Sentence Openers — Permitted and Flagged

### Permitted openers observed in Walid's human-scored text
These opener types appear frequently and read as natural in his voice:

| Type | Example |
|---|---|
| Participial | "Identifying which populations...", "Estimating this quantity...", "Adding recombination maps..." |
| Adversative "Yet" | "Yet populations with plenty of it...", "Yet two populations..." |
| Causal "Because" | "Because mutations arise in individuals..." |
| Demonstrative + pivot | "That competition implies...", "That puts the implied variances...", "That is the observation..." |
| Mechanism as subject | "Neutral diversity sets...", "Linked selection creates...", "Drift carries...", "Mutational meltdown is..." |
| Prepositional context | "Under meltdown...", "Under drought...", "In île aux Coudres...", "At this point..." |
| Negative quantifier | "None of these populations were shrinking..." |
| Personal + past | "I found that...", "I identified...", "I reconstructed...", "I investigated..." |
| Ordinal adverb | "Ordinarily, this load is prevented..." |
| Contrastive | "In contrast, where selection on the trait becomes stabilizing..." |
| "Even" for robustness | "Even assuming independent assortment, and requiring no linkage map..." |
| Personal + purpose | "To check the sensitivity of these estimates..." |

### Flagged opener patterns — AI signals
Avoid these or revise them:

| Type | Example | Fix |
|---|---|---|
| Indefinite abstract subject triplet | "A population adapting... / A continuously adapting population... / A population at its optimum..." | Break with mechanism-first opener |
| Signpost announcement | "The key prediction is that...", "The critical prediction involves..." | State the claim directly |
| Repair connective | "They do so because..." | Collapse into previous sentence |
| Evaluative passive | "X is well positioned for...", "X are ideally suited to..." | State what X is; let fit be inferred |
| Wrap-up announcement | "This aim identifies/supplies/demonstrates X" | Replace with consequence or forward pointer |
| Sequential "I will" | "I will build... I will apply... I will produce..." | Embed methods; predict first |

---

## Part 6: Paragraph Rhythm

Walid's human-scored paragraphs have variable sentence length. The signature rhythm of his strongest paragraphs:

**Short opening thesis (8–16 words)** → **Long dense mechanism sentence (25–40 words)** → **Short consequence or pivot (6–12 words)** → **Medium elaboration (15–25 words)** → **Short punch or forward pointer (7–15 words)**

**Reference paragraph (Mutational Drought — confirmed human):**
1. "Mutational meltdown is considered the primary genetic driver of extinction in small populations." [15 words]
2. "I identified a second driver, mutational drought." [7 words — SHORT PUNCH]
3. "Under meltdown, deleterious mutations accumulate faster than selection can purge them." [11 words]
4. "Because mutations arise in individuals, a shrinking population's total mutational supply diminishes each generation." [15 words]
5. "Under drought, too few beneficial mutations appear for a population that needs them for two things at once: offsetting the deleterious load it carries and keeping pace with a changing environment." [33 words — LONG DENSE]
6. "The deficit of beneficials outweighs the accumulation of load at the population size where gains and losses in fitness balance, which I established by applying a perturbation analysis around that point and confirming it in whole genome simulations." [40 words — LONGEST]
7. "Populations that look genetically healthy by the standards of meltdown can therefore be on the brink of collapse, because of the lack of new beneficial mutations rather than an accumulation of bad ones." [34 words]
8. "Aim 1 asks how far beneficial supply can fall short before the deficit becomes detectable." [16 words — FORWARD POINTER]

**Diagnostic:** If any paragraph has three or more consecutive sentences within 4 words of each other in length, it lacks rhythm and needs a short punch or one long dense sentence inserted.

---

## Part 7: What to Preserve — Do Not Change

These are features that appear unusual or could be "corrected" by a naive editor but are deliberate in Walid's voice:

1. **"Yet" at sentence start** — not a grammatical error; a deliberate adversative move.
2. **"Because" at sentence start** — not a fragment; gives the cause its own sentence weight.
3. **Dash-appositives for naming** — "I identified a second driver, mutational drought." — the comma-appositive structure is intentional; do not rewrite as "I identified a second driver: mutational drought."
4. **Colon after complete clause** — "Both processes draw from the same finite budget: reproductive excess." — the colon delivers a one-word or short-phrase definition. Do not expand the predicate.
5. **Short closing sentences as forward pointers** — "That is the observation Aim 2 explains." — do not pad.
6. **"However" mid-sentence, not at start** — "This limit however applies only to the directional component" — Walid places "however" after the subject, not at sentence start, when he wants to maintain topic-position continuity.
7. **Informal precision markers** — "too few", "barely move", "only once it is too late to act" — these are not loose language; they are precise informal registers used at moments of consequence.

---

## Quick Reference: De-AI-ification Decision Tree

When a sentence or paragraph reads as AI-generated, diagnose it in this order:

```
1. Does it start with "I will"? → Embed method into prediction.
2. Does it start with "The [key/critical/main] [prediction/outcome/finding] is/involves"? → Cut opener, state directly.
3. Is this the second or third consecutive sentence starting "A [adjective] population"? → Restart from mechanism.
4. Are two adjacent sentences grammatically parallel with the same subject structure? → Merge with semicolon + pronoun.
5. Does the sentence start with "They do so because"? → Collapse into previous sentence.
6. Does the closing sentence say "This aim/work/result [does/supplies/identifies] X"? → Replace with consequence or pointer.
7. Is there a run of 3+ sentences of similar length? → Add a short punch or one long dense sentence.
8. Are mechanisms described in abstract categories when named systems exist? → Name the system.
```

---

## Appendix: Confirmed Human-Written Reference Sentences

These sentences scored 100% human. Use them as benchmarks when evaluating tone and register. All are from the Intro or Past Work sections of the research statement (`research_statement_3pages.docx`).

> "The features that decide the outcome are precisely the ones a single number strips away."

> "I identified a second driver, mutational drought."

> "Because mutations arise in individuals, a shrinking population's total mutational supply diminishes each generation."

> "Populations that look genetically healthy by the standards of meltdown can therefore be on the brink of collapse, because of the lack of new beneficial mutations rather than an accumulation of bad ones."

> "Neutral diversity sets an upper limit on how much of a population's fitness variance can be heritable and consistently directional."

> "Even assuming independent assortment, and requiring no linkage map, no annotation, and no stationarity assumption, the upper limit on directional fitness variance falls below what the 19 wild vertebrate populations' pedigree estimates require."

> "The bias is worst not when structure is strongest but where structure first becomes detectable."

> "Selection was measurable, the trait was heritable, a response occurred, and it did not recur — the paradox of stasis."

> "None of these populations were shrinking, so this is not an artifact of small size."

> "That is the observation Aim 2 explains."

> "Most fitness variance measured in the wild therefore cannot be the directional kind; some is not heritable, some is real but reversing, and the bound I find does not say which."

> "Adding recombination maps and functional target sizes at a chromosome level only tightens the discrepancy."

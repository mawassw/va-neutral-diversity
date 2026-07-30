---
name: signoff
description: Run the end-of-session sign-off for project#3. Use when the user is wrapping up, signing off, closing the session, or asks for a handoff — anything like "let's sign off", "/signoff", "handoff", "I'm done for today", "close this out". Records decisions and staleness into CLAUDE.md, verifies the manuscript builds, and reports git state.
---

# Sign-off — project#3

Work through the **Sign-off process** checklist in `CLAUDE.md` (repo root), in order.

Read that section now and follow it verbatim — it is the source of truth and may have been
updated since this skill was written. Do not work from memory of it.

## Why this exists

This project's durable memory is `CLAUDE.md`, not the transcript. Decisions reached in
conversation — especially framing and emphasis changes that have no artifact yet — vanish
unless written down. The checklist exists to catch exactly that.

## Non-negotiables

- **Report every item explicitly**, including ones needing no action, so the user knows they
  were checked. A silent skip is indistinguishable from a missed step.
- **Do not commit or push unless the user asks.** Item 6 is a *report*.
- **Exit code 0 is not a passing build.** Item 4 requires confirming zero
  `Citation ... undefined` in `main.log` — a missing key still produces a PDF, just a wrong one.
- **Write findings into `CLAUDE.md`, not just the chat reply.** Items 1 and 2 are the whole
  point of the process; leaving them in prose defeats it.

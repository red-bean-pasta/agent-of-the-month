---
name: scout-and-build
description: Operational rule governing agent workflow. MUST call before exploring any task or formulating plans.
---

# Scout and build

Executing without planning is bug-prone. It creates messy state. Planning before execution reduces costly corrections. 

Planning too early without context produces superficial guesses. Investigation is therefore necessarily sequential: each finding determines what to explore next.

Follow this loop:

1. Identify the current need
2. Investigate
3. Update your understanding
4. Identify the next need
5. Repeat until you have enough clarity to commit to meaningful action
6. Synthesize
7. Plan
8. Execute

If execution reveals information that invalidates a plan, revise and re-loop. Progress is an upward spiral; intermediate failures are not penalized.

Plans can be recorded under `.agents/tmp/` when useful for tracking decisions and modifications.

## Investigation

Context exploration (e.g., reading files, making tool calls) improves project understanding but consumes context window capacity and user waiting time. Excessive investigation can also dilute task focus.

**Name the intention:** For each investigation step, internally state its purpose: how it informs the next decision or action. If you cannot articulate either, stop and act on what is known. Avoid aimless repository exploration. Be specific (e.g., "Checking existing utilities before adding a parsing helper", "Checking git history for commits related to the bug"), not vague or repetitive (e.g., "Working on it", "Checking git logs"). Don't waste inference on polishing status updates.

**Don't push your luck:** Stop investigating once you can answer the prompt or concretely plan the next action, and further information is unlikely to change your decision. Don't repeatedly reread unchanged material or keep inspecting merely to find something else to inspect. Don't be paranoid.

**Favor feedback over certainty:** Follow `inspect → plan → act → observe → correct`, rather than eliminating every uncertainty before acting. Investigation has diminishing returns, and intermediate failures are ok.

**Keep the user posted:** Investigation can be lengthy and iterative. Users can lose patience. Use concise status updates as your "progress bar", particularly when findings change the plan or investigation takes longer than expected. 

### Web search 

When a task requires locally unavailable information, or involves external dependencies' bugs, quirks, limitations, or uncertain behavior, search online before improvising workarounds. Check both official documentation and third-party discussions. Never include secrets, credentials, or proprietary code in queries. After four search calls without usable results, stop searching, state what remains unknown, and choose a viable next action. 

## Making choices

A task can branch in many directions. Make routine choices after sufficient investigation and within established constraints. For remaining uncertainties:

1. Ask the user:

Ask the user freely when the question concerns:

- underspecified or contradictory prompts
- intended behavior
- user preferences
- product or design tradeoffs
- priorities
- acceptable compromises
- externally visible semantics
- irreversible or costly-to-reverse choices

Do not avoid asking useful questions merely to preserve autonomy. A brief interruption is cheaper than revising substantial work completed against wrong assumptions. User ideas, descriptions, and constraints are naturally lossy in translation, time pressure, and thought organizing. Treat underspecified requests as invitations for clarification—establish intents early.

2. Quantify confidence:

Else, after gathering enough information, quantify your confidence. Fall back to asking the user only when confidence is below 3:1 odds (one interpretation is judged three times as likely as all alternatives combined). This threshold does not replace the decision ownership distinction above.

Record your confidence and the choice you made in scratch space.

Users exercise different levels of control over their projects. For user-led projects, raise the odds to 4:1.

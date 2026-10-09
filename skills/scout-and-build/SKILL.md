---
name: scout-and-build
description: MUST use before exploring a task and formulating plans to know how to work cleanly.
---

# Scout and build

Planning before execution separates concerns and reduces costly corrections and management overhead. Planning too early produces guesses with no context.

Work in this loop:

1. Identify the current need
2. Investigate
3. Update your understanding
4. Identify the next need
5. Repeat until you know enough to make the next meaningful commitment
6. Synthesize
7. Plan
8. Execute
9. If execution reveals information that invalidates the current understanding or plan, return to investigation

Investigation is necessarily linear: each finding determines what is worth learning next. Execution is not.

A stable plan avoids repeatedly reconstructing the task.

The plan can be recorded in a file under `.agents/tmp/` so it is easier to modify and the user can trace its source.

## Investigation

Investigation improves project understanding, at the cost of context, time, and user experience. Too much investigation loses task focus. Resolve the tension with the following rules:

**Name the intention:** For EACH investigation step, INFORM the user its purpose. If a purpose cannot be named or does not help planning actions, STOP and act on what is known. This prevents aimless repository exploration and user frustration during prolonged waiting. Be specific (e.g., Checking existing utilities before adding a parsing helper, Tracing error paths), not vague (e.g., Working on it, Processing). Do not waste inference on polishing updates' wording.

**Don't push your luck:** Stop investigating once you can concretely plan the next task action and further information is unlikely to change it. Do not repeatedly reread unchanged material or continue inspecting merely to find something else to inspect.

**Expect failures:** Follow `inspect → act → observe → correct`, not `inspect → ensure everything → act → get a heuristic better chance at being correct`.

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

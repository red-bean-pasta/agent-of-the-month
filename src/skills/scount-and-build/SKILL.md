---
name: scount-and-build
description: Use before investigation, planing and editing to work cleanly.
---

# Planner

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

Once you know enough, synthesize what you have learned into a stable plan. Do not continuously reconstruct the task or continue investigating without a purpose.

The plan can be recorded in a file under `.aitmp/` so it is easier to modify and the user can trace its source.

## Investigation

Investigation improves project understanding, at the cost of context, time, and user experience. Too much investigation loses task focus. Resolve the tension with the following rules:

**Name the intention:** Before each investigation, state its purpose in a progress message: what you are trying to learn, which task or decision the information supports, and what would be enough to stop investigating.

**Don't push your luck:** Stop investigating once you can concretely plan the next action and further information is unlikely to change it.

**Expect failures:** Follow `inspect → act → observe → correct`, not `inspect → ensure everything → act → gain a better chance at being correct`.

**Scoped search:** Search symbols, likely references, dedicated utilities, focused documentation, and directly related modules. Do not tour the repository.

**Search external sources:** Use web search when the question requires external information that is unavailable in local sources. Never include secrets, credentials, or proprietary code in queries. After four search calls without usable results, stop searching, state what remains unknown, and choose a viable next action.

**Run focused experiments or tests:**


## Making choices

A nontrivial task may involve many branches and decisions.

**Ask the user:**

Ask the user freely when the question concerns:

- underspecified or contradictory prompts
- intended behavior
- user preferences
- product or design tradeoffs
- priorities
- acceptable compromises
- externally visible semantics
- irreversible or costly-to-reverse choices

Do not avoid a useful question merely to preserve autonomy. A small interruption is cheaper than completing substantial work against the wrong assumption.

**Quantify confidence:**

Agents face many branches during a task and can make often choices themselves. After gathering enough information, if the choice is not obvious, quantify your confidence. Ask the user only when confidence is below 3:1 odds: one interpretation is judged three times as likely as all alternatives combined.

Record your confidence and the choice you made in scratch space.

Users exercise different levels of control over their projects. For user-led projects, raise the threshold to 4:1 odds.

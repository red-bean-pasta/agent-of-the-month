---
name: handoff
description: Use before resuming or handing off a task or conversation.
---

# Handoff

Handoffs can lose context and continuity. Preserve information that would be expensive, risky, or impossible for the next agent to reconstruct. Preserve the reasoning, not just the conclusion.

All handoffs should be at `.agents/handoffs/<action>.md`. Action-based filenames should describe the task. No cleanup is required.

## Quick start

Each conversation or task section should preserve:

- goal
- completed phases
- what remains unresolved, blocked, or failing
- related observed facts and constraints
- decisions and their rationales
- failed approaches worth not repeating
- next concrete action
- active files, skills, and procedures relevant to the next phase

1. Identify the task being handed off.
2. Identify unfinished goals of the conversation.
3. If the conversation's goal is broader than or different from the task's goal, preserve a conversation section.
4. Preserve a task section.

Distinguish “observed”, “user-stated”, “decided”, “hypothesized”, and “unresolved” information.

Do not include information that is cheap to rediscover. Do not duplicate source artifacts; reference them instead.

Before finishing, ask yourself: “Could I pick up this handoff with no prior context?”

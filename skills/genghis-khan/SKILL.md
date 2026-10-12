---
name: genghis-khan
description: Operational rule governing subagent delegation and context insulation. MUST call before exploring any task or formulating plans.
---

# Genghis Khan

You can spawn subagents to save the active context window to: 
  - keep your "warm state"
  - preserve abstract ideas raw
  - avoid focus derailing
  - greatly delay context compaction
  - offload the clutter of output- or reasoning-heavy subtasks
  - avoid polluting the thread with failed attempts
  - improve user experience and reduce manual handoff needs

Use subagents as **tactical scouts and context sponges**: they absorb intermediate noise in an isolated sandbox and return only distilled signal. 

Delegate when a subtask:
  - Has a self-contained boundary (a specific question, isolated bug, or distinct research target).
  - Generates high intermediate output (heavy web scraping, massive compiler or test logs, broad repository grepping).
  - Explores speculative hypotheses or risky experiments that would clutter the main context if they fail.

Do not delegate simply because a task can be potentially long. **Isolation is the decisive criterion.**

Keep in the main thread when the task:
  - is the conversational base itself.
  - relies heavily on subtle conversational nuance and unwritten user preferences that are hard to brief up front.
  - is a direct 1–2 command lookup producing negligible context noise.

## Workflow

Treat each delegation as a self-contained handoff:

1. Never fork the subagent with the full conversation history. Doing so defeats context insulation and burns token budget. 
2. Provide everything necessary in the initial prompt to minimize round trips. Call handoff skill if available.
3. Use a shared temporary disk folder for large outputs.
4. Review, verify and synthesize upon return.

## Skill compatibility

Subagents inherit the workspace's skills and operational rules; a subagent should automatically follow them.

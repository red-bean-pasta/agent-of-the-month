---
name: genghis-khan
description: Operational rule governing subagent delegation and context insulation. MUST call before exploring any task when subagent feature is available.
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

Treat each delegation as a self-contained handoff:

1. Never pass the full conversation history.
2. Front-load all necessary context to minimize round trips. Use the handoff skill if available.
3. Instruct the subagent to:
   - Store large or reusable tool outputs in shared temporary folders and report their paths.
   - Return detailed, well-cited findings to spare you duplicating work.
4. Review and synthesize the results.

Subagents can increase token usage and input cache misses. This can be justified in long-running main threads. Don't overweigh these costs.

## Skill compatibility

Subagents inherit your skills and rules and can read them independently. Not all skills apply to agent-to-agent interactions. Explicitly specify which skills to bootstrap and suppress the rest.

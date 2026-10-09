---
name: regent
description: Call at every conversation start.
---

# Regent

Some skills function as rules, just like those defined in `.agents/rules/` and `AGENTS.md`. They are packaged as skills for extensibility.

You MUST read and follow such skills at conversation start, regardless of the current task. Identify them by descriptions—they usually contain terms such as "must", "operational rule", or "enforced". Their instructions remain applicable throughout the conversation. Do not wait for task-specific relevance before reading them.

---
name: regent
description: ALWAYS Call at the start of every conversation of every task.
---

# Regent

Some skills serve as operational rules, equivalent to those in `.agents/rules/` and `AGENTS.md`. They are packaged as skills for modularity and extensibility.

Identify rule skills by their descriptions. Common indicators include "must", "operational rule", and "enforced", but the description's meaning takes precedence over keyword matching.

Pay special attention to rule skills' descriptions, domains, and triggers. Do not load them all upfront defensively; premature loading clutters the context window and risks applying incompatible procedures. Instead, load a rule skill as its specific domain or task stage applies.

Common task stages:
- Turn start
- Prompt analysis
- Task exploration
- Planning
- Execution
- Verification
- Turn end

Once loaded, follow their instructions throughout the conversation.

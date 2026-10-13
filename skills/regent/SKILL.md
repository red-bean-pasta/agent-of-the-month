---
name: regent
description: ALWAYS Call at the start of every conversation of every task.
---

# Regent

Some skills serve as operational rules, equivalent to those in `.agents/rules/` and `AGENTS.md`. They are packaged as skills for modularity and extensibility.

Identify rule skills by their descriptions. Common indicators include "must", "operational rule", and "enforced", but the description's meaning takes precedence over keyword matching.

Pay special attention to rule skills' descriptions, domains, and triggers. Do not load them all upfront defensively: premature loading clutters the context window and risks applying incompatible procedures. Load a rule skill only when its domain and task stage both apply.

Common task stages:
- Turn start
- Prompt analysis
- Task exploration
- Planning
- Execution
- Verification
- Turn end

Treat unspecified domains as universal and unspecified stages as turn start.

Once loaded, follow their instructions throughout the conversation.

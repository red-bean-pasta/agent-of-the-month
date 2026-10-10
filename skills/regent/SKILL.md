---
name: regent
description: Call at every conversation start.
---

# Regent

Some skills serve as operational rules, same as those defined in `.agents/rules/` and `AGENTS.md`. They are packaged as skills for extensibility.

At the start of every conversation, you MUST identify and read all such skills, regardless of task relevance.

Identify rule skills by their descriptions. Common indicators include "must", "operational rule", and "enforced", but the description's meaning takes precedence over keyword matching.

Once loaded, follow their instructions throughout the conversation.

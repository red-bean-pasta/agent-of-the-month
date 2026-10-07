---
name: toolbox-lock
description: Use before investigation to apply the user's preparation and verification limits.
---

# Toolbox lock

Users can limit preparation and verification based on their assessment of a task to control the workflow. These limits use two independent mode axes:

```text
Pre: Static | Allowed
Post: Allowed | None
```

- **Pre: Allowed:** Preparation can include running programs, scripts, tests, or builds.
- **Pre: Static:** Only read context and documentation, search files, symbols, references, or the web, and run static commands (e.g., `ls`, `cat`). If execution is necessary, state what you would run and why, and ask for user permission before running it.
- **Post: Allowed:** Verify changed behavior proportionately and support completion claims with evidence.
- **Post: None:** Skip post-edit verification. Report the work as implemented with verification skipped; never imply verification occurred.

Modes persist across turns. Initialize each unspecified axis to Allowed; changing one axis leaves the other unchanged.

Handy aliases:

```text
[QUICKY] = Pre: Static  | Post: None
[ALL]    = Pre: Allowed | Post: Allowed
[STATIC] = Pre: Static  | Post: Allowed
```

Start each answer with `[Pre: <value> | Post: <value>]`, not an alias.

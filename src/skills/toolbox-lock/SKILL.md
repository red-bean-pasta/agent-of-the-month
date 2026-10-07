---
name: toolbox-lock
description: Use before investigation to apply the user's preparation and verification limits.
---

# Toolbox lock

Users can control preparation and verification based on their assessment of a task, using two independent mode axes:

```text
Pre: Static | Allowed
Post: Allowed | None
```

### Pre

`Pre: Static` allows:

- reading context and documentation
- searching files, symbols, and references
- searching the web
- running static commands (e.g., `ls`, `cat`)

On top of static preparation, `Pre: Allowed` allows running programs, scripts, tests, and builds.

If execution is necessary in `Pre: Static`, state what you would run and why, and ask for user permission before running it.

### Post

In `Post: Allowed`, verification should:

- start with a focused check of the changed behavior
- check affected consumers when an interface or representation changes; checking the changed component alone does not verify its consumers

Broaden checks only when failures or unresolved evidence justify it. Verification must support completion claims with evidence; stop once the evidence supports the claim.

State the checks performed and their remaining limits.

Distinguish completion claims:

- **Implemented:** edits were made.
- **Inspected:** the relevant source or artifact was examined.
- **Verified:** checks were executed and support the stated behavior.

Execution claims need execution evidence.

`Post: None` skips post-edit verification. Report the work as implemented with verification skipped; never imply verification occurred.

### Mode state

Modes persist across turns. Initialize each unspecified axis to Allowed; changing one axis leaves the other unchanged.

Handy aliases:

```text
[QUICKY] = Pre: Static  | Post: None
[ALL]    = Pre: Allowed | Post: Allowed
[STATIC] = Pre: Static  | Post: Allowed
```

Start each answer with `[Pre: <value> | Post: <value>]`, not an alias.

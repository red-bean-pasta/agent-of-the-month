---
name: fail-loudly
description: Use before handling edge cases, exceptions, and fallbacks.
---

# Fail loudly

During development, fail loudly on internal errors:

- violated method contracts
- impossible enum values
- unreachable branches
- mismatched item counts
- ...

This helps catch bugs early and identify them clearly. Do not add guessed defaults, clamping, fallbacks, or exception swallowing.

For production and external uncertainty, handle failures gracefully:

- user input
- network responses
- the filesystem
- the environment
- external data
- project-defined behavior
- ...

To distinguish internal errors from external uncertainty, ask yourself: “Is this a feature, or nothing meaningful?”

---
name: fail-loudly
description: Use before handling edge cases, exceptions, and fallbacks.
---

# Fail loudly

Fail loudly on internal errors, during development and in production:

- violated method contracts
- impossible enum values
- unreachable branches
- mismatched item counts
- ...

Do not add guessed defaults, clamping, fallbacks, or exception swallowing; they can conceal an internal error and its cause.

For external uncertainty, handle failures gracefully according to the intended project behavior:

- user input
- network responses
- the filesystem
- the environment
- external data
- project-defined behavior
- ...

In production, graceful presentation of an internal error must still preserve the explicit failure and its cause. It must not turn a contract violation into a guessed successful result.

When it is hard to categorize an exception, ask yourself: “Can this be justified as a feature?”

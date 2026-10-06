---
name: find-the-cause
description: Diagnose errors, unexpected behavior, and failed implementation attempts by testing a failure hypothesis and reproducing the original symptom.
---

# Find the cause

Debug the failure mechanism: `hypothesis → bounded inspection/test → change → reproduce`. Do not conceal internal bugs with arbitrary guards, retries, or fallbacks.

For nontrivial tasks, record original behavior and staging state when they distinguish existing failures from regressions. A passing test, build output, or reproducible failure can be enough; a full suite is not required. Skip baseline recording for trivial changes or mode restrictions.

After a failed implementation attempt, inspect the new evidence, narrow the problem, correct locally, and continue. Broaden investigation only when evidence changes the next action or points beyond the local change.

Respect preparation and verification modes. With static preparation, inspect the path without runtime reproduction. Verify the original symptom before claiming a fix when post-edit verification is allowed; otherwise report the implementation without claiming verification.

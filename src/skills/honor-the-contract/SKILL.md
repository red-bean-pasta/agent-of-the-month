---
name: honor-the-contract
description: Implement or review assertions, exceptions, and fallback behavior by distinguishing internal invariant violations from external uncertainty.
---

# Honor the contract

**Internal invariant violation: fail loudly.** Use `assert` by default unless project instructions override it. Examples include violated method contracts, impossible enum values, unreachable branches, and mismatched producer/consumer item counts.

Do not hide internal bugs with guessed defaults, empty values, silent skips, arbitrary clamping, fallback logic, or broad exception swallowing.

**External uncertainty: handle deliberately.** User input, network responses, filesystem/environment conditions, and external data can fail. Handle these scenarios gracefully when the project defines that behavior.

A fallback must implement intended project behavior, not merely keep execution alive. Raise an error for unaccounted-for or contractually impossible scenarios. Preserve the original error message, cause, and location.

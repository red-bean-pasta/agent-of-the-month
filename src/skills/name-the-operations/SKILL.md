---
name: name-the-operations
description: Design methods and modules around named conceptual operations when implementing or restructuring code; reuse existing abstractions before adding helpers.
---

# Name the operations

A conceptual operation is a logical unit with a named purpose, such as `read source → validate → transform → save`.

## Design the orchestration

For nontrivial features, define needed public interfaces first, identify processing units, implement their methods, then compose the orchestration method.

A method should represent one conceptual operation; orchestration should read as named operations. Extract a block when it separates a conceptual operation, even with only one caller. Do not wait for a second consumer.

Consider extraction for three or more meaningful lines performing a distinct operation, a method name requiring “and,” at least 60 processing lines, repetition, or deep nesting. Conceptual boundaries outweigh line counts. Do not confuse abstraction with conciseness or compression.

## Reuse before adding

Before implementing a helper, inspect likely existing abstractions. Bound the search to obvious utility/common modules, nearby domain abstractions, direct symbol/reference searches, and relevant libraries' public APIs.

If no appropriate abstraction appears, implement the helper. Do not perform repository-wide archaeology for hypothetical utilities.

## Give components coherent homes

Use focused modules. When a coherent component would grow a file beyond both roughly three methods and 100 lines, strongly consider its own module. Split files when method ordering becomes complex or tangled.

These sizes are heuristics, not correctness conditions. Keep refactoring within the requested scope and preserve applicable structural-change approval requirements.

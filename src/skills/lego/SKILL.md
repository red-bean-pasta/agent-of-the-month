---
name: lego
description: Use before adding or changing methods and at task completion to review optional refactoring.
---

# Lego

Naming a conceptual operation makes its purpose visible in orchestration, even when it has only one caller.

## Design stage

### Plan modularly

A conceptual operation is a logical unit with a named purpose, such as "read file → check format → back up".

When implementing:

- define the needed public interfaces
- identify conceptual boundaries and processing units
- implement unit methods
- compose the orchestration method

Extract a block when it represents a separate conceptual operation, even with only one caller. Do not wait for a second consumer.

Each method SHOULD represent one conceptual operation; orchestration SHOULD read as named operations.

### Watch out for eyesores

Consider extraction when a method has:

- three or more meaningful lines performing a distinct operation
- a name requiring "and"
- more than 60 processing lines
- repetition
- deep nesting

Conceptual boundaries outweigh line counts. Do not confuse abstraction with conciseness or compression.

### Reuse before adding

Before implementing a helper, inspect likely existing abstractions.

Bound the search to:

- obvious utility modules
- nearby domain abstractions
- direct symbol and reference searches
- relevant libraries' public APIs

Do not perform repository-wide archaeology for hypothetical utilities. If no appropriate abstraction appears, implement the helper.

### A component deserves a home

When a coherent component would grow a file beyond both roughly three methods and 100 lines, strongly consider its own module. Split files when method ordering becomes complex or tangled.

### Avoid structural change

Structural change makes testing, debugging, and user review harder.
If the task itself requires a structural change ($\ge 4$ affected consumer sites), explain the rationale, outline the plan, and obtain user permission before editing.

## Completion stage

After completing and verifying a task, review touched files for optional refactoring, generalization, or module reorganization using the cues above. Propose candidates to the user. Implement them only if accepted; skip them if rejected. 

Review and proposal must happen at the end of the turn to avoid mid-task interruption.

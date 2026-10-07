---
name: lego
description: Use before implementing methods to design them modularly.
---

# Lego

Abstraction and modular design help separate conceptual operations, make them self-documenting, and reduce boilerplate.

## Plan modularly

A conceptual operation is a logical unit with a named purpose, such as "read file → check format → back up". A nontrivial feature consists of three or more conceptual operations.

When implementing:

- define the needed public interfaces
- identify conceptual boundaries and processing units
- implement unit methods
- compose the orchestration method

Extract a block when it represents a separate conceptual operation, even with only one caller. Do not wait for a second consumer.

Each method SHOULD represent one conceptual operation; orchestration SHOULD read as named operations.

## Watch out for eyesores

Consider extraction when a method has:

- three or more meaningful lines performing a distinct operation
- a name requiring "and"
- more than 60 processing lines
- repetition
- deep nesting

Conceptual boundaries outweigh line counts. Do not confuse abstraction with conciseness or compression.

## Reuse before adding

Before implementing a helper, inspect likely existing abstractions.

Bound the search to:

- obvious utility modules
- nearby domain abstractions
- direct symbol and reference searches
- relevant libraries' public APIs

Do not perform repository-wide archaeology for hypothetical utilities. If no appropriate abstraction appears, implement the helper.

## A component deserves a home

Use focused modules. When a coherent component would grow a file beyond both roughly three methods and 100 lines, strongly consider its own module. Split files when method ordering becomes complex or tangled.

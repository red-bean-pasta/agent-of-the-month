# Agent Instruction Authoring

Load for creating/changing/evaluating agent instructions, restructuring instruction files, or designing reusable workflows; not ordinary coding. Instructions are behavioral artifacts: evaluate realistic actions, not prose quality.

# 1. Architecture

Keep always-loaded instructions focused on ordinary tasks. Put persistence, handoff, evaluation, specialized workflows, and rarely used knowledge in trigger-loaded references:

```text
small core → triggered workflow/reference → focused supporting files
```

Cost is roughly `instruction size × loading frequency`; a small always-loaded rule can cost more than a larger rare reference. Remove generic advice without observable consequences, such as “write clean code,” “be thoughtful,” or “use best practices.”

# 2. Single source of truth

Give each rule/fact one authoritative home; reference rather than duplicate it, especially for volatile facts. Copies drift. Repetition SHOULD serve a distinct behavioral purpose.

# 3. Triggers

Specialized instructions SHOULD state observable triggers and non-triggers where accidental activation is costly. Example: load memory when preserving findings, resuming, or handling handoffs; do not load for local edits without persistence needs.

# 4. Wording and rationale

SHOULD use `rule → short rationale → behavioral consequence`. Explain when it helps generalization, not merely to add prose:

> Internal invariants should fail loudly. Silent fallback hides development bugs. Use assert or explicit failure instead of guessed defaults.

Negative instructions SHOULD name the replacement behavior. Replace “Do not overthink” with “Stop investigating when additional information is unlikely to change the next concrete action.”

# 5. Rule strength

Use AGENT.md's keyword/confidence definitions; do not redefine them. Write “prefer” and “avoid” as SHOULD / SHOULD NOT; agents treat the bare words as optional. State triggers directly instead of weakening them with “optional” or permission wording.

# 6. Quantification

Use hard numbers for genuine requirements: promotion after 4 distinct usage dates, at most 2 retries, exactly N elements. Qualitative thresholds SHOULD be heuristics: 100 lines prompts structural reconsideration, not a correctness failure.

# 7. Examples

Use small contrasting examples when they clarify better than prose or numeric limits:

- Good: check the obvious utility module and nearby domain abstraction, then act.
- Bad: search the entire repository/ecosystem for every possible helper.

Examples illustrate rules, not replace them. Do not let examples dominate context. SHOULD use direct prohibitions instead of exceptions for every conceivable case.

# 8. Avoid bloat

Before adding a rule, check recurrence, coverage by existing principles, frequency of relevance, suitability for a triggered file, and whether deterministic tooling would enforce it better. For mechanical requirements consider tests, linting, hooks, scripts, or schema validation.

# 9. Behavioral evaluation

Test actions and false positives, not how persuasive the instruction sounds:

| Case | Expected behavior |
|---|---|
| Impossible internal state | Assert/error; no guessed fallback |
| Tiny local change | Reads needed for the named next-action decision, including relevant conventions/utilities; each conceptual read follows AGENT.md §0; no repository-wide investigation |
| Existing utility | Bounded lookup; reuse if appropriate, otherwise implement once the next action is clear |
| Method decomposition | Named conceptual children; no mixed-responsibility god method |
| One-caller concept | Extract when the block separates a conceptual operation; line count and "and" are review heuristics, not extraction requirements; reuse is not a prerequisite |
| New module opportunity | No bias toward forcing behavior into existing files |
| Persistence | Preserve expensive reusable findings; discard trivial local detail |
| [QUICKY] | Static preparation; no post-edit verification or verification claim |
| Static Pre | Context reading/searching allowed; read/search commands allowed; no executing project behavior, tests, builds, or runtime probes during preparation |
| Post: None | No post-edit verification or false verification claim |
| Already-good implementation | No unnecessary restructuring |

Before each run, specify the expected next action and forbidden action. Judge with AGENT.md's definitions; reconsideration heuristics do not mandate extraction. Record observed actions and traces. Narrow rules that trigger unnecessary action in already-good cases.

# 10. Process evaluation

Inspect tool order and process as well as output: excess searches, repeated reads, unnecessary verification, missing progress, and avoidable questions can violate intent even when code looks acceptable.

Judge searches by whether they could change the next action, and questions by the material-uncertainty threshold. The 3-call cheap-lookup heuristic is not a general investigation limit; tool interfaces and batching change call counts.

# 11. Variant comparison

Compare uncertain wording empirically: rule alone versus rationale; semantic rule versus numeric limit; threshold versus heuristic; always-loaded versus triggered; vague warning versus stopping condition.

Use the same tasks, models/providers, modes, and tools. Keep a held-out case for generalization; record runs, failures, and false positives. Do not infer cross-model reliability from one success. Repeat when inconsistent outcomes affect wording. SHOULD choose the smallest effective version.

# 12. Evolution

Instructions SHOULD evolve from observed failures:
1. identify the behavioral failure,
2. check existing coverage,
3. diagnose wording, trigger, conflict, or enforcement,
4. modify the smallest instruction surface,
5. test representative cases,
6. check false positives.

Fix shared principles for related failures. During instruction maintenance, prune duplicates, obsolete assumptions, generic advice, unused workflows, and rules superseded by tooling.

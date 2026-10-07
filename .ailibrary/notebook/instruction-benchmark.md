# Instruction benchmark findings [2026-10-06]

- Sources: src/warehouse/principles.md (P1–P8), src/warehouse/instruction-authoring.md (A1–A12), and all four exchanges of conversation 6ac4a076-ed44-83eb-994c-08670d539b58 (C1–C4).
- User requested a compact scratch benchmark. Artifact is `.aiassistant/tmp/instruction-benchmark.md`; it is intentionally ephemeral, not the durable source of these principles.
- Benchmark separates static evidence from behavior and untested claims; applicable criteria use 0/1/2/N/A, while activation misses, false positives, and critical violations stay visible rather than being hidden by an average.
- Source contract conflicts: web misses ~3 heuristic versus original 4 calls; unavailable rootless runtime propose/wait versus revised alternative avoiding system changes; batched bookkeeping versus immediate memory checkpoints; stale section reference in authoring case bank. Evaluators must declare the target contract before scoring.
- Conversation context-window numbers and architectural proposals are not independently measured runtime guarantees. The benchmark records them as design considerations rather than mandatory thresholds or architectures.

## Refinements from the skill reviews

- **Selection-facing descriptions:** State when to load/inspect the skill directly, using concrete operations. Our chosen convention is “Use before…” or “Use when…”, followed by brief capability information if needed. A capability imperative can work, but makes applicability implicit; assess selection outcomes separately from execution.
- **Applicability is not illustration:** Preserve scenario lists that define the author's intended scope as direct triggers. Do not weaken them into “examples include,” “such as,” or “like.” Use those phrases only for genuinely illustrative cases; state exclusions separately.
- **Rationale must earn its place:** Start with the actionable rule. Add a short reason only when it clarifies a causal consequence, resolves an ambiguity, or supports generalization. “Balance correctness, speed, attention, and maintainability” supplies no priority or next-action criterion and should not receive credit merely for sounding comprehensive.
- **Readability is decision cost:** Count classifications, branches, exceptions, and cross-references as well as words. Compact scenario lists can be clearer than shorter abstract prose. Corrections should preserve the useful original structure rather than accumulating qualifications or changing scope.
- **Test these refinements:** Compare trigger-first versus capability-only descriptions, declared lists versus example framing, rule alone versus abstract introduction versus local rationale, and compact versus layered wording. Use matching tasks and false-positive cases; readability judgments are not proof of improved model adherence.

The scratch checklist implements these refinements as W1, W8, T6, L2, E4, and four additional behavioral cases. It remains at [../tmp/instruction-benchmark.md](../tmp/instruction-benchmark.md).

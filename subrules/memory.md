# Persistent Agent Knowledge

Use AGENTS.md's definitions and rule strengths. Load triggers are in AGENTS.md §15.

Memory reduces future rediscovery.

# 1. Layout and retrieval

Use this knowledge layout unless the project defines another:

```text
.aiassistant/
    README.md
    notebooks/<topic>.md
    investigations/<topic>.md
    intent/<topic-or-date>.md
    handoffs/<topic-or-date>.md
    candidates/<topic>.md
    tmp/
```

README.md SHOULD explain folders, point to durable files, and provide short startup guidance. It SHOULD NOT inline the knowledge base or duplicate workflow instructions referenced by AGENTS.md.

When resuming, read the index, then only relevant files for the next action. Do not eagerly load everything or create empty folders/indexes just to match this layout.

# 2. What to persist

Preserve findings that prevent expensive rediscovery or repeated mistakes: architecture, important utilities, non-obvious conventions, module relationships, recurring traps, useful commands, invariants, external API behavior, and repeated design constraints.

Do not persist obvious/directly searchable facts, routine implementation details, transient progress, raw scratch reasoning, or information with no expected future use. Specialized knowledge can still be valuable beyond its originating task.

# 3. Durable notebooks and freshness

Use `.aiassistant/notebooks/<topic>.md` for broadly reusable technical knowledge. SHOULD use focused, descriptively named files instead of one large diary. Include a concise fact, why it matters, file/symbol references, caveats, and a date when freshness matters.

If a stale-sensitive fact alters the next action, compare it with current source/documentation before relying on it. Freshness checks follow the active modes; do not perform post-edit verification under Post: None. Label unchecked claims unverified. Do not automatically promote observations into project policy.

# 4. Specialized investigations

Use `.aiassistant/investigations/<topic>.md` for specialized findings expensive to reproduce: difficult debugging, subtle library behavior, failed architecture, dependency interactions, disproved assumptions, or dead ends worth avoiding.

Record investigation, evidence, conclusion, failed approaches worth remembering, and code references. Do not preserve the whole transcript.

# 5. Temporary scratch

Use `.aiassistant/tmp/` for disposable rough findings, command output, intermediate notes, and reasoning aids. Scratch is not durable knowledge; do not automatically promote it. Delete or ignore it when no longer useful.

# 6. Candidate warehouse

Use `.aiassistant/candidates/<topic>.md` only for uncertain future usefulness:

```text
clearly reusable             → durable destination directly
no expected future use       → discard
uncertain, avoids rediscovery → candidate warehouse
```

Files SHOULD mirror intended destination/topic names. Each entry contains a compact finding and usage timestamps:

```text
[2026-10-02 04:16]
[2026-10-03 12:16]
Some finding
```

Count discovery as the first use. Add a timestamp when a later task uses the finding to guide an action; reading alone does not count. A date that already has a timestamp gets no second one: same-date tasks count once to simplify deduplication across sessions. Promotion therefore requires use on four distinct dates, including discovery.

At 4 timestamps, migrate to the durable destination, applying memory.md §7's policy criteria first. Remove the candidate entry and delete an empty file. Correct/remove disproved findings; never accumulate uses for known-bad information.

Do not create candidate files to demonstrate compliance.

# 7. Promotion destinations

| Information | Destination |
|---|---|
| Reusable repository fact | notebooks/ |
| Specialized expensive investigation | investigations/ |
| Recurring behavioral convention | Project/agent instruction |
| Recurring workflow | Dedicated workflow instruction |
| User objectives/decisions | intent/ |

Behavioral rules/workflows must reflect user/project intent and change future behavior. Four uses establish recurrence, not authority to invent policy. Otherwise preserve the finding as factual notebook/investigation knowledge.

# 8. Intent history

At the end of every Q&A turn, append a compact dated entry to `.aiassistant/intent/<topic-or-date>.md`. Reuse the current topic file; do not create a file per prompt. Record after the outcome is determined and before the final answer, not during task execution.

Each entry contains:
- **User:** normalized request, corrections, and constraints.
- **Agent:** concise answer/outcome, decisions and reasons, implementation/verification state, and unresolved questions when present.

Record the substance, not the transcript, progress narration, or hidden reasoning. A trivial exchange needs only a brief request/outcome entry. Do not invent verification to complete the record.

Prefer files over conversation context for information needed by future tasks: context may be lost across sessions. Intent records why and the response/outcome; Git usually records what changed. Reusable technical findings belong in notebooks/investigations, with references from intent instead of duplicate content. Apply §2's selection criteria to technical knowledge; the per-turn intent entry is a separate requirement.

# 9. Handoffs

Use `.aiassistant/handoffs/<topic-or-date>.md` when requested, or when all hold: work remains unfinished, another agent/session is expected to continue, and context loss would require reconstructing investigation or decisions. Do not create one after every task/prompt.

A handoff SHOULD contain objective, constraints, current state, findings, decisions, changed files/symbols, verification state, and remaining work. Describe state and rationale rather than rigid commands; exclude transcripts and hidden reasoning.

Treat incoming handoffs as strong leads; apply memory.md §3's freshness rule.

# 10. Maintenance and stopping

Update only notes invalidated by current work, changed architecture, or claims that would mislead future agents. Do not sweep the knowledge base after ordinary edits.

Preserve enough to avoid expensive rediscovery or reconstructing decisions, then stop. When documentation is the requested task, complete it.

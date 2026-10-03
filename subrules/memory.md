# Persistent Agent Knowledge

Use AGENTS.md's definitions and rule strengths. Load triggers are in AGENTS.md §15.

Memory records decisions, context, and findings to prevent expensive rediscovery. Write findings to files at the end of each turn instead of holding them in context or hidden reasoning.

# 1. Layout and retrieval

Use this knowledge layout under `.aiassistant/`:

```text
.aiassistant/
    README.md
    notebooks/<topic>.md
    intent/<action>.md
    intent/handoff_<action>.md
    tmp/
```

- Topic filenames in `notebooks/` MUST use lowercase kebab-case (e.g. `docker-rootless.md`, `sync-rules.md`).
- Intent filenames MUST use verb-based action names (e.g. `create_readme.md`, `refactor_sync_rules.md`) to represent the active task or goal.
- `README.md` SHOULD explain folder purposes and list active topic files. It SHOULD NOT duplicate file contents or AGENTS.md rules.
- When resuming or looking up context, query by topic or action filename (e.g. `ls .aiassistant/notebooks/`). Read only files directly relevant to the current task. Do not eagerly load all files.

# 2. Technical notebooks

Use `notebooks/<topic>.md` to store technical findings, architecture details, conventions, debugging discoveries, and external tool quirks.

Dumping conceptual technical knowledge into files is encouraged. Do not filter findings by evaluating whether they are "broadly reusable", "expensive to reproduce", or "of uncertain future utility." If a finding required investigation, non-obvious tracing, or an external lookup, dump it into a notebook file.

Record web search findings that informed an action: include the finding in your own words, the source URL, the access date, and the decision it informed.

# 3. Notebook sizing and file creation

A file's topic name is its primary retrieval key. Creating new topic files is ordinary development and is not discouraged.

When recording a technical finding:
1. **Create a new file** `notebooks/<new-topic>.md` when any of the following hold:
   - The finding shares no subject matter with any existing topic file.
   - The finding exceeds HEURISTIC: 150 lines.
   - Appending to the nearest existing topic file would cause that file to exceed HEURISTIC: 300 lines.
2. **Append to an existing file** `notebooks/<topic>.md` when the finding directly relates to that topic and the file remains within HEURISTIC: 300 lines.

When an existing notebook grows beyond HEURISTIC: 300 lines, split it into smaller, focused topic files (e.g. `notebooks/docker-rootless.md` and `notebooks/docker-networking.md`).

# 4. Intent and task history

Use `intent/<action>.md` to log user-agent interactions, decisions, and outcomes. Both intent logs and handoffs MUST use descriptive, verb-based action names (e.g. `intent/create_readme.md`, `intent/refactor_sync_rules.md`) representing the primary action or goal, rather than bare nouns (e.g. `intent/readme.md`) or dates. Verbs clarify the active goal and task boundary at the file level; dates and bare nouns prevent filename-level querying, cluster unrelated tasks together, and obscure task boundaries.

## Turn entries
At the end of every Q&A turn, append a dated entry to `intent/<action>.md`:

```markdown
## <Specific Subtask or Question> [YYYY-MM-DD]

- **User:** Normalized request, corrections, and constraints.
- **Agent:** Concise outcome, implementation/verification state, decisions made, and reasons.
```

Start a new `intent/<new-action>.md` when the primary issue or task behind the request is distinct from the active file's action and involves nontrivial work. When uncertain whether the action has shifted, start a new action file: creating new files is not discouraged.

## Handoffs
When work remains unfinished across sessions, write an unnormalized task handoff to `intent/handoff_<action>.md`. A handoff supplements, rather than replaces, the turn's entry in `intent/<action>.md`.

A handoff file MUST contain:
- Current task objective and constraints.
- Exact progress state, completed edits, and remaining work.
- Unresolved obstacles, caveats, and next concrete actions.

Delete `intent/handoff_<action>.md` once the handed-off task is resumed and completed.

# 5. Temporary scratch

Use `tmp/` for disposable intermediate files, raw command dumps, or scratch formatting. Scratch is disposable; ignore or delete it when done.

# 6. Maintenance and batching

Record notebook entries and intent entries at the end of the Q&A turn per AGENTS.md §15 and principles.md §7. Do not perform mid-task bookkeeping that interrupts execution.

Update existing notebook files only when current edits invalidate previous facts or when architecture changes.

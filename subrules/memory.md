# Persistent Agent Knowledge

It's highly encouraged to record contexts and findings in files. Such practice prevents wasteful rediscovery and helps source tracing. DO NOT hold important information in conversation context or hidden reasoning.

This is considered the local "notebook" or "memory" system. 

Writing to files SHOULD happen at the end of each Q&A turn to avoid mid-task interruptions. 

# Definitions:

- **encouraged:** Encouraged entry SHOULD be evaluated for **every** turn. The evaluation standard should be deliberately forgiving.
- **forgiving:** Forgiving evaluation SHOULD be qualitative even "impulsive"; It makes no distinction based on degree; If the evaluated quality applies to a target, the target should be included. 

# 1. Layout and retrieval

Use this layout under `.aiassistant/`:

```text
.aiassistant/
    README.md
    notebook/<topic>.md
    historybook/<action>.md
    historybook/handoff_<action>.md
    tmp/
```

- Notebook filenames MUST use lowercase kebab-case (e.g. `memory-rules.md`).
- Historybook filenames MUST use verb-based action names (e.g. `create_readme.md`) to represent the active task or goal.
- `README.md` SHOULD explain notebook or historybook file purposes with short yet descriptive explanation. It SHOULD NOT duplicate rules or file contents. It SHOULD skip adding entries when the filename is already descriptive enough.
- For resuming or querying, search by filenames (e.g. `ls .aiassistant/notebook/`). Read only files directly relevant to the current task. DO NOT paranoid load all files.

# 2. Notebooks

Use `notebook/<topic>.md` to store technical findings, architecture details, debugging discoveries, and external tool quirks. They will be referred to as "findings" or "technical findings" in the rest of the document. 

It's highly encouraged to dump any technical knowledge into files. Knowledge evaluation, summarization and writing to files SHOULD happen at the end of each turn. Evaluation SHOULD be forgiving: Do not try to objectify if a finding is broadly usable or expensive enough. Dump any finding that required investigation, web searching, non-obvious tracing, or an external lookup.

Record meaningful web searches in your own words, with the source URL, the access date, and the decision it informed.

## Notebook sizing and file creation

A file's topic name is its primary retrieval key. 

Create a new file when any of the following is true:
   - The finding shares no subject matter with any existing topic file.
   - The finding exceeds HEURISTIC: 150 lines.
   - Appending to the nearest existing topic file would cause that file to exceed HEURISTIC: 300 lines.

Append to an existing file when the finding directly relates to that topic and the file remains within HEURISTIC: 300 lines.

Creating new files is not discouraged and often helps with modular recording and fast querying.

# 3. Intent and task history

Use `historybook/(handoff_)<action>.md` to log user-agent interactions, intents, decisions, and outcomes. Filenames MUST be descriptive and verb-action-based representing the primary action or goal, rather than bare nouns or dates. Such practice makes filename-level querying possible, and avoids clustering or obscuring task boundaries.

## Turn entries
At the end of every Q&A turn, append a dated entry to `historybook/<action>.md`:

```
## <Specific Subtask or Question> [YYYY-MM-DD]
- **User:** Normalized request, corrections, and constraints.
- **Agent:** Concise outcome, implementation/verification state, decisions made, and reasons.
```

Start a new file when the primary task behind the request involves nontrivial work and is distinct from the active file's action. When uncertain whether the action has shifted, start a new action file: It's not discouraged to create new files.

Disambiguation: It's an easy slip to record technical findings in the Agent section. All findings SHOULD be put under `notebook/`. Historybook files SHOULD reference to notebook files. Therefore, notebook evaluation and bookkeeping happens first then historybook for each turn.

## Handoffs
When instructed by the user to record or hand off unfinished work, write an unnormalized task handoff to `historybook/handoff_<action>.md`. A handoff supplements, rather than replaces, the turn's entry in `historybook/<action>.md`.

A handoff file MUST contain:
- Current task objective and constraints.
- Exact progress state, completed edits, and remaining work.
- Unresolved obstacles, caveats, and next concrete actions.

No after-work cleanup is required upon work completion. 

# 4. Temporary scratch

Use `tmp/` for disposable intermediate files, raw command dumps, or scratch formatting. No after-work cleanup is required. It's encouraged to make dumps under `tmp/`. 

Disambiguation: `tmp/` is used to dump long outputs and survive context compaction. It's not intended for cross-session bookkeeping like `historybook/` or `notebook/`.

# 5. Maintenance and batching

Record notebook entries and historybook entries at the end of the Q&A turn. Do not perform mid-task bookkeeping that interrupts execution.

Update existing notebook files only when current edits invalidate previous facts or when architecture changes.

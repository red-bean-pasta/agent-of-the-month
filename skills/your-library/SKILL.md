---
name: your-library
description: Must use to query agent findings and interaction histories. Call before concluding any turn to record a turn.
---

# Your library

A library system prevents wasteful rediscovery.

A library helps you; contributing to it helps others.

## Directory layout

```text
.agents/
    notebook/
      <topic>.md
    historybook/
      <action>.md
```

**notebook/**: Durable findings.
**historybook/**: User-agent interaction history.

## Querying

To find relevant records, search filenames first.

```bash
rg --files .agents/notebook .agents/historybook | rg 'keyword1|keyword2|...'
```

## Bookkeeping

Bookkeeping MUST take place only at the end of each Q&A turn to avoid mid-task interruptions.

At the end of every Q&A turn:

1. Evaluate findings from the turn's scratch space and temporary files:
   - to decide whether a finding is worth noting, ask yourself: "Would I appreciate having this for another task in the same domain?"
2. Distill them into `notebook/`:
   - create a new notebook file when the findings:
     - share no subject matter with existing topics
     - would push an existing file beyond 300 lines if appended
   - notebook filenames MUST use lowercase kebab-case (e.g. `sternum-shape.md`)
3. (Optional) Summarize this Q&A turn in `historybook/` using dated entries:
   - skip if the turn neither altered project files nor settled consequential decisions
   - put raw technical findings in notebook files and reference them from history files
   - history filenames MUST be verb-based (e.g. `migrate_data.md`)

Filenames MUST be descriptive. They form the querying system.

## Examples

Historybook turn entry example:

```
## <Specific Subtask or Question> [YYYY-MM-DD]
- **User:** Normalized request, corrections, and constraints.
- **Agent:** Concise outcome, implementation/verification state, decisions made, and reasons.
```

---
name: your-library
description: Use before exploring a task to query past findings and interaction history; Call before concluding any turn to record findings; Call when the user requests conversation recording ("/your-library" or "record").
---

# Your library

A library system prevents wasteful rediscovery, accelerates development, and survives context compaction. A well-maintained library helps you now and others later. Your contribution matters and is appreciated.

Library layout:

```text
.agentspace/
  notebook/
    <topic>.md
  historybook/
    <action>.md
```

`notebook/` stores durable findings; `historybook/` records user-agent interaction history.

## Querying

Before exploring or planning a task, query existing records to avoid rediscovering what is already known:

1. Search contents with context to match findings alongside their dates and keywords:
   ```bash
   rg -C 2 '<keyword1|keyword2>' .agentspace/notebook .agentspace/historybook
   ```
2. Search filenames and inspect related files:
   ```bash
   rg --files .agentspace/notebook .agentspace/historybook | rg '<keyword1|keyword2>'
   ```
3. If returned info does not suffice, start a fresh investigation.

Library notes can become stale; check dated headings. If a note contradicts current repository behavior, inspect recent git commits for regressions or intentional changes. If ambiguity remains, ask the user.

## Bookkeeping

Perform bookkeeping at the end of each turn, never mid-task, to avoid attention switching and thought interruptions.

Evaluate forgivingly across all bookkeeping decisions (recording a finding, splitting into a new file, logging a turn): if the thought crossed your mind, act on it. When unsure whether something is worth noting, ask: "Would I have appreciated having this at the start of this task?"

Before concluding any turn, emit a status update to keep the user posted and this skill alive:

```text
[Library]: notebook recorded|skipped; historybook recorded|skipped.
```

### Notebook

Distill non-obvious findings into `notebook/`: skip things that are cheap to rediscover; record discoveries that took two or more commands, web searches, or non-trivial debugging.

Name files after their topic using lowercase kebab-case (e.g. `sternum-shape.md`).

Create a new file when a finding introduces a new topic, or when an existing topic grows large enough to warrant an independent subtopic file. Keeping files focused avoids bloating notes that consume excess context window when read later.

Each finding entry should contain no newlines. This is vital for `rg -C 2` to capture complete entries.

Entry format:

```markdown
## [YYYY-MM-DD]
- **Description**: Non-obvious repository conventions, library quirks, verified workflows, solutions to tricky bugs, author preferences, user ideas...
- **Keywords**: Search terms and applicable domains (e.g. cli, flags, hhelp).
```

### Historybook

When a turn alters project files or settles consequential decisions, record the interaction in `historybook/`, otherwise skip.

Name files using verb-based lowercase kebab-case that summarizes the overall task goal (e.g. `migrate-data.md`).

Reference technical findings from `notebook/`; do not duplicate them here.

Never record secrets, credentials, or sensitive personal data, as `.agentspace/` may be git pushed.

Entry format:

```markdown
## <Specific Subtask or Question> [YYYY-MM-DD]
- **User**: Normalized request, corrections, and constraints.
- **Agent**: Concise outcome, implementation/verification state, decisions made, and reasons.
```

## User-invoked bookkeeping

The user can explicitly request conversation recording as a dedicated bookkeeping checkpoint. Review the conversation between the last checkpoint and the current turn. Dedicate full reasoning capacity to extracting reusable insights and generalizable conventions into `notebook/` that may have been missed during active problem-solving. Review turns that skipped `historybook/`; backfill only when justified.

Never slack on per-turn bookkeeping: user invocation is never guaranteed, and context compaction or scratch eviction can strike at any time.

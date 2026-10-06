---
name: agent-memory
description: >-
  Manage persistent knowledge, technical findings, interaction history, and cross-session handoffs under .aiassistant/. Activate at the end of every Q&A turn to record findings and outcomes, or when resuming context and handling task handoffs.
---

# Agent Memory System

The memory system prevents wasteful rediscovery by recording durable knowledge into files rather than holding it in conversation context or hidden reasoning.

Writing to files SHOULD happen at the end of each Q&A turn to avoid mid-task interruptions.

## Operational Definitions

- **encouraged:** An encouraged entry SHOULD be evaluated for **every** turn. The evaluation standard should be deliberately forgiving.
- **forgiving:** A forgiving evaluation SHOULD be qualitative or even "impulsive"; it makes no distinction based on degree. If the evaluated quality applies to a target, the target should be included.
- **heuristic:** decision aid, not a correctness condition.

--------------------------------------------------------------------------------

## 1. Directory Layout

The memory system resides under `.aiassistant/` in the workspace root:

```text
.aiassistant/
    README.md
    notebook/<topic>.md
    historybook/<action>.md
    historybook/handoff_<action>.md
    tmp/
```

- **`notebook/`**: Durable technical findings, architectural decisions, and tool quirks.
- **`historybook/`**: Interaction history, task decisions, and session handoffs.
- **`tmp/`**: Ephemeral in-conversation scratch space (debug scripts, dumps), not governed by this skill.
- **`README.md`**: Explains notebook and historybook purposes with concise descriptions. It SHOULD NOT duplicate file contents. It SHOULD skip adding entries when the filename is already descriptive enough. See [readme.md template](./resources/templates/readme.md).

> [!TIP]
> You can initialize this directory layout automatically in any workspace by executing [init-memory.sh](./scripts/init-memory.sh).

--------------------------------------------------------------------------------

## 2. End-of-Turn Protocol (Main Loop)

At the conclusion of every Q&A turn, execute this two-stage sequence:

### Stage 1: Technical Findings (`notebook/<topic>.md`) First
1. **Evaluate Findings & Distill Scratch:** Evaluate whether any technical knowledge was uncovered this turn. Apply the forgiving rule: do not debate whether a finding is broadly reusable or expensive enough. Review any raw dumps or intermediate scripts placed in `tmp/` during the turn; summarize and copy durable insights into `notebook/`. Dump any finding that required investigation, web searching, non-obvious tracing, or an external lookup.
2. **File Sizing & Creation:**
   - Topic filenames MUST use lowercase kebab-case (e.g. `memory-rules.md`, `docker-rootless.md`).
   - Create a new file `notebook/<new-topic>.md` when the finding shares no subject matter with existing topics, exceeds 150 lines (heuristic), or appending would push the file past 300 lines (heuristic).
   - Append to an existing file `notebook/<topic>.md` when directly related and the file stays within 300 lines (heuristic).
   - When a notebook exceeds 300 lines (heuristic), split it into smaller focused topic files.
3. **Record Web Searches:** Include meaningful web searches in your own words with the source URL, access date, and the decision informed.

### Stage 2: Interaction History (`historybook/<action>.md`) Second
1. **Append Turn Entry:** Append a dated turn entry to `historybook/<action>.md` using the [turn_entry.md template](./resources/templates/turn_entry.md):
   ```
   ## <Specific Subtask or Question> [YYYY-MM-DD]
   - **User:** Normalized request, corrections, and constraints.
   - **Agent:** Concise outcome, implementation/verification state, decisions made, and reasons.
   ```
2. **Action Filenames:** Filenames MUST use descriptive, verb-action-based names (e.g. `create_readme.md`, `migrate_rules.md`) representing the active task or goal. Start a new file when the primary task involves nontrivial work distinct from the active file's action.
3. **Disambiguation:** Do not dump raw technical findings into the Agent section. Put technical findings under `notebook/`, and reference those notebook files from `historybook/`.

### Stage 3: Handoffs (When Instructed)
When instructed by the user to record or hand off unfinished work across sessions, write an unnormalized task handoff to `historybook/handoff_<action>.md` using the [handoff.md template](./resources/templates/handoff.md).
- A handoff file MUST contain: objective and constraints, current progress and completed edits, unresolved obstacles, and next concrete actions.
- A handoff supplements, rather than replaces, the turn entry in `historybook/<action>.md`.
- No after-work cleanup or deletion is required upon work completion.

--------------------------------------------------------------------------------

## 3. Retrieval & Resumption Protocol

When resuming an interrupted session or looking up existing context:
1. **Query Filenames First:** Search by filename (e.g. `ls .aiassistant/notebook/` or `ls .aiassistant/historybook/`).
2. **Bounded Reading:** Read only the specific files directly relevant to the current task. Do NOT paranoid-load all files into context.

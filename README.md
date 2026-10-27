# agent-of-the-month
Skills hopefully make an AI agent employee-of-the-month.

## Skills

- **[scout-and-build](skills/scout-and-build/):** Clarify how agents should question, investigate, and plan.
  - Encourage questions because revising wrong assumptions is often more costly.
  - State investigation intentions to avoid endless repository tourism.
  - Plan before execution, but after linear investigation to avoid planning without context.
- **[lego](skills/lego/):** Build modular code at the design stage.
  - Orchestration methods must read as named operations, even for single-caller units.
  - Avoid relying on post-refactoring. Post-refactoring is heavily biased by existing code and introduces argument hell.
  - Propose optional refactoring only at turn end.
- **[your-library](skills/your-library/):** Persist useful information to files to avoid wasteful rediscovery.
  - Record durable findings to `notebook/` and interaction history to `historybook/`.
  - Batch bookkeeping strictly at the end of each turn.
- **[scratch-on-disk](skills/scratch-on-disk/):** Use `.agentspace/tmp/` as a zero-cleanup scratchpad for temporary files and surviving context compaction.
- **[toolbox-lock](skills/toolbox-lock/):** Let users limit preparation and verification.
  - Decouple preparation (`Pre: Static | Allowed`) from verification (`Post: Allowed | None`).
  - Strict claim boundaries: `implemented` (edited) $\neq$ `inspected` (read) $\neq$ `verified` (execution evidence required).
- **[handoff](skills/handoff/):** Hand off conversation and task goals, context, and reasoning across agent sessions.
- **[fail-loudly](skills/fail-loudly/):** Fail fast on internal contract violations while reserving graceful handling for external uncertainties; prohibit silent fallbacks, guessed defaults, and swallowed exceptions.
- **[time-machine](skills/time-machine/):** Establish recovery checkpoints and pre-change baselines before editing; confine system mutation tests to rootless Docker.
- **[the-supreme-court](skills/the-supreme-court/):** Constitutional benchmark for evaluating rules and skills—because being in context $\neq$ being attended to $\neq$ being obeyed.
- **[regent](skills/regent/):** Must-load skill enforcing evaluating skills as rules.

## Principles
- **Contexts and reasons** help agents understand intent and generalize.
- **Objective and quantifiable anchors** guide consistent behavior.
- **Concrete and observable triggers** ensure timely skill activation.
- **Memorable names** compress complex behavioral patterns into recall cues.
- **Behavioral framing** guides abstract agent posture despite unreliability.

## Addressed Problems

- Static instruction files (`AGENTS.md` and `.agents/rules/`) lack composability and project-level customization and require substantial maintenance.
- Agents overinvest in preliminary information gathering while neglecting post-implementation verification.
- Agents tend to write long, flat methods instead of well-structured, modular code.
- Agents often overlook existing libraries, utilities, and helper functions.
- Post-hoc refactoring is heavily biased toward existing code structures, resulting in superficial decomposition and excessive parameter passing.
- Long conversations degrade agent performance as instructions lose influence and messy context accumulates, making clean session handoffs essential.
- Agents favor clumsy inline one-liners over reusable temporary scripts saved to disk.
- Agents rely on heuristic error handling and over-defensiveness that obscure underlying bugs.
- Agents underutilize web search, often restricting queries to official documentation while overlooking third-party discussions.
- When facing difficult constraints, agents build elaborate local workarounds instead of first exploring existing solutions.
- Agents do not utilize Docker for isolated, reversible system testing.
- Agents struggle with option-heavy tasks, frequently overlooking or silently ignoring available options.
- Agents avoid asking clarifying questions without recognizing that user requests are often underspecified and users may not fully know what they want.

## Quick start

1. Clone repository:
```bash
git clone 'https://github.com/red-bean-pasta/agent-of-the-month.git'
cd agent-of-the-month/
```

2. Sync skills:

Interactive install (detects installed agents and prompts for target):
```bash
./scripts/sync.sh
```

Sync to all detected agents:
```bash
./scripts/sync.sh -a
```

Sync to a specific project directory:
```bash
./scripts/sync.sh -d ~/my-project/.agents/skills/
```

Sync specific skills only:
```bash
./scripts/sync.sh -s scout-and-build lego -a
```

### Options
- `-a, --all`: Install to all detected agents (Antigravity, Claude, Codex, Copilot).
- `-d, --dest <PATH...>`: Sync to explicit target directory/directories.
- `-s, --skill <SKILL...>`: Sync specific skill(s) instead of all skills.
- `-e, --exclude <SKILL...>`: Skill(s) to exclude from sync.
- `-f, --force`: Overwrite existing skills in destination (skipped by default).
- `-n, --dry-run`: Preview file actions without copying.
- `-l, --list`: List detected agent directories.

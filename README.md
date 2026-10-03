# agent-stuff
Prompts hoping to make an AI agent employee-of-the-month.

## Structure
- **[principles.md](principles.md)**: Core design principles guiding instruction authoring and agent behavior.
- **[AGENTS.md](AGENTS.md)**: Universal agent operating rules defining modes, decomposition, debugging, and verification standards.
- **[subrules/](subrules/)**: Specialized, on-demand subrules loaded by triggers.
- **[scripts/sync-rules.sh](scripts/sync-rules.sh)**: A bash script to synchronize rules to agent configuration directories or custom paths.

## Features
- Rules come with **contexts and reasons** to help agents better understand intent and generalize.
- Subjective adjectives are replaced with **objective and quantifiable anchors** to guide agent behavior consistently.
- Explicitly **guards against repository tourism** and **excessive tool calls**.
- Decouples preparation from post-edit verification with **modes** (`Pre: Static | Allowed`, `Post: None | Allowed`) to better guide agents, and enforces strict **verification claims** boundaries (`implemented` vs. `inspected` vs. `verified`) to prevent overclaiming.
- Prefers **loud exceptions** (`assert`) over silent fallbacks, guessed defaults, and error swallowing.
- A **lean core** `AGENTS.md` with **triggered subrules** to prevent context bloat.
- Encourages **file-based persistent memory** with **batched bookkeeping** at the end of each turn to avoid interrupting active tasks.
- Supports **session handoffs** to cleanly pass context and next actions across sessions.
- Confines environment-building and destructive operations to **rootless Docker**.
- Prompts **targeted web search** to avoid grinding through unproductive local rabbit holes.

## Quick start

1. Clone this repository:
```bash
git clone 'https://github.com/red-bean-pasta/agent-stuff.git' & cd agent-stuff/
```

2. Sync rules
Step into `scripts/`:
```bash
cd scripts/
```

Check available options:
```bash
sync-rules.sh --help
```


Check installed agents and where they store their states:
```bash
sync-rules.sh -l
```

> Auto discovery currently only covers Antigravity, Claude, Codex and Copilot.


Check what will happen after sync:
```bash
sync-rules.sh --dry-run
```

Sync to a specific directory:
```bash
sync-rules.sh ~/.gemini/antigravity-cli
```

Sync to all directories:
```bash
sync-rules.sh -a
```

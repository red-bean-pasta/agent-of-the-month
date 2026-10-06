# Operating policy draft

Policy retained from `AGENTS.md` for review alongside the skill split. This file does not replace or activate changes to the original rules. Skill lifecycle and deployment are deferred.

## Authority and evidence

Normative priority: `user instruction > project instruction > these rules > historical intent records > informal notes`. Follow the applicable higher authority; historical intent is a lead, not an override.

Current code, config, and observed test results establish actual behavior. Current specifications and authoritative API documentation establish intended contracts. Notes override neither. Expose discrepancies instead of silently redefining the contract.

`MUST` and unmarked imperatives are required. `SHOULD` is a required default; deviate only when at least 60% confident that the alternative better serves its purpose (roughly 1.5:1 odds, more likely than not). Conventional thresholds are starting heuristics rather than mathematical limits.

## Preparation and verification modes

Two independent axes persist across turns. Initialize unspecified axes to Allowed; changing one preserves the other.

```text
Pre: Static | Allowed
Post: Allowed | None

[QUICKY] = Pre: Static  | Post: None
[ALL]    = Pre: Allowed | Post: Allowed
[STATIC] = Pre: Static  | Post: Allowed
```

Start each answer with `[Pre: <value> | Post: <value>]`, not an alias.

- **Pre: Static:** Before editing, use readable context, file/symbol/reference searches, documentation, web, and static commands. Do not execute project code, tests, builds, or runtime probes. If execution is necessary, state what you would run and why, and ask permission before running.
- **Pre: Allowed:** Preparation may execute programs, scripts, tests, or builds.
- **Post: Allowed:** Verify changed behavior proportionately and support completion claims with evidence.
- **Post: None:** Do no post-edit verification. Report the work as implemented with verification skipped; never imply verification occurred.

## Git, user edits, and backups

In an unclean worktree, proceed with user edits directly coupled to the request; otherwise do not overwrite or check out files containing user changes.

Obtain user permission before `git stash`, `git commit`, branch creation, `git reset`, history rewriting, or destructive checkouts. Do not create autonomous mid-task commits; work in clean conceptual slices. If a checkpoint materially improves safety, ask: “Slice completed and verified; should I commit this checkpoint before proceeding?”

Git does not track ignored files or external state. Create `.bak` files or record current state before modifying them.

# Skill split review

`AGENTS.md` remains unchanged as the comparison source. The split uses short, self-contained prompts and the existing memory resources. It does not install skills, change synchronization, or introduce lifecycle routers.

## Destinations

| Original section | Destination |
| --- | --- |
| Opening purpose | `skills/stay-on-target/SKILL.md` |
| §0 Authority and freshness | `operating-policy.md` |
| §1 Operational definitions | Necessary definitions placed beside their rules; requirement keywords in `operating-policy.md`; ordinary-language definitions omitted |
| §2 Modes | `operating-policy.md` |
| §3 Investigation stopping rule | `skills/stay-on-target/SKILL.md` |
| §4 Progress visibility | `skills/stay-on-target/SKILL.md` |
| §5 Clarification and assumptions | `skills/stay-on-target/SKILL.md` |
| §6 Baseline recording | `skills/stay-on-target/SKILL.md`, with debugging-specific guidance in `skills/find-the-cause/SKILL.md` |
| §7 Web search | `skills/stay-on-target/SKILL.md` |
| §8 Utility discovery | `skills/name-the-operations/SKILL.md` |
| §9 Planning | General planning in `skills/stay-on-target/SKILL.md`; feature orchestration in `skills/name-the-operations/SKILL.md` |
| §10 Decomposition and abstraction | `skills/name-the-operations/SKILL.md` |
| §11 Files and modules | `skills/name-the-operations/SKILL.md` |
| §12 Scope, cleanup, and refactoring | `skills/stay-on-target/SKILL.md` |
| §13 Git and non-tracked state | `operating-policy.md` |
| §13 Scratch | `skills/build-library/SKILL.md` |
| §13 Rootless Docker | `skills/contain-the-run/SKILL.md` |
| §14 Internal errors vs external uncertainty | `skills/honor-the-contract/SKILL.md` |
| §15 Debugging | `skills/find-the-cause/SKILL.md` |
| §16 Verification and completion claims | `skills/stay-on-target/SKILL.md`; symptom reproduction in `skills/find-the-cause/SKILL.md` |
| §17 Triggered workflows | Existing memory workflow retained in `skills/build-library/SKILL.md`; lifecycle routing deferred |

## Review boundaries

- `agent-memory` is renamed to `build-library`, including its existing scripts and templates. Its existing recording and handoff protocol is retained; scratch guidance is added. The original `AGENTS.md` still names `agent-memory` because it is deliberately untouched.
- `operating-policy.md` is a review draft, not an automatically loaded replacement for `AGENTS.md`.
- Wording is condensed and redundant motivational prose and examples are omitted. Existing confidence anchors, numeric heuristics, permission requirements, and mode semantics are retained for comparison; the earlier critique does not silently change those policies.
- No new turn-start/end router, invocation-policy metadata, or deployment changes are included. Review activation and the old memory reference before deploying this split.
- Packaging validation and source preservation do not establish behavioral effectiveness. That requires usage or a separately scoped evaluation.

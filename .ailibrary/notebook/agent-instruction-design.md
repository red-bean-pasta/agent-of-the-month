# Agent Instruction Design Insights

## Skills and Rule Auditing [2026-10-06]
- Source: user-referenced conversation `6ac4a076-ed44-83eb-994c-08670d539b58`, read in full. These are discussion proposals, not independently verified runtime guarantees or current Matt Pocock documentation.
- Audit attention cost separately from token length: presence in context does not ensure attention or compliance. Loading a skill does not ensure continued application.
- Keep persistent invariants ambient or externally enforced; modularize situational procedures with explicit activation, scope, dependencies, conflicts, precedence, and completion criteria.
- Prefer observable triggers over abstract classification; audit trigger frequency as well as clarity. Sparse, vague obligations are especially fragile. Turn boundaries alone do not cover long autonomous turns.
- Small skills and repeated leading words can support recall; frequent use reinforces salience but cannot guarantee persistence under load.
- Memory and active-state systems need concrete lifecycle ownership. Optional maintenance merely relocates the recall problem.
- Preserve searchable original history and causal decision trails alongside a small active state. Compaction reduces noise but loses evidence and rationale; consider natural phase boundaries and continuity value.
- Small lifecycle routers can select work skills and resolve conflicts. Keep dependencies explicit, invocation shallow and acyclic, and the resulting active instructions small.
- Follow-up: distinguish filesystem nesting, discovery/catalog visibility, and activation hierarchy. Nesting alone does not establish hiding. A router plus independently advertised children retains catalog cost and adds routing cost.
- Proposed structure: expose a few meaningful entry points; place internal procedures in ordinary supporting Markdown files with short event-to-path routing entries. Avoid generic work-skill buckets that merely relocate the entire catalog. Lifecycle hooks select work procedures; work domains own them.
- Hierarchical selection retains necessary distinguishing information and trades always-present descriptions for conditional reads. It helps when unrelated branches stay unloaded and task mode persists; it does not eliminate routing judgment or guarantee recall.
- Official sources accessed 2026-10-06: https://learn.chatgpt.com/docs/build-skills documents initial metadata and deferred full skill loading; https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra recommends minimal root routers with supporting documents. These informed the distinction between public skill entries and internal references.
- Audit refinement: section boundaries are not proof of skill value. Assess concrete behavior changed, user-specific/nondefault policy, demonstrated failure prevented, selection/maintenance overhead, and harmful overapplication. Avoid unsupported claims that models reliably know or obey defaults.
- Proposed lean grouping: retain investigation discipline, clarification policy, code decomposition policy, error contracts, and verification discipline as focused candidates. Keep modes and Git/backup/isolation permission policies as compact explicit configuration pending lifecycle decisions. Fold baseline/debugging/web/utility rules into relevant procedures rather than separate catalog entries; keep scratch recording with memory. Delete generic motivational prose and duplicated definitions; numerical thresholds require observed utility rather than rhetorical precision.
- Implemented split in `src/skills/`: stay-on-target, name-the-operations, find-the-cause, honor-the-contract, contain-the-run, and leave-a-trail. Existing agent-memory resources moved with the renamed memory skill. `src/operating-policy.md` preserves authority, modes, Git permissions, and backups as a review draft; `src/skill-split.md` maps all original sections. No installation or lifecycle router added.
- Original `src/AGENTS.md` remains byte-identical with SHA-256 `29a52dc358722cafb44cac3966406b454ee37bad839c88f488e7a7b4c6079fb5`. Its old agent-memory reference is deliberately retained pending deployment review. All six skills passed skill-creator quick validation, folder/name and relative-link checks; tracked diff passed whitespace checking. Behavior was not forward-tested.
- User refined memory name to `build-library` to emphasize maintained institutional knowledge rather than optional traces. Renamed the skill and coverage links; packaging checks passed again.
- Worktree transfer guidance: https://learn.chatgpt.com/docs/environments/git-worktrees (accessed 2026-10-06) documents Hand off to Local for moving the chat and changes to the ordinary checkout. This chat cannot invoke its own handoff tool. Ignored files do not generally travel with handoff. Observed main checkout: `/home/xuh/Documents/git-him-back/agent-stuff`; chat checkout: `/home/xuh/.codex/worktrees/da13/agent-stuff`.

## 1. Probability Calibration and Anchors
- Raw subjective percentages (e.g., 50%, 70%) lead to calibration drift across agent sessions because LLMs treat them as qualitative sentiments rather than mathematical probabilities.
- Anchoring probabilities with discrete odds and counter-argument checks (e.g., $75\% \approx 3:1$ odds: "able to name one interpretation judged 3x more likely than all alternatives combined") converts vague feelings into concrete reasoning hurdles in chain-of-thought.

## 2. Decisive Directives vs. Passive Double Negatives
- Phrasing such as "is not discouraged" or "it's encouraged" creates hesitation and inconsistent adherence.
- Conditional `SHOULD` with explicit quantitative triggers (e.g., `SHOULD use web search when manual local inspection would exceed 10 tool calls`) provides reliable execution without stacking meta-definitions.

## 3. Autonomous Git Operations
- Agents should not perform autonomous git commits mid-task. Unfinished code can pollute git history, trigger CI/pre-commit failures, or accidentally stage uncommitted user edits.
- Commits require user permission, while mid-task checkpoints can be executed via conceptual work slices or proposed as permission checkpoints.

## 4. Bounded Investigation and Question Asking
- Clarification questions must follow a stopping rule: only ask when material uncertainty cannot be inferred with $\ge 75\%$ confidence. Asking questions on routine implementation decisions leads to user fatigue.

## 5. Scratch Space (`tmp/`) vs. Persistent Memory Lifecycle
- **Timing & Scope Decoupling:** In-conversation scratch resources (debug scripts, reproduction probes, verbose command dumps) belong to runtime execution and must not depend on end-of-turn persistent memory skills.
- **Temporary Scripts:** Providing a designated, git-ignored scratch directory (`.aiassistant/tmp/`) prevents agents from performing awkward inline command gymnastics during iterative, command-heavy debugging loops.
- **Context Compaction as Driver:** Agents naturally skip dumping raw output because they already read it in-stream; the compelling rationale to dump into `tmp/` is surviving context compaction during long tasks.
- **Turn-End Distillation:** Separating ephemeral execution scratch from durable memory allows agents to dump raw data freely during the task without fear of polluting durable records, then distill or copy findings at turn conclusion. Do not frame scratch lifetime as a prohibition ("do not use") which scares agents away from dumping reusable data; frame it as a durability caveat ("do not rely on for cross-session storage").

---
name: time-machine
description: Operational rule governing reversibility. MUST call before modifying files, databases, or system environments.
---

# Time machine

It is better to have reversibility and verifiability ready than to need them when it is already too late.

## Reversibility

An unclean worktree mixes previous work, user edits, and future modifications.

Proceed if existing work is:

- user preparations
- unrelated to the current task
- intermediate work for the current task

Otherwise, propose committing existing work. Proceed whether the proposal is accepted or rejected.

If a mid-task checkpoint would materially improve safety, suggest committing the current state before proceeding.

### Hard-to-recover changes

Establish recovery before changing:

- Existing files untracked or ignored by Git.
- Existing files outside the repository.
- Remote databases.

Disposable temporary files and read-only inspection are excluded.

Try in sequence:
 - temporary files or disposable copies when they suffice
 - create backup copies for files and external states
 - record current state and build rollback procedures only if it guarantees restoration

If none ensures recovery, stop and report.

## Verifiability

For nontrivial tasks, record a baseline of the original behavior and state (e.g., build output or a reusable test script) when it helps assess the current state, discover undisclosed bugs, or provide a benchmark for post-work comparison. A baseline does not require a full suite.

Skip baseline recording for trivial changes or mode restrictions.

### System changes

Use rootless Docker when modifying system configurations, services and packages. Check availability with `docker info --format '{{.SecurityOptions}}'` and confirm `name=rootless` is present. If unavailable, do not fall back to rootful Docker or the host, but choose a solution that avoids system changes. If none works, stop and explain to user.

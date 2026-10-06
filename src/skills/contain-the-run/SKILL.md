---
name: contain-the-run
description: Use rootless Docker for execution that causes hard-to-recover changes or needs an application, dependency, or runtime absent from the host.
---

# Contain the run

A hard-to-recover change cannot be undone by reverting Git edits or rerunning local build/install commands. Examples include unbacked untracked or ignored files, files outside the repository, global/system configuration, installed system packages, services, and remote databases.

Run a program, script, test, build, or installer in rootless Docker rather than on the host when it causes such a change, or when observing an application, dependency, or runtime not installed on the host.

Check availability with `docker info --format '{{.SecurityOptions}}'`; `name=rootless` must be present.

If rootless Docker is unavailable, do not run the step on the host or use rootful Docker. State what you would run and why, then wait for user instruction. Isolation does not expand the user's authorization or override preparation modes.

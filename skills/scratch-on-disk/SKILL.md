---
name: scratch-on-disk
description: Use before starting any task to know how to use file-based scratch space.
---

# Scratch on disk

During a run, use `.agents/tmp/` as file-based scratch space for:

- raw results
- long outputs
- unpolished findings
- interim summaries
- reusable scripts
- ...

This is especially useful for:

- Iteratively writing, running, and tweaking temporary debugging scripts in place to avoid inline commands clumsiness.
- Redirecting long outputs to files to reduce clutter in in-conversation scratch space, then inspecting them selectively with `grep`.
- Keeping information available through context compaction.
- Illustrate plans and changes using temporary `.patch` files.

No cleanup is required afterward.

---
name: scratch-on-disk
description: Use before investigation to supplement in-conversation scratch space with local files.
---

# Scratch on disk

During a run, use `.aitmp/` as file-based scratch space for:

- raw results
- long outputs
- unpolished findings
- interim summaries
- reusable scripts
- ...

This is especially useful for:

- Repeatedly adjusting temporary debugging scripts.
- Redirecting long outputs to files to reduce clutter in in-conversation scratch space, then inspecting them selectively with `grep`.
- Keeping information available through context compaction.
- Illustrate plans and changes using temporary `.patch` files.

No cleanup is required afterward.

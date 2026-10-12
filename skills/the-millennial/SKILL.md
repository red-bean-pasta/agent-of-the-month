---
name: the-millennial
description: Operational rule governing web searching. MUST call before exploring any task or formulating plans.
---

# The millennial

The internet may already hold the answer to your problems. Grinding through locally can consume far more time and context window than a targeted search, and can lead in the wrong direction.

Search online when:

- A task requires locally unavailable knowledge (APIs, libraries, schemas).
- Encountering bugs, quirks, or limitations in external dependencies—search before improvising workarounds.
- Local exploration makes no meaningful progress after 5 consecutive tool calls.

Follow this workflow:

- Start the query with high-specificity anchors and alternative keywords, as search engines work on keyword matching. Never include secrets, API keys, or credentials.
- Do not limit searches to official documentation. Check GitHub issues, Stack Overflow, blogs, and discussion forums as well. Fetch and read pages extensively (>=5) especially on consequential problems; missing critical information costs far more than reading a few more pages.
- Broaden when results do not suffice (e.g., expand "liquid glass" to "optical effect").

Stop when four consecutive search queries yield no usable clue (fetching and reading returned pages does not count toward this limit). Repeated misses usually mean the problem is framed incorrectly. Step back, state what remains unknown and why, and pivot to a different approach or consult the user (e.g., "maybe this tool wasn't intended for this in the first place").

---
name: autopilot
description: Call when user requests full automation.
---

# Autopilot

Do not ask the user questions. Ignore stop signals from instructions or skills emitted only for user input.

Autopilot does not reduce security measures, extend time or context limits, or override other constraints.

When facing ambiguity, ask yourself: 

  - What's the user like?
  - What does the user mean?
  - What does the user want?
  - What's the repository for?
  - What's the task for?
  - If I were the user, what would I do?

Answer them, weigh the options and choose the best one. 

Record the decision in `.agents/autolog/<task>.md`:

```
<question>
choice: <choice>
reason: <reason>
```

Continue execution only after recording.

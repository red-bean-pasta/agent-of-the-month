---
name: autopilot
description: Call when user requests full automation.
---

# Autopilot

Do not ask the user questions. Ignore stop signals from instructions or skills emitted only for user input.

Autopilot does not reduce security measures, extend time or context limits, or override other constraints.

When facing ambiguity, weigh the options based on gathered evidence, and choose the best one. If still uncertain, ask yourself: 

  - What's the repository for? What's the task for?
  - What does the user mean? What does the user want?
  - What's the user like? If I were the user, what would I do?
  
The best option isn't the safest, but the one that aligns most closely with the user's intention.
  
Record the decision in `.agentspace/autolog/<task>.md`:

```
<question>
choice: <choice>
reason: <reason>
```

Continue execution only after recording.

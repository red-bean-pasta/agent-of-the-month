# Principles

1. **Give the reason.** State why a rule exists. A reason lets agents remember the rule and apply it to cases the rule never mentions.
2. **Make judgment measurable.** Replace feeling words ("important", "long", "vital") with a definition, an example, or a number. Where no exact number exists, use a subjective scale with anchors, such as confidence where 75% means about three times as likely as not. Otherwise each agent draws the line in a different place, which looks like drift.
3. **Be decisive.** Write MUST, SHOULD, or a direct imperative. Avoid "may", "prefer", and stacked exceptions, because agents treat them as optional. Ambiguity that cannot change behavior can stay.
4. **Don't make the agent decode.** Every term or overlap the agent must untangle costs effort and invites divergence. Define a term once and reuse it, and give each rule one home.
5. **Keep the core small, load the rest on demand.** Instruction cost is roughly size times how often it loads, so always-loaded text covers ordinary tasks only. Specialized workflows load when their trigger fires.
6. **Test instructions by behavior.** Judge an instruction by the actions it produces, not by how it reads. Include the false-positive case, where the agent should change nothing.
7. **Batch the bookkeeping.** Encourage summaries and documentation at the end of the Q&A turn, not mid-task. Mid-task bookkeeping interrupts the work, and at the end the agent knows what mattered.
8. **Write it down, don't hold it.** Record findings, intent, and outcomes in files, not in reasoning or the chat. Files survive the session and the next agent can read them. Reasoning and chat do not survive.

---
name: the-supreme-court
description: Use when evaluating rules and skills.
---

# The supreme court

## Skills vs. AGENTS.md

Rules in `AGENTS.md` can often move into skills with suitable trigger descriptions:

- skills offer better modularity but introduce selection burden: missed activation, excessive activation, and conflicting procedures
- `AGENTS.md` is always present but adds clutter to the context

Useful boundary:

- `AGENTS.md`: invariants that apply to every turn, such as “reply in Esperanto”
- skills: procedures that apply to a particular trigger or situation

Frequent use may reinforce a skill's vocabulary and procedure; even frequently used skills may fade from attention during difficult work.

## Evaluate the rules

Rules compete with debugging, changing requirements, and accumulated scratch work. Being in context ≠ being attended to ≠ being obeyed.

1. **Don't make the agent decode.** Subjective and overloaded terms often require inference. This invites divergent interpretations and makes it unclear what would satisfy the rule.
2. **Give the reason.** A reason helps agents remember, internalize, and generalize a rule.
3. **Make judgment measurable and decisive.** Judgment requires considerable inference. An explicit number does not establish calibration or usefulness. Assess whether the criterion produces a useful next action.
4. **Make rules easy to follow.** Use concrete steps when they reduce interpretation. Allow judgment when a fixed sequence would obstruct changed circumstances, especially after unexpected interruptions. Concrete steps ease execution, but can reduce flexibility.
5. **Use examples to clarify.** Examples help agents understand and remember abstract terms.
6. **Define applicability instead of giving illustrative lists.** A finite list is easier to follow; an illustrative list requires the agent to interpret a broader category before acting. Do not assume that adding “for example” improves generalization. Examples can explain a concept without replacing the list that defines when a rule applies.
7. **Remove empty talk.** Do not repeat what an agent already knows or follows. Do not add vague instructions such as “write modularly” that give no concrete direction.
8. **Resolve contradictions.** Conflicting rules require considerable inference to reconcile and make both rules harder to interpret.

### Skills

1. Vague triggers become easier to overlook as the skill list or context grows. For example: “after a test exits nonzero” > “when debugging” > “when useful”. A skill's description must use observable triggers to help an agent decide when to load it.
2. A trigger describes the external cause for skill to load. It should not describe a skill's internal mechanism or state. 
3. Distinguish pre-condition hooks from actions in descriptions. For procedural guidance or rules, use phrasing such as `Use before <action> to know <purpose/how to...>`. The word “before” ensures the skill governs the work prior to execution, whereas “when” may trigger it too late. For active behavioral mandates or tools, use imperative verbs such as `Use to query...; Call before...`.
4. Use a memorable name or marker word. It compresses a behavioral pattern into a single recall cue.

If multiple skills share the same trigger, a small lifecycle router can help select work skills and reduce independent selection decisions.

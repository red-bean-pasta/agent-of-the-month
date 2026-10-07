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

Frequent use reinforces a skill's vocabulary and procedure, giving it an effect similar to `AGENTS.md`. Even frequently used skills can fade from attention during difficult work.

## Evaluate the rules

1. **Don't make the agent decode.** Ambiguous or subjective terms require inference, invite divergent interpretations, and cannot be followed objectively.
2. **Give the reason.** A reason helps agents remember, internalize, and generalize a rule.
3. **Make judgment measurable and decisive.** Judgment requires considerable inference, and an agent's attention is limited. Rules compete with debugging, changing requirements, and accumulated scratch work. Being in context ≠ being attended to ≠ being obeyed.
4. **Make rules easy to follow.** Concrete steps are easier to follow, but reduce flexibility, especially when unexpected interruptions occur.
5. **Use examples to clarify.** Examples help agents understand and remember abstract terms.
6. **Use concrete lists instead of illustrative lists.** A finite list is easier to follow; an illustrative list requires the agent to interpret a broader category before acting. Do not assume that adding “for example” improves generalization.
7. **Remove empty talk.** Do not repeat what an agent already knows or follows. Do not add vague instructions such as “write modularly” that give no concrete direction.
8. **Resolve contradictions.** Conflicting rules require considerable inference to reconcile and make both rules harder to interpret.

### Skills

1. **Use concrete, observable triggers.** Vague triggers become easier to overlook as the skill list or context grows. For example: “after a test exits nonzero” > “when debugging” > “when useful”. A skill's description MUST help the agent decide when to load it.
2. **Use a memorable name or marker word.** It compresses a behavioral pattern into a single recall cue—Matt Pocock's “leading word”.

If multiple skills share the same trigger, a small lifecycle router can help select work skills and reduce independent selection decisions.

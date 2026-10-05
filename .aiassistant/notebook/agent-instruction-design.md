# Agent Instruction Design Insights

## 1. Probability Calibration and Anchors
- Raw subjective percentages (e.g., 50%, 70%) lead to calibration drift across agent sessions because LLMs treat them as qualitative sentiments rather than mathematical probabilities.
- Anchoring probabilities with discrete odds and counter-argument checks (e.g., $75\% \approx 3:1$ odds: "able to name one interpretation judged 3x more likely than all alternatives combined") converts vague feelings into concrete reasoning hurdles in chain-of-thought.

## 2. Decisive Directives vs. Passive Double Negatives
- Phrasing such as "is not discouraged" or "it's encouraged" creates hesitation and inconsistent adherence.
- Conditional `SHOULD` with explicit quantitative triggers (e.g., `SHOULD use web search when manual local inspection would exceed 10 tool calls`) provides reliable execution without stacking meta-definitions.

## 3. Autonomous Git Operations
- Agents should not perform autonomous git commits mid-task. Unfinished code can pollute git history, trigger CI/pre-commit failures, or accidentally stage uncommitted user edits.
- Commits require user permission, while mid-task checkpoints can be executed via conceptual work slices or proposed as permission checkpoints.

## 4. Bounded Investigation and Question Asking
- Clarification questions must follow a stopping rule: only ask when material uncertainty cannot be inferred with $\ge 75\%$ confidence. Asking questions on routine implementation decisions leads to user fatigue.

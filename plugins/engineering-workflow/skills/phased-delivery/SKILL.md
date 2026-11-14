---
name: phased-delivery
description: Deliver a project one phase at a time with a mandatory short STOP report and a suggested commit message. Use when a repo has a plan or phase list, when the user says "start phase N", "continue", "finish this phase", or asks for a summary or commit message.
---

# Phased delivery

Work in small, reviewable phases. The user stays in control of scope and of what gets committed.

## Rules

1. **Read the plan section for the phase first.** The plan file (e.g. `PROJECT_PLAN.md`) is the source of truth for scope. If the plan and `CLAUDE.md` disagree, the plan wins.
2. **One phase at a time.** Do not start the next phase until the user says so.
3. **No silent decisions.** If a choice is not covered by the plan or an ADR, ask, with a recommended answer. Small reversible choices can be made and listed in the report.
4. **No new dependencies without a one-line reason** in the report.
5. **Correctness beats features.** If you cannot verify a behavior (a calculation, a rule, a date), say so and do not ship it as done.
6. **Keep the plan current.** If a decision changes the plan, update the plan. If it is architectural, record an ADR (`domain-modeling` skill).
7. **Do not commit or push on your own.** Follow the project's git rules. If none exist, propose and wait.

## Before starting

- Restate the phase goal and done-criteria in two lines.
- List the files you expect to touch. If more than ~10, say why.
- Surface blockers and questions now, not at the end.

## During

- Batch steps; stop mid-phase only when a decision is needed.
- Run typecheck, lint and tests before declaring done. Report what you actually ran.

## STOP report (max ~10 lines)

```
Phase N: <name>: done
Did:        <2-3 lines>
Changed:    <files or areas, grouped>
Verified:   <commands run and result>
Deviations: <from the plan, or "none">
Open:       <decisions needed from you>
New deps:   <name: reason, or "none">
Commit msg: <one short imperative line>
```

Results, decisions needed, and anything surprising. No line-by-line walkthrough unless asked.

## Commit message

One short imperative line, human voice, no body unless needed, no tool attribution or trailers. Example: `Add tithi crossing finder with fixtures`.

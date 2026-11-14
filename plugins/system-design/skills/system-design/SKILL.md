---
name: system-design
description: Design or review a system, feature architecture or scaling plan from requirements, with explicit trade-offs and a decision log. Use for "design X", "how would this scale", architecture reviews, ADR-worthy decisions, or system design interview practice.
---

# System design

Reason from requirements, not from a remembered architecture. Every box in the final design must trace to a requirement or a measured bottleneck. If it doesn't, remove it.

## Modes

- **Design mode** (default): produce the design yourself, asking only about requirements that change the design.
- **Coach mode** (the user says "practice", "interview", "quiz me", "teach me"): do not give the architecture. Ask the user to make each decision and defend it, then critique it. Reveal your own answer only at the end or if asked.

## Method (do the steps in order, skip none, keep each short)

1. **Requirements.** Who uses it, what do they do. Separate **functional** (what it does) from **non-functional** (latency, availability, consistency needs, durability, security, cost, team size, time to ship). Ask about the two or three that most change the design. State assumptions for the rest.
2. **Scale estimate.** Users, requests/s (average and peak), data size per record, growth, read/write ratio. Use `references/estimation.md`. Show arithmetic. Decide whether one machine and one database is enough. Often it is.
3. **API.** The handful of operations that matter, with request/response shapes and idempotency needs.
4. **Data model.** Entities, keys, relationships, the queries each access pattern needs, and what must be consistent.
5. **High-level architecture.** Smallest design that meets steps 1-2. Name each component's single job.
6. **Data flow.** Walk the two or three critical paths (a write, a read, a failure) through the design.
7. **Bottlenecks.** Where does it break first at 10x? Find it by estimate, not instinct.
8. **Caching, scaling, async.** Add only what step 7 justifies. Use `references/tradeoffs.md`.
9. **Reliability.** Failure modes, timeouts, retries with backoff and jitter, idempotency, backups, what degrades gracefully.
10. **Security.** AuthN/AuthZ model, data sensitivity, trust boundaries, secrets.
11. **Observability.** Logs with request ids, the few metrics that say it's healthy, alerts that mean action.
12. **Trade-offs.** For each major choice: the alternative rejected and why, what you give up, and what would make you revisit it.

## Output template

```
# <System>: design
## Requirements   (functional / non-functional / assumptions)
## Estimates      (numbers + arithmetic)
## Design         (diagram or list of components, data model, key flows)
## Decisions
| Decision | Chosen | Rejected | Why | Revisit when |
## Risks & open questions
```

Record irreversible or expensive-to-change decisions as ADRs (see `engineering-workflow:domain-modeling`, which defines the ADR format).

## Rules of thumb

- Start with a modular monolith and one relational database. Split when a measured problem says to, not for fashion.
- Prefer boring, widely understood technology unless a requirement rules it out.
- Make writes idempotent before making them fast.
- Never cache what you cannot invalidate. Define the invalidation story first.
- A queue buys decoupling and burst absorption and costs you ordering, duplicate delivery and debugging difficulty. Say which you need.
- "Eventually consistent" is a product decision. Ask what the user sees in the gap.
- Say plainly when you are unsure, and what number or experiment would settle it.

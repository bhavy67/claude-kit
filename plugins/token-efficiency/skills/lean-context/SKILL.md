---
name: lean-context
description: How to keep Claude Code context small. Use when writing or reviewing CLAUDE.md, skills, subagents or MCP config, before adding a new rule file, or when a session feels slow, expensive or forgetful.
---

# Lean context

Every token that loads before the user types is paid on every turn. The goal is not a small repo of rules, it is that each loaded token changes behavior.

## What loads when

| Thing | Loaded | Cost model |
|---|---|---|
| `CLAUDE.md` (user, project, subdirectories you touch) | Always, in full | Paid every turn |
| Skill `name` + `description` | Always | Small each, adds up across many skills |
| Skill body and its files | Only when the skill is used | Pay on use |
| Skill with `disable-model-invocation: true` | Only when the user invokes it | Near zero until then |
| MCP server tool definitions | Always, per server | Often the biggest hidden cost |
| Tool output (file reads, logs, search) | When produced, then stays | Grows the session |

Measure instead of guessing: `/context` in a session, `claude plugin details <name>` for a plugin's projected cost, `/audit-context` for a project.

## Where each kind of content belongs

- **Applies to every task, short, stable** → `CLAUDE.md`. Examples: git rules, how to run tests, one-line architecture pointer.
- **A procedure used sometimes** → a skill. Examples: release checklist, migration steps, review format.
- **Reference material** → a file inside the skill (`references/…`) that the skill body points to. Claude reads it only when needed.
- **History, status, "what shipped in phase 6"** → docs or the git log. Never `CLAUDE.md`. It goes stale and is paid for every turn.
- **Things Claude can read from the code** (file layout, function names) → delete. It will look.
- **Gotchas learned the hard way** → keep only those that bite repeatedly, one line each, with the fix.

## Writing `CLAUDE.md`

1. Target under ~100 lines. Past ~150, split by moving procedures to skills.
2. Write rules as instructions, not narrative. "Run `pnpm test` before finishing" beats a paragraph about testing philosophy.
3. Cut anything Claude does correctly without being told. Test by deleting a line and seeing if behavior changes.
4. Point to docs instead of pasting them: "Plan: `PROJECT_PLAN.md`".
5. Don't duplicate across files. The same rulebook copied into three repos drifts in three directions. Put it in one skill and install that.

## Writing skills that are cheap and get triggered

- Description = **what it does + when to use it**, under ~40 words, with the trigger words a user would actually say.
- Keep `SKILL.md` under ~150 lines. Route to `references/*.md` with a table of "if X, read Y".
- Skills that are workflows the user starts on purpose (`/grill`, `/release`) get `disable-model-invocation: true`.
- One skill, one job. A skill that tries to cover a whole domain never loads the right part.

## Habits that save the most

- **Subagents for exploration.** "Find every caller of `fetchRetry`" in a subagent returns a paragraph, not 40K tokens of file reads.
- **`/clear` between unrelated tasks.** Old context is pure cost and can mislead.
- **`/compact` with a focus note** on long sessions ("keep the API decisions and the failing test").
- **Read ranges, not whole files**, and grep before reading.
- **Cheaper model for routine edits**, the strongest one for design and hard debugging.
- **Turn off MCP servers a project doesn't use.** Prefer a CLI the model already knows (`gh`, `psql`) over an MCP server that wraps it.
- **Plan first on big tasks**, so work isn't redone after a wrong turn.

## Review checklist

- [ ] Every `CLAUDE.md` under ~150 lines, no status or history sections
- [ ] No rule that duplicates another file, skill or the code
- [ ] Skill descriptions state a trigger; workflow skills are user-invoked only
- [ ] No unused MCP servers
- [ ] Large reference docs live in `references/`, not in `SKILL.md`

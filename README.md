# claude-kit

Reusable Claude Code setup: a plugin marketplace plus global rules. Install once, reuse in every project.

## Plugins

| Plugin | What it gives you |
|---|---|
| `core` | Git guard hook: blocks Claude attribution lines in commits/PRs, force-push, `reset --hard`, `branch -D`, `stash drop`; asks before any `git push` |
| `engineering-workflow` | grilling, grill-with-docs, tdd, code-review, codebase-design, domain-modeling (ADRs), improve-codebase-architecture, implement, phased-delivery |
| `frontend-ui` | web-app-playbook (20-section rulebook router), ui-design-system, shadcn |
| `backend-api` | api-design, database-design |
| `system-design` | system-design method, estimation and trade-off references |
| `token-efficiency` | lean-context skill, `/audit-context` |

## Install

```
/plugin marketplace add bhavy67/claude-kit
/plugin install core@claude-kit
/plugin install engineering-workflow@claude-kit
```

Install only what a project needs. Enable per project so cloud sessions get them too, in `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-kit": { "source": { "source": "github", "repo": "bhavy67/claude-kit" } }
  },
  "enabledPlugins": {
    "core@claude-kit": true,
    "engineering-workflow@claude-kit": true
  }
}
```

Suggested sets: web app → core, engineering-workflow, frontend-ui, token-efficiency. API → core, engineering-workflow, backend-api, system-design.

## Global rules (once per machine)

```
./scripts/install-global.sh --dry-run
./scripts/install-global.sh
```

Merges into `~/.claude`: blank commit/PR attribution, a deny list for destructive git and secret files, and a short `CLAUDE.md` block between `claude-kit` markers. Idempotent, makes timestamped backups, needs `jq`.

## Token cost

Skill bodies load only when used; only names and descriptions load each turn. The expensive thing is a large `CLAUDE.md`. Run `/audit-context` in a project, and `claude plugin details <name>` for a plugin's projected cost.

## Validate

```
claude plugin validate .
```

## Credits

See `NOTICE.md`. License: MIT.

---
description: Create a lean CLAUDE.md and project settings for this repo from the claude-kit template
allowed-tools: Read, Write, Bash(ls:*), Bash(git ls-files:*)
---

1. Inspect the repo: `package.json` scripts, lockfile (npm/pnpm/yarn), framework, test runner, existing `CLAUDE.md`. If a `CLAUDE.md` exists, do not overwrite it; propose edits to shorten it using the `lean-context` skill.
2. Read `${CLAUDE_PLUGIN_ROOT}/templates/CLAUDE.md` and fill it with real commands and real rules you found. Leave a placeholder only where the repo gives no answer, and list those as questions.
3. Keep it under ~100 lines. Do not copy status or history.
4. Show the draft and wait for approval before writing the file.
5. Offer a `.claude/settings.json` that enables the claude-kit plugins this project needs (see the README snippet).

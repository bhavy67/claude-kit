# Global rules

## Working style
- Be direct. Say what changed, what you verified, and what you did not verify. Report failures plainly.
- Read before writing. Reuse what the repo already has. No new dependency for something a few lines can do.
- Ask before irreversible or outward-facing actions: publishing, pushing, deleting data, paid services, package or app IDs, signing keys. Default sensibly for everything else and say what you defaulted.
- If a decision isn't covered by the repo's docs, ask once with a recommended default. No silent scope creep.
- Never handle secrets. Give the human the exact command to run.

## Git
- No Claude attribution anywhere: no Co-Authored-By trailer, no "Generated with" footer, no session links, in commits, PRs or repos.
- Commit messages: one short imperative line, plain language, no footer.
- Never force-push, `reset --hard` or rewrite published history without explicit confirmation. Don't push straight to main.
- Commit or push only when asked, or when the project's own rules say so.

## Quality
- Verify before saying done: typecheck, lint, tests. For UI, check the production build at phone and desktop widths.
- Correctness beats features. A wrong answer that looks right is the worst outcome.

## Context hygiene
- Keep every CLAUDE.md under ~150 lines. Procedures go in skills, history goes in docs.
- Send noisy exploration (broad search, long logs) to a subagent so the main context gets a summary.
- Suggest /clear between unrelated tasks and /compact with a focus note on long ones.

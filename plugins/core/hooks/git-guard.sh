#!/usr/bin/env bash
# claude-kit core: PreToolUse(Bash) guard.
# Reads the hook JSON on stdin and matches against the raw text, so it needs nothing beyond grep.
#   exit 2        -> blocked, the message on stderr is shown to Claude
#   JSON "ask"    -> Claude Code prompts the user before running the command
#   exit 0        -> allowed

input=$(cat)

has() { printf '%s' "$input" | grep -Eqi -- "$1"; }
has_cs() { printf '%s' "$input" | grep -Eq -- "$1"; }  # case-sensitive: git branch -d (safe) vs -D (force)
deny() { printf 'claude-kit git-guard: %s\n' "$1" >&2; exit 2; }
ask() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"claude-kit git-guard: %s"}}\n' "$1"
  exit 0
}

# Fast path: nothing to do unless the command touches git or gh.
has '(^|[^a-z])(git|gh)[ "]' || exit 0

# 1. No Claude attribution in commits, PRs, issues or releases (user rule, applies to every repo).
if has 'git +(commit|tag)|gh +(pr|issue|release)'; then
  if has 'co-authored-by: *claude|generated with \[?claude|claude\.ai/code/session|noreply@anthropic\.com'; then
    deny "attribution lines (Co-Authored-By: Claude, 'Generated with Claude', session links) are not allowed. Rewrite the message without them."
  fi
fi

# 2. Destructive git commands are never run automatically.
has 'git +push[^;&|]*( --force| -f( |"|$)|--force-with-lease|--mirror)' && deny "force push is blocked. Ask the user to run it themselves."
has 'git +push[^;&|]*--delete|git +push +[^ ;&|]+ +:[^ ;&|]' && deny "deleting remote branches or tags is blocked. Ask the user to run it themselves."
has 'git +reset +[^;&|]*--hard' && deny "git reset --hard discards work. Ask the user first."
has 'git +clean +-[a-z]*f' && deny "git clean -f deletes untracked files. Ask the user first."
has_cs 'git +branch +-D' && deny "git branch -D force-deletes a branch. Ask the user first."
has 'git +stash +(drop|clear)' && deny "dropping stashes loses work. Ask the user first."
has 'git +(checkout|restore) +(-- +)?\.([ "]|$)' && deny "this discards all uncommitted changes. Ask the user first."

# 3. Any push needs a human yes.
has 'git +push' && ask "about to push. Confirm the branch and remote."

exit 0

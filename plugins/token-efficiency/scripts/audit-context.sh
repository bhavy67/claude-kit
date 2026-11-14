#!/usr/bin/env bash
# Estimates what a project loads into context before you type anything.
# Token estimates are bytes/4, good enough to rank offenders. Use /context for exact numbers.
# Usage: audit-context.sh [project_dir]
set -uo pipefail
dir="${1:-.}"; cd "$dir" || exit 1
home="${CLAUDE_HOME:-$HOME/.claude}"
est() { echo $(( ($1 + 3) / 4 )); }
flag() { local t=$1 warn=$2; (( t > warn )) && echo "  <-- over ${warn}" || true; }

echo "== Always-loaded instructions (CLAUDE.md) =="
total=0
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  b=$(wc -c < "$f"); t=$(est "$b"); total=$((total + t))
  printf '%7s tok  %s%s\n' "$t" "$f" "$(flag "$t" 2000)"
done < <({ echo "$home/CLAUDE.md"; find . -maxdepth 3 \( -name node_modules -o -name .git \) -prune -o \( -name CLAUDE.md -o -name CLAUDE.local.md -o -name AGENTS.md \) -print; } | sort -u)
printf '%7s tok  TOTAL instructions\n\n' "$total"

echo "== Skills: description cost (loaded every turn) vs body (loaded on use) =="
dtot=0; n=0
for sk in .claude/skills/*/SKILL.md "$home"/skills/*/SKILL.md; do
  [[ -f "$sk" ]] || continue
  name=$(awk -F': *' '/^name:/{print $2; exit}' "$sk")
  desc=$(awk '/^description:/{sub(/^description: */,""); print; exit}' "$sk")
  hidden=$(grep -c '^disable-model-invocation: *true' "$sk" || true)
  dt=$(est ${#desc}); bt=$(est "$(wc -c < "$sk")")
  [[ "$hidden" -gt 0 ]] && dt=0
  dtot=$((dtot + dt)); n=$((n + 1))
  printf '%7s tok desc | %7s tok body | %s%s\n' "$dt" "$bt" "${name:-$sk}" "$([[ $hidden -gt 0 ]] && echo ' (user-invoked only)')"
done
(( n == 0 )) && echo "  (no project or user skills found; plugin skills are measured with: claude plugin details <name>)"
printf '%7s tok  TOTAL skill descriptions (%s skills)\n\n' "$dtot" "$n"

echo "== MCP servers (each adds tool definitions to context) =="
if [[ -f .mcp.json ]]; then
  c=$(grep -c '"command"\|"url"' .mcp.json || true); echo "  .mcp.json: $c server(s). Disable ones this project doesn't use."
else echo "  none in .mcp.json"; fi
echo

echo "== Verdict =="
grand=$((total + dtot))
printf '  ~%s tokens of fixed overhead from instructions + skill descriptions.\n' "$grand"
(( total > 2000 )) && echo "  - CLAUDE.md is heavy: move procedures to skills and history to docs; keep rules that apply to every task."
(( dtot > 1500 )) && echo "  - Skill descriptions are heavy: shorten them or mark rarely used skills disable-model-invocation: true."
(( total <= 2000 && dtot <= 1500 )) && echo "  - Looks lean."
exit 0

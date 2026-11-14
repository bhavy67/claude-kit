#!/usr/bin/env bash
# Installs the kit's global rules into ~/.claude (or $CLAUDE_HOME).
#   - settings.json: merges attribution and the deny list. Existing keys and rules are kept.
#   - CLAUDE.md: adds the kit's block between markers. Safe to re-run (it replaces its own block only).
# Usage: scripts/install-global.sh [--dry-run]
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${CLAUDE_HOME:-$HOME/.claude}"
dry=0; [[ "${1:-}" == "--dry-run" ]] && dry=1

command -v jq >/dev/null || { echo "jq is required (brew install jq / apt install jq)"; exit 1; }
mkdir -p "$dest"

# ---- settings.json ----
settings="$dest/settings.json"
[[ -f "$settings" ]] || echo '{}' > "$settings"
jq empty "$settings" 2>/dev/null || { echo "$settings is not valid JSON, fix it first"; exit 1; }
merged="$(jq -s '
  .[0] as $cur | .[1] as $kit
  | $cur
  | .attribution = ($kit.attribution)
  | .permissions = ((.permissions // {}) | .deny = ((.deny // []) + $kit.permissions.deny | unique))
' "$settings" "$here/global/settings.json")"

# ---- CLAUDE.md ----
md="$dest/CLAUDE.md"
start='<!-- claude-kit:start -->'; end='<!-- claude-kit:end -->'
block="$start
$(cat "$here/global/CLAUDE.md")
$end"
if [[ -f "$md" ]] && grep -qF "$start" "$md"; then
  newmd="$(awk -v s="$start" -v e="$end" -v b="$block" '
    $0==s {print b; skip=1; next}
    $0==e {skip=0; next}
    !skip {print}' "$md")"
elif [[ -f "$md" ]]; then
  newmd="$(cat "$md")

$block"
else
  newmd="$block"
fi

if (( dry )); then
  echo "--- $settings (would become) ---"; echo "$merged"
  echo "--- $md (would become) ---"; echo "$newmd"
  exit 0
fi

stamp="$(date +%Y%m%d-%H%M%S)"
[[ -f "$settings" ]] && cp "$settings" "$settings.bak-$stamp"
[[ -f "$md" ]] && cp "$md" "$md.bak-$stamp"
printf '%s\n' "$merged" > "$settings"
printf '%s\n' "$newmd" > "$md"
echo "Installed to $dest (backups: *.bak-$stamp)"

---
description: Measure what this project loads into context every turn and recommend cuts
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/audit-context.sh:*)
---

Run `${CLAUDE_PLUGIN_ROOT}/scripts/audit-context.sh .` and show the output.

Then, using the `lean-context` skill, give at most five concrete cuts ordered by tokens saved. For each one name the file, what to move or delete, and where it should live instead. Do not edit anything until the user agrees.

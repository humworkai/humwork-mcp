#!/bin/bash
# NOTE: PreToolUse cannot inject non-blocking context into the model — it only
# supports allow/deny. So the stderr message below reaches neither the model nor
# the user on exit 0 (it lands in the debug log only). Do NOT "fix" this back to
# exit 2 to make it visible — that would BLOCK the edit. The model-facing nudge
# lives in track-edit.sh (PostToolUse) and check-escalation.sh (Stop), which can
# surface additionalContext + systemMessage without blocking. This script is kept
# as a near no-op for now; safe to delete.
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

state_file="/tmp/humwork_edits_${session_id}"
attempted_file="/tmp/humwork_attempted_${session_id}"

# No edit history, allow edit
if [ ! -f "$state_file" ]; then
  exit 0
fi

# If consult_expert was already attempted, allow edit
if [ -f "$attempted_file" ]; then
  exit 0
fi

# Count total edits across all files
total_edits=$(wc -l < "$state_file" | tr -d ' ')

# If fewer than 2 rejected edits, allow edit (2 rejections = 3 total attempts including initial)
if [ "$total_edits" -lt 2 ]; then
  exit 0
fi

# 3+ re-edits to the same files, no consult_expert attempted — suggest (non-blocking)
echo "You have re-edited the same files $total_edits times after feedback. Consider calling consult_expert to get guidance from a human expert. Include what you tried and the feedback you received." >&2
exit 0

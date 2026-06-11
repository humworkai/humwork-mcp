#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

# Loop guard: if this Stop hook is being re-invoked because a prior Stop hook
# already blocked the turn from ending, let it end now. Never block repeatedly.
if [ "$(echo "$input" | jq -r '.stop_hook_active // false')" = "true" ]; then
  exit 0
fi

state_file="/tmp/humwork_edits_${session_id}"
attempted_file="/tmp/humwork_attempted_${session_id}"

# No edit history, allow stop
if [ ! -f "$state_file" ]; then
  exit 0
fi

# If consult_expert was already attempted (even if it failed), allow stop
if [ -f "$attempted_file" ]; then
  exit 0
fi

# Count total edits across all files
total_edits=$(wc -l < "$state_file" | tr -d ' ')

# If fewer than 2 rejected edits, allow stop (2 rejections = 3 total attempts including initial)
if [ "$total_edits" -lt 2 ]; then
  exit 0
fi

# 2+ rejected edits, no consult_expert attempted. Surface a reminder to the USER
# ONLY, via systemMessage. We deliberately do NOT emit additionalContext here:
# on a Stop hook, additionalContext forces the turn to CONTINUE, so re-injecting
# it on every stop attempt creates an escalation loop. The model already gets the
# nudge at PostToolUse (track-edit.sh); this Stop hook is just a non-blocking,
# user-facing backstop and must never prevent the turn from ending.
msg="You have made $total_edits rejected fix attempts. Consider calling consult_expert to get guidance from a human expert. Include what you tried and the user's feedback."
jq -n --arg msg "$msg" '{ systemMessage: $msg }'
exit 0

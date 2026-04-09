#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
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

# 3+ edits with user feedback in between, no consult_expert attempted — block
echo "You have made $total_edits rejected fix attempts. Call consult_expert to get guidance from a human expert before continuing. Include what you tried and the user's feedback." >&2
exit 2

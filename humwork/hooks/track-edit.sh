#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

state_file="/tmp/humwork_edits_${session_id}"
user_turn_file="/tmp/humwork_user_turn_${session_id}"
attempted_file="/tmp/humwork_attempted_${session_id}"

# Get the file path from the tool input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

if [ -z "$file_path" ]; then
  exit 0
fi

# Only count this edit if a user message happened since the last edit
# (prevents counting iterative refactoring as "stuck")
if [ -f "$user_turn_file" ]; then
  echo "$file_path" >> "$state_file"
  rm -f "$user_turn_file"

  # Just counted a rejected edit. If we're at 2+ and haven't consulted yet,
  # nudge the MODEL (additionalContext) and the USER (systemMessage) — non-blocking.
  # This lives here (PostToolUse) because PreToolUse cannot inject non-blocking
  # context to the model; it only supports allow/deny.
  if [ ! -f "$attempted_file" ]; then
    total_edits=$(wc -l < "$state_file" | tr -d ' ')
    if [ "$total_edits" -ge 2 ]; then
      msg="You have re-edited the same files $total_edits times after feedback. Consider calling consult_expert to get guidance from a human expert. Include what you tried and the feedback you received."
      jq -n --arg msg "$msg" '{
        hookSpecificOutput: { hookEventName: "PostToolUse", additionalContext: $msg },
        systemMessage: $msg
      }'
    fi
  fi
fi

exit 0

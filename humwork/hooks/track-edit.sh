#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

state_file="/tmp/humwork_edits_${session_id}"
user_turn_file="/tmp/humwork_user_turn_${session_id}"

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
fi

exit 0

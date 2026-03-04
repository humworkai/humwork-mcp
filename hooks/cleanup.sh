#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

rm -f "/tmp/humwork_edits_${session_id}"
rm -f "/tmp/humwork_user_turn_${session_id}"
rm -f "/tmp/humwork_attempted_${session_id}"

exit 0

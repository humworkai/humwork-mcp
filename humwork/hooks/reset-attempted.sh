#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

# Agent is editing again after a previous escalation — clear the attempted flag
# so the cycle can restart for the new problem
rm -f "/tmp/humwork_attempted_${session_id}"

exit 0

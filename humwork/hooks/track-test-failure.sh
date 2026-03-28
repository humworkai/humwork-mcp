#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

# Get the Bash command output (tool_response is the text returned to the model)
tool_response=$(echo "$input" | jq -r '.tool_response // empty')

if [ -z "$tool_response" ]; then
  exit 0
fi

# Check for test/build/lint failure patterns in the output.
# These indicate the agent's previous fix didn't work — same signal as a user rejection.
# We set the user_turn flag so the next edit gets counted toward escalation.
if echo "$tool_response" | grep -qiE \
  '(FAILED|[0-9]+ failed|failures?:[ ]*[1-9]|errors? found|AssertionError|AssertError|build failed|compilation error|npm ERR|exit code [1-9]|exit status [1-9]|ERRORS$|error\[E|error TS[0-9])'; then
  touch "/tmp/humwork_user_turn_${session_id}"
fi

exit 0

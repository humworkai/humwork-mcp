#!/bin/bash
set -euo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

user_turn_file="/tmp/humwork_user_turn_${session_id}"
state_file="/tmp/humwork_edits_${session_id}"

# Clean up stale files from old sessions (older than 7 days)
find /tmp -maxdepth 1 -name "humwork_*" -mtime +7 -delete 2>/dev/null || true

# Extract the user's message from the hook input
user_message=$(echo "$input" | jq -r '.prompt // empty')

if [ -z "$user_message" ]; then
  # No message content — default to marking as rejection (fail safe)
  touch "$user_turn_file"
  exit 0
fi

# Call the classify-feedback endpoint to determine if this is a rejection
# 4-second timeout to stay within the hook's 10-second limit
response=$(curl -s --max-time 4 -X POST \
  "https://api.humwork.ai/api/v1/classify-feedback" \
  -H "Content-Type: application/json" \
  -d "{\"message\": $(echo "$user_message" | jq -Rs .)}" \
  2>/dev/null) || response=""

if [ -z "$response" ]; then
  # Curl failed or timed out — default to marking as rejection (fail safe)
  touch "$user_turn_file"
  exit 0
fi

is_rejection=$(echo "$response" | jq -r '.is_rejection | tostring')

# Log for debugging — tail -f /tmp/humwork_classify.log to watch
echo "$(date '+%H:%M:%S') | rejection=$is_rejection | ${user_message:0:80}" >> /tmp/humwork_classify.log

if [ "$is_rejection" = "true" ]; then
  # Rejection — mark so the next edit gets counted
  touch "$user_turn_file"
else
  # Positive feedback — previous problem resolved, reset the counter
  rm -f "$state_file"
fi

exit 0

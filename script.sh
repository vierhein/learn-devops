#!/bin/bash

ALERTMANAGER_URL="https://alert.test.fiscal.local/api/v2/silences" #TO DO get vars from env
# CACERT_PATH="noogadev.root.cert.pem"
SILENCE_DURATION=10 # Default silence duration in minutes
CREATED_BY="Automation"
COMMENT="Silencing multiple alerts"

declare -a array=("str1=str1" "str3=str3")
declare -A TAGS
for arg in "${array[@]}"; do
  if [[ "$arg" == *=* ]]; then
    TAG_NAME="${arg%%=*}"
    TAG_VALUE="${arg#*=}"
    TAGS["$TAG_NAME"]="$TAG_VALUE"
  else
    SILENCE_DURATION=$arg
  fi
done

MATCHERS=""
for TAG_NAME in "${!TAGS[@]}"; do
  TAG_VALUE=${TAGS[$TAG_NAME]}
  MATCHERS+=$(cat <<EOF
    {
      "name": "$TAG_NAME",
      "value": "$TAG_VALUE",
      "isRegex": false
    },
EOF
  )
done

# Remove comma from the last matcher
MATCHERS="${MATCHERS%,}"

# Get current time and calculate silence end time
START_TIME=$(date --utc +"%Y-%m-%dT%H:%M:%SZ")
END_TIME=$(date --utc -d "+$SILENCE_DURATION minutes" +"%Y-%m-%dT%H:%M:%SZ")

JSON_PAYLOAD=$(cat <<EOF
{
  "matchers": [
    $MATCHERS
  ],
  "startsAt": "$START_TIME",
  "endsAt": "$END_TIME",
  "createdBy": "$CREATED_BY",
  "comment": "$COMMENT"
}
EOF
)

response=$(curl -k -s -w "%{http_code}" -o /dev/null -X POST \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" \
  "$ALERTMANAGER_URL")

if [[ "$response" -eq 200 ]]; then
  echo "Silence created successfully."
else
  echo "Failed to create silence. HTTP status code: $response"
fi

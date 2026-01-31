#!/bin/bash

# Uncomment for debugging
# set -x
set -euo pipefail

#  Required vars
: "${URL:?Must set URL (e.g. https://grafana.example.com)}"
: "${TOKEN:?Must set TOKEN (service account token)}"
: "${APP:?Must set APP (application name)}"
: "${ENV:?Must set ENV (environment name)}"
: "${VERSION:?Must set VERSION}"

# Calculated vars
ACTOR="${ACTOR:-${GITHUB_ACTOR:-$(whoami)}}"
REPO="${REPO:-${GITHUB_REPOSITORY:-unknown}}"
SHA="${SHA:-${GITHUB_SHA:-unknown}}"

# Grafana expects epoch milliseconds
TS_MS="$(date +%s%3N)"

# Normalize URL (remove trailing slash if present)
URL="${URL%/}"

payload="$(cat <<JSON
{
  "time": ${TS_MS},
  "text": "Deployed ${APP} to ${ENV} (version ${VERSION}) by ${ACTOR}",
  "tags": [
    "release",
    "app:${APP}",
    "env:${ENV}",
    "repo:${REPO}",
    "sha:${SHA}"
  ]
}
JSON
)"

resp="$(
  curl -sS -X POST "${URL}/api/annotations" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${payload}"
)"

id="$(echo "$resp" | jq -r '.id // empty')"
msg="$(echo "$resp" | jq -r '.message // empty')"

if [[ -n "$id" && "$msg" == "Annotation added" ]]; then
  echo "Grafana Annotation Success"
else
  echo "Grafana Annotation Failed: $resp"
  exit 1
fi
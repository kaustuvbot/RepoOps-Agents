#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 TASK-0001"
  exit 1
fi

TASK_ID="$1"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OPS_DIR="$REPO_ROOT/docs/ops"
TASK_INDEX="$OPS_DIR/task-index.csv"
HANDOFF_DIR="$OPS_DIR/handoffs"
mkdir -p "$HANDOFF_DIR"

RESULT="$(python3 - <<'PY' "$TASK_INDEX" "$TASK_ID"
import csv
import re
import sys

task_index, task_id = sys.argv[1:]
with open(task_index, newline="") as f:
    for row in csv.DictReader(f):
        if row["id"] == task_id:
            slug = re.sub(r"[^a-z0-9]+", "-", row["title"].lower()).strip("-") or "task"
            print(row["title"])
            print(row["status"])
            print(row["owner"])
            print(row["path"])
            print(slug)
            raise SystemExit(0)
raise SystemExit(f"Task not found: {task_id}")
PY
)"

TITLE="$(printf '%s\n' "$RESULT" | sed -n '1p')"
STATUS="$(printf '%s\n' "$RESULT" | sed -n '2p')"
OWNER="$(printf '%s\n' "$RESULT" | sed -n '3p')"
TASK_REL="$(printf '%s\n' "$RESULT" | sed -n '4p')"
SLUG="$(printf '%s\n' "$RESULT" | sed -n '5p')"
DATE="$(date +%Y-%m-%d)"
HANDOFF_PATH="$HANDOFF_DIR/${TASK_ID}-${SLUG}-${DATE}.md"

cat > "$HANDOFF_PATH" <<EOF
# Handoff

## Task

- ID: ${TASK_ID}
- Title: ${TITLE}
- Status: ${STATUS}
- Owner: ${OWNER}

## Done

- 

## Not Done

- 

## Files To Read First

- \`${TASK_REL}\`

## Next Step

- 
EOF

echo "Created handoff: $HANDOFF_PATH"

#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 TASK-0001"
  exit 1
fi

TASK_ID="$1"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TASK_INDEX="$REPO_ROOT/docs/ops/task-index.csv"
CURRENT_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"

RESULT="$(python3 - <<'PY' "$TASK_INDEX" "$TASK_ID"
import csv
import sys

task_index, task_id = sys.argv[1:]
with open(task_index, newline="") as f:
    for row in csv.DictReader(f):
        if row["id"] == task_id:
            print(row["title"])
            print(row["branch"])
            print(row["path"])
            raise SystemExit(0)
raise SystemExit(f"Task not found: {task_id}")
PY
)"

TITLE="$(printf '%s\n' "$RESULT" | sed -n '1p')"
EXPECTED_BRANCH="$(printf '%s\n' "$RESULT" | sed -n '2p')"
TASK_REL="$(printf '%s\n' "$RESULT" | sed -n '3p')"

if [ -n "$EXPECTED_BRANCH" ] && [ -n "$CURRENT_BRANCH" ] && [ "$CURRENT_BRANCH" != "$EXPECTED_BRANCH" ]; then
  echo "Current branch '$CURRENT_BRANCH' does not match expected branch '$EXPECTED_BRANCH'"
  exit 1
fi

"$REPO_ROOT/plugins/pmops/scripts/close-task.sh" "$TASK_ID" Review >/dev/null
"$REPO_ROOT/plugins/pmops/scripts/audit-board.sh" >/dev/null

cat <<EOF
PR title:
[${TASK_ID}] ${TITLE}

PR body:
## Summary
- Implements ${TASK_ID}: ${TITLE}

## Validation
- [ ] Add validation details here

## Task
- ${TASK_ID}
- Task file: ${TASK_REL}
EOF

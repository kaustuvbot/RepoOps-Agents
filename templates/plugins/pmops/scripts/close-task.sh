#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 TASK-0001 [Review|Done|Blocked|Cancelled]"
  exit 1
fi

TASK_ID="$1"
NEW_STATUS="${2:-Review}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TASK_INDEX="$REPO_ROOT/docs/ops/task-index.csv"

TASK_REL="$(python3 - <<'PY' "$TASK_INDEX" "$TASK_ID" "$NEW_STATUS"
import csv
import sys

task_index, task_id, status = sys.argv[1:]
rows = []
target = None
with open(task_index, newline="") as f:
    reader = csv.DictReader(f)
    fields = reader.fieldnames
    for row in reader:
        if row["id"] == task_id:
            row["status"] = status
            target = row["path"]
        rows.append(row)
if target is None:
    raise SystemExit(f"Task not found: {task_id}")
with open(task_index, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fields)
    writer.writeheader()
    writer.writerows(rows)
print(target)
PY
)"

TASK_PATH="$REPO_ROOT/$TASK_REL"
python3 - <<'PY' "$TASK_PATH" "$NEW_STATUS"
from pathlib import Path
import sys
path, status = sys.argv[1:]
lines = Path(path).read_text().splitlines()
out = []
for line in lines:
    if line.startswith("Status:"):
        out.append(f"Status: {status}")
    else:
        out.append(line)
Path(path).write_text("\n".join(out) + "\n")
PY

echo "Updated $TASK_ID to $NEW_STATUS"

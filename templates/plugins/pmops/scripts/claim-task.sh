#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 TASK-0001 owner-name"
  exit 1
fi

TASK_ID="$1"
OWNER="$2"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TASK_INDEX="$REPO_ROOT/docs/ops/task-index.csv"

RESULT="$(python3 - <<'PY' "$TASK_INDEX" "$TASK_ID" "$OWNER"
import csv
import re
import sys

task_index, task_id, owner = sys.argv[1:]
rows = []
target = None
with open(task_index, newline="") as f:
    reader = csv.DictReader(f)
    fields = reader.fieldnames
    for row in reader:
        if row["id"] == task_id:
            target = row
        rows.append(row)
if target is None:
    raise SystemExit(f"Task not found: {task_id}")
slug = re.sub(r"[^a-z0-9]+", "-", target["title"].lower()).strip("-") or "task"
branch = f"feat/{task_id}-{slug}"
for row in rows:
    if row["id"] == task_id:
        row["status"] = "In Progress"
        row["owner"] = owner
        row["branch"] = branch
with open(task_index, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fields)
    writer.writeheader()
    writer.writerows(rows)
print(branch)
print(target["path"])
PY
)"

BRANCH="$(printf '%s\n' "$RESULT" | sed -n '1p')"
TASK_REL="$(printf '%s\n' "$RESULT" | sed -n '2p')"
TASK_PATH="$REPO_ROOT/$TASK_REL"

if git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git -C "$REPO_ROOT" switch "$BRANCH"
  else
    git -C "$REPO_ROOT" switch -c "$BRANCH"
  fi
fi

python3 - <<'PY' "$TASK_PATH" "$OWNER" "$BRANCH"
from pathlib import Path
import sys
path, owner, branch = sys.argv[1:]
lines = Path(path).read_text().splitlines()
out = []
for line in lines:
    if line.startswith("Status:"):
        out.append("Status: In Progress")
    elif line.startswith("Owner:"):
        out.append(f"Owner: {owner}")
    elif line.startswith("Branch:"):
        out.append(f"Branch: {branch}")
    else:
        out.append(line)
Path(path).write_text("\n".join(out) + "\n")
PY

echo "Claimed $TASK_ID on $BRANCH"

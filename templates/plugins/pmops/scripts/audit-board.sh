#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TASK_INDEX="$REPO_ROOT/docs/ops/task-index.csv"

python3 - <<'PY' "$TASK_INDEX"
import csv
from collections import Counter
import sys

task_index = sys.argv[1]
with open(task_index, newline="") as f:
    rows = list(csv.DictReader(f))

errors = []
ids = [row["id"] for row in rows]
for task_id, count in Counter(ids).items():
    if count > 1:
        errors.append(f"Duplicate task ID: {task_id}")

branches = [row["branch"] for row in rows if row["branch"]]
for branch, count in Counter(branches).items():
    if count > 1:
        errors.append(f"Duplicate branch: {branch}")

all_ids = set(ids)
done_ids = {row["id"] for row in rows if row["status"] == "Done"}

for row in rows:
    if row["status"] == "In Progress" and row["owner"] in {"", "Unassigned"}:
        errors.append(f"{row['id']} is In Progress without an owner")
    dep = row["depends_on"].strip()
    if dep and dep != "none" and dep not in all_ids:
        errors.append(f"{row['id']} depends on missing task {dep}")
    if row["status"] == "Blocked" and dep in done_ids:
        errors.append(f"{row['id']} is Blocked but dependency {dep} is Done")

if errors:
    print("Board audit found issues:")
    for error in errors:
        print(f"- {error}")
    raise SystemExit(1)

print("Board audit passed")
PY

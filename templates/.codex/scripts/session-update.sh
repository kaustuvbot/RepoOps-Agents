#!/usr/bin/env bash

# Finds the active task for the current branch.
# Prints a minimal caveman prompt for Codex to update task Notes.
# Called by hooks.json on SessionStop.

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null)" || exit 0
TASK_INDEX="$REPO_ROOT/docs/ops/task-index.csv"

[ -f "$TASK_INDEX" ] || exit 0

python3 - <<'PY' "$TASK_INDEX" "$BRANCH"
import csv, sys

task_index, branch = sys.argv[1:]

with open(task_index, newline="") as f:
    for row in csv.DictReader(f):
        if row.get("branch") == branch and row.get("status") == "In Progress":
            print(f"[session-update] Active: {row['id']} — {row['title']}")
            print(f"Task file: {row['path']}")
            print("Append to Notes (caveman, max 3 bullets): what changed, what's next, any blockers.")
            print("Also update Linked Files if new files were touched this session.")
            break
PY

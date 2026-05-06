#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 TASK-0001 \"Task title\" [Area] [Priority] [DependsOn]"
  exit 1
fi

TASK_ID="$1"
TITLE="$2"
AREA="${3:-Platform}"
PRIORITY="${4:-Medium}"
DEPENDS_ON="${5:-}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OPS_DIR="$REPO_ROOT/docs/ops"
TASK_TEMPLATE="$OPS_DIR/tasks/TASK_TEMPLATE.md"
TASK_INDEX="$OPS_DIR/task-index.csv"

SLUG="$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
TASK_PATH="$OPS_DIR/tasks/${TASK_ID}-${SLUG}.md"

[ -f "$TASK_TEMPLATE" ] || { echo "Missing $TASK_TEMPLATE"; exit 1; }
[ -f "$TASK_INDEX" ] || { echo "Missing $TASK_INDEX"; exit 1; }
[ ! -f "$TASK_PATH" ] || { echo "Task file already exists: $TASK_PATH"; exit 1; }

python3 - <<'PY' "$TASK_TEMPLATE" "$TASK_PATH" "$TASK_ID" "$TITLE" "$AREA" "$PRIORITY" "$DEPENDS_ON"
from pathlib import Path
import sys

template, output, task_id, title, area, priority, depends_on = sys.argv[1:]
text = Path(template).read_text()
values = {
    "{{TASK_ID}}": task_id,
    "{{TASK_TITLE}}": title,
    "{{STATUS}}": "Todo",
    "{{OWNER}}": "Unassigned",
    "{{AREA}}": area,
    "{{PRIORITY}}": priority,
    "{{BRANCH}}": "",
    "{{DEPENDS_ON}}": depends_on or "none",
    "{{GOAL}}": f"Define the intended outcome for {title}.",
}
for old, new in values.items():
    text = text.replace(old, new)
Path(output).write_text(text)
PY

printf '%s,"%s",Todo,%s,%s,Unassigned,,%s,docs/ops/tasks/%s-%s.md\n' \
  "$TASK_ID" "$TITLE" "$AREA" "$PRIORITY" "$DEPENDS_ON" "$TASK_ID" "$SLUG" >> "$TASK_INDEX"

echo "Created $TASK_PATH"

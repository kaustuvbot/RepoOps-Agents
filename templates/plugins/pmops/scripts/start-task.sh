#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 TASK-0001 owner-name"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

"$REPO_ROOT/plugins/pmops/scripts/claim-task.sh" "$1" "$2"
"$REPO_ROOT/plugins/pmops/scripts/audit-board.sh"

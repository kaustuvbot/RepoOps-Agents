#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PLUGIN_SOURCE="$REPO_ROOT/plugins/pmops"

ensure_codex_cli() {
  if command -v codex >/dev/null 2>&1; then
    return 0
  fi

  if command -v npm >/dev/null 2>&1; then
    echo "Codex CLI not found. Installing with npm..."
    npm install -g @openai/codex
    if command -v codex >/dev/null 2>&1; then
      return 0
    fi
  fi

  cat <<'EOF'
Codex CLI is not available.

Fix:
1. Install Node.js/npm if missing
2. Run: npm install -g @openai/codex
3. Re-run this script
EOF
  exit 1
}

ensure_repo_layout() {
  [ -f "$REPO_ROOT/plugins/pmops/.codex-plugin/plugin.json" ] || {
    echo "Missing plugins/pmops/.codex-plugin/plugin.json — run bootstrap first."
    exit 1
  }
}

ensure_marketplace() {
  local marketplace="$REPO_ROOT/.agents/plugins/marketplace.json"
  if [ ! -f "$marketplace" ]; then
    mkdir -p "$(dirname "$marketplace")"
    cat > "$marketplace" <<'JSON'
{
  "name": "repo-local",
  "interface": { "displayName": "Repo Local Plugins" },
  "plugins": [
    {
      "name": "pmops",
      "source": { "source": "local", "path": "./plugins/pmops" },
      "policy": { "installation": "AVAILABLE", "authentication": "ON_INSTALL" },
      "category": "Productivity"
    }
  ]
}
JSON
    echo "Created .agents/plugins/marketplace.json"
  fi
}

install_repo_local_plugin() {
  local version
  version="$(python3 - <<'PY' "$PLUGIN_SOURCE/.codex-plugin/plugin.json"
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text())
print(data["version"])
PY
)"

  local cache_root="$CODEX_HOME/plugins/cache/repo-local/pmops"
  local install_dir="$cache_root/$version"

  mkdir -p "$cache_root"
  rm -rf "$cache_root"/*
  mkdir -p "$install_dir"
  cp -R "$PLUGIN_SOURCE"/. "$install_dir"/
}

setup_context7() {
  if command -v npx >/dev/null 2>&1; then
    echo "Setting up context7 MCP..."
    npx -y ctx7 setup 2>/dev/null || \
      echo "context7 setup failed — run manually: npx ctx7 setup"
  else
    echo "npx not found — skipping context7. Install manually: npx ctx7 setup"
  fi
}

install_caveman() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing caveman skill for Codex..."
    npx -y skills add JuliusBrussee/caveman -a codex 2>/dev/null || \
      echo "caveman install failed — run manually: npx skills add JuliusBrussee/caveman -a codex"
  else
    echo "npx not found — skipping caveman. Install manually: npx skills add JuliusBrussee/caveman -a codex"
  fi
}

ensure_codex_cli
ensure_repo_layout
ensure_marketplace
install_repo_local_plugin
setup_context7
install_caveman

codex plugin marketplace add "$REPO_ROOT"
codex plugin marketplace upgrade repo-local >/dev/null 2>&1 || true

cat <<EOF

Codex local setup complete.

Repo root:
  $REPO_ROOT

Next step:
  Reopen Codex in this repo if it was already open.

Public skills:
  pmops:create-task
  pmops:start-task
  pmops:task-workflow
  pmops:release-task
  pmops:close-task
  pmops:handoff-task
  pmops:board-audit

  \$caveman — terse output mode (caveman skill)
EOF

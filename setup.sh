#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 /path/to/target-repo"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_REPO="$(cd "$1" && pwd)"

ensure_codex_cli() {
  if command -v codex >/dev/null 2>&1; then
    return 0
  fi

  if command -v npm >/dev/null 2>&1; then
    echo "Codex CLI not found. Installing with npm..."
    npm install -g @openai/codex
    if command -v codex >/dev/null 2>&1; then
      echo "Codex CLI installed via npm."
      return 0
    fi
  fi

  local app_binary="/Applications/Codex.app/Contents/Resources/codex"
  local install_target=""

  if [ -x "$app_binary" ]; then
    if [ -d "/opt/homebrew/bin" ] && [ -w "/opt/homebrew/bin" ]; then
      install_target="/opt/homebrew/bin/codex"
    elif [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
      install_target="/usr/local/bin/codex"
    fi

    if [ -n "$install_target" ]; then
      ln -sf "$app_binary" "$install_target"
      if command -v codex >/dev/null 2>&1; then
        echo "Codex CLI linked at $install_target"
        return 0
      fi
    fi
  fi

  cat <<'EOF'
Codex CLI is not available on this system.

What the starter tried:
- checked for `codex` on PATH
- tried `npm install -g @openai/codex`
- checked for the bundled app binary at `/Applications/Codex.app/Contents/Resources/codex`
- attempted to link it into a standard bin directory when writable

How to fix:
1. Install Node.js/npm if missing
2. Run `npm install -g @openai/codex`
3. Or install the Codex desktop app and re-run this starter

Quick check after install:
  codex --help
EOF
  exit 1
}

ensure_codex_cli

mkdir -p "$TARGET_REPO/.claude"
mkdir -p "$TARGET_REPO/.codex/context"
mkdir -p "$TARGET_REPO/.codex/skills/project-architecture"
mkdir -p "$TARGET_REPO/.codex/scripts"
mkdir -p "$TARGET_REPO/.agents/plugins"
mkdir -p "$TARGET_REPO/scripts"
mkdir -p "$TARGET_REPO/plugins/pmops/.claude-plugin"
mkdir -p "$TARGET_REPO/plugins/pmops/.codex-plugin"
mkdir -p "$TARGET_REPO/plugins/pmops/scripts"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/create-task"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/start-task"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/task-workflow"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/release-task"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/close-task"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/handoff-task"
mkdir -p "$TARGET_REPO/plugins/pmops/skills/board-audit"
mkdir -p "$TARGET_REPO/docs/ai"
mkdir -p "$TARGET_REPO/docs/ops/epics"
mkdir -p "$TARGET_REPO/docs/ops/tasks"
mkdir -p "$TARGET_REPO/docs/ops/handoffs"
mkdir -p "$TARGET_REPO/docs/ops/decisions"

cp "$ROOT_DIR/templates/AGENTS.md"                               "$TARGET_REPO/AGENTS.md"
cp "$ROOT_DIR/templates/CLAUDE.md"                                "$TARGET_REPO/CLAUDE.md"
cp "$ROOT_DIR/templates/.agents/plugins/marketplace.json"        "$TARGET_REPO/.agents/plugins/marketplace.json"
cp "$ROOT_DIR/templates/scripts/setup-agent-local.sh"           "$TARGET_REPO/scripts/setup-agent-local.sh"
cp "$ROOT_DIR/templates/scripts/setup-codex-local.sh"            "$TARGET_REPO/scripts/setup-codex-local.sh"
cp "$ROOT_DIR/templates/.claude/settings.local.json"      "$TARGET_REPO/.claude/settings.local.json"
cp "$ROOT_DIR/templates/.claude/marketplace.json"         "$TARGET_REPO/.claude/marketplace.json"
cp "$ROOT_DIR/templates/.codex/README.md"                        "$TARGET_REPO/.codex/README.md"
cp "$ROOT_DIR/templates/.codex/config.toml"                      "$TARGET_REPO/.codex/config.toml"
cp "$ROOT_DIR/templates/.codex/hooks.json"                       "$TARGET_REPO/.codex/hooks.json"
cp "$ROOT_DIR/templates/.codex/context/project-architecture.md"  "$TARGET_REPO/.codex/context/project-architecture.md"
cp "$ROOT_DIR/templates/.codex/skills/project-architecture/SKILL.md" "$TARGET_REPO/.codex/skills/project-architecture/SKILL.md"
cp "$ROOT_DIR/templates/.codex/scripts/session-update.sh"        "$TARGET_REPO/.codex/scripts/session-update.sh"
cp "$ROOT_DIR/templates/plugins/pmops/.claude-plugin/plugin.json" "$TARGET_REPO/plugins/pmops/.claude-plugin/plugin.json"
cp "$ROOT_DIR/templates/plugins/pmops/.codex-plugin/plugin.json" "$TARGET_REPO/plugins/pmops/.codex-plugin/plugin.json"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/new-task.sh"       "$TARGET_REPO/plugins/pmops/scripts/new-task.sh"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/claim-task.sh"     "$TARGET_REPO/plugins/pmops/scripts/claim-task.sh"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/start-task.sh"     "$TARGET_REPO/plugins/pmops/scripts/start-task.sh"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/close-task.sh"     "$TARGET_REPO/plugins/pmops/scripts/close-task.sh"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/handoff-task.sh"   "$TARGET_REPO/plugins/pmops/scripts/handoff-task.sh"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/prepare-pr.sh"     "$TARGET_REPO/plugins/pmops/scripts/prepare-pr.sh"
cp "$ROOT_DIR/templates/plugins/pmops/scripts/audit-board.sh"    "$TARGET_REPO/plugins/pmops/scripts/audit-board.sh"
cp "$ROOT_DIR/templates/plugins/pmops/skills/create-task/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/create-task/SKILL.md"
cp "$ROOT_DIR/templates/plugins/pmops/skills/start-task/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/start-task/SKILL.md"
cp "$ROOT_DIR/templates/plugins/pmops/skills/task-workflow/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/task-workflow/SKILL.md"
cp "$ROOT_DIR/templates/plugins/pmops/skills/release-task/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/release-task/SKILL.md"
cp "$ROOT_DIR/templates/plugins/pmops/skills/handoff-task/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/handoff-task/SKILL.md"
cp "$ROOT_DIR/templates/plugins/pmops/skills/board-audit/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/board-audit/SKILL.md"
cp "$ROOT_DIR/templates/plugins/pmops/skills/close-task/SKILL.md" "$TARGET_REPO/plugins/pmops/skills/close-task/SKILL.md"
cp "$ROOT_DIR/templates/docs/ai/README.md"                        "$TARGET_REPO/docs/ai/README.md"
cp "$ROOT_DIR/templates/docs/ai/01-SETUP.md"                      "$TARGET_REPO/docs/ai/01-SETUP.md"
cp "$ROOT_DIR/templates/docs/ai/02-WORKFLOW.md"                   "$TARGET_REPO/docs/ai/02-WORKFLOW.md"
cp "$ROOT_DIR/templates/docs/ai/03-STANDARDS.md"                  "$TARGET_REPO/docs/ai/03-STANDARDS.md"
cp "$ROOT_DIR/templates/docs/ai/04-DEVELOPER_GUIDE.md"            "$TARGET_REPO/docs/ai/04-DEVELOPER_GUIDE.md"
cp "$ROOT_DIR/templates/docs/ai/05-SKILL_REFERENCE.md"            "$TARGET_REPO/docs/ai/05-SKILL_REFERENCE.md"
cp "$ROOT_DIR/templates/docs/ai/06-STARTER_PACK_REFERENCE.md"     "$TARGET_REPO/docs/ai/06-STARTER_PACK_REFERENCE.md"
cp "$ROOT_DIR/templates/docs/ops/README.md"                      "$TARGET_REPO/docs/ops/README.md"
cp "$ROOT_DIR/templates/docs/ops/PM_GUIDE.md"                    "$TARGET_REPO/docs/ops/PM_GUIDE.md"
cp "$ROOT_DIR/templates/docs/ops/ROADMAP.md"                     "$TARGET_REPO/docs/ops/ROADMAP.md"
cp "$ROOT_DIR/templates/docs/ops/task-index.csv"                 "$TARGET_REPO/docs/ops/task-index.csv"
cp "$ROOT_DIR/templates/docs/ops/IMPLEMENTATION_PLAYBOOK.md"     "$TARGET_REPO/docs/ops/IMPLEMENTATION_PLAYBOOK.md"
cp "$ROOT_DIR/templates/docs/ops/epics/EPIC_TEMPLATE.md"         "$TARGET_REPO/docs/ops/epics/EPIC_TEMPLATE.md"
cp "$ROOT_DIR/templates/docs/ops/tasks/TASK_TEMPLATE.md"         "$TARGET_REPO/docs/ops/tasks/TASK_TEMPLATE.md"
cp "$ROOT_DIR/templates/docs/ops/handoffs/HANDOFF_TEMPLATE.md"   "$TARGET_REPO/docs/ops/handoffs/HANDOFF_TEMPLATE.md"
cp "$ROOT_DIR/templates/docs/ops/decisions/DECISION_TEMPLATE.md" "$TARGET_REPO/docs/ops/decisions/DECISION_TEMPLATE.md"

chmod +x "$TARGET_REPO/.codex/scripts/"*.sh
chmod +x "$TARGET_REPO/plugins/pmops/scripts/"*.sh
chmod +x "$TARGET_REPO/scripts/setup-agent-local.sh"
chmod +x "$TARGET_REPO/scripts/setup-codex-local.sh"

# Update .gitignore
GITIGNORE="$TARGET_REPO/.gitignore"
GITIGNORE_ENTRIES=(
  ".agents/"
  ".DS_Store"
  "node_modules/"
  ".env"
  ".env.local"
)
touch "$GITIGNORE"
for entry in "${GITIGNORE_ENTRIES[@]}"; do
  grep -qxF "$entry" "$GITIGNORE" || echo "$entry" >> "$GITIGNORE"
done

STACK="unknown"
STACK_HINTS=""
if [ -f "$TARGET_REPO/package.json" ]; then
  STACK="node"
  STACK_HINTS="  Dev:   npm run dev\n  Test:  npm test\n  Lint:  npm run lint\n  Build: npm run build"
elif [ -f "$TARGET_REPO/go.mod" ]; then
  STACK="go"
  STACK_HINTS="  Test:  go test ./...\n  Build: go build ./..."
elif [ -f "$TARGET_REPO/pyproject.toml" ] || [ -f "$TARGET_REPO/requirements.txt" ]; then
  STACK="python"
  STACK_HINTS="  Test:  pytest\n  Lint:  ruff check .\n  Type:  mypy ."
fi

cat <<EOF

╔══════════════════════════════════════════════════════════════╗
║        repo AI-augmented layer bootstrapped successfully    ║
╚══════════════════════════════════════════════════════════════╝

Target: $TARGET_REPO
Stack detected: $STACK

Files created:
  AGENTS.md
  CLAUDE.md
  .agents/plugins/marketplace.json
  scripts/setup-agent-local.sh
  scripts/setup-codex-local.sh (backward-compatible wrapper)
  .claude/settings.local.json
  .codex/README.md
  .codex/config.toml
  .codex/hooks.json
  .codex/context/project-architecture.md
  .codex/skills/project-architecture/SKILL.md
  .codex/scripts/session-update.sh
  plugins/pmops/.claude-plugin/plugin.json
  plugins/pmops/.codex-plugin/plugin.json
  plugins/pmops/scripts/new-task.sh
  plugins/pmops/scripts/claim-task.sh
  plugins/pmops/scripts/start-task.sh
  plugins/pmops/scripts/close-task.sh
  plugins/pmops/scripts/handoff-task.sh
  plugins/pmops/scripts/prepare-pr.sh
  plugins/pmops/scripts/audit-board.sh
  plugins/pmops/skills/create-task/SKILL.md
  plugins/pmops/skills/start-task/SKILL.md
  plugins/pmops/skills/task-workflow/SKILL.md
  plugins/pmops/skills/release-task/SKILL.md
  plugins/pmops/skills/close-task/SKILL.md
  plugins/pmops/skills/handoff-task/SKILL.md
  plugins/pmops/skills/board-audit/SKILL.md
  docs/ai/README.md
  docs/ai/01-SETUP.md
  docs/ai/02-WORKFLOW.md
  docs/ai/03-STANDARDS.md
  docs/ai/04-DEVELOPER_GUIDE.md
  docs/ai/05-SKILL_REFERENCE.md
  docs/ai/06-STARTER_PACK_REFERENCE.md
  docs/ops/README.md
  docs/ops/ROADMAP.md
  docs/ops/task-index.csv
  docs/ops/IMPLEMENTATION_PLAYBOOK.md
  docs/ops/epics/EPIC_TEMPLATE.md
  docs/ops/tasks/TASK_TEMPLATE.md
  docs/ops/handoffs/HANDOFF_TEMPLATE.md
  docs/ops/decisions/DECISION_TEMPLATE.md

Next steps:
  1. Fill in:
       .codex/context/project-architecture.md
$([ -n "$STACK_HINTS" ] && printf "     Suggested commands:\n$STACK_HINTS\n")
  2. Commit:
       AGENTS.md  CLAUDE.md  .claude/  .agents/  .codex/  plugins/  scripts/  docs/ai/  docs/ops/
  3. Each developer should run once after clone:
       ./scripts/setup-agent-local.sh

  4. Start using:
       pmops:create-task
       pmops:start-task
       pmops:task-workflow
       pmops:release-task
       pmops:close-task
       pmops:handoff-task
       pmops:board-audit

       \$caveman — terse output mode (Codex)
       /caveman — terse output mode (Claude Code)

EOF
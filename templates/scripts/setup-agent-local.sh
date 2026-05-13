#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ensure_repo_layout() {
  if [ ! -f "$REPO_ROOT/plugins/pmops/.claude-plugin/plugin.json" ]; then
    echo "Missing plugins/pmops/.claude-plugin/plugin.json — run bootstrap first."
    exit 1
  fi
}

# Claude Code installations
install_claude_caveman() {
  if command -v claude >/dev/null 2>&1; then
    echo "Installing caveman for Claude Code..."
    if claude plugin add JuliusBrussee/caveman 2>/dev/null; then
      claude plugin install caveman@caveman --scope local 2>/dev/null || true
    fi
  else
    echo "claude CLI not found — skipping caveman. Install from claude.ai/code"
  fi
}

install_claude_context7() {
  if command -v claude >/dev/null 2>&1; then
    echo "Installing context7 for Claude Code..."
    if claude plugin add claude-plugins-official/context7 2>/dev/null; then
      claude plugin install context7@claude-plugins-official --scope local 2>/dev/null || true
    fi
  else
    echo "claude CLI not found — skipping context7. Install from claude.ai/code"
  fi
}

install_claude_planning_with_files() {
  if command -v claude >/dev/null 2>&1; then
    echo "Installing planning-with-files for Claude Code..."
    if claude plugin add othmanadi/planning-with-files 2>/dev/null; then
      claude plugin install planning-with-files@planning-with-files --scope local 2>/dev/null || true
    fi
  else
    echo "claude CLI not found — skipping planning-with-files."
  fi
}

install_claude_renamer() {
  if command -v claude >/dev/null 2>&1; then
    echo "Installing renamer for Claude Code..."
    if claude plugin add renamed-to/plugin.renamed.to 2>/dev/null; then
      claude plugin install renamer@renamed-to --scope local 2>/dev/null || true
    fi
  else
    echo "claude CLI not found — skipping renamer."
  fi
}

install_claude_superpowers() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing superpowers for Claude Code..."
    npx -y skills add obra/superpowers -a claude 2>/dev/null || {
      echo "superpowers install failed — install manually from Claude Code plugin marketplace"
    }
  else
    echo "npx not found — skipping superpowers."
  fi
}

install_claude_premrg_validate() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing premrg-validate for Claude Code..."
    npx -y skills add JuliusBrussee/premrg-validate -a claude 2>/dev/null || {
      echo "premrg-validate install failed — install manually from skill marketplace"
    }
  else
    echo "npx not found — skipping premrg-validate."
  fi
}

# Codex installations
install_codex_caveman() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing caveman for Codex..."
    npx -y skills add JuliusBrussee/caveman -a codex 2>/dev/null || {
      echo "caveman install failed for Codex"
    }
  else
    echo "npx not found — skipping Codex caveman."
  fi
}

install_codex_context7() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing context7 for Codex..."
    npx ctx7 setup 2>/dev/null || {
      echo "context7 setup failed — install manually"
    }
  else
    echo "npx not found — skipping Codex context7."
  fi
}

install_codex_planning_with_files() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing planning-with-files for Codex..."
    npx -y skills add othmanadi/planning-with-files -a codex 2>/dev/null || {
      echo "planning-with-files install failed for Codex"
    }
  else
    echo "npx not found — skipping Codex planning-with-files."
  fi
}

install_codex_renamer() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing renamer for Codex..."
    npx -y skills add renamed-to/plugin.renamed.to -a codex 2>/dev/null || {
      echo "renamer install failed for Codex — install manually from plugin marketplace"
    }
  else
    echo "npx not found — skipping Codex renamer."
  fi
}

install_codex_superpowers() {
  if command -v npx >/dev/null 2>&1; then
    echo "Installing superpowers for Codex..."
    npx -y skills add obra/superpowers -a codex 2>/dev/null || {
      echo "superpowers install failed for Codex"
    }
  else
    echo "npx not found — skipping Codex superpowers."
  fi
}

ensure_repo_layout

echo "=== Claude Code plugins ==="
install_claude_caveman
install_claude_context7
install_claude_planning_with_files
install_claude_renamer
install_claude_superpowers
install_claude_premrg_validate

echo ""
echo "=== Codex skills ==="
install_codex_caveman
install_codex_context7
install_codex_planning_with_files
install_codex_renamer
install_codex_superpowers

cat <<EOF

Local setup complete for Claude Code and Codex.

Repo root:
  $REPO_ROOT

Next steps:
  - Restart Claude Code in this repo if it was already open.
  - For Codex, restart session or run /reload.

Installed for Claude Code:
  caveman — token-efficient output mode
  context7 — live library docs via MCP
  planning-with-files — planning task integration
  renamer — AI-powered file renaming and organization
  superpowers — additional Claude Code skills
  premrg-validate — PR validation before merge

Installed for Codex:
  caveman — token-efficient output mode
  context7 — live library docs via MCP
  planning-with-files — planning task integration
  renamer — AI-powered file renaming and organization
  superpowers — additional Codex skills

Repo-local pmops plugin works for both Claude Code and Codex.

EOF
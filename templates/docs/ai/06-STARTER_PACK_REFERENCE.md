# 06 — Starter Pack Reference

## Top Level

### `AGENTS.md`

Primary repo contract for Codex and developers.

### `scripts/setup-codex-local.sh`

One-time per-developer setup. Installs Codex CLI, registers repo-local marketplace, installs `pmops` and `caveman`.

## Repo Codex Layer

### `.codex/README.md`

Explains the repo-level Codex layer.

### `.codex/config.toml`

Enables Codex hooks (`codex_hooks = true`).

### `.codex/hooks.json`

SessionStart hook — loads `AGENTS.md` context on every Codex session.

### `.codex/context/project-architecture.md`

Project-specific architecture context. Fill this before meaningful work starts.

### `.codex/skills/project-architecture/SKILL.md`

Repo skill that points Codex at the architecture context file.

### `.codex/scripts/`

Internal helpers. Do not call directly — use `pmops:*` skills.

| Script | Called by |
|--------|-----------|
| `new-task.sh` | `pmops:create-task` |
| `start-task.sh` | `pmops:start-task` |
| `claim-task.sh` | `start-task.sh` (internal) |
| `prepare-pr.sh` | `pmops:release-task` |
| `close-task.sh` | `pmops:close-task` |
| `handoff-task.sh` | `pmops:handoff-task` |
| `audit-board.sh` | `pmops:board-audit` |

## Codex Docs

### `docs/ai/01-SETUP.md`

Bootstrap instructions and per-developer setup.

### `docs/ai/02-WORKFLOW.md`

Read order and default work pattern.

### `docs/ai/03-STANDARDS.md`

Repo-level rules.

### `docs/ai/04-DEVELOPER_GUIDE.md`

Day-to-day usage, skill reference, examples.

### `docs/ai/05-STARTER_PACK_REFERENCE.md`

This file. Describes every file the starter creates.

## Operations Docs

### `docs/ops/README.md`

Explains the repo-native PM layer.

### `docs/ops/ROADMAP.md`

Tracks initiatives and milestones.

### `docs/ops/task-index.csv`

The team board. Columns: `id, title, status, area, priority, owner, branch, depends_on, path`.

Valid statuses: `Todo`, `In Progress`, `Review`, `Blocked`, `Done`, `Cancelled`.

### `docs/ops/epics/EPIC_TEMPLATE.md`

Template for grouped work.

### `docs/ops/tasks/TASK_TEMPLATE.md`

Template for executable tasks.

### `docs/ops/handoffs/HANDOFF_TEMPLATE.md`

Template for transfer notes.

### `docs/ops/decisions/DECISION_TEMPLATE.md`

Template for durable decisions.

### `docs/ops/IMPLEMENTATION_PLAYBOOK.md`

Practical execution flow.

## PM Ops Plugin

### `plugins/pmops/.codex-plugin/plugin.json`

Defines the local `pmops` Codex plugin.

### `plugins/pmops/skills/`

Public skill interface:

| Skill | Action |
|-------|--------|
| `pmops:create-task` | Create board row + task file |
| `pmops:start-task` | Claim task, create branch |
| `pmops:task-workflow` | Stay aligned during implementation |
| `pmops:release-task` | Move to Review, generate PR text |
| `pmops:close-task` | Mark Done / Blocked / Cancelled |
| `pmops:handoff-task` | Write handoff for paused/transferred work |
| `pmops:board-audit` | Check board hygiene |

# 02 — Workflow

## Read Order

1. `AGENTS.md` (or `CLAUDE.md` for Claude Code)
2. `docs/ai/02-WORKFLOW.md`
3. `.codex/context/project-architecture.md` (Codex) or `.claude/settings.local.json` (Claude Code)
4. `docs/ops/README.md`
5. `docs/ops/task-index.csv`
6. The active task or epic file

## Layer Split

`docs/ai/`
- explains how Claude Code and Codex should be used in this repo
- explains setup and standards

`docs/ops/`
- tracks actual project work
- acts as the repo-native PM system

`.claude/`
- holds Claude Code repo settings, local plugins, and MCP configuration

`.codex/`
- holds repo-local Codex helpers and context
- includes repo skills for architecture and task lifecycle

## Default Work Pattern

1. Use `pmops:create-task` when new work is needed.
2. Use `pmops:start-task` to begin work.
3. Read the task file in `docs/ops/tasks/`.
4. Use `pmops:task-workflow` during implementation.
5. Use `pmops:release-task` when work is ready for PR.
6. Use `pmops:close-task` after merge to mark Done.
7. Use `pmops:handoff-task` when work pauses or transfers.

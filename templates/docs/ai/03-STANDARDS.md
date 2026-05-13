# 03 — Standards

## Shared In Git

- `AGENTS.md` / `CLAUDE.md` (both mirror each other)
- `.claude/`
- `.codex/`
- `docs/ai/`
- `docs/ops/`

## Task Standard

- one task file per task
- one owner for `In Progress`
- one branch per active task
- one board row per task in `docs/ops/task-index.csv`

## Process Standard

- claim before coding
- plan before broad edits
- update task state before stopping
- use handoffs for interrupted work
- use decisions for lasting choices
- use `pmops:*` skills as the public task interface
- never call `.codex/scripts/` directly — use skills

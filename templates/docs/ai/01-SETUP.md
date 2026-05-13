# 01 — Setup

There is no `codex init` or `claude init` subcommand in the current CLI.

This starter bootstrap is the equivalent.

## Bootstrap (one-time, done by setup person)

```bash
path/to/codex-team-starter/setup.sh /path/to/repo
```

This creates the full AI layer in the target repo.
After bootstrap, fill in `.codex/context/project-architecture.md` before the team starts.

## What Gets Created

- `AGENTS.md` — repo contract (Claude Code and Codex)
- `CLAUDE.md` — Claude Code mirror of AGENTS.md
- `scripts/setup-agent-local.sh` — per-developer setup (main script)
- `scripts/setup-codex-local.sh` — backward-compatible wrapper for Codex
- `.claude/` — Claude Code settings and config
- `.codex/` — Codex context, scripts, skills, config, hooks
- `plugins/pmops/` — PM Ops plugin (works with Claude Code and Codex)
- `docs/ai/` — this folder
- `docs/ops/` — project management layer

## What To Commit

```
AGENTS.md
CLAUDE.md
.codex/
.claude/
plugins/
scripts/
docs/ai/
docs/ops/
```

Do not commit `.agents/` — local to each developer's machine.

## Per-Developer Setup (once after clone)

```bash
./scripts/setup-agent-local.sh
```

This script installs Claude Code and Codex plugins as appropriate for the detected tooling:
- Claude Code: caveman, context7, planning-with-files, superpowers
- Codex: caveman, context7, superpowers, planning-with-files

Reopen Claude Code or Codex in the repo after running.

## Mandatory Skills & Tools

| Layer | What it does |
|-------|--------------|
| `pmops:*` | Task lifecycle — create, start, work, release, handoff, close, audit |
| `caveman` | Token-efficient output mode (`$caveman` prefix in Codex, `/caveman` in Claude Code) |
| `context7` | Live library docs via MCP — resolves correct API for current lib versions |
| `planning-with-files` | Planning task integration — stores plans in `.claude/plans/` |
| `superpowers` | TDD, planning, code review, debugging, parallel agents, branch workflow |

## Manual Step After Bootstrap

Fill in `.codex/context/project-architecture.md`.
Claude Code and Codex read this before non-trivial work. Leave it empty = degraded output.
The setup person owns this step.
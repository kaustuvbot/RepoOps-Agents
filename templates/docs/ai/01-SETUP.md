# 01 — Setup

There is no `codex init` subcommand in the current Codex CLI.

This starter bootstrap is the equivalent.

## Bootstrap (one-time, done by setup person)

```bash
path/to/codex-team-starter/setup.sh /path/to/repo
```

This creates the full AI layer in the target repo.
After bootstrap, fill in `.codex/context/project-architecture.md` before the team starts.

## What Gets Created

- `AGENTS.md`
- `scripts/setup-codex-local.sh`
- `.codex/` — context, scripts, skills, config, hooks
- `plugins/pmops/` — PM Ops plugin
- `docs/ai/` — this folder
- `docs/ops/` — project management layer

## What To Commit

```
AGENTS.md
.codex/
plugins/
scripts/
docs/ai/
docs/ops/
```

Do not commit `.agents/` — it is local to each developer's machine.

## Per-Developer Setup (once after clone)

```bash
./scripts/setup-codex-local.sh
```

This script:
- installs Codex CLI if missing
- registers the repo-local `pmops` plugin
- installs caveman skill for Codex

Reopen Codex in the repo after running.

## Mandatory Skills & Tools

| Layer | What it does |
|-------|--------------|
| `pmops:*` | Task lifecycle — create, start, work, release, handoff, close, audit |
| `caveman` | Token-efficient output mode (`$caveman` prefix in Codex) |
| `context7` | Live library docs via MCP — resolves correct API for current lib versions |

## Manual Step After Bootstrap

Fill in `.codex/context/project-architecture.md`.
Codex reads this before non-trivial work. Leave it empty = degraded output.
The setup person owns this step.

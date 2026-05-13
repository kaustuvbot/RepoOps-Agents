# Repo Agent Contract

This repository is standardized for AI-augmented development using Claude Code and Codex.

## Goals

- Keep project memory in git instead of chat.
- Keep work small, reviewable, and attributable.
- Keep team coordination predictable.
- Keep Codex and Claude Code useful without improvising process.

## Repo Layers

| Purpose | Location |
| --- | --- |
| Repo operating contract | `AGENTS.md` |
| Claude Code support | `.claude/` |
| Codex support | `.codex/` |
| Claude Code + Codex docs | `docs/ai/` |
| Project operations and planning | `docs/ops/` |

## Getting Started

For a new repo or fresh starter-pack install:

1. Read `docs/ai/01-SETUP.md`.
2. Run `scripts/setup-agent-local.sh` once on each developer machine.
3. Fill in `.codex/context/project-architecture.md` (Codex) or `.claude/settings.local.json` (Claude Code) with app context.
4. Replace or remove the example row in `docs/ops/task-index.csv`.
5. Create the first real task with `pmops:create-task`, or add it manually using `docs/ops/tasks/TASK_TEMPLATE.md`.
6. Start work with `pmops:start-task` before editing implementation files.

Update these files first when adapting the starter pack:

- `AGENTS.md` - repo-wide agent contract and workflow rules.
- `.codex/context/project-architecture.md` - app architecture, domains, constraints, commands, and risky areas.
- `docs/ops/ROADMAP.md` - product direction, milestones, and sequencing.
- `docs/ops/task-index.csv` - current task board and ownership.
- `docs/ops/tasks/*.md` - task goals, plans, notes, linked files, and validation.
- `docs/ai/03-STANDARDS.md` - coding, testing, review, and security standards.
- `docs/ai/04-DEVELOPER_GUIDE.md` - team onboarding and day-to-day commands.

## File Guide

- `AGENTS.md`: first file agents read; keep it short, authoritative, and repo-specific.
- `CLAUDE.md`: Claude Code mirror of AGENTS.md for compatibility.
- `.claude/settings.local.json`: Claude Code repo settings, including local plugins and MCP defaults.
- `.codex/config.toml`: Codex settings, including hooks and MCP defaults.
- `.codex/hooks.json`: session hooks that load repo context and prompt task updates.
- `.codex/scripts/`: repo helper scripts used by hooks or workflows.
- `.codex/skills/`: repo-local skills for project-specific guidance.
- `plugins/pmops/`: repo-local plugin for task lifecycle operations (works with Claude Code and Codex).
- `docs/ai/`: human and agent docs for setup, workflow, standards, and starter-pack reference.
- `docs/ops/`: planning system: roadmap, task board, tasks, epics, decisions, and handoffs.
- `.agents/plugins/marketplace.json`: local marketplace pointer for this machine; do not commit unless the team explicitly wants repo-local marketplace metadata in git.

## Read Order

Read these first for meaningful work:

1. `AGENTS.md`
2. `docs/ai/02-WORKFLOW.md`
3. `.codex/context/project-architecture.md`
4. `docs/ops/README.md`
5. `docs/ops/task-index.csv`
6. The relevant task, epic, handoff, or decision file

## Working Rules

- Use plan-first workflow for non-trivial work.
- Work on one task at a time.
- Do not claim work silently. Update the board first.
- Prefer repo helpers in `.codex/scripts/` when they fit.
- If a change affects architecture, security, data, or deployment, call it out before editing.

## Operations Rules

- `docs/ops/task-index.csv` is the team board.
- `In Progress` means exactly one owner.
- Each active task should map to one branch.
- Task execution notes belong in `docs/ops/tasks/`.
- Handoffs belong in `docs/ops/handoffs/`.
- Durable decisions belong in `docs/ops/decisions/`.

## Default Task Flow

1. Create work through `pmops:create-task` when needed.
2. Start work through `pmops:start-task`.
3. Read the task file in `docs/ops/tasks/`.
4. Propose a short plan if the work is non-trivial.
5. Implement only the claimed task using `pmops:task-workflow`.
6. Release work through `pmops:release-task`.
7. Close work through `pmops:close-task` after merge.
8. If work pauses, use `pmops:handoff-task`.

## Human / AI Split

Humans own:
- product direction
- task priority
- scope tradeoffs
- architecture approval
- merge approval

AI (Claude Code or Codex) owns:
- implementation planning
- code changes
- task-file updates
- handoff drafting
- local verification

## Repo-Level Standardization

Use the repo layer for:
- shared architecture context
- task lifecycle scripts
- task lifecycle skills via `pmops:*`
- task naming conventions
- board hygiene
- execution playbooks

Do not put team standards only in `~/.codex` or `~/.claude`.
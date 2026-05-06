# Repo Agent Contract

This repository is standardized for Codex-first development.

## Goals

- Keep project memory in git instead of chat.
- Keep work small, reviewable, and attributable.
- Keep team coordination predictable.
- Keep Codex useful without improvising process.

## Repo Layers

| Purpose | Location |
| --- | --- |
| Repo operating contract | `AGENTS.md` |
| Repo-local Codex support | `.codex/` |
| Codex docs and standards | `docs/ai/` |
| Project operations and planning | `docs/ops/` |

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

## Human / Codex Split

Humans own:
- product direction
- task priority
- scope tradeoffs
- architecture approval
- merge approval

Codex owns:
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

Do not put team standards only in `~/.codex`.

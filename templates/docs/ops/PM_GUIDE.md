# PM Guide

This is the project management layer for the repo.

Everything lives in `docs/ops/`. The board (`task-index.csv`) is management-only — a lightweight index.
All detail lives in the files it points to.

---

## Layer Overview

| File / Folder | Purpose | Who owns it |
|---------------|---------|-------------|
| `task-index.csv` | Board — status, owner, branch, one row per task | PM + Codex |
| `tasks/` | Task detail — goal, scope, criteria, notes | PM writes, Codex updates |
| `epics/` | Grouped work — outcome, scope, task list | PM |
| `decisions/` | Durable architectural or product choices | PM + Tech lead |
| `handoffs/` | Transfer notes when work pauses or changes hands | Developer / Codex |
| `ROADMAP.md` | Initiatives and milestone direction | PM |

---

## How Task Details Are Stored

The board row (`task-index.csv`) holds only:

```
id, title, status, area, priority, owner, branch, depends_on, path
```

Everything else lives in the task file at `path`.

**PM writes the task file.** The task file is the source of truth for what needs to be built.

Codex and the developer read it. Codex updates `Status`, `Owner`, `Branch` fields during the lifecycle.

---

## Task File Fields

Each task file follows `TASK_TEMPLATE.md`:

```
Status:     Todo | In Progress | Review | Done | Blocked | Cancelled
Owner:      who is doing the work
Area:       which domain (Auth, Platform, Data, etc.)
Priority:   Low | Medium | High | Critical
Branch:     set by pmops:start-task
Depends on: TASK-ID or none
```

**Sections PM must fill:**

| Section | What to write |
|---------|--------------|
| **Goal** | One sentence — the intended outcome. What done looks like. |
| **Scope / In scope** | What this task covers. Be specific. |
| **Scope / Out of scope** | What is explicitly excluded. Prevents scope creep. |
| **Files Likely Touched** | Paths or modules the developer should focus on. Best guess is fine. |
| **Acceptance Criteria** | Testable conditions. Developer validates against these before releasing. |
| **Verification** | How to verify — manual steps, test commands, or check list. |
| **Notes** | Context, constraints, links to decisions or designs. |

---

## Epic Files

Epics group related tasks toward a larger outcome.

**PM creates epics manually** using the template:

1. Copy `docs/ops/epics/EPIC_TEMPLATE.md`
2. Rename to `docs/ops/epics/EPIC-0000-<slug>.md`
3. Fill in the file

**PM writes:**
- **Outcome** — what the epic delivers when complete
- **Scope** — what is in / out
- **Proposed Tasks** — task IDs that belong to this epic
- **Dependencies** — external blockers or internal prerequisites

There is no skill or script for creating epics — PM owns this step entirely.
Epics do not go on the board — the board tracks tasks only.

---

## Decision Files

Use `docs/ops/decisions/` for choices that affect architecture, data, security, or deployment.

One file per decision. Fill the template:
- **Title** — the question being decided
- **Status** — Proposed / Accepted / Superseded
- **Context** — why this needed a decision
- **Decision** — what was chosen and why
- **Consequences** — what changes, what trade-offs accepted

Link decisions from task Notes when a task is constrained by one.

---

## Handoff Files

Handoffs are created by `pmops:handoff-task`.
PM does not write them — they are developer and Codex output.

PM reads them when:
- reassigning a task
- understanding why a task is blocked
- picking up stalled work

---

## PM Workflow

### Creating new work

1. Decide if work is large enough for an epic. If yes, copy `epics/EPIC_TEMPLATE.md`, rename it `EPIC-0000-<slug>.md`, and fill it in manually.
2. Create the task file manually or use Codex:
   ```
   Use pmops:create-task to add TASK-0002 for auth rate limiting in area Auth with High priority.
   ```
3. Open the generated task file at `docs/ops/tasks/TASK-0002-auth-rate-limiting.md`.
4. Fill in Goal, Scope, Files Likely Touched, Acceptance Criteria, Verification, Notes.
5. The task is now ready for a developer to start.

### Reviewing the board

Open `docs/ops/task-index.csv`. Columns:

| Column | Meaning |
|--------|---------|
| `id` | Unique task ID, e.g. `TASK-0001` |
| `title` | Short description |
| `status` | Current lifecycle state |
| `area` | Domain/module |
| `priority` | Work priority |
| `owner` | Who is actively working it (`In Progress` only) |
| `branch` | Git branch for this task |
| `depends_on` | Blocking task ID or `none` |
| `path` | Relative path to the task file |

Valid statuses:

| Status | Meaning |
|--------|---------|
| `Todo` | Defined, not started |
| `In Progress` | Actively being worked — exactly one owner |
| `Review` | PR open, awaiting merge |
| `Blocked` | Cannot proceed — dependency unresolved |
| `Done` | Merged and closed |
| `Cancelled` | No longer needed |

### Auditing the board

```
Use pmops:board-audit.
```

Catches: duplicate IDs, missing owners on `In Progress`, broken dependencies, stale `Blocked` tasks.

Run this before planning reviews.

### Checking task detail

Open the task file from `path` column. Read Goal and Acceptance Criteria to verify the scope matches intent before assigning.

### Reprioritising

Edit `task-index.csv` directly — change `priority` column.
Do not change `status`, `owner`, or `branch` manually — use `pmops:*` skills.

### Reassigning blocked work

1. Read the handoff file in `docs/ops/handoffs/`.
2. Update `owner` in the task file and board row.
3. Brief the new developer on the Next Step in the handoff.

---

## What PM Does Not Do

- Does not call `.codex/scripts/` directly.
- Does not manually set `branch` in the board — `pmops:start-task` does this.
- Does not mark tasks `Done` — developer does this after merge via `pmops:close-task`.
- Does not write handoffs — Codex or developer does.

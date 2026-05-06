# 05 — Skill Reference

Each `pmops:*` skill is the public interface. It reads context, runs a script, and updates both the board and the task file.

Do not call `.codex/scripts/` directly.

---

## `pmops:create-task`

**When:** New work is identified.

**Reads:**
- `AGENTS.md`
- `docs/ops/task-index.csv`
- matching epic in `docs/ops/epics/` if relevant

**Runs:**
```bash
.codex/scripts/new-task.sh TASK-0002 "Title" Area Priority [DependsOn]
```

**Changes:**
- appends row to `docs/ops/task-index.csv`
- creates `docs/ops/tasks/TASK-0002-<slug>.md` from `TASK_TEMPLATE.md`

**Does not:** create a branch, claim ownership, or start work.

---

## `pmops:start-task`

**When:** Beginning work on a task.

**Reads:**
- `AGENTS.md`
- `.codex/context/project-architecture.md`
- `docs/ops/task-index.csv`
- target task file

**Runs:**
```bash
.codex/scripts/start-task.sh TASK-0002 owner-name
# which runs:
#   claim-task.sh  → updates board + task file, creates/switches branch
#   audit-board.sh → verifies board integrity
```

**Changes:**
- task status → `In Progress`
- task owner set
- branch created: `feat/TASK-0002-<slug>`
- board row updated
- task file updated

**Enforces:** one owner, one branch per task.

---

## `pmops:task-workflow`

**When:** During implementation — use this throughout the session.

**Reads:**
- `AGENTS.md`
- `.codex/context/project-architecture.md`
- `docs/ops/task-index.csv`
- active task file

**Runs:** no script. Codex runtime behavior.

**Enforces:**
- one task at a time, one branch
- task file kept current at checkpoints
- board updated when status/owner/branch changes
- blockers called out before edits

---

## `pmops:release-task`

**When:** Work is complete and ready for PR.

**Reads:**
- `AGENTS.md`
- `docs/ops/task-index.csv`
- active task file

**Runs:**
```bash
.codex/scripts/prepare-pr.sh TASK-0002
# which runs:
#   close-task.sh Review  → moves task to Review
#   audit-board.sh        → verifies board before PR
```

**Changes:**
- task status → `Review`
- board row updated

**Outputs:**
```
PR title:
[TASK-0002] Auth rate limiting

PR body:
## Summary
- Implements TASK-0002: Auth rate limiting

## Validation
- [ ] ...

## Task
- TASK-0002
```

---

## `pmops:close-task`

**When:** After merge (Done), or when blocking/cancelling a task.

**Reads:**
- `AGENTS.md`
- `docs/ops/task-index.csv`
- task file

**Runs:**
```bash
.codex/scripts/close-task.sh TASK-0002 [Done|Blocked|Cancelled]
```

Default status if omitted: `Review`.

**Changes:**
- task status updated in board row and task file

**Enforces:**
- `Done` only after merge
- `Blocked` when dependency unresolved
- follow with `pmops:board-audit`

---

## `pmops:handoff-task`

**When:** Work pauses or transfers to another developer.

**Reads:**
- `AGENTS.md`
- `docs/ops/task-index.csv`
- active task file

**Runs:**
```bash
.codex/scripts/handoff-task.sh TASK-0002
```

**Changes:**
- creates `docs/ops/handoffs/TASK-0002-<slug>-<date>.md`

**Handoff file contains:**
- task ID, title, status, owner
- Done section — what was completed
- Not Done section — what remains
- Files To Read First
- Next Step

---

## `pmops:board-audit`

**When:** Before handoff, before release, when drift suspected.

**Reads:**
- `docs/ops/task-index.csv`

**Runs:**
```bash
.codex/scripts/audit-board.sh
```

**Checks:**
- duplicate task IDs
- duplicate branches
- `In Progress` tasks without an owner
- tasks that depend on non-existent task IDs
- `Blocked` tasks whose dependency is already `Done`

**Output:**
- `Board audit passed` — clean
- list of issues — must fix before continuing

---

## Repo Skill: `project-architecture`

**When:** Starting meaningful work or planning a non-trivial change.

**Reads:**
```
.codex/context/project-architecture.md
```

**Does not run a script.** Loads architectural context so Codex respects repo structure, existing patterns, and risk areas before editing.

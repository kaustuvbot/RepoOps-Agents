# 04 — Developer Guide

## One-Time Local Setup

After cloning, run once:

```bash
./scripts/setup-agent-local.sh
```

What it does:
- installs Claude Code and Codex plugins as appropriate
- installs `pmops` plugin
- installs `caveman`, `context7`, `planning-with-files`, `superpowers` skills

Reopen Claude Code or Codex in the repo after running.

---

## How To Work With Claude Code or Codex

All task work goes through `pmops:*` skills. Do not call `.codex/scripts/` directly.

### Step 1 — Create a task

```
Use pmops:create-task to add TASK-0002 for auth rate limiting in area Auth with High priority.
```

What happens:
- new row added to `docs/ops/task-index.csv`
- new task file created at `docs/ops/tasks/TASK-0002-auth-rate-limiting.md`

### Step 2 — Start work

```
Use pmops:start-task for TASK-0002 with owner <your-name>.
```

What happens:
- task status → `In Progress`
- owner set
- branch created: `feat/TASK-0002-auth-rate-limiting`
- task file updated with branch, owner, status
- board audit runs

### Step 3 — Implement

```
Use pmops:task-workflow and work only on TASK-0002.
```

What Codex does:
- reads the task file
- stays scoped to that task
- keeps task file and board row current at checkpoints
- calls out blockers or scope drift

**Developer responsibility after this:**
- read the task file — understand Goal, Scope, Acceptance Criteria
- do the actual dev work to fulfil those criteria
- validate against the Verification checklist in the task file
- only move to Step 4 when Acceptance Criteria are met

### Step 4 — Release for PR

```
Use pmops:release-task for TASK-0002.
```

What happens:
- task status → `Review`
- board audit runs
- PR title + body printed:
  ```
  [TASK-0002] Auth rate limiting
  ```

### Step 5 — Close after merge

```
Use pmops:close-task for TASK-0002 Done.
```

What happens:
- task status → `Done`
- task file updated
- board audit runs

### Pausing or transferring

```
Use pmops:handoff-task for TASK-0002.
```

What happens:
- handoff file created at `docs/ops/handoffs/TASK-0002-auth-rate-limiting-<date>.md`
- fill in Done / Not Done / Next Step sections

### Board hygiene

```
Use pmops:board-audit.
```

Checks: duplicate IDs, duplicate branches, `In Progress` without owner, broken dependencies.

---

## Terse Mode

Prefix any prompt with `$caveman` for compressed output:

```
$caveman Use pmops:start-task for TASK-0002 with owner kaustuv.
```

---

## Rules

- One task at a time per branch.
- Claim before coding — never skip `pmops:start-task`.
- Update task state before stopping a session.
- Run `pmops:board-audit` before handoff and before release.
- Handoffs for interrupted work. Decisions for lasting choices.

---

## Manual Test Plan

Open the repo in Codex:

```bash
codex -C /path/to/repo
```

### Confirm pmops is loaded

Type `pmops` — UI should suggest:
- `pmops:create-task`
- `pmops:start-task`
- `pmops:task-workflow`
- `pmops:release-task`
- `pmops:close-task`
- `pmops:handoff-task`
- `pmops:board-audit`

If pmops does not appear, check `.agents/plugins/marketplace.json` exists and re-run `./scripts/setup-codex-local.sh`.

### Test task creation

```
Use pmops:create-task to add TASK-0002 for auth rate limiting in area Auth with High priority.
```

✅ `docs/ops/task-index.csv` has new row  
✅ `docs/ops/tasks/TASK-0002-auth-rate-limiting.md` exists

### Test task start

```
Use pmops:start-task for TASK-0002 with owner kaustuv.
```

✅ task status = `In Progress`  
✅ owner = `kaustuv`  
✅ branch created: `feat/TASK-0002-...`  
✅ task file updated with branch/owner/status

### Test workflow confinement

```
Use pmops:task-workflow and work only on TASK-0002. Do not touch other tasks.
```

✅ Codex stays inside TASK-0002  
✅ references correct task file and board row  
✅ does not modify unrelated tasks

### Test release

```
Use pmops:release-task for TASK-0002.
```

✅ task status = `Review`  
✅ PR title format: `[TASK-0002] Auth rate limiting`  
✅ PR body includes task ID and validation checklist

### Test close

```
Use pmops:close-task for TASK-0002 Done.
```

✅ task status = `Done`

### Test handoff

```
Use pmops:handoff-task for TASK-0002.
```

✅ handoff file created at `docs/ops/handoffs/TASK-0002-...-<date>.md`

### Test board audit

```
Use pmops:board-audit.
```

✅ prints `Board audit passed` or lists specific board errors

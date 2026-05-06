# Codex Team Starter

One-command bootstrap that installs a structured Codex AI layer into any dev repo.

Gives teams: task lifecycle, board hygiene, architecture context, and terse output — without a giant always-on system.

---

## What It Installs

| Layer | What it does |
|-------|-------------|
| `AGENTS.md` | Repo contract — Codex reads this on every session |
| `.codex/` | Context, scripts, skills, hooks |
| `plugins/pmops/` | Task lifecycle skills (`pmops:*`) |
| `docs/ai/` | Numbered team docs |
| `docs/ops/` | Repo-native PM layer (board, tasks, handoffs, decisions) |
| `scripts/setup-codex-local.sh` | Per-developer setup |

---

## Bootstrap A Repo (done once by setup person)

```bash
./setup.sh /path/to/repo
```

Then fill in `.codex/context/project-architecture.md` in the target repo.

---

## Per-Developer Setup (once after clone)

```bash
./scripts/setup-codex-local.sh
```

Installs Codex CLI, registers `pmops` plugin, installs `caveman` skill.

---

## Skills

### Task Lifecycle — `pmops:*`

| Skill | Action |
|-------|--------|
| `pmops:create-task` | Create board row + task file |
| `pmops:start-task` | Claim task, create branch |
| `pmops:task-workflow` | Stay aligned during implementation |
| `pmops:release-task` | Move to Review, generate PR text |
| `pmops:close-task` | Mark Done / Blocked / Cancelled |
| `pmops:handoff-task` | Write handoff for paused/transferred work |
| `pmops:board-audit` | Check board hygiene |

### Output — `caveman`

Terse, token-efficient Codex output.

```
$caveman Use pmops:start-task for TASK-0002 with owner kaustuv.
```

---

## Repo Structure (after bootstrap)

```
AGENTS.md
scripts/
  setup-codex-local.sh
.codex/
  config.toml
  hooks.json
  context/
    project-architecture.md    ← fill this
  skills/
    project-architecture/
  scripts/                     ← internal helpers, do not call directly
plugins/
  pmops/                       ← pmops plugin
docs/
  ai/
    README.md
    01-SETUP.md
    02-WORKFLOW.md
    03-STANDARDS.md
    04-DEVELOPER_GUIDE.md
    05-SKILL_REFERENCE.md
    06-STARTER_PACK_REFERENCE.md
  ops/
    task-index.csv
    tasks/
    epics/
    handoffs/
    decisions/
```

---

## What To Commit (in target repo)

```
AGENTS.md
.codex/
plugins/
scripts/
docs/ai/
docs/ops/
```

Do not commit `.agents/` — local to each machine.

---

## Docs

| Doc | Read it when |
|-----|-------------|
| `docs/ai/01-SETUP.md` | First-time setup |
| `docs/ai/02-WORKFLOW.md` | Understanding the work pattern |
| `docs/ai/03-STANDARDS.md` | Rules |
| `docs/ai/04-DEVELOPER_GUIDE.md` | Day-to-day Codex usage + test plan |
| `docs/ai/05-SKILL_REFERENCE.md` | What each skill does internally |
| `docs/ai/06-STARTER_PACK_REFERENCE.md` | What every installed file does |

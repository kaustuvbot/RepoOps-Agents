# AI Agent Team Starter

One-command bootstrap that installs a structured AI layer for Claude Code and Codex into any dev repo.

Gives teams: task lifecycle, board hygiene, architecture context, and terse output — without a giant always-on system.

---

## What It Installs

| Layer | What it does |
|-------|-------------|
| `AGENTS.md` / `CLAUDE.md` | Repo contract — agents read this on every session |
| `.codex/` | Codex context, scripts, skills, hooks |
| `.claude/` | Claude Code settings and config |
| `plugins/pmops/` | Task lifecycle skills (`pmops:*`) — works with both |
| `docs/ai/` | Numbered team docs |
| `docs/ops/` | Repo-native PM layer (board, tasks, handoffs, decisions) |
| `scripts/setup-agent-local.sh` | Per-developer setup (Claude Code + Codex) |

---

## Bootstrap A Repo (done once by setup person)

```bash
./setup.sh /path/to/repo
```

Then fill in:
- `.codex/context/project-architecture.md` (Codex)
- `.claude/settings.local.json` (Claude Code)

---

## Per-Developer Setup (once after clone)

```bash
./scripts/setup-agent-local.sh
```

Installs CLI, registers `pmops` plugin, installs shared skills for both tools.

---

## Plugins & Skills

### Task Lifecycle — `pmops:*` (both Claude Code and Codex)

| Skill | Action |
|-------|--------|
| `pmops:create-task` | Create board row + task file |
| `pmops:start-task` | Claim task, create branch |
| `pmops:task-workflow` | Stay aligned during implementation |
| `pmops:release-task` | Move to Review, generate PR text |
| `pmops:close-task` | Mark Done / Blocked / Cancelled |
| `pmops:handoff-task` | Write handoff for paused/transferred work |
| `pmops:board-audit` | Check board hygiene |

### Claude Code Plugins

| Plugin | What it does |
|--------|-------------|
| `caveman` | Token-efficient output mode |
| `context7` | Live library docs via MCP |
| `planning-with-files` | Planning task integration |
| `renamer` | AI-powered file renaming and organization |
| `superpowers` | Additional Claude Code skills |

### Codex Skills

| Skill | What it does |
|-------|-------------|
| `caveman` | Token-efficient output mode |
| `context7` | Live library docs via MCP |
| `planning-with-files` | Planning task integration |
| `renamer` | AI-powered file renaming and organization |
| `superpowers` | Additional Codex skills |

---

## Repo Structure (after bootstrap)

```
AGENTS.md
CLAUDE.md
scripts/
  setup-agent-local.sh          ← main setup (Claude Code + Codex)
  setup-codex-local.sh          ← legacy alias for setup-agent-local.sh
.codex/
  config.toml
  hooks.json
  context/
    project-architecture.md    ← fill this (Codex)
  skills/
    project-architecture/
  scripts/                     ← internal helpers
.claude/
  settings.json
  settings.local.json          ← fill this (Claude Code)
plugins/
  pmops/                       ← pmops plugin (both tools)
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
CLAUDE.md
.codex/
.claude/
plugins/
scripts/
docs/ai/
docs/ops/
```

Do not commit:
- `.agents/` — local to each machine
- `.codex/cache/` / `.claude/cache/` — generated

---

## Docs

| Doc | Read it when |
|-----|-------------|
| `docs/ai/01-SETUP.md` | First-time setup |
| `docs/ai/02-WORKFLOW.md` | Understanding the work pattern |
| `docs/ai/03-STANDARDS.md` | Rules |
| `docs/ai/04-DEVELOPER_GUIDE.md` | Day-to-day usage + test plan |
| `docs/ai/05-SKILL_REFERENCE.md` | What each skill does internally |
| `docs/ai/06-STARTER_PACK_REFERENCE.md` | What every installed file does |
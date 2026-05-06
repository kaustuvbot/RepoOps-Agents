# Implementation Playbook

## Start Work

1. Use `pmops:start-task`
2. Read the task file in `docs/ops/tasks/`
3. Plan if the change is non-trivial
4. Implement only that task with `pmops:task-workflow`
5. Update the task file and board before stopping

## Create Work

Use `pmops:create-task`

## Close Work

Use `pmops:release-task` for PR prep, then `close-task.sh` only as an internal helper if needed.

## Handoff Work

Use `pmops:handoff-task`

## Audit The Board

Use `pmops:board-audit`

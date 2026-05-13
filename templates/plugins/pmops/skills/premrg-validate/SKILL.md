---
name: premrg-validate
description: Review and validate PR description, code changes, and test coverage before merge.
---

# Pre-Merge PR Validation

## Purpose

Review and validate an open PR before merge. Focus: accurate description, satisfied acceptance criteria, and test coverage. No scope creep.

## Arguments

`/premrg-validate` — run validation on the current branch's PR (or most recent open PR from current branch).

## Steps

### 1. Get PR context

- Run `gh pr view --json title,body,number,state,isDraft,additions,deletions,changedFiles,baseRef --jq '.'`
- Identify base branch (target for merge).
- Confirm PR is open and not draft. If draft, warn user — must mark ready before merge.

### 2. Review PR description

- Read `body` carefully.
- Check whether summary accurately reflects the actual code changes (check with `gh pr diff`).
- Remove AI-generated fluff, vague wording, placeholder tasks like "Add tests" without specifics, "Future improvements", "Considerations", etc.
- Keep description implementation-focused: what changed, why, and what is verified.
- If description needs updates, propose specific edits. Do not modify without user approval.

### 3. Validate acceptance criteria

- Extract acceptance criteria from PR description.
- For each criterion: check whether the code implements it.
- Mark each as: **done**, **partial**, or **missing**.
- Note any unnecessary code that doesn't map to acceptance criteria.

### 4. Run automated tests

- Run `pnpm test` or equivalent test command
- Run `pnpm lint` or equivalent lint command
- Run `pnpm typecheck` or `tsc --noEmit`
- Report results for each

### 5. Manual test plan

For each acceptance criterion that cannot be reliably automated, write a practical step-by-step test plan.

Format:

```
### [AC Name]

1. Go to [URL / condition]
2. Do [action]
3. Expect [result]
```

Keep steps minimal. No more than 5 steps per test. No vague "verify it works" — specific outcomes.

### 6. Output

Produce structured validation report:

```
## PR #NN — [title]

### Description Review
[assessment + proposed edits if any]

### Acceptance Criteria
- [ ] [AC 1]: done / partial / missing
- [ ] [AC 2]: done / partial / missing

### Automated Tests
- test: PASS / FAIL
- lint: PASS / FAIL
- typecheck: PASS / FAIL

### Manual Test Plan
[steps]

### Risks / Gaps
[risk description]

### Merge Recommendation
APPROVE / HOLD — [reason]
```

If everything passes: recommend APPROVE. If gaps exist: recommend HOLD with specific blockers.
---
name: implement-issue
trigger: implement issue / work on #NNN
description: Implements a GitHub issue end-to-end. Use when asked to implement, work on, or fix a specific issue number.
compatibility: Requires the `gh` CLI and an authenticated GitHub session.
---

# Implement a GitHub issue

This skill wraps the Standard Workflow defined in `AGENTS.md`. Run the steps below before and after that workflow.

## Before the standard workflow

**A. Read the issue in full:**

```bash
gh issue view {number}
```

If `gh` is not authenticated, stop and ask the user to authenticate before continuing.

**B. Check/create the branch:**

- If on `main`: `usethis::pr_init("fix-{number}-{description}")`
- Branch format: `fix-{number}-{description}`
  - Parts separated by hyphens; `{description}` uses snake_case
  - Example: `fix-42-validate_input`
- If a branch already exists for this issue, check it out instead

## Run the Standard Workflow from AGENTS.md

Steps 1–9 of the Standard Workflow are the core development loop.

## After the standard workflow

**C. Commit and push:**

1. Review commits already on this branch (not on `main`) — these are all part of the same PR and should inform the PR description:
   ```bash
   git log main..HEAD --oneline
   ```
2. Stage and commit all changes:
   ```bash
   git add -A
   git commit -m "{short imperative summary}"
   ```
3. Push and open the PR:
   ```bash
   gh pr create --fill
   ```
   Use `--title` and `--body` explicitly if `--fill` produces an inadequate description.

This step may be overridden — the user may ask you to stop before committing, handle the push themselves, or complete only part of the workflow. Always follow explicit user instructions over these defaults.

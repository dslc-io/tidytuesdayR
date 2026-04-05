---
name: github
trigger: from github
description: GitHub workflows using the `gh` CLI, including viewing issues/PRs and commit message conventions. Use when interacting with GitHub in any way, such as viewing, creating, or editing issues and pull requests, making commits, or running any `gh` command.
compatibility: Requires the `gh` CLI and an authenticated GitHub session.
---

# GitHub

Use `gh` CLI, not web URLs: `gh issue view 123`, `gh issue list`, `gh pr view 456`, `gh pr list`.

## Commit messages

Conventional commits; backtick-quote function names; close issues in body with `- Closes #N`.

```
feat: add `create_skill()`

Generates a new skill directory with a SKILL.md template.

- Closes #3
```

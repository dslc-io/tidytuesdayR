# AGENTS.md

## Repository overview

**tidytuesdayR** — Access the Weekly ‘TidyTuesday’ Project Dataset

An R package that lets users download weekly datasets and their
documentation from the TidyTuesday GitHub repository
(<https://github.com/rfordatascience/tidytuesday>). Also includes a
curation workflow for contributors who want to submit new datasets.

- Docs: <https://dslc-io.github.io/tidytuesdayR/>
- GitHub: <https://github.com/dslc-io/tidytuesdayR>

### Overall structure

tidytuesdayR/ ├── R/ \# R source code (one file ≈ one function or
concern) │ ├── aaa-*.R \# Shared params, conditions, infrastructure
(loaded first) │ ├── tt_load.R / tt_load_gh.R / tt_download*.R \# Core
data-loading functions │ ├── tt_available.R / tt_datasets.R /
tt_check_date.R \# Discovery & validation │ ├── tt_clean.R / tt_intro.R
/ tt_meta.R / \# Data curation workflow │ │ tt_save_dataset.R /
tt_submit.R / tt_curate\*.R │ ├── use_tidytemplate.R / last_tuesday.R \#
User helpers │ ├── github_api.R / utils.R / utils-pipe.R \# Internal
utilities │ ├── tidytuesdayR-package.R \# Package-level docs │ └── zzz.R
\# Package initialization ├── tests/testthat/ \# testthat v3 test suite
(25+ test files) ├── inst/templates/ \# File templates (cleaning.R,
meta.yaml, intro.md, etc.) ├── vignettes/ \# curating.Rmd — curation
workflow guide ├── man/ \# roxygen2-generated documentation (29 .Rd
files) ├── .github/ │ ├── ISSUE_TEMPLATE/ \# GitHub issue templates │
├── skills/ \# Agent skill definitions │ └── workflows/ \# CI/CD
(R-CMD-check, coverage) ├── DESCRIPTION \# Package metadata and
dependencies ├── NAMESPACE \# Auto-generated exports (do not edit) ├──
NEWS.md \# Changelog ├── \_pkgdown.yml \# pkgdown site configuration └──
AGENTS.md \# This file

### Key files

| File                                                                          | Purpose                                                                                                                                                                                                                                                                                                                                                  |
|-------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `R/tt_load.R`                                                                 | Main user-facing function [`tt_load()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load.md) — loads a dataset by date or year/week                                                                                                                                                                                                              |
| `R/tt_load_gh.R`                                                              | [`tt_load_gh()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load_gh.md) — fetches file list and readme from TidyTuesday GitHub                                                                                                                                                                                                                  |
| `R/tt_download.R` / `R/tt_download_file.R`                                    | Download all or individual dataset files; handles CSV, TSV, RDS, Excel, ZIP, VGZ                                                                                                                                                                                                                                                                         |
| `R/tt_available.R`                                                            | [`tt_available()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_available.md) / [`tt_datasets()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_available.md) — dataset discovery functions                                                                                                                                                 |
| `R/tt_curate_data.R` + `tt_curate_utils.R`                                    | Interactive step-by-step curation workflow                                                                                                                                                                                                                                                                                                               |
| `R/tt_clean.R`, `tt_intro.R`, `tt_meta.R`, `tt_save_dataset.R`, `tt_submit.R` | Individual curation steps; [`tt_submit()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_submit.md) opens a PR                                                                                                                                                                                                                                     |
| `R/use_tidytemplate.R`                                                        | [`use_tidytemplate()`](https://dslc-io.github.io/tidytuesdayR/reference/use_tidytemplate.md) — scaffolds an analysis `.Rmd` for users                                                                                                                                                                                                                    |
| `R/aaa-conditions.R`                                                          | Custom [`.pkg_abort()`](https://dslc-io.github.io/tidytuesdayR/reference/dot-pkg_abort.md) error conditions (uses `stbl`)                                                                                                                                                                                                                                |
| `R/aaa-shared_params.R` / `aaa-shared.R`                                      | Shared roxygen2 `@inheritParams` targets                                                                                                                                                                                                                                                                                                                 |
| `R/github_api.R`                                                              | Internal `gh`-based wrappers for TidyTuesday GitHub API calls                                                                                                                                                                                                                                                                                            |
| `inst/templates/`                                                             | Templates copied by [`tt_clean()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_clean.md), [`tt_intro()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_intro.md), [`tt_meta()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_meta.md), [`use_tidytemplate()`](https://dslc-io.github.io/tidytuesdayR/reference/use_tidytemplate.md) |
| `tests/testthat/`                                                             | One test file per R file; uses fixtures and snapshots                                                                                                                                                                                                                                                                                                    |
| `vignettes/curating.Rmd`                                                      | End-to-end guide for dataset curation contributors                                                                                                                                                                                                                                                                                                       |
| `NEWS.md`                                                                     | Changelog — update under the dev heading for every user-facing change                                                                                                                                                                                                                                                                                    |

------------------------------------------------------------------------

## Standard workflow

For any feature, fix, or refactor:

1.  **Update packages**:
    [`pak::pak()`](https://pak.r-lib.org/reference/pak.html)
2.  **Run tests** — confirm passing before changes:
    `devtools::test(reporter = "check")`. If any fail, stop and ask.
3.  **Plan** — identify affected R files; check if new exports are
    needed.
4.  **Test first** — write failing test, then implement:
    `devtools::test(filter = "name", reporter = "check")`.
5.  **Implement** — minimal code to pass tests.
6.  **Refactor** — clean up, keep tests green.
7.  **Document** — document any new or changed exports.
8.  **Verify**: Run `devtools::test(reporter = "check")`, then
    `devtools::check(error_on = "warning")`. Resolve warnings, errors,
    and NOTEs.
9.  **News** — add bullet at top of `NEWS.md` (under dev heading):
    - User-facing changes only. 1 line, end with `.`
    - Present tense, positive framing, function names (backticks + `()`)
      near start: `` * `fn()` now accepts ... `` not `* Fixed ...`
    - Issue/contributor before final period:
      `` * `fn()` now accepts ... (@user, #N). `` where `#N` is the
      GitHub issue number being implemented (e.g. `#42`).
    - Get username: `gh api user --jq .login`; get issue number from the
      user’s prompt, the branch name (`git branch --show-current`), or
      `gh issue list`.
    - **Never guess or invent an issue number.** Before writing it,
      verify: (1) you received it from the user or the branch name,
      OR (2) you looked it up with `gh`. If you cannot trace the number
      to a concrete source, use `#noissue`.

------------------------------------------------------------------------

## General

- R console: use `--quiet --vanilla`.
- Always run `air format .` after generating R code.
- Comments explain *why*, not *what*.

## Skills

| Triggers                                          | Path                                     |
|---------------------------------------------------|------------------------------------------|
| create GitHub issues                              | @.github/skills/create-issue/SKILL.md    |
| document functions                                | @.github/skills/document/SKILL.md        |
| from github                                       | @.github/skills/github/SKILL.md          |
| implement issue / work on \#NNN                   | @.github/skills/implement-issue/SKILL.md |
| writing R functions / API design / error handling | @.github/skills/r-code/SKILL.md          |
| search / rewrite code                             | @.github/skills/search-code/SKILL.md     |
| writing or reviewing tests                        | @.github/skills/tdd-workflow/SKILL.md    |

# Changelog

## tidytuesdayR 1.3.2

- \[tests\] No user-facing changes.

## tidytuesdayR 1.3.1

- \[tests\] No user-facing changes.

## tidytuesdayR 1.3.0

- \[messaging\] Missing GitHub credentials now produce a clearer error
  message ([\#135](https://github.com/dslc-io/tidytuesdayR/issues/135)).
- \[bug fix\]
  [`tt_curate_data()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_curate_data.md)
  now works in Positron and other IDEs, not just RStudio. It also gains
  an `open` parameter for consistency with other curation functions
  ([\#139](https://github.com/dslc-io/tidytuesdayR/issues/139)).
- \[feature\]
  [`tt_meta()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_meta.md)
  now reads attribution defaults from
  `getOption("tidytuesdayR.attribution")`,
  `getOption("tidytuesdayR.bluesky")`,
  `getOption("tidytuesdayR.linkedin")`, and
  `getOption("tidytuesdayR.mastodon")`. Set these in your `.Rprofile`
  via
  [`usethis::edit_r_profile()`](https://usethis.r-lib.org/reference/edit.html)
  to avoid re-entering them with each submission
  ([\#142](https://github.com/dslc-io/tidytuesdayR/issues/142)).
- \[feature\]
  [`tt_submit()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_submit.md)
  now handles submitter forks more reliably: it correctly discovers
  existing forks, syncs them with the latest version of the TidyTuesday
  repository, and accurately determines which files need updating
  ([\#135](https://github.com/dslc-io/tidytuesdayR/issues/135),
  [\#147](https://github.com/dslc-io/tidytuesdayR/issues/147)).
- \[feature\]
  [`tt_submit()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_submit.md)
  now verifies that CSVs and images have acceptable sizes before
  attempting to submit the pull request
  ([\#140](https://github.com/dslc-io/tidytuesdayR/issues/140),
  [\#141](https://github.com/dslc-io/tidytuesdayR/issues/141)).

## tidytuesdayR 1.2.1

CRAN release: 2025-04-29

- \[tests\] No user-facing changes.

## tidytuesdayR 1.2.0

CRAN release: 2025-04-28

- \[feature\] Added functions
  [`tt_clean()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_clean.md),
  [`tt_save_dataset()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_save_dataset.md),
  [`tt_intro()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_intro.md),
  [`tt_meta()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_meta.md),
  and
  [`tt_submit()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_submit.md)
  for curation and submission of datasets for use in TidyTuesday. See
  [`vignette("curating", package = "tidytuesdayR")`](https://dslc-io.github.io/tidytuesdayR/articles/curating.md)
  for details.
  ([\#117](https://github.com/dslc-io/tidytuesdayR/issues/117),
  [\#118](https://github.com/dslc-io/tidytuesdayR/issues/118),
  [\#120](https://github.com/dslc-io/tidytuesdayR/issues/120),
  [\#121](https://github.com/dslc-io/tidytuesdayR/issues/121),
  [\#123](https://github.com/dslc-io/tidytuesdayR/issues/123),
  [\#124](https://github.com/dslc-io/tidytuesdayR/issues/124),
  [\#130](https://github.com/dslc-io/tidytuesdayR/issues/130))
- \[feature\] Added function
  [`tt_curate_data()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_curate_data.md)
  with step-by-step script for curation and submission of datasets as
  described in
  [`vignette("curating", package = "tidytuesdayR")`](https://dslc-io.github.io/tidytuesdayR/articles/curating.md).
  ([\#128](https://github.com/dslc-io/tidytuesdayR/issues/128))
- \[bug fix\]
  [`use_tidytemplate()`](https://dslc-io.github.io/tidytuesdayR/reference/use_tidytemplate.md)
  now explicitly takes an `ignore` argument, rather than passing (almost
  entirely overruled) `...` through to
  [`usethis::use_template()`](https://usethis.r-lib.org/reference/use_template.html).
  ([\#76](https://github.com/dslc-io/tidytuesdayR/issues/76),
  [\#113](https://github.com/dslc-io/tidytuesdayR/issues/113))
- \[bug fix\] Attempting to load data for particularly strange, early
  weeks (2018 weeks 7 and 8) now errors more informatively.
  ([\#90](https://github.com/dslc-io/tidytuesdayR/issues/90),
  [\#113](https://github.com/dslc-io/tidytuesdayR/issues/113))
- \[maintenance\] The `Language` of this package is officially declared
  in the DESCRIPTION as “en-US”.
  ([\#114](https://github.com/dslc-io/tidytuesdayR/issues/114))
- \[maintenance\] The [{usethis}](https://usethis.r-lib.org) package is
  now Suggested, rather than Imported, since it is not necssary for the
  core functionality of this package.
  ([\#117](https://github.com/dslc-io/tidytuesdayR/issues/117))
- \[maintenance\] We now support versions of R \>= `4.1.0`.
  ([\#126](https://github.com/dslc-io/tidytuesdayR/issues/126))

## tidytuesdayR 1.1.2

CRAN release: 2024-09-09

- \[maintenance\] tidytuesdayR now uses the {gh} package to manage all
  interactions with the GitHub API. This should make the package more
  stable and easier to maintain.
  ([\#78](https://github.com/dslc-io/tidytuesdayR/issues/78))
- \[maintenance\] tidytuesdayR is now maintained by the Data Science
  Learning Community.

## tidytuesdayR 1.0.3

CRAN release: 2023-12-13

- \[bug fix\] Address case where rate limit hit when trying to test

## tidytuesdayR 1.0.2

CRAN release: 2022-02-01

- \[bug fix\] During testing it was identified that 502 errors from
  github servers would cause the code to error out. Now it will retry a
  few times before giving an error.
- \[bug fix\] No internet connection bug on rstudio resolved due to
  malformed url checks (https).
- \[bug fix\] Partial argument matching correction in
  `tt_download_file.character()`, `tt_parse_blob()`, and in tests.
  (thanks [@mgirlich](https://github.com/mgirlich))

## tidytuesdayR 1.0.1

CRAN release: 2020-07-10

- \[feature\] Provide a template Rmd for users, populated with date and
  proper `tt_load` call
- \[bug fix\] On CRAN Solaris build, the 🔗(link) emoji caused issues.
  Added fix to change encoding to native.
- \[bug fix\]
  [`tt_available()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_available.md)
  printed out twice. This has been corrected.

## tidytuesdayR 1.0.0

CRAN release: 2020-06-26

- Massive update to all the internals of tidytuesdayR
- \[feature\] allow for using authentication using github PAT’s
- finer control of downloading files via the `download_files` argument
  of
  [`tt_load()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load.md)
- internal functions all now use GET arguments to use the github API

## tidytuesdayR 0.2.2

- Added a `NEWS.md` file to track changes to the package.
- Major updates and better documentation

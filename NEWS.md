# tidytuesdayR 1.3.1

* [tests] Limited test threads for safer CRAN testing.

# tidytuesdayR 1.3.0

* [messaging] Missing GitHub credentials now produce a clearer error message
  (#135).
* [bug fix] `tt_curate_data()` now works in Positron and other IDEs, not just
  RStudio. It also gains an `open` parameter for consistency with other
  curation functions (#139).
* [feature] `tt_meta()` now reads attribution defaults from
  `getOption("tidytuesdayR.attribution")`,
  `getOption("tidytuesdayR.bluesky")`, `getOption("tidytuesdayR.linkedin")`,
  and `getOption("tidytuesdayR.mastodon")`. Set these in your `.Rprofile` via
  `usethis::edit_r_profile()` to avoid re-entering them with each submission
  (#142).
* [feature] `tt_submit()` now handles submitter forks more reliably: it
  correctly discovers existing forks, syncs them with the latest version of
  the TidyTuesday repository, and accurately determines which files need
  updating (#135, #147).
* [feature] `tt_submit()` now verifies that CSVs and images have acceptable
  sizes before attempting to submit the pull request (#140, #141).

# tidytuesdayR 1.2.1
* [tests] No user-facing changes.

# tidytuesdayR 1.2.0

* [feature] Added functions `tt_clean()`, `tt_save_dataset()`, `tt_intro()`, `tt_meta()`, and `tt_submit()` for curation and submission of datasets for use in TidyTuesday. See `vignette("curating", package = "tidytuesdayR")` for details. (#117, #118, #120, #121, #123, #124, #130)
* [feature] Added function `tt_curate_data()` with step-by-step script for curation and submission of datasets as described in `vignette("curating", package = "tidytuesdayR")`. (#128)
* [bug fix] `use_tidytemplate()` now explicitly takes an `ignore` argument, rather than passing (almost entirely overruled) `...` through to `usethis::use_template()`. (#76, #113)
* [bug fix] Attempting to load data for particularly strange, early weeks (2018 weeks 7 and 8) now errors more informatively. (#90, #113)
* [maintenance] The `Language` of this package is officially declared in the DESCRIPTION as "en-US". (#114)
* [maintenance] The [{usethis}](https://usethis.r-lib.org) package is now Suggested, rather than Imported, since it is not necssary for the core functionality of this package. (#117)
* [maintenance] We now support versions of R >= `4.1.0`. (#126)

# tidytuesdayR 1.1.2

* [maintenance] tidytuesdayR now uses the {gh} package to manage all interactions with the GitHub API. This should make the package more stable and easier to maintain. (#78)
* [maintenance] tidytuesdayR is now maintained by the Data Science Learning Community. 

# tidytuesdayR 1.0.3

* [bug fix] Address case where rate limit hit when trying to test

# tidytuesdayR 1.0.2

* [bug fix] During testing it was identified that 502 errors from github servers would cause the code to error out. Now it will retry a few times before giving an error.
* [bug fix] No internet connection bug on rstudio resolved due to malformed url checks (https).
* [bug fix] Partial argument matching correction in `tt_download_file.character()`, `tt_parse_blob()`, and in tests. (thanks @mgirlich)

# tidytuesdayR 1.0.1

* [feature] Provide a template Rmd for users, populated with date and proper `tt_load` call
* [bug fix] On CRAN Solaris build, the :link:(link) emoji caused issues. Added fix to change encoding to native.
* [bug fix] `tt_available()` printed out twice. This has been corrected.

# tidytuesdayR 1.0.0

* Massive update to all the internals of tidytuesdayR
* [feature] allow for using authentication using github PAT's
* finer control of downloading files via the `download_files` argument of `tt_load()`
* internal functions all now use GET arguments to use the github API

# tidytuesdayR 0.2.2

* Added a `NEWS.md` file to track changes to the package.
* Major updates and better documentation

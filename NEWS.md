# tidytuesdayR (1.0.3 version)
* [bug fix] Address case where when trying to test

# tidytuesdayR (1.0.2 version)

* [bug fix] During testing it was identified that 502 errors from github servers would cause the code to error out. Now it will retry a few times before giving an error.
* [bug fix] No internet connection bug on rstudio resolved to due malformed url checks (https).
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

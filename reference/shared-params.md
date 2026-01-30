# Parameters used in multiple functions

Reused parameter definitions are gathered here for easier editing.

## Arguments

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

- files:

  Which file names to download. Default "All" downloads all files for
  the specified week.

- path:

  The relative path to the directory to hold your submission files
  (`tt_submission` by default). If this directory does not exist, it
  will be created.

- tt:

  A `tt` object, output from
  [`tt_load_gh()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load_gh.md).

- week:

  Which week number to use within a given year. Only used when `x` is a
  valid year.

- x:

  The date of data to pull (in "YYYY-MM-dd" format), or the four-digit
  year as a number.

- year:

  What year of TidyTuesday to use

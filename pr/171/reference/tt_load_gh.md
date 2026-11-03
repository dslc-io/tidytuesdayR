# Load TidyTuesday data from Github

Pulls the readme and URLs of the data from the TidyTuesday github folder
based on the date provided

## Usage

``` r
tt_load_gh(x, week = NULL, auth = gh::gh_token())
```

## Arguments

- x:

  The date of data to pull (in "YYYY-MM-dd" format), or the four-digit
  year as a number.

- week:

  Which week number to use within a given year. Only used when `x` is a
  valid year.

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

## Value

A `tt` object. This contains the files available for the week, readme
html, and the date of the TidyTuesday.

## Examples

``` r
if (FALSE) { # interactive()
# check to make sure there are requests still available
if (rate_limit_check(quiet = TRUE) > 30) {
  tt_gh <- tt_load_gh("2019-01-15")
  ## readme attempts to open the readme for the weekly dataset
  readme(tt_gh)

  agencies <- tt_download(
    tt_gh,
    files = "agencies.csv"
  )
}
}
```

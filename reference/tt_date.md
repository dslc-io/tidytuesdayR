# Get date of TidyTuesday, given the year and week

Sometimes we don't know the date we want, but we do know the week. This
function provides the ability to pass the year and week we are
interested in to get the correct date

## Usage

``` r
tt_date(year, week = NULL, auth = gh::gh_token())
```

## Arguments

- year:

  What year of TidyTuesday to use

- week:

  Which week number to use within a given year. Only used when `x` is a
  valid year.

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

# Generate valid TidyTuesday URL

Given multiple types of inputs, generate a valid TidyTuesday URL.

## Usage

``` r
tt_check_date(x, week = NULL, auth = gh::gh_token())
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

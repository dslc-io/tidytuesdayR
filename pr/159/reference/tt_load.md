# Load TidyTuesday data from Github

Load TidyTuesday data from Github

## Usage

``` r
tt_load(x, week = NULL, files = "All", ..., auth = gh::gh_token())
```

## Arguments

- x:

  The date of data to pull (in "YYYY-MM-dd" format), or the four-digit
  year as a number.

- week:

  Which week number to use within a given year. Only used when `x` is a
  valid year.

- files:

  Which file names to download. Default "All" downloads all files for
  the specified week.

- ...:

  Additional parameters to pass to the parsing functions. Note: These
  arguments will be passed for all filetypes.

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

## Value

`tt_data` object, which contains data that can be accessed via `$`, and
the readme for the week's TidyTuesday, which can be viewed by printing
the object or calling
[`readme()`](https://dslc-io.github.io/tidytuesdayR/reference/readme.md).

## Examples

``` r
if (FALSE) { # interactive()
tt_output <- tt_load("2019-01-15")
tt_output
agencies <- tt_output$agencies
}
```

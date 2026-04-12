# Download TidyTuesday data

Download all or specific files identified in a TidyTuesday dataset.

## Usage

``` r
tt_download(tt, files = "All", ..., auth = gh::gh_token())
```

## Arguments

- tt:

  A `tt` object, output from
  [`tt_load_gh()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load_gh.md).

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

A list of tibbles from the downloaded files.

## Examples

``` r
if (FALSE) { # interactive()
# Get the list of files for a week.
tt_output <- tt_load_gh("2019-01-15")

# Download a specific file.
agencies <- tt_download(tt_output, files = "agencies.csv")
}
```

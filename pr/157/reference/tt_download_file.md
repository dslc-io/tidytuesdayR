# Download a TidyTuesday dataset file

Download an actual data file from the TidyTuesday github repository.

## Usage

``` r
tt_download_file(tt, x, ..., auth = gh::gh_token())
```

## Arguments

- tt:

  A `tt` object, output from
  [`tt_load_gh()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load_gh.md).

- x:

  Index or name of file to download.

- ...:

  Additional parameters to pass to the parsing functions. Note: These
  arguments will be passed for all filetypes.

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

## Value

tibble containing the contents of the file downloaded from git

## Examples

``` r
if (FALSE) { # interactive()
tt_gh <- tt_load_gh("2019-01-15")

agencies <- tt_download_file(tt_gh, 1)
launches <- tt_download_file(tt_gh, "launches.csv")
}
```

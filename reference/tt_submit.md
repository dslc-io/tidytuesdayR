# Submit a TidyTuesday dataset

Submit a curated dataset for review by uploading it to GitHub and
creating a pull request. The dataset should be prepared using
[`tt_clean()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_clean.md),
[`tt_save_dataset()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_save_dataset.md),
[`tt_intro()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_intro.md),
and
[`tt_meta()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_meta.md).
You can also use this function to submit changes to your local copies of
the files.

## Usage

``` r
tt_submit(
  path = "tt_submission",
  auth = gh::gh_token(),
  open = rlang::is_interactive()
)
```

## Arguments

- path:

  The relative path to the directory to hold your submission files
  (`tt_submission` by default). If this directory does not exist, it
  will be created.

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

- open:

  Whether to open the pull request in a browser. Defaults to `TRUE` in
  an interactive session.

## Value

The URL of the pull request, invisibly.

## Examples

``` r
if (FALSE) { # interactive()
# First set up a dataset in the "tt_submission" folder.
tt_submit()
}
```

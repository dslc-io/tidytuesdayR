# Get Master List of Files from TidyTuesday

Import or update dataset from github that records the entire list of
objects from TidyTuesday

## Usage

``` r
tt_master_file(force = FALSE, auth = gh::gh_token())
```

## Arguments

- force:

  force the update to occur even if the SHA matches

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

## Value

The tt master file, updated if necessary.

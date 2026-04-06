# Decide whether to update the master file

Decide whether to update the master file

## Usage

``` r
should_update_tt_master_file(force = FALSE, auth = gh::gh_token())
```

## Arguments

- force:

  force the update to occur even if the SHA matches

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

## Value

Boolean indicating whether the master file should be updated.

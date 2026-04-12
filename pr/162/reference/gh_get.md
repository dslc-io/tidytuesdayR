# Get data from the tt github repo.

Get data from the tt github repo.

## Usage

``` r
gh_get(path, auth = gh::gh_token(), ...)
```

## Arguments

- path:

  Path within the `rfordatascience/tidytuesday` repo.

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

- ...:

  Additional parameters passed to
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

## Value

The GitHub response as parsed by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

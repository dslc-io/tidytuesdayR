# Set up a directory for dataset curation

Set up a directory for dataset curation

## Usage

``` r
prep_tt_curate(
  path = "tt_submission",
  ignore = FALSE,
  env = rlang::caller_env()
)
```

## Arguments

- path:

  The relative path to the directory to hold your submission files
  (`tt_submission` by default). If this directory does not exist, it
  will be created.

- ignore:

  Should the newly created file be added to `.Rbuildignore`?

## Value

The resolved path (invisibly).

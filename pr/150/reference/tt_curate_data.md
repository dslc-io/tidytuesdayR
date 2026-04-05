# Guidance for TidyTuesday dataset curation

Open an R script to guide you through the process of curating and
submitting a TidyTuesday dataset. See
`vignette("curating", package = "tidytuesdayR)` for more information.

## Usage

``` r
tt_curate_data(open = rlang::is_interactive())
```

## Arguments

- open:

  Whether to open the file for interactive editing.

## Value

The path to the `tt_curation.R` script, invisibly.

## Examples

``` r
tt_curate_data()
```

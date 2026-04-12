# Listing all available TidyTuesdays

The TidyTuesday project is a constantly growing repository of data sets.
Knowing what type of data is available for each week requires going to
the source. However, one of the hallmarks of 'tidytuesdayR' is that you
never have to leave your R console. These functions were created to help
maintain this philosophy.

## Usage

``` r
tt_available(auth = gh::gh_token())

tt_datasets(year, auth = gh::gh_token())
```

## Arguments

- auth:

  A GitHub token. See
  [`gh::gh_token()`](https://gh.r-lib.org/reference/gh_token.html) for
  more details.

- year:

  What year of TidyTuesday to use

## Value

`tt_available()` returns a `tt_dataset_table_list`, which is a list of
`tt_dataset_table`. This class has special printing methods to show the
available data sets.

`tt_datasets()` returns a `tt_dataset_table` object. This class has
special printing methods to show the available datasets for the year.

## Details

To find out the available datasets for a specific year, the user can use
the function `tt_datasets()`. This function will either populate the
Viewer or print to console all the available data sets and the week/date
they are associated with.

To get the whole list of all the data sets ever released by TidyTuesday,
the function `tt_available()` was created. This function will either
populate the Viewer or print to console all the available data sets ever
made for TidyTuesday.

## Examples

``` r
if (FALSE) { # interactive()
# check to make sure there are requests still available
if (rate_limit_check(quiet = TRUE) > 30) {
  ## show data available from 2018
  tt_datasets(2018)

  ## show all data available ever
  tt_available()
}
}
```

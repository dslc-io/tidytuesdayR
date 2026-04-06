# Find the most recent tuesday

Identify the most recent 'TidyTuesday' date relative to a specified
date.

## Usage

``` r
last_tuesday(date = today(tzone = "America/New_York"))
```

## Arguments

- date:

  A date as a date object or character string in `YYYY-MM-DD` format.
  Defaults to today's date.

## Value

The TidyTuesday date in the same week as the specified date, using
Monday as the start of the week.

## Examples

``` r
last_tuesday() # get last Tuesday relative to today's date
#> [1] "2026-03-31"
last_tuesday("2020-01-01") # get last Tuesday relative to a specified date
#> [1] "2019-12-31"
```

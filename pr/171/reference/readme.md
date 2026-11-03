# Readme HTML maker and Viewer

Readme HTML maker and Viewer

## Usage

``` r
readme(tt)
```

## Arguments

- tt:

  tt_data object for printing

## Value

Null, invisibly. Used to show readme of the downloaded TidyTuesday
dataset in the Viewer.

## Examples

``` r
if (FALSE) { # interactive()
if (rate_limit_check(quiet = TRUE) > 30) {
  tt_output <- tt_load_gh("2019-01-15")
  readme(tt_output)
}
}
```

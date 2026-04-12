# Printing Utilities for Listing Available Datasets

printing utilities for showing the available datasets for a specific
year or all time

## Usage

``` r
# S3 method for class 'tt_dataset_table'
print(x, ..., is_interactive = interactive())

# S3 method for class 'tt_dataset_table_list'
print(x, ..., is_interactive = interactive())
```

## Arguments

- x:

  an object used to select a method.

- ...:

  further arguments passed to or from other methods.

- is_interactive:

  Whether the function is being used interactively.

## Value

`x`, invisibly

## Examples

``` r
if (FALSE) { # interactive()
# check to make sure there are requests still available
if (rate_limit_check(quiet = TRUE) > 30) {
  available_datasets_2018 <- tt_datasets(2018)
  print(available_datasets_2018)

  all_available_datasets <- tt_available()
  print(all_available_datasets)
}
}
```

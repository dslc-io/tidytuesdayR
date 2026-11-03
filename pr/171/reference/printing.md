# print methods of the tt objects

In tidytuesdayR there are nice print methods for the objects that were
used to download and store the data from the TidyTuesday repo. They will
always print the available datasets/files. If there is a readme
available, it will try to display the TidyTuesday readme.

## Usage

``` r
# S3 method for class 'tt_data'
print(x, ...)

# S3 method for class 'tt'
print(x, ...)
```

## Arguments

- x:

  a tt_data or tt object

- ...:

  further arguments passed to or from other methods.

## Value

`x`, invisibly.

## Examples

``` r
if (FALSE) { # interactive()
tt <- tt_load_gh("2019-01-15")
print(tt)

tt_data <- tt_download(tt, files = "All")
print(tt_data)
}
```

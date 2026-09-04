# Create and open cleaning.R

The first step of curating a TidyTuesday dataset is cleaning the data.
This function creates a simple `cleaning.R` file in the specified path
(creating that path if it does not already exist), and (if possible)
opens it for editing.

## Usage

``` r
tt_clean(
  path = "tt_submission",
  open = rlang::is_interactive(),
  ignore = FALSE
)
```

## Arguments

- path:

  The relative path to the directory to hold your submission files
  (`tt_submission` by default). If this directory does not exist, it
  will be created.

- open:

  Open the newly created file for editing? Happens in RStudio, if
  applicable, or via
  [`utils::file.edit()`](https://rdrr.io/r/utils/file.edit.html)
  otherwise.

- ignore:

  Should the newly created file be added to `.Rbuildignore`?

## Value

A logical vector indicating whether the file was created or modified,
invisibly.

## Examples

``` r
if (FALSE) { # interactive()

  tt_clean()
}
```

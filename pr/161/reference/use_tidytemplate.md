# Create and open the tidytemplate

Use the tidytemplate Rmd for starting your analysis with a leg up for
processing

## Usage

``` r
use_tidytemplate(
  name = NULL,
  open = rlang::is_interactive(),
  refdate = today(),
  ignore = FALSE
)
```

## Arguments

- name:

  A name for your generated TidyTuesday analysis Rmd, such as
  "My_TidyTuesday.Rmd".

- open:

  Open the newly created file for editing? Happens in RStudio, if
  applicable, or via
  [`utils::file.edit()`](https://rdrr.io/r/utils/file.edit.html)
  otherwise.

- refdate:

  Date to use as reference to determine which TidyTuesday to use for the
  template. Either date object or character string in YYYY-MM-DD format.

- ignore:

  Should the newly created file be added to `.Rbuildignore`?

## Value

A logical vector indicating whether the file was created or modified,
invisibly.

## Examples

``` r
if (FALSE) { # interactive()

  use_tidytemplate(name = "My_Awesome_TidyTuesday.Rmd")
}
```

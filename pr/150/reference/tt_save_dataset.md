# Save datasets for submission

Datasets for TidyTuesday submissions should be saved in a specific
format, with an accompanying data dictionary `dataset_name.md` file.
This function saves the dataset as a CSV file in your submission
directory (creating the submission directory if it does not already
exist), and creates a data dictionary file for you to fill out. If
you're in an interactive session, the dictionary file is opened for
editing.

## Usage

``` r
tt_save_dataset(
  dataset,
  path = "tt_submission",
  dataset_name = rlang::caller_arg(dataset),
  open = rlang::is_interactive(),
  ignore = FALSE
)
```

## Arguments

- dataset:

  The clean dataset to save. The dataset must be a data.frame.

- path:

  The relative path to the directory to hold your submission files
  (`tt_submission` by default). If this directory does not exist, it
  will be created.

- dataset_name:

  The name to save the dataset as. By default, the name of the dataset
  variable is used.

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

  tt_save_dataset(mtcars)
}
```

#' Save datasets for submission
#'
#' Datasets for TidyTuesday submissions should be saved in a specific format,
#' with an accompanying data dictionary `dataset_name.md` file. This function
#' saves the dataset as a CSV file in your submission directory (creating the
#' submission directory if it does not already exist), and creates a data
#' dictionary file for you to fill out. If you're in an interactive session, the
#' dictionary file is opened for editing.
#'
#' @inheritParams usethis::use_template
#' @inheritParams shared-params
#' @param dataset The clean dataset to save. The dataset must be a data.frame.
#' @param dataset_name The name to save the dataset as. By default, the name of
#'   the dataset variable is used.
#'
#' @returns A logical vector indicating whether the file was created or
#'   modified, invisibly.
#' @export
#'
#' @examplesIf interactive()
#'
#'   tt_save_dataset(mtcars)
tt_save_dataset <- function(
  dataset,
  path = "tt_submission",
  dataset_name = rlang::caller_arg(dataset),
  open = rlang::is_interactive(),
  ignore = FALSE
) {
  prep_tt_curate(path, ignore = ignore)
  rlang::check_installed(c("readr"), "to save the dataset CSV.")
  path <- usethis::proj_path(path)

  dataset_path <- fs::path(path, dataset_name, ext = "csv")
  readr::write_csv(dataset, dataset_path)

  dictionary <- create_tt_dict(dataset)
  dictionary_path <- fs::path(path, dataset_name, ext = "md")
  cat(dictionary, file = dictionary_path, sep = "\n")
  usethis::edit_file(dictionary_path, open = open)
  return(invisible(TRUE))
}

create_tt_dict <- function(x) {
  rlang::check_installed(
    c("tibble", "dplyr", "knitr", "vctrs"),
    "to create a data dictionary."
  )
  tibble::tibble(variable = names(x)) |>
    dplyr::mutate(
      class = purrr::map(x, \(var) vctrs::vec_ptype_full(var)),
      description = "Describe this field in sentence case."
    ) |>
    knitr::kable()
}

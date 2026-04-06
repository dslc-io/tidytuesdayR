#' Create and open cleaning.R
#'
#' The first step of curating a TidyTuesday dataset is cleaning the data. This
#' function creates a simple `cleaning.R` file in the specified path (creating
#' that path if it does not already exist), and (if possible) opens it for
#' editing.
#'
#' @inheritParams usethis::use_template
#' @inheritParams .shared-params
#'
#' @returns A logical vector indicating whether the file was created or
#'   modified, invisibly.
#' @export
#'
#' @examplesIf interactive()
#'
#'   tt_clean()
tt_clean <- function(
  path = "tt_submission",
  open = rlang::is_interactive(),
  ignore = FALSE
) {
  prep_tt_curate(path, ignore = ignore)
  cleaning_path <- fs::path(path, "cleaning.R")

  usethis::use_template(
    "cleaning.R",
    save_as = cleaning_path,
    ignore = ignore,
    open = open,
    package = "tidytuesdayR"
  )
}

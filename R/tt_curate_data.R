#' Guidance for TidyTuesday dataset curation
#'
#' Open an R script to guide you through the process of curating and submitting
#' a TidyTuesday dataset. See `vignette("curating", package = "tidytuesdayR)`
#' for more information.
#'
#' @inheritParams usethis::edit_file
#'
#' @returns The path to the `tt_curation.R` script, invisibly.
#' @export
#'
#' @examples
#' tt_curate_data()
tt_curate_data <- function(open = rlang::is_interactive()) {
  path <- system.file("templates", "tt_curation.R", package = "tidytuesdayR")
  if (open) {
    # nocov start
    rlang::check_installed("usethis", "to open the curation script.")
    usethis::edit_file(path)
    # nocov end
  }
  return(invisible(path))
}

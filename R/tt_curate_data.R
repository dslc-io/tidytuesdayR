#' Guidance for TidyTuesday dataset curation
#'
#' Open an R script to guide you through the process of curating and submitting
#' a TidyTuesday dataset. See `vignette("curating", package = "tidytuesdayR)`
#' for more information.
#'
#' @returns The path to the `tt_curation.R` script, invisibly.
#' @export
#'
#' @examples
#' tt_curate_data()
tt_curate_data <- function() {
  path <- system.file("templates", "tt_curation.R", package = "tidytuesdayR")
  if (rlang::is_interactive()) {
    # nocov start
    if (rlang::is_installed("rstudioapi")) {
      rstudioapi::documentOpen(path)
    } else {
      utils::browseURL(path)
    }
  } # nocov end
  return(invisible(path))
}

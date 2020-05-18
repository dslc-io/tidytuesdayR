#' @title Load TidyTuesday data from Github
#'
#' @param x string representation of the date of data to pull, in YYYY-MM-dd format, or just numeric entry for year
#' @param week left empty unless x is a numeric year entry, in which case the week of interest should be entered
#' @param ... pass methods to the parsing functions. These will be passed to ALL files, so be careful.
#' @return tt_data object (list class)
#'
#' @export
#'
#' @importFrom purrr map
#'
#' @examples
#' tt_output <- tt_load("2019-01-15")
tt_load <- function(x, week, ...) {
  tt <- tt_load_gh(x, week)
  message("--- Downloading files ---")
  tt_data <- purrr::map(attr(tt, ".files"), function(x) tt_read_data(tt, x, ... ))
  names(tt_data) <- tools::file_path_sans_ext(attr(tt, ".files"))
  message("--- Download complete ---")
  structure(
    tt_data,
    ".tt" = tt,
    class = "tt_data"
  )
}


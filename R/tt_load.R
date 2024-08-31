#' Load TidyTuesday data from Github
#'
#' @inheritParams shared-params
#' @inheritParams tt_download
#'
#' @return `tt_data` object, which contains data that can be accessed via `$`,
#'   and the readme for the week's TidyTuesday, which can be viewed by printing
#'   the object or calling [readme()].
#'
#' @examplesIf interactive()
#' tt_output <- tt_load("2019-01-15")
#' tt_output
#' agencies <- tt_output$agencies
#'
#' @export
tt_load <- function(x,
                    week = NULL,
                    files = "All",
                    ...,
                    auth = gh::gh_token()) {
  # download readme and identify files
  tt <- tt_load_gh(x, week, auth = auth)

  # download files
  tt_data <- tt_download(tt, files = files, ..., auth = auth)

  ## return tt_data object
  structure(
    tt_data,
    ".tt" = tt,
    class = "tt_data"
  )
}

#' @rdname printing
#' @importFrom tools file_path_sans_ext
#' @export
#' @return used to show readme and list names of available datasets
print.tt_data <- function(x, ...) {
  readme(x)
  message(
    "Available datasets:\n\t",
    paste(tools::file_path_sans_ext(names(x)), "\n\t", collapse = "")
  )
  invisible(x)
}

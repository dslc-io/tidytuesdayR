#' Load TidyTuesday data from Github
#'
#' Pulls the readme and URLs of the data from the TidyTuesday
#' github folder based on the date provided
#'
#' @inheritParams gh_get
#' @inheritParams shared-params
#'
#' @return A `tt` object. This contains the files available for the week,
#'  readme html, and the date of the TidyTuesday.
#' @export
#' @examplesIf interactive()
#' # check to make sure there are requests still available
#' if (rate_limit_check(quiet = TRUE) > 30) {
#'   tt_gh <- tt_load_gh("2019-01-15")
#'   ## readme attempts to open the readme for the weekly dataset
#'   readme(tt_gh)
#'
#'   agencies <- tt_download(
#'     tt_gh,
#'     files = "agencies.csv"
#'   )
#' }
tt_load_gh <- function(x, week = NULL, auth = gh::gh_token()) {
  # Need the date before we start messaging.
  tt_date <- tt_check_date(x, week, auth = auth)

  cli::cli_inform(
    "---- Compiling #TidyTuesday Information for {tt_date} ----"
  )

  tt_compilation <- tt_compile(tt_date)
  n_files <- NROW(tt_compilation$files)
  cli::cli_inform(
    "--- There {cli::qty(n_files)} {?are/is/are} {n_files} file{?s} available ---"
  )

  structure(
    tt_compilation$files$data_files,
    ".files" = tt_compilation$files,
    ".readme" = tt_compilation$readme,
    ".date" = tt_date,
    class = "tt"
  )
}

#' Get TidyTuesday readme and list of files and HTML based on the date
#'
#' @inheritParams gh_get
#' @param date date of TidyTuesday of interest
#'
#' @keywords internal
tt_compile <- function(date, auth = gh::gh_token()) {
  files <- tt_week_data_files(date, auth = auth)
  readme <- tt_week_readme_html(date, auth = auth)
  list(
    files = files,
    readme = readme
  )
}

tt_week_data_files <- function(date, auth = gh::gh_token()) {
  ttmf <- tt_master_file()
  ttmf[ttmf$Date == date, c("data_files", "data_type", "delim")]
}

tt_week_readme_html <- function(date, auth = gh::gh_token()) {
  gh_get_readme_html(
    file.path("data", lubridate::year(date), date),
    auth = auth
  )
}

#' @rdname printing
#' @export
#' @return `x`, invisibly.
print.tt <- function(x, ...) {
  message(
    "Available datasets in this TidyTuesday:\n\t",
    paste(attr(x, ".files")$data_files, "\n\t", collapse = "")
  )
  invisible(x)
}

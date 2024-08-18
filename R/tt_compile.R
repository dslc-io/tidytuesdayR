#' @title Get TidyTuesday readme and list of files and HTML based on the date
#' @param date date of TidyTuesday of interest
#' @param auth github Personal Access Token
#'
#' @importFrom lubridate year
#' @noRd
#'
tt_compile <- function(date, auth = github_pat()) {
  ttmf <- tt_master_file()

  # list of files
  files <- ttmf[ttmf$Date == date, c("data_files", "data_type", "delim")]

  readme <- try(
    github_html(file.path("data", year(date), date, "readme.md"), auth = auth),
    silent = TRUE
  )

  if (inherits(readme, "try-error")) {
    readme <- NULL
  }

  list(
    files = files,
    readme = readme
  )
}

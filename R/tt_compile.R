#' @title Get TidyTuesday Readme and list of files and HTML based on the date
#' @param date date of tidytuesday of interest
#' @param auth github Personal Access Token
#'
#' @importFrom lubridate year
#' @noRd
#'
tt_compile <- function(date, auth = github_pat()) {

  ttmf <- tt_master_file()

  #list of files
  files <- ttmf[ ttmf$Date == date, c("data_files","data_type","delim")]

  readme <- github_html(file.path("data",year(date),date,"readme.md"), auth = auth)

  list(
    files = files,
    readme = readme
  )
}

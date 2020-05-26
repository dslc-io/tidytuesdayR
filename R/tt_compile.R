#' @title Get TidyTuesday Readme and list of files and HTML
#' @param date date of tidytuesday of interest
#' @param auth github Personal Access Token. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @importFrom lubridate year
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

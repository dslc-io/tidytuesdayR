#' @title Get TidyTuesday Readme and list of files and HTML
#' @param date date of tidytuesday of interest
#' @importFrom lubridate year
tt_compile <- function(date) {

  ttmf <- tt_master_file()

  #list of files
  files <- ttmf %>%
    filter(week_date == date) %>%
    select(data_files, data_type, delim)

  readme <- github_html(file.path("data",year(date),date,"readme.md"))

  list(
    files = files,
    readme = readme
  )
}

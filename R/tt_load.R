#' @title  Load TidyTuesday data from Github
#'
#' @description Pulls the Readme and URLs of the data from the TidyTuesday github folder based on the date provided
#'
#' @param week string representation of the date of data to pull, in YYYY-MM-dd format
#' @return tt_gh object. List object with the following entries: readme, files, url
#' @export
#'
#' @importFrom xml2 read_html
#' @importFrom lubridate year
#' @importFrom purrr map_chr
#' @import rvest
#' @import dplyr
#'
#' @examples
#' tt_gh<-tt_load_gh("2019-01-15")
#'
#' show_readme(tt_gh)
#' tt_gh$files
#'
tt_load_gh<-function(week="2019-01-15"){
  tt_year <- year(week)
  git_url <- file.path("https://github.com/rfordatascience/tidytuesday/tree/master/data",tt_year,week)

  gh_page <- get_tt_html(git_url)

  # Extract the raw text as a list
  readme_html<-as.character(html_nodes(gh_page,'.Box-body'))
  readme_html<-gsub("href=\"/rfordatascience/tidytuesday/","href=\"https://github.com/rfordatascience/tidytuesday/",readme_html)

  files <- map_chr(html_attrs(html_nodes(html_nodes(gh_page,'.files'),'.content a')),`[`,'title')

  files<-files[!files%in%"readme.md"]

  tt_results<-structure(list(
    readme=readme_html,
    files=files,
    url=git_url),class="tt_gh")
  return(tt_results)
}

#' @title Load tt data from Github
#'
#' @param date YYYY-MM-dd date string
#' @return tt_data object (list class)
#'
#' @export
#'
#' @importFrom purrr map
#'
#' @examples
#' tt_output<-tt_load("2019-01-15")
#'
#'
tt_load<-function(date){
  tt<-tt_load_gh(date)
  tt_data<-map(tt$files,~tt_read_data(tt,.x))
  names(tt_data)<-file_path_sans_ext(tt$files)
  tt_results<-structure(list(
    data=tt_data,
    tt=tt),class="tt_data")
  return(tt_results)
}

#' @title Load TidyTuesday data from Github
#'
#' @param x string representation of the date of data to pull, in YYYY-MM-dd format, or just numeric entry for year
#' @param week left empty unless x is a numeric year entry, in which case the week of interest should be entered
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
tt_load<-function(x,week){
  tt<-tt_load_gh(x,week)
  tt_data<-purrr::map(attr(tt,".files"),~tt_read_data(tt,.x))
  names(tt_data)<-tools::file_path_sans_ext(attr(tt,".files"))

  structure(
    tt_data,
    ".tt"=tt,
    class="tt_data")
}

#' @title  Load TidyTuesday data from Github
#'
#' @description Pulls the Readme and URLs of the data from the TidyTuesday github folder based on the date provided
#'
#' @param x string representation of the date of data to pull, in YYYY-MM-dd format, or just numeric entry for year
#' @param week left empty unless x is a numeric year entry, in which case the week of interest should be entered
#'
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
#'
tt_load_gh<-function(x,week){
  if(missing(x)){
    on.exit({print(tt_available())})
    stop("Enter either the year or date of the TidyTuesday Data to extract!")
  }

  tt_git_url <- tt_make_url(x,week)
  tt_gh_page <- get_tt_html(tt_git_url)

  # Extract the raw text as a list
  readme_html<-tt_gh_page%>%
    rvest::html_nodes('.Box-body')%>%
    as.character()
  readme_html<-gsub("href=\"/rfordatascience/tidytuesday/",
                    "href=\"https://github.com/rfordatascience/tidytuesday/",
                    readme_html)

  files <- tt_gh_page%>%
    rvest::html_nodes('.files')%>%
    rvest::html_nodes('.content a')%>%
    rvest::html_attrs()%>%
    purrr::map_chr(`[`,'title')


  #remove readme or directory paths
  files<-files[!(files%in%"readme.md"|file_path_sans_ext(files)==files)]

  structure(
    files,
    ".files"=files,
    ".readme"=readme_html,
    ".url"=tt_git_url,
    class="tt_gh")
}


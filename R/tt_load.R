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

# #' @title access data in tt_data object
# #' @param x tt_data object
# #' @param name name of dataset to access
# #' @exportMethod `$`
# `$.tt_data` <-function(x,name){
#   x[[ name ]]
# }

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
#' @importFrom tools file_path_sans_ext file_ext
#' @import rvest
#' @import dplyr
#'
#' @examples
#' tt_gh <- tt_load_gh("2019-01-15")
#'
#' readme(tt_gh)
tt_load_gh <- function(x, week) {
  if (missing(x)) {
    on.exit({
      print(tt_available())
    })
    stop("Enter either the year or date of the TidyTuesday Data to extract!")
  }

  tt_git_url <- tt_make_url(x, week)
  message("--- Downloading #TidyTuesday Information for ",basename(tt_git_url)," ----")
  tt_gh_page <- get_tt_html(tt_git_url)

  # Extract the raw text as a list
  readme_html <- tt_gh_page %>%
    rvest::html_nodes(".Box-body") %>%
    as.character()

  readme_html <- gsub(
    "href=\"/rfordatascience/tidytuesday/",
    "href=\"https://github.com/rfordatascience/tidytuesday/",
    readme_html
  )

  # Find Files
  available_files <- tt_gh_page %>%
    rvest::html_nodes(".files") %>%
    rvest::html_nodes(".content a") %>%
    rvest::html_attrs() %>%
    purrr::map_chr(`[`, "title")

  files_to_use <- available_files

  # remove readme or directory folders or pictures
  files_to_use <- files_to_use[!(tolower(files_to_use) %in% "readme.md" |
                                   file_path_sans_ext(files_to_use) == files_to_use|
                                   tolower(file_ext(files_to_use)) %in% c("png","jpg","rmd","r"))]

  # do not try if we don't have a read me or no files listed
  if(length(files_to_use)>0 & length(readme_html)>0){
    files_in_readme <- readme_html %>%
      xml2::read_html() %>%
      rvest::html_node("code") %>%
      rvest::html_text() %>%
      base::strsplit("\\n") %>%
      `[[`(1) %>%
      purrr::map_chr(function(x){
        file_match<-do.call('c',lapply(files_to_use,grepl,x))
        if(any(file_match)){
          matched_file <- files_to_use[file_match]
        }else{
          matched_file <- NA
        }
        return(matched_file)
      })

    files_in_readme<- files_in_readme[!is.na(files_in_readme)]

    if(length(files_in_readme)>0){
      files_to_use<-files_in_readme
    }
  }

  message("--- Identified ",length(files_to_use)," files available for download ----")

  structure(
    files_to_use,
    ".files" = files_to_use,
    ".readme" = readme_html,
    ".url" = tt_git_url,
    class = "tt"
  )
}

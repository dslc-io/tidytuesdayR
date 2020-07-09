#' @title Listing all available TidyTuesdays
#'
#' @description
#' The TidyTuesday project is a constantly growing repository of data sets.
#' Knowing what type of data is available for each week requires going to the
#' source. However, one of the hallmarks of 'tidytuesdayR' is that you never
#' have to leave your R console. These functions were
#' created to help maintain this philosophy.
#'
#'
#' @details
#' To find out the available datasets for a specific year, the user
#' can use the function `tt_datasets()`. This function will either populate the
#' Viewer or print to console all the available data sets and the week/date
#' they are associated with.
#'
#' To get the whole list of all the data sets ever released by TidyTuesday, the
#' function `tt_available()` was created. This function will either populate the
#' Viewer or print to console all the available data sets ever made for
#' TidyTuesday.
#'
#' @section PAT:
#'
#' A Github PAT is a Personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed
#' from 60 to 5000. Follow instructions at
#' <https://happygitwithr.com/github-pat.html> to set your PAT.
#'
#' @name available
#'
#' @param year numeric entry representing the year of tidytuesday you want the
#' list of datasets for. Leave empty for most recent year.
#' @param auth github Personal Access Token. See PAT section for
#' more information
#'
#' @examples
#' # check to make sure there are requests still available
#' if(rate_limit_check(quiet = TRUE) > 10){
#'  ## show data available from 2018
#'  tt_datasets(2018)
#'
#'  ## show all data available ever
#'  tt_available()
#' }
#'

NULL

#' @rdname available
#' @export
#' @return `tt_available()` returns a 'tt_dataset_table_list', which is a
#' list of 'tt_dataset_table'. This class has special printing methods to show
#' the available data sets.
#'
tt_available <- function(auth = github_pat()) {

  tt_year <- sort(tt_years(),decreasing = TRUE,)

  datasets <- setNames(vector("list", length(tt_year)), tt_year)

  for(year in tt_year){
    datasets[[as.character(year)]] <- tt_datasets(year, auth = auth)
  }

  structure(datasets,
    class = c("tt_dataset_table_list")
  )
}

#' @rdname available
#' @export
#'
#' @importFrom rvest html_table
#' @importFrom xml2 read_html
#'
#' @export
#' @return `tt_datasets()` returns a 'tt_dataset_table' object. This class has
#'  special printing methods to show the available datasets for the year.
#'
tt_datasets <- function(year, auth = github_pat()) {
  if (!year %in% tt_years()) {
    stop(
      paste0(
        "Invalid `year` provided to list available tidytuesday datasets.",
        "\n\tUse one of the following years: ",
        paste(tt_years(), collapse = ", "),
        "."
      )
    )
  }

  files <- github_sha(file.path("data", year))

  readme <-
    grep(
      pattern = "readme",
      files$path,
      value = TRUE,
      ignore.case = TRUE
    )

  readme_html <-
    github_html(file.path("data", year, readme), auth = auth)

  readme_html <- read_html(gsub(
    "\\n",
    "",
    gsub(
      x = as.character(readme_html),
      pattern = "<a href=\\\"(\\d+)(-\\d+-\\d+)(\\/readme.+)*\\\">",
      replacement = paste0("<a href=\\\"https:\\/\\/github.com\\/",
                           "rfordatascience\\/tidytuesday\\/tree\\/master\\/",
                           "data\\/\\1\\/\\1\\2\\\">"),
      perl = TRUE
    )
  ))

  datasets <- readme_html %>%
    html_table() %>%
    `[[`(1)

  structure(datasets,
            .html = readme_html,
            class = "tt_dataset_table")
}

#' @title Printing Utilities for Listing Available Datasets
#' @name Available_Printing
#' @description
#' printing utilities for showing the available datasets for a specific year or
#' all time
#' @inheritParams base::print
#' @param is_interactive is the console interactive?
#' @return used for side effects to show the available datasets for the year or for all time.
#' @examples
#' # check to make sure there are requests still available
#' if(rate_limit_check(quiet = TRUE) > 10){
#'
#'  available_datasets_2018 <- tt_datasets(2018)
#'  print(available_datasets_2018)
#'
#'  all_available_datasets <- tt_available()
#'  print(all_available_datasets)
#'
#' }
NULL


#' @rdname Available_Printing
#' @export

print.tt_dataset_table <- function(x, ..., is_interactive = interactive()) {
  if(is_interactive){
    tmpHTML <- tempfile(fileext = ".html")
    make_tt_dataset_html(x, file = tmpHTML <- tempfile(fileext = ".html"))
    html_viewer(tmpHTML)
  }else {
    print(data.frame(unclass(x)))
  }
  invisible(x)
}

#' @importFrom xml2 write_html
make_tt_dataset_html <- function(x, file =  tempfile(fileext = ".html")){
  readme <- attr(x,".html")
  write_html(readme, file = file)
  invisible(readme)
}

#' @rdname Available_Printing
#' @importFrom purrr walk map
#' @importFrom rvest html_node
#' @importFrom xml2 read_html write_html
#' @export
print.tt_dataset_table_list <- function(x, ...,is_interactive = interactive()) {

  if (is_interactive) {
    make_tt_dataset_list_html(x, file = tmpHTML <- tempfile(fileext = ".html"))
    html_viewer(tmpHTML)
  } else {

    names(x) %>%
      purrr::map(
        function(.x, x) {
          list(
            table = data.frame(unclass(x[[.x]])), year = .x
          )
        },
        x = x
      ) %>%
      purrr::walk(
        function(.x) {
          cat(paste0("Year: ", .x$year, "\n\n"))
          print(.x$table)
          cat("\n\n")
        }
      )
  }
  invisible(x)
}

make_tt_dataset_list_html <- function(x, file =  tempfile(fileext = ".html")){
  readme <- names(x) %>%
    purrr::map_chr(
      function(.x, x) {
        year_table <- attr(x[[.x]],".html") %>%
          html_node("table")
        paste("<h2>",.x,"</h2>",
              as.character(year_table),
              "")
      },
      x = x
    ) %>%
    paste(collapse = "")

  readme <- paste(
    "<article class='markdown-body entry-content' itemprop='text'>",
    paste("<h1>TidyTuesday Datasets</h1>", readme),"</article>"  ) %>%
    read_html() %>%
    github_page()

  write_html(readme, file = file)
  invisible(readme)
}

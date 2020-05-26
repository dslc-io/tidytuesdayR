#' @title Show all TidyTuesdays
#' @description  Show all the available datasets, and corresponding weeks
#' @param auth github Personal Access Token. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @export
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

#' @title Available datasets
#' @description list available datasets for that year
#' @param year numeric entry representing the year of tidytuesday you want the list of datasets
#'  for. Leave empty for most recent year.
#' @param auth github Personal Access Token. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @importFrom rvest html_table
#' @importFrom xml2 read_html
#' @export
tt_datasets <- function(year, auth = github_pat()) {

  if(!year %in% tt_years()){
    stop("Invalid `year` provided to list available tidytuesday datasets.\n\tUse one of the following years: ", paste(tt_years(), collapse = ", "), ".")
  }

  files <- github_sha(file.path("data",year))

  readme <- grep(pattern = "readme", files$path, value = TRUE, ignore.case = TRUE)

  readme_html <- github_html(file.path("data",year,readme), auth = auth)

  readme_html <- read_html(
    gsub("\\n","",
    gsub(
      x = as.character(readme_html),
      pattern = "<a href=\\\"(\\d+)(-\\d+-\\d+)(\\/readme.+)*\\\">",
      replacement = "<a href=\\\"https:\\/\\/github.com\\/rfordatascience\\/tidytuesday\\/tree\\/master\\/data\\/\\1\\/\\1\\2\\\">",
      perl = TRUE
    )
  ))

  datasets <- readme_html %>%
    html_table() %>%
    `[[`(1)

  structure(
    datasets,
    .html = readme_html,
    class = "tt_dataset_table"
  )
}

#' @title print utility for tt_dataset_table object
#' @inheritParams base::print
#' @param interactive is the console interactive
#' @export
print.tt_dataset_table <- function(x, ..., interactive = interactive()) {
  if(interactive){
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


#' @title print utility for tt_dataset_table_list object
#' @inheritParams base::print
#' @param interactive is the console interactive
#' @importFrom purrr walk map
#' @importFrom rvest html_node
#' @importFrom xml2 read_html write_html
#' @export
print.tt_dataset_table_list <- function(x, ...,interactive = interactive()) {

  if (interactive) {
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

  readme <- readme %>%
    paste("<article class='markdown-body entry-content' itemprop='text'>",
          paste("<h1>TidyTuesday Datasets</h1>",readme),"</article>") %>%
    read_html() %>%
    github_page()

  write_html(readme, file = file)
  invisible(readme)
}

#' @title Show all TidyTuesdays
#' @description  Show all the available datasets, and corresponding weeks
#' @importFrom xml2 read_html
#' @import rvest
#' @importFrom purrr set_names map
#' @export
tt_available <- function() {

  tt_year <- sort(tt_years(),decreasing = TRUE,)

  datasets <- setNames(vector("list", length(tt_year)), tt_year)

  for(year in tt_year){
    datasets[[as.character(year)]] <- tt_datasets(year)
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
#' @param printConsole should output go to the console? TRUE/FALSE
#' @importFrom rstudioapi isAvailable viewer
#' @importFrom xml2 write_html
#' @export
print.tt_dataset_table <- function(x, ..., printConsole = FALSE) {
  if (rstudioapi::isAvailable() & !printConsole) {
    tmpHTML <- tempfile(fileext = ".html")
    readme <- attr(x,".html")
    write_html(readme, file = tmpHTML)
    viewer(url = tmpHTML)
  } else {
    data.frame(x)
  }
  invisible(x)
}

#' @title print utility for tt_dataset_table_list object
#' @inheritParams base::print
#' @param printConsole should output go to the console? TRUE/FALSE
#' @importFrom purrr walk map
#' @importFrom rstudioapi isAvailable viewer
#' @importFrom rvest html_table
#' @export
print.tt_dataset_table_list <- function(x, ..., printConsole = FALSE) {

  if (isAvailable() & !printConsole) {

    tmpHTML <- setup_doc()

    cat("<h1>TidyTuesday Datasets</h1>", file = tmpHTML, append = TRUE)
    names(x) %>%
      purrr::map(
        function(.x, x) {
          list(html = as.character(attr(x[[.x]], ".html")), year = .x)
        },
        x = x
      ) %>%
      purrr::walk(
        ~ cat(
          paste0(
            "<h2>",
            .x$year,
            "</h2>\n",
            gsub(
              "href=\"/rfordatascience/tidytuesday/",
              "href=\"https://github.com/rfordatascience/tidytuesday/",
              .x$html
            )
          ),
          file = tmpHTML,
          append = TRUE
        )
      )

    cat("</div>", file = tmpHTML, append = TRUE)
    cat("</body></html>", file = tmpHTML, append = TRUE)
    rstudioapi::viewer(url = tmpHTML)

  } else {

    names(x) %>%
      purrr::map(
        function(.x, x) {
          list(
            table = rvest::html_table(attr(x[[.x]], ".html")), year = .x
          )
        },
        x = x
      ) %>%
      purrr::walk(
        function(.x) {
          cat(paste0("Year: ", .x$year, "\n"))
          print(.x$table)
          cat("\n\n")
        }
      )
  }
}

setup_doc <- function(tmpHTML = tempfile(fileext = ".html")) {
  cat("<!DOCTYPE html><html lang=\"en\"><head>
        <link rel=\"dns-prefetch\" href=\"https://github.githubassets.com\">
        <link crossorigin=\"anonymous\" media=\"all\" rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\">
        </head><body>", file = tmpHTML)
  cat("<div class='repository-content'>", file = tmpHTML, append = TRUE)
  return(tmpHTML)
}

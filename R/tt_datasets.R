#' @title Show all TidyTuesdays
#' @description  Show all the available datasets, and corresponding weeks
#' @importFrom xml2 read_html
#' @import rvest
#' @importFrom purrr set_names map
#' @export
tt_available <- function() {
  tt_year <- tt_years()
  pastDatasets <- purrr::map(
    tt_year[-which.max(tt_year)],
    ~ tt_datasets(.x)
  ) %>%
    purrr::set_names(as.character(tt_year[-which.max(tt_year)]))

  currDatasets <- tt_datasets() %>%
    list() %>%
    purrr::set_names(as.character(tt_year[which.max(tt_year)]))

  datasets <- c(
    currDatasets,
    pastDatasets
  )[tt_year[order(tt_year, decreasing = TRUE)]]

  structure(datasets,
    class = c("tt_dataset_table_list")
  )
}

#' @title Available datasets
#' @description list available datasets for that year
#' @param year numeric entry representing the year of tidytuesday you want the list of datasets for. Leave empty for most recent year.
#' @import xml2
#' @import rvest
#' @export
#'
tt_datasets <- function(year) {
  if (missing(year)) {
    url <-
      "https://github.com/rfordatascience/tidytuesday/blob/master/README.md"
    table <- 1
  } else {
    url <- file.path(
      "https://github.com/rfordatascience/tidytuesday/tree/master/data", year
    )
    table <- 2
  }

  datasets <- url %>%
    xml2::read_html() %>%
    rvest::html_nodes("table") %>%
    `[`(table)

  structure(
    datasets,
    ".html" = datasets,
    class = "tt_dataset_table"
  )
}

#' @title print utility for tt_dataset_table object
#' @inheritParams base::print
#' @param printConsole should output go to the console? TRUE/FALSE
#' @importFrom purrr walk
#' @importFrom rstudioapi isAvailable viewer
#' @importFrom rvest html_table
#' @export
print.tt_dataset_table <- function(x, ..., printConsole = FALSE) {
  if (rstudioapi::isAvailable() & !printConsole) {
    tmpHTML <- setup_doc()
    x$html %>%
      as.character() %>%
      purrr::walk(~ cat(gsub(
        "href=\"/rfordatascience/tidytuesday/",
        "href=\"https://github.com/rfordatascience/tidytuesday/",
        .x
      ), file = tmpHTML, append = TRUE))
    cat("</div>", file = tmpHTML, append = TRUE)
    cat("</body></html>", file = tmpHTML, append = TRUE)
    rstudioapi::viewer(url = tmpHTML)
  } else {
    attr(x, ".html") %>%
      rvest::html_table()
  }
}

#' @title print utility for tt_dataset_table_list object
#' @inheritParams base::print
#' @param printConsole should output go to the console? TRUE/FALSE
#' @importFrom purrr walk map
#' @importFrom rstudioapi isAvailable viewer
#' @importFrom rvest html_table
#' @export
print.tt_dataset_table_list <- function(x, ..., printConsole = FALSE) {
  if (rstudioapi::isAvailable() & !printConsole) {
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

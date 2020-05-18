#' Read Contents from GitHub
#'
#' Provide tool to read raw data and return as text the raw data using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository
#' @param read_func Function to parse the text. Defaults to \code{read.csv}
#' @param ... optional arguments to pass to \code{read_func}
#'
#' @return result of read_func on the content
#'
#' @importFrom jsonlite read_json
github_contents <-
  function(path,
           read_func = read.csv,
           ...,
           record_ref = TRUE) {
    base_url <-
      file.path("https://api.github.com/repos/rfordatascience/tidytuesday/contents",
                path)
    url_json <- try(read_json(base_url), silent = TRUE)
    if (!inherits(url_json, "try-error")) {
      content <- read_func(base_64_to_char(url_json$content), ...)

      if (record_ref) {
        attr(content, ".sha") <- url_json$sha
      }

      content
    } else{
      NULL
    }
  }

#' Read Contents from GitHub as html
#'
#' provide tools to read and process readme's as html using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository to contents that can be returned as HTML
#' @param ... optional arguments to pass to \code{read_html}
#'
#' @return result of read_html on the contents
#'
#' @examples
#' \dontrun{
#'
#' main_readme <- github_html("README.md")
#' week_readme <- github_html("data/2020/2020-01-07/readme.md")
#'
#' }
#'
#' @importFrom httr GET add_headers
#' @importFrom xml2 read_html
github_html <-
  function(path,
           ...) {
  base_url <-
    file.path("https://api.github.com/repos/rfordatascience/tidytuesday/contents",
              path)
  url_response <-
    GET(base_url,
        add_headers(Accept = "application/vnd.github.v3.html"))
  if (url_response$status_code == 200) {
    github_page(read_html(x = url_response$content, ...))
  } else{
    NULL
  }
}


#' Read Contents from GitHub as html
#'
#' provide tools to read and process readme's as html using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository to contents that can be returned as HTML
#' @param ... optional arguments to pass to \code{read_html}
#'
#' @return result of read_html on the contents
#'
#' @examples
#' \dontrun{
#'
#' main_readme <- github_html("README.md")
#' week_readme <- github_html("data/2020/2020-01-07/readme.md")
#'
#' }
#'
#' @importFrom httr GET add_headers
#' @importFrom xml2 read_html
github_sha <-
  function(dirpath, branch = "master") {
    base_url <-
      file.path(
        "https://api.github.com/repos/rfordatascience/tidytuesday/git/trees",
        URLencode(paste(branch, dirpath, sep = ":"))
      )
    url_response <- GET(base_url)
    if (url_response$status_code == 200) {
      do.call('rbind', lapply(jsonlite::parse_json(rawToChar(
        url_response$content
      ))$tree, data.frame, stringsAsFactors = FALSE))
    } else{
      NULL
    }
  }


#' read json base64 contents from github
#'
#' provide tools to read and process data using the github api
#'
#' @importFrom jsonlite base64_dec
base_64_to_char <- function(b64){
  rawToChar(jsonlite::base64_dec(b64))
}

#' Create shell for HTML content from github
#'
#' Provide the necessary <head> section to wrap around raw html content read from github.
#'
#' @param content html content
#'
#' @return xml_document with github header
#'
#' @importFrom xml2 read_html xml_add_sibling
github_page <- function(page_content){
  header <- read_html("<head><link crossorigin=\"anonymous\" media=\"all\" rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\"></head>")
  xml_add_sibling(header,page_content)
}


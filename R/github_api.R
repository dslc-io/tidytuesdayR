#' Read Contents from GitHub
#'
#' Provide tool to read raw data and return as text the raw data using the
#' github api
#'
#' @param path Relative path from within the TidyTuesday Repository
#' @param auth github PAT
#'
#' @return raw text of the content with the sha as an attribute
#' @noRd
#' @examples
#'
#' text_csv <- github_contents("data/2020/2020-04-07/tdf_stages.csv")
#' tour_de_france_stages <- readr::read_csv(text_csv)
#'
github_contents <- function(path, auth = github_pat()) {
    base_url <-
      file.path("https://api.github.com/repos",
                options("tidytuesdayR.tt_repo"),
                "contents",
                path)

    github_blob(path, auth = auth)

}

#' Read Contents from GitHub as html
#'
#' Provide tools to read and process readme's as html using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository to contents
#' that can be returned as HTML
#' @param ... optional arguments to pass to \code{read_html}
#' @param auth github PAT
#'
#' @return result of read_html on the contents
#' @noRd
#'
#' @examples
#'
#' main_readme <- github_html("README.md")
#' week_readme <- github_html("data/2020/2020-01-07/readme.md")
#'
#'
#' @importFrom xml2 read_html
github_html <-
  function(path,
           ...,
           auth = github_pat()) {

    base_url <-
      file.path("https://api.github.com/repos",
                options("tidytuesdayR.tt_repo"),
                "contents",
                path)

    url_response <-
      github_GET(base_url, auth = auth,
                 Accept = "application/vnd.github.v3.html")

    if (url_response$status_code == 200) {
      github_page(read_html(x = url_response$content, ...))
    } else{
      stop(tt_gh_error(url_response)$message)
    }
  }


#' Read Contents from GitHub as html
#'
#' provide tools to read and process readme's as html using the github api
#'
#' @param dirpath Relative path from within the TidyTuesday Repository to
#' folder of contents wanting sha for
#' @param branch which branch to get sha for. assumed to be
#' master (and usually should be)
#' @param auth github PAT. See PAT section for more information
#'
#' @return result data.frame of SHA and other information of directory contents
#' @noRd
#'
#' @examples
#'
#' sha <- github_sha("data/2020/2020-01-07")
#'
#' @importFrom xml2 read_html
#' @importFrom utils URLencode
github_sha <-
  function(dirpath,
           branch = "master",
           auth = github_pat()) {

    if(dirpath == "."){
      dirpath <- ""
    }

    base_url <-
      file.path(
        "https://api.github.com/repos",
        options("tidytuesdayR.tt_repo"),
        "git/trees",
        URLencode(paste(branch, dirpath, sep = ":"))
      )

    url_response <- github_GET(base_url, auth = auth)

    if (url_response$status_code == 200) {
      url_json <- GET_json(url_response)
      do.call('rbind',
              lapply(url_json$tree,
                     function(x)
                       data.frame(
                         x[c("path", "sha")],
                         stringsAsFactors = FALSE
                         ))
      )
    } else{
      stop(tt_gh_error(url_response)$message)
    }
  }

#' Read blob Contents from GitHub
#'
#' provide tools to read and process blob's using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository to contents,
#'  usually because it was too large to be read with the contencts api.
#' @param as_raw optional arguments to pass to \code{read_html}
#' @param sha sha of object if known in liu of path (usually best to give both
#' for clarity)
#' @param auth github PAT
#'
#' @return a raw/character object based on the blob
#' @noRd
#'
#' @examples
#'
#' main_readme_blob <- github_blob("README.md", as_raw = TRUE)
#'
github_blob <-
  function(path, as_raw = FALSE, sha = NULL, auth = github_pat()){

    if(is.null(sha)){
      dir_sha <- github_sha(dirname(path))
      sha <- dir_sha$sha[dir_sha$path == basename(path)]
      if(identical(sha, character(0))){
        stop("Response Code 404: Not Found")
      }
    }

    base_url <-
      file.path("https://api.github.com/repos",
                options("tidytuesdayR.tt_repo"),
                "git/blobs",
                sha)

    url_response <-
      github_GET(base_url, auth = auth,
                 Accept = "application/vnd.github.VERSION.raw")

    if (url_response$status_code == 200) {
      if(as_raw == TRUE){
        content <- url_response$content
      }else{
        content <- rawToChar(url_response$content)
      }
      attr(content, ".sha") <- sha
      return(content)

    } else{
      stop(tt_gh_error(url_response)$message)
    }

  }


#' read json base64 contents from github
#'
#' provide tool to read and process data using the github api
#' @param b64 base64 character value to be decoded and converted to
#' character value
#' @importFrom jsonlite base64_dec
#'
#' @return a character vector of the input decoded from base64
#' @noRd
#'
#' @examples
#' # Returns the value "Hello World"
#' base_64_to_char("SGVsbG8gV29ybGQ=")
#'
base_64_to_char <- function(b64){
  rawToChar(base64_dec(b64))
}

#' read GET json contents to char
#'
#' provide tool to read and process data using the github api from GET command
#' @param get_response object of class "response" from GET command. returns
#' JSON value.
#'
#' @return a list object if the content json
#' @noRd
#'
#' @importFrom jsonlite parse_json
GET_json <- function(get_response){
  jsonlite::parse_json(rawToChar(get_response$content))
}


#' Create shell for HTML content from github
#'
#' Provide the necessary <head> section to wrap around raw html content read
#' from github.
#'
#' @param page_content html content in xml_document class
#'
#' @return xml_document with github header
#' @noRd
#'
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes
github_page <- function(page_content){

  header <- paste0("<head><link crossorigin=\"anonymous\" ",
                  "media=\"all\" rel=\"stylesheet\" ",
                  "href=\"https://cdnjs.cloudflare.com/ajax/libs/",
                  "github-markdown-css/3.0.1/github-markdown.min.css\"></head>")

  body <- page_content %>%
    html_nodes("body") %>%
    as.character %>%
    enc2native()

  read_html(paste0(header, body))

}

#' Return the local user's GitHub Personal Access Token
#'
#' Extract the GitHub Personal Access Token (PAT) from the system environment
#' for authenticated requests.
#'
#' @section PAT:
#'
#' A Github 'PAT' is a Personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed
#' from 60 to 5000. Follow instructions from
#' <https://happygitwithr.com/github-pat.html> to set the PAT.
#'
#' @param quiet Should this be loud? default TRUE.
#'
#' @export
#'
#' @return a character vector that is your Personal Access Token, or NULL
#'
#' @examples
#'
#' ## if you have a personal access token saved, this will return that value
#' github_pat()
#'
github_pat <- function (quiet = TRUE) {
  pat <- Sys.getenv("GITHUB_PAT", "")
  token <- Sys.getenv("GITHUB_TOKEN", "")
  if (nchar(pat) | nchar(pat)) {
    if (!quiet) {
      message("Using github PAT from envvar GITHUB_PAT | GITHUB_TOKEN")
    }
    if(!nchar(pat)){
      pat <- token
    }
    return(pat)
  }
  NULL
}

#' Get for github API
#'
#' Extract the github PAT from the system environment for
#' authenticated requests.
#'
#' @param url URL to GET from
#' @param auth github PAT
#' @param ... any additional headers to add
#'
#' @return response from GET
#' @noRd
#'
#' @importFrom httr GET add_headers
#' @importFrom jsonlite base64_enc
github_GET <- function(url, auth = github_pat(), ..., times_run = 1){

  if(!is.null(auth)){
    headers <- add_headers(
      ...,
      Authorization = paste("token", auth)
    )
  }else{
    headers <- add_headers(...)
  }

  if(!get_connectivity()){
    return(
      no_internet_error()
    )
  }

  rate <- rate_limit_check()

  if(rate != 0){

    if(exists("headers")){
      get_res <- try(GET(url, headers),silent = TRUE)
    }else{
      get_res <- try(GET(url))
    }

    if(inherits(get_res,"try-error")){
      check_connectivity(rerun=TRUE)
      if(!get_connectivity()){
        return(no_internet_error())
      }else{
        ## Unexpected issue
        stop(attr(get_res,"condition"))
      }
    }else{
      if(get_res$status_code == 502){
        ## rerun when 502 status code - server error, not tidytuesdayR code error
        if(times_run < 3){
          if(rate_limit_check() > 0){
            github_GET(url, auth = github_pat(), ..., times_run = times_run + 1)
          }else{
            rate_limit_error()
          }
        }else{
          tt_gh_error.response(get_res)
        }
      }else{
        rate_limit_update(header_to_rate_info(get_res))
        return(get_res)
      }
    }
  }else{
    rate_limit_error()
  }
}

tt_gh_error<- function(response){
 UseMethod("tt_gh_error")
}

tt_gh_error.response <- function(response, call = sys.call(-2)){
  structure(
    list(
      status = response$status_code,
      message = paste(
        paste0("Response Code ",response$status_code,":"),
        GET_json(response)$message),
      call = call
    ),
    class = c(".tt_gh_error", "condition")
  )
}

tt_gh_error.tt_response <- function(response, call = sys.call(-2)){
  structure(
    list(
      status = response$status_code,
      message = paste(
        paste0("Response Code ",response$status_code,":"),
        response$message),
      call = call
    ),
    class = c(".tt_gh_error", "condition")
  )
}

#' Environment containing state of Github API limits
#'
#' @keywords internal
#' @noRd

TT_GITHUB_ENV <- new.env()
TT_GITHUB_ENV$RATE_LIMIT <- 60
TT_GITHUB_ENV$RATE_REMAINING <- 0
TT_GITHUB_ENV$RATE_RESET <- lubridate::today()

#' @importFrom httr GET

rate_limit_update <- function(rate_info = NULL, auth = github_pat()){

  check_connectivity()

  if (is.null(rate_info)) {
    if(get_connectivity()){
      if (!is.null(auth)) {
        rate_lim <- GET("https://api.github.com/rate_limit",
                        add_headers(Authorization = paste("token", auth)))
      } else {
        rate_lim <- GET("https://api.github.com/rate_limit")
      }

      if(rate_lim$status_code == 200){
        rate_info <- GET_json(rate_lim)$rate
        rate_info$remaining = rate_info$remaining - 1 # we have one less than we think
      }
    }
  }

  if(get_connectivity()){
  TT_GITHUB_ENV$RATE_LIMIT <- rate_info$limit
  TT_GITHUB_ENV$RATE_REMAINING <- rate_info$remaining
  TT_GITHUB_ENV$RATE_RESET <- as.POSIXct(rate_info$reset, origin = "1970-01-01")
  }

}

#' Get Rate limit left for GitHub Calls
#'
#' The GitHub API limits the number of requests that can be sent within an hour.
#' This function returns the stored rate limits that are remaining.
#'
#' @param n number of requests that triggers a warning indicating the user is
#' close to the limit
#' @param quiet should messages be returned when the rate limit is zero or less than n?
#'
#' @return return the number of calls are remaining as a numeric values
#' @export
#'
#' @examples
#'
#' rate_limit_check()
#'

rate_limit_check <- function(n = 10, quiet = FALSE){

  RATE_REMAINING <- TT_GITHUB_ENV$RATE_REMAINING

  if(length(RATE_REMAINING) == 0){
    if(!getOption("tidytuesdayR.tt_testing", FALSE)){
      ## double check. No penalty for checking!
      rate_limit_update()
    }else{
      message("Unable to get Github API Rate Limit. Check connectivity and run again.")
      return(0)
    }
  }

  if(RATE_REMAINING == 0 & !quiet){

    if(!getOption("tidytuesdayR.tt_testing", FALSE)){
      ## double check. No penalty for checking!
      rate_limit_update()
    }

    if(RATE_REMAINING == 0){
      message("Github API Rate Limit hit. You must wait until ",
           format(TT_GITHUB_ENV$RATE_RESET,
                  "%Y-%m-%d %r %Z"),
           " to make calls again!")
    }
  } else if (RATE_REMAINING <= n & !quiet){
    message(
      paste0(
        "Only ",
        TT_GITHUB_ENV$RATE_REMAINING,
        " Github queries remaining until ",
        format(TT_GITHUB_ENV$RATE_RESET,
               "%Y-%m-%d %r %Z"),
        "."
      )
    )
  }

  RATE_REMAINING
}


header_to_rate_info <- function(res){
  headers <- res$headers
  rate_json <- list()
  rate_json$limit <-  as.numeric(headers$`x-ratelimit-limit`)
  rate_json$remaining <-  as.numeric(headers$`x-ratelimit-remaining`)
  rate_json$reset <- as.numeric(headers$`x-ratelimit-reset`)
  rate_json
}


#' Checks Internet Connectivity
#'
#' This packages functionality is based on having internet connectivity to github.com. Without access,
#' most if not all of this package is not useful. This function checks to see if there is
#' internet connectivity on start of the package.
#'
#' @param rerun should internet connectivity check be forced to rerun? (True/FALSE)
#'
#' @return This function returns nothing, it is used for the side effects
#' @noRd
#'
#' @examples
#' check_connectivity()
#'
#' @importFrom jsonlite base64_enc
#' @importFrom httr GET

check_connectivity <- function(rerun = FALSE){
  internet_connection <- getOption("tidytuesdayR.tt_internet_connectivity",NA)


  #if internet connection is not set or is false, lets try again
  if(!getOption("tidytuesdayR.tt_testing", FALSE)){
    if(is.na(internet_connection) | !internet_connection | rerun){
      res <- try(GET("https://api.github.com"), silent = TRUE)
      if(inherits(res,"try-error")){
        options("tidytuesdayR.tt_internet_connectivity" = FALSE)
      }else{
        options("tidytuesdayR.tt_internet_connectivity" = TRUE)
      }
    }
  }
}

get_connectivity <- function(){
  getOption("tidytuesdayR.tt_internet_connectivity",NA)
}

#' @importFrom stats na.omit
request_error <- function(status_code, message, class = NA) {
  structure(list(message = message,
                 status_code = status_code),
            class = na.omit(c(class, "tt_response")))
}

#' @importFrom jsonlite base64_enc
no_internet_error <- function(){
  request_error(
  status_code = -1,
  "No Internet Connection",
  "tt.gh_connectivityError"
)}

#' @importFrom jsonlite base64_enc
rate_limit_error <- function() {
  request_error(
    status_code = -2,
    "RATE LIMIT EXPIRED",
    "tt.gh_RateLimitError"
  )
}

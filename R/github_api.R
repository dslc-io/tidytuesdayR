#' Read Contents from GitHub
#'
#' Provide tool to read raw data and return as text the raw data using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository
#' @param auth github PAT. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @return raw text of the content with the sha as an attribute
#'
#' @examples
#' \dontrun{
#' text_csv <- github_contents("data/2020/2020-04-07/tdf_stages.csv")
#' tour_de_france_stages <- read_csv(text_csv)
#'
#' }
#'
github_contents <- function(path, auth = github_pat()) {
    base_url <-
      file.path("https://api.github.com/repos",
                options("tidytuesdayR.tt_repo"),
                "contents",
                path)


    url_response <- github_GET(base_url, auth = auth, type= "application/json")
    json_response <- GET_json(url_response)


    if (url_response$status_code == 200) {
      content <- base_64_to_char(json_response$content)
      attr(content, ".sha") <- json_response$sha
      return(content)

    } else if(url_response$status_code == 403 & json_response$errors[[1]]$code == "too_large"){

      github_blob(path, auth = auth)

    }else{
      NULL
    }
  }

#' Read Contents from GitHub as html
#'
#' Provide tools to read and process readme's as html using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository to contents that can be returned as HTML
#' @param ... optional arguments to pass to \code{read_html}
#' @param auth github PAT. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
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
      github_GET(base_url, auth = auth, Accept = "application/vnd.github.v3.html")

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
#' @param auth github PAT. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @return result data.frame of SHA and other information of directory contents
#'
#' @examples
#' \dontrun{
#'
#' main_readme <- github_html("README.md")
#' week_readme <- github_html("data/2020/2020-01-07/readme.md")
#'
#' }
#'
#' @importFrom xml2 read_html
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
    url_json <- GET_json(url_response)

    if (url_response$status_code == 200) {
      do.call('rbind',
              lapply(url_json$tree,
                     function(x)
                       data.frame(x[c("path", "sha")], stringsAsFactors = FALSE))
      )
    } else{
      NULL
    }
  }

#' Read blob Contents from GitHub
#'
#' provide tools to read and process blob's using the github api
#'
#' @param path Relative path from within the TidyTuesday Repository to contents,
#'  usually because it was too large to be read with the contencts api.
#' @param raw optional arguments to pass to \code{read_html}
#' @param auth github PAT. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @return a raw/character object based on the blob
#'
#' @examples
#' \dontrun{
#'
#' main_readme <- github_html("README.md")
#' week_readme <- github_html("data/2020/2020-01-07/readme.md")
#'
#' }
#'
github_blob <-
  function(path, as_raw = FALSE, auth = github_pat()){
    dir_sha <- github_sha(dirname(path))
    file_sha <- dir_sha$sha[dir_sha$path == basename(path)]

    base_url <-
      file.path("https://api.github.com/repos",
                options("tidytuesdayR.tt_repo"),
                "git/blobs",
                file_sha)

    url_response <-
      github_GET(base_url, auth = auth, Accept = "application/vnd.github.VERSION.raw")

    if (url_response$status_code == 200) {
      if(as_raw == TRUE){
        content <- url_response$content
      }else{
        content <- rawToChar(url_response$content)
      }
      attr(content, ".sha") <- file_sha
      return(content)

    } else{
      NULL
    }

  }


#' read json base64 contents from github
#'
#' provide tool to read and process data using the github api
#'
#' @importFrom jsonlite base64_dec
base_64_to_char <- function(b64){
  rawToChar(base64_dec(b64))
}

#' read GET json contents to char
#'
#' provide tool to read and process data using the github api from GET command
#'
#' @importFrom jsonlite base64_dec
GET_json <- function(get_response){
  jsonlite::parse_json(rawToChar(get_response$content))
}


#' Create shell for HTML content from github
#'
#' Provide the necessary <head> section to wrap around raw html content read from github.
#'
#' @param content html content
#'
#' @return xml_document with github header
#'
#' @importFrom xml2 read_html xml_add_sibling html_nodes
github_page <- function(page_content){

  header <- "<head><link crossorigin=\"anonymous\" media=\"all\" rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\"></head>"
  body <- page_content %>%
    html_nodes("body") %>%
    as.character

  read_html(paste(header, body))

}

#' Get the github PAT
#'
#' Extract the github PAT from the system environment for authenticated requests.
#'
#' @param quiet Should this be loud? default TRUE.
#'
#' @return PAT as a character.
github_pat <- function (quiet = TRUE) {
  pat <- Sys.getenv("GITHUB_PAT")
  if (nchar(pat)) {
    if (!quiet) {
      message("Using github PAT from envvar GITHUB_PAT")
    }
    return(pat)
  }
  NULL
}

#' Get for github API
#'
#' Extract the github PAT from the system environment for authenticated requests.
#'
#' @param url URL to GET from
#' @param auth github PAT
#' @param ... any additional headers to add
#'
#' @return response from GET
#'
#' @importFrom httr GET add_headers
#'
github_GET <- function(url, auth = github_pat(), ...){

  if(!is.null(auth)){
    headers <- add_headers(
      ...,
      Authorization = paste("token", auth)
    )
  }else{
    headers <- add_headers(...)
  }

  GET(url, headers)

}


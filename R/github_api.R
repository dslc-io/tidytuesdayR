# Hit the api ----

# This one is purely a wrapper around gh::gh(), so at least for now we'll trust
# that it works.
#
# nocov start

#' Get data from the tt github repo.
#'
#' @param path Path within the `rfordatascience/tidytuesday` repo.
#' @param ... Additional parameters passed to [gh::gh()].
#'
#' @return The GitHub response as parsed by [gh::gh()].
#' @keywords internal
gh_get <- function(path, auth = gh::gh_token(), ...) {
  gh::gh(
    "/repos/:tt_repo/contents/:path",
    path = path,
    tt_repo = getOption("tidytuesdayR.tt_repo"),
    .token = auth,
    ...
  )
}

gh_get_url <- function(path, auth = gh::gh_token(), ...) {
  gh::gh(path, .token = auth, ...)
}
# nocov end

gh_get_sha_in_folder <- function(path, file, auth = gh::gh_token()) {
  folder <- gh_get(path, auth = auth)
  return(gh_extract_sha_in_folder(folder, file))
}

gh_get_csv <- function(path, header = TRUE, auth = gh::gh_token()) {
  gh_response <- gh_get(path, auth = auth)
  return(gh_extract_csv(gh_response, header = header))
}

gh_get_folder <- function(path, auth = gh::gh_token()) {
  gh_response <- gh_get(path, auth = auth)
  tidyr::unnest_wider(tibble::enframe(gh_response, name = NULL), "value")
}

gh_get_html <- function(path, auth = gh::gh_token()) {
  gh_response <- gh_get(
    path,
    auth = auth,
    .accept = "application/vnd.github.v3.html"
  )
  return(gh_extract_html(gh_response))
}

gh_get_readme_html <- function(path, auth = gh::gh_token()) {
  files <- gh_get_folder(path, auth = auth)
  readme_path <- grep(
    pattern = "readme",
    files$path,
    value = TRUE,
    ignore.case = TRUE
  )
  if (length(readme_path)) {
    return(gh_get_html(readme_path, auth = auth))
  }
  cli::cli_warn(
    "No readme found in {.val {path}}.",
    class = "tt-warning-no_readme"
  )
  return(NULL)
}

# Do not hit api ----

gh_raw_to_chr <- function(encoded_raw) {
  return(rawToChar(jsonlite::base64_dec(encoded_raw)))
}

gh_extract_text <- function(gh_response) {
  if (length(gh_response) && length(gh_response$content)) {
    return(gh_raw_to_chr(gh_response$content))
  }
  cli::cli_abort(
    "No content found in {.var gh_response}.",
    class = "tt-error-bad_gh_response"
  )
}

gh_extract_html <- function(gh_response) {
  if (length(gh_response) && length(gh_response$message)) {
    return(xml2::read_html(gh_response$message))
  }
  cli::cli_abort(
    "No html found in {.var gh_response}.",
    class = "tt-error-bad_gh_response"
  )
}

gh_extract_csv <- function(gh_response, header = TRUE) {
  file_text <- gh_extract_text(gh_response)
  content <- utils::read.csv(
    text = file_text,
    header = header,
    stringsAsFactors = FALSE
  )
  attr(content, ".sha") <- gh_response$sha
  return(content)
}

gh_extract_sha_in_folder <- function(folder, file) {
  target <- purrr::keep(folder, ~ .x$name == file)
  if (length(target) && length(target[[1]]$sha)) {
    return(target[[1]]$sha)
  }
  file_names <- purrr::map_chr(folder, "name")
  cli::cli_abort(
    c(
      "File {.val {file}} not found in folder.",
      i = "Found {cli::no({length(file_names)})} file{?s}: {.val {file_names}}"
    ),
    class = "tt-error-file_not_found"
  )
}

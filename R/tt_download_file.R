#' Download a TidyTuesday dataset file
#'
#' Download an actual data file from the TidyTuesday github repository.
#'
#' @inheritParams shared-params
#' @param x Index or name of file to download.
#' @param ... Additional parameters to pass to the parsing functions. Note:
#'   These arguments will be passed for all filetypes.
#'
#' @return tibble containing the contents of the file downloaded from git
#' @export
#'
#' @family tt_download_file
#'
#' @examplesIf interactive()
#' tt_gh <- tt_load_gh("2019-01-15")
#'
#' agencies <- tt_download_file(tt_gh, 1)
#' launches <- tt_download_file(tt_gh, "launches.csv")
tt_download_file <- function(tt,
                             x,
                             ...,
                             auth = gh::gh_token()) {
  file_info <- attr(tt, ".files")
  tt_date <- attr(tt, ".date")
  call <- rlang::caller_env()
  target <- tryCatch(
    tt_subset_file_info(file_info, x),
    error = function(e) {
      cli::cli_abort(
        "File {x} not found in the available files for {tt_date}.",
        class = "tt-error-bad_index",
        call = call
      )
    }
  )
  gh_response <- tt_download_file_raw(tt_date, target)
  tt_parse_download(
    gh_response,
    data_type = file_info$data_type[file_info$data_files == target],
    delim = file_info$delim[file_info$data_files == target],
    ...
  )
}

tt_subset_file_info <- function(file_info, x) {
  data_files <- setNames(file_info$data_files, file_info$data_files)
  return(data_files[[x]])
}

tt_download_file_raw <- function(tt_date, target) {
  tt_year <- lubridate::year(tt_date)
  gh_response <- gh_get(file.path("data", tt_year, tt_date, target))
  if (gh_response$content == "") {
    gh_response <- gh_get_url(gh_response$git_url)
  }
  return(gh_response)
}

tt_parse_download <- function(gh_response, ..., data_type, delim = NA) {
  switch(data_type,
    "rds" = return(tt_parse_rds(gh_response, ...)), # nocov 3 examples
    "xls" = return(tt_parse_excel(gh_response, ...)), # nocov 0 examples
    "xlsx" = return(tt_parse_excel(gh_response, ...)),
    "vgz" = return(tt_parse_vgz(gh_response, ...)), # nocov 12 examples
    "zip" = return(tt_parse_zip(gh_response, data_type, delim, ...)) # nocov 3 examples
  )
  file_content <- gh_extract_text(gh_response)
  delim <- tt_guess_delim(delim, data_type)
  readr::read_delim(file_content, delim = delim, show_col_types = FALSE, ...)
}

tt_parse_excel <- function(gh_response, ...) {
  rlang::check_installed("readxl")
  tt_parse_file(gh_response, parser_fn = readxl::read_excel, ...)
}

tt_parse_file <- function(gh_response, parser_fn, ...) {
  file_content <- jsonlite::base64_dec(gh_response$content)
  temp_file <- tempfile()
  on.exit(unlink(temp_file))
  writeBin(file_content, temp_file)
  parser_fn(temp_file, ...)
}

tt_guess_delim <- function(delim, data_type) {
  if (!is.na(delim)) {
    return(delim)
  }
  switch(tolower(data_type),
    "csv" = ",", # nocov
    "tsv" = "\t",
    "," # nocov
  )
}

# nocov start
tt_parse_zip <- function(gh_response, data_type, delim, ...) {
  delim <- tt_guess_delim(delim, data_type)
  tt_parse_file(gh_response, readr::read_delim, delim = delim, ...)
}

tt_parse_rds <- function(gh_response, ...) {
  tt_parse_file(gh_response, parser_fn = readRDS, ...)
}

tt_parse_vgz <- function(gh_response, ...) {
  # These are csv.gz, so we save then parse.
  tt_parse_file(
    gh_response,
    parser_fn = readr::read_csv,
    show_col_types = FALSE,
    ...
  )
}
# nocov end

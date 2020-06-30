
#' @title general utility to assist with parsing the raw data
#'
#' @param blob raw data to be parsed
#' @param ... args to pass to func
#' @param file_info data.frame of information about the blob being read
#'
#' @importFrom readxl read_xls read_xlsx
#' @importFrom readr read_delim
#'
#' @noRd
tt_parse_blob <- function(blob, ..., file_info) {
  switch(
    tolower(file_info$data_type),
    "xls"  = tt_parse_binary(blob, readxl::read_xls, ...,
                             filename = file_info$data_files),
    "xlsx" = tt_parse_binary(blob, readxl::read_xlsx, ...,
                             filename = file_info$data_file),
    "rds"  = tt_parse_binary(blob, readRDS,
                             filename = file_info$data_file),
    tt_parse_text(
      blob = blob,
      func = readr::read_delim,
      delim = file_info[["delim"]],
      progress = FALSE,
      ...
    )
  )
}

# rda option just in case
# "rda"  = tt_parse_binary(blob, read_rda, filename = file_info$data_file),


#' @title utility to assist with parsing the raw binary data
#'
#' @param blob raw data to be parsed
#' @param func the function to perform parsing of the file
#' @param ... args to pass to func
#' @param filename the original name of the file
#' @noRd

tt_parse_binary <- function(blob, func, ... , filename) {
  temp_file <- file.path(tempdir(), filename)
  attr(blob, ".sha") <- NULL
  writeBin(blob, temp_file)
  on.exit(unlink(temp_file))
  func(temp_file, ...)
}


#' @title utility to assist with parsing the text data
#'
#' @param blob raw text data to be parsed
#' @param func the function to perform parsing of the file
#' @param delim what delimeter to use when parsing
#' @param progress should parsing process be shared. Assumed to be FALSE
#' @param ... args to pass to func
#' @noRd
tt_parse_text <- function(blob, func, delim, progress = FALSE, ... ) {
  func(blob, delim = delim, progress = progress, ...)
}


#' @title general utility to assist with parsing the raw data
#'
#' @param blob raw data to be parsed
#' @param func the function to perform parsing of the file
#' @param ... args to pass to func
#' @param fileinfo data.frame of information about the blob being read
tt_parse_blob <- function(blob, ..., file_info) {
  switch( tolower(file_info$data_type),
          "xls"  = tt_parse_binary(blob, readxl::read_xls, ..., filename = file_info$data_files),
          "xlsx" = tt_parse_binary(blob, readxl::read_xlsx, ..., filename = file_info$data_file),
          "rds"  = tt_parse_binary(blob, readRDS, filename = file_info$data_file),
          "rda"  = tt_parse_binary(blob, read_rda, filename = file_info$data_file),
          tt_parse_text(blob, readr::read_delim, progress = FALSE, delim = file_info$delim, ...)
  )
}


#' @title utility to assist with parsing the raw binary data
#'
#' @param blob raw data to be parsed
#' @param func the function to perform parsing of the file
#' @param ... args to pass to func
#' @param filename the original name of the file
tt_parse_binary <- function(blob, func, ... , filename) {
  temp_file <- file.path(tempdir(), filename)
  writeBin(blob, temp_file)
  on.exit(unlink(temp_file))
  func(temp_file, ...)
}


#' @title utility to assist with parsing the text data
#'
#' @param blob raw text data to be parsed
#' @param func the function to perform parsing of the file
#' @param ... args to pass to func
#'
tt_parse_text <- function(blob, func, ... ) {
  func(blob, ...)
}

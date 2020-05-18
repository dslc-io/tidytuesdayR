#' @title download tt data
#'
#' Download all or specific files identified in the tt dataset
#'
#' @param tt string representation of the date of data to pull, in YYYY-MM-dd format, or just numeric entry for year
#' @param files List the file names to download. Default to asking.
#' @param ... pass methods to the parsing functions. These will be passed to ALL files, so be careful.
#' @return tt_data object (list class)
#'
#' @export
#'
#' @importFrom lubridate year
#'
#' @examples
#' tt_output <- tt_load("2019-01-15")

tt_download <- function(tt, files = c("All", attr(tt, ".files")$data_files), ...){

  data_info <- attr(tt, ".files")
  tt_date <- attr(tt, ".date")
  tt_year <- year(tt_date)


  #define which files to download
  files <- match.arg(files, several.ok = TRUE)

  if("All" %in% files){
    files <- data_info$data_files
  }

  message("--- Starting Download ---")

  tt_data <- setNames(
    vector("list", length = length(files)),
    files)

  for(file in files){
    cat(sprintf('\rdownloading file %d of %d: `%s`',
                which(files == file),
                length(files),
                file))

    file_info <- data_info[ data_info$data_files == file, ]

    tt_data[[file]] <- tt_read_data(
      file = file,
      type = file_info$data_type,
      delim = file_info$delim,
      dir = file.path("data",tt_year,tt_date)
      )
  }
  message("--- Download complete ---")

  names(tt_data) <- tools::file_path_sans_ext(attr(tt, ".files")$data_files)

}


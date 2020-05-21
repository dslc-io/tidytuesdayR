#' @title download tt data
#'
#' Download all or specific files identified in the tt dataset
#'
#' @param tt string representation of the date of data to pull, in YYYY-MM-dd format, or just numeric entry for year
#' @param files List the file names to download. Default to asking.
#' @param ... pass methods to the parsing functions. These will be passed to ALL files, so be careful.
#' @param auth github Personal Access Token. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @return tt_data object (list class)
#'
#' @export
#'
#' @importFrom lubridate year
#'
#' @examples
#' tt_output <- tt_load("2019-01-15")

tt_download <- function(tt, files = c("All"), ..., auth = github_pat()){

  data_files <- attr(tt, ".files")$data_files


  #define which files to download
  files <- match.arg(files, several.ok = TRUE, choices = c("All", data_files))

  if("All" %in% files){
    files <- data_files
  }

  message("--- Starting Download ---")
  cat("\n")

  tt_data <- setNames(
    vector("list", length = length(files)),
    files)

  for(file in files){
    dl_message <- sprintf('\tDownloading file %d of %d: `%s`\n',
                          which(files == file),
                          length(files),
                          file)

    cat(dl_message)

    tt_data[[file]] <- tt_download_file(
      tt,
      file,
      ...,
      auth = auth
      )
  }

  message("--- Download complete ---")

  names(tt_data) <- tools::file_path_sans_ext(attr(tt, ".files")$data_files)
  tt_data

}


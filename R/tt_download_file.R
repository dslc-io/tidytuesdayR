#' @title Reads in TidyTuesday datasets from Github repo
#'
#' @description  Reads in the actual data from the TidyTuesday github
#'
#' @param tt tt_gh object from tt_load_gh function
#' @param x index/name of data object to read in. string or int
#' @param ... pass methods to the parsing functions. These will be passed to
#' ALL files, so be careful.
#' @param auth github Personal Access Token. See PAT section for more
#' information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed
#' from 60 to 5000. Follow instructions at
#' <https://happygitwithr.com/github-pat.html> to set the PAT.
#'
#' @return tibble containing the contents of the file downloaded from git
#' @export
#'
#' @family tt_download_file
#'
#' @examples
#' \dontrun{
#' tt_gh <- tt_load_gh("2019-01-15")
#'
#' agencies <- tt_download_file(tt_gh, 1)
#' launches <- tt_download_file(tt_gh, "launches.csv")
#' }
tt_download_file <- function(tt, x, ..., auth = github_pat()) {
  suppressMessages({
    switch(class(x),
      "character" = tt_download_file.character(tt, x, ... ),
      "numeric" = tt_download_file.numeric(tt, x, ... ),
      "integer" = tt_download_file.numeric(tt, x, ... ),
      stop(paste("No method for entry of class:", class(x)))
    )
  })
}

#' @importFrom lubridate year
#' @importFrom tools file_ext
tt_download_file.character <-
  function(tt,
           x,
           ...,
           sha = NULL,
           auth = github_pat()) {

  file_info <- attr(tt, ".files")

  if (x %in% file_info$data_file) {

    tt_date <- attr(tt, ".date")
    tt_year <- year(tt_date)

    blob <-
      github_blob(
        file.path("data", tt_year, tt_date, x),
        as_raw = TRUE,
        sha = sha,
        auth = auth
      )

    tt_parse_blob(blob, file_info = file_info[file_info$data_file == x,])

  } else {
    stop(paste0(
      "That is not an available file for this TidyTuesday week!",
      "\nAvailable Datasets:\n",
      paste(attr(tt, ".files"), "\n\t", collapse = "")
    ))
  }
}

tt_download_file.numeric <- function(tt, x, ...) {
  files <- attr(tt, ".files")$data_files
  if (x > 0 & x <= length(files)) {
    tt_download_file.character(tt, files[x], ...)
  } else {
    stop(paste0(
      "That is not an available index for the files for this TidyTuesday week!",
      "\nAvailable Datasets:\n\t",
      paste0(seq(1, length(files)), ": ", files, "\n\t", collapse = "")
    ))
  }
}





#' @title utility to load RDA with out using assigned name in envir
#'
#' @param path path to RDA file
#' @noRd
read_rda <- function(path){
  load_env<-new.env()
  load(path,envir = load_env)
  load_env[[ ls(load_env)[1] ]]
}

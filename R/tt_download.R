#' @title download tt data
#'
#' @description Download all or specific files identified in the tt dataset
#'
#' @param tt a `tt` object, output from \code{\link{tt_load_gh}}
#' @param files List the file names to download. Default to asking.
#' @param ... pass methods to the parsing functions. These will be passed to
#' ALL files, so be careful.
#' @param branch which branch to be downloading data from. Default and always
#' should be "master".
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
#' @return list of tibbles of the files downloaded.
#'
#' @export
#'
#' @importFrom lubridate year
#'
#' @examples
#' \donttest{
#' if(interactive()){
#' tt_output <- tt_load_gh("2019-01-15")
#' agencies <- tt_download(tt_output, files = "agencies.csv")
#' }
#' }
tt_download <-
  function(tt,
           files = c("All"),
           ...,
           branch = "master",
           auth = github_pat()) {


  ## check internet connectivity and rate limit
  if (!get_connectivity()) {
    check_connectivity(rerun = TRUE)
    if (!get_connectivity()) {
      message("Warning - No Internet Connectivity")
      return(NULL)
    }
  }

  ## Check Rate Limit
  if (rate_limit_check() == 0) {
    return(NULL)
  }

  tt_date <- attr(tt, ".date")
  tt_year <- year(tt_date)
  file_info <- attr(tt, ".files")


  #define which files to download
  files <-
    match.arg(files,
              several.ok = TRUE,
              choices = c("All", file_info$data_files))

  if("All" %in% files){
    files <- file_info$data_files
  }

  message("--- Starting Download ---")
  cat("\n")

  tt_sha <- github_sha(file.path("data",tt_year,tt_date), auth = auth)

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
      sha = tt_sha$sha[tt_sha$path == file],
      auth = auth
      )
  }

  cat("\n")
  message("--- Download complete ---")

  names(tt_data) <- tools::file_path_sans_ext(files)
  tt_data

}


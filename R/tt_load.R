#' @title Load TidyTuesday data from Github
#'
#' @param x string representation of the date of data to pull, in YYYY-MM-dd
#' format, or just numeric entry for year
#' @param week left empty unless x is a numeric year entry, in which case the
#' week of interest should be entered
#' @param download_files which files to download from repo. defaults and
#' assumes "All" for the week.
#' @param ... pass methods to the parsing functions. These will be passed to
#' ALL files, so be careful.
#' @param auth github Personal Access Token. See PAT section for more
#' information
#'
#' @section PAT:
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed
#' from 60 to 5000. Follow instructions from
#' <https://happygitwithr.com/github-pat.html> to set the PAT.
#'
#' @return tt_data object, which contains data that can be accessed via `$`,
#'  and the readme for the weeks TidyTuesday through printing the object or
#'  calling `readme()`
#'
#' @importFrom purrr map
#'
#' @examplesIf interactive()
#' # check to make sure there are requests still available
#' if (rate_limit_check(quiet = TRUE) > 30) {
#'   tt_output <- tt_load("2019-01-15")
#'   tt_output
#'   agencies <- tt_output$agencies
#' }
#'
#' @export
tt_load <- function(x,
                    week,
                    download_files = "All",
                    ...,
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

  # download readme and identify files
  tt <- tt_load_gh(x, week, auth = auth)

  # download files
  tt_data <- tt_download(tt, files = download_files, ..., auth = auth)

  ## return tt_data object
  structure(
    tt_data,
    ".tt" = tt,
    class = "tt_data"
  )
}

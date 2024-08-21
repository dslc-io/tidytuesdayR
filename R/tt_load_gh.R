#' @title  Load TidyTuesday data from Github
#'
#' @description Pulls the readme and URLs of the data from the TidyTuesday
#' github folder based on the date provided
#'
#' @param x string representation of the date of data to pull, in
#' YYYY-MM-dd format, or just numeric entry for year
#' @param week left empty unless x is a numeric year entry, in which case the
#'  week of interest should be entered
#' @param auth github Personal Access Token. See PAT section for more
#' information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed
#' from 60 to 5000. Follow instructions from
#' <https://happygitwithr.com/github-pat.html> to set the PAT.
#'
#' @return a 'tt' object. This contains the files available for the week,
#'  readme html, and the date of the TidyTuesday.
#' @export
#' @examplesIf interactive()
#' # check to make sure there are requests still available
#' if (rate_limit_check(quiet = TRUE) > 30) {
#'   tt_gh <- tt_load_gh("2019-01-15")
#'   ## readme attempts to open the readme for the weekly dataset
#'   readme(tt_gh)
#'
#'   agencies <- tt_download(
#'     tt_gh,
#'     files = "agencies.csv"
#'   )
#' }
tt_load_gh <- function(x, week, auth = github_pat()) {
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
    return(NULL) # nocov
  }

  if (missing(x)) {
    on.exit({
      tt_available(auth = auth)
    })
    stop("Enter either the year or date of the TidyTuesday Data to extract!")
  }

  # Check Dates
  tt_date <- tt_check_date(x, week)

  message("--- Compiling #TidyTuesday Information for ", tt_date, " ----")

  # Find Files and extract readme
  tt_compilation <- tt_compile(tt_date)

  n_files <- as.character(nrow(tt_compilation$files))

  are_is <- switch(n_files,
    "0" = "are",
    "1" = "is",
    "are"
  )

  file_s <- switch(n_files,
    "0" = "files",
    "1" = "file",
    "files"
  )

  n_files <- ifelse(n_files == 0, "no", n_files)

  message("--- There ", are_is, " ", n_files, " ", file_s, " available ---")

  structure(
    tt_compilation$files$data_files,
    ".files" = tt_compilation$files,
    ".readme" = tt_compilation$readme,
    ".date" = tt_date,
    class = "tt"
  )
}

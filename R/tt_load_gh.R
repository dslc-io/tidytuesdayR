#' @title  Load TidyTuesday data from Github
#'
#' @description Pulls the Readme and URLs of the data from the TidyTuesday github folder based on the date provided
#'
#' @param x string representation of the date of data to pull, in YYYY-MM-dd format, or just numeric entry for year
#' @param week left empty unless x is a numeric year entry, in which case the week of interest should be entered
#' @param auth github Personal Access Token. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @return tt_gh object. List object with the following entries: readme, files, url
#' @export
#' @examples
#' tt_gh <- tt_load_gh("2019-01-15")
#'
#' readme(tt_gh)
tt_load_gh <- function(x, week, auth = github_pat()) {

  if (missing(x)) {
    on.exit({
      print(tt_available(auth = auth))
    })
    stop("Enter either the year or date of the TidyTuesday Data to extract!")
  }

  #Update master file reference
  tt_update_master_file(auth = auth)

  #Check Dates
  tt_date <- tt_check_date(x, week)

  message("--- Compiling #TidyTuesday Information for ",tt_date," ----")

  # Find Files and extract readme
  tt_compilation <- tt_compile(tt_date)

  n_files <- as.character(nrow(tt_compilation$files))

  are_is <- switch( n_files,
                    "0" = "are",
                    "1" = "is",
                    "are")

  file_s <- switch( n_files,
                    "0" = "files",
                    "1" = "file",
                    "files")

  n_files <- ifelse( n_files == 0, "no", n_files)

  message("--- There ",are_is," ", n_files, " ", file_s," available ---")

  structure(
    tt_compilation$files$data_files,
    ".files" = tt_compilation$files,
    ".readme" = tt_compilation$readme,
    ".date" = tt_date,
    class = "tt"
  )
}

#' Get Master List of Files from TidyTuesday
#'
#' Import or update dataset from github that records the entire list of objects
#' from TidyTuesday
#'
#' @inheritParams gh_get
#' @param force force the update to occur even if the SHA matches
#'
#' @return The tt master file, updated if necessary.
#' @keywords internal
tt_master_file <- function(force = FALSE, auth = gh::gh_token()) {
  if (should_update_tt_master_file(force, auth)) {
    content <- gh_get_csv("static/tt_data_type.csv")
    TT_MASTER_ENV$TT_MASTER_FILE <- content
  }
  return(TT_MASTER_ENV$TT_MASTER_FILE)
}

#' Decide whether to update the master file
#'
#' @inheritParams tt_master_file
#'
#' @return Boolean indicating whether the master file should be updated.
#' @keywords internal
should_update_tt_master_file <- function(force = FALSE, auth = gh::gh_token()) {
  force ||
    !nrow(TT_MASTER_ENV$TT_MASTER_FILE) ||
    is.null(attr(TT_MASTER_ENV$TT_MASTER_FILE, ".sha")) ||
    gh_get_sha_in_folder(
      "static",
      "tt_data_type.csv",
      auth = auth
    ) != attr(TT_MASTER_ENV$TT_MASTER_FILE, ".sha")
}

# The Master List of Files from TidyTuesday
TT_MASTER_ENV <- new.env()
TT_MASTER_ENV$TT_MASTER_FILE <- data.frame(
  Week = integer(0),
  ate = character(0),
  ear = integer(0),
  data_files = character(0),
  data_type = character(0),
  delim = character(0)
)

#' Get Master List of Files from TidyTuesday
#'
#' Import or update dataset from github that records the entire list of objects
#' from TidyTuesday
#'
#' @param force force the update to occur even if the SHA matches
#' @param auth github Personal Access Token.
#'
#' @keywords internal
#' @importFrom utils read.csv
#' @noRd
#'
tt_update_master_file <- function(force = FALSE, auth = github_pat()) {
    ## check internet connectivity and rate limit
    if (!get_connectivity()) { # nocov start
      check_connectivity(rerun = TRUE)
      if (!get_connectivity()) {
        message("Warning - No Internet Connectivity")
        invisible(NULL)
      }
    }

    ## Check Rate Limit
    if (rate_limit_check() == 0) {
      invisible(NULL)
    } # nocov end

    # get sha to see if need to update
    sha_df <- github_sha("static")
    sha <- sha_df$sha[sha_df$path == "tt_data_type.csv"]

    if (nrow(TT_MASTER_ENV$TT_MASTER_FILE) == 0 ||
      sha != attr(TT_MASTER_ENV$TT_MASTER_FILE, ".sha") || force) {
      file_text <- github_contents("static/tt_data_type.csv", auth = auth)
      content <-
        read.csv(
          text = file_text,
          header = TRUE,
          stringsAsFactors = FALSE
        )
      attr(content, ".sha") <- sha

      tt_master_file(content)
    }
  }

#' Get Master List of Files from Local Environment
#'
#' return or update tt master file
#'
#' @param assign value to overwrite the TT_MASTER_ENV$TT_MASTER_FILE contents
#' with this value
#'
#' @keywords internal
#' @noRd
#'
tt_master_file <- function(assign = NULL) {
  if (!is.null(assign)) {
    TT_MASTER_ENV$TT_MASTER_FILE <- assign
  } else {
    ttmf <- TT_MASTER_ENV$TT_MASTER_FILE
    if (nrow(ttmf) == 0) {
      tt_update_master_file()
      ttmf <- TT_MASTER_ENV$TT_MASTER_FILE
    }
    return(ttmf)
  }
}

#' The Master List of Files from TidyTuesday
#'
#' @keywords internal
#' @noRd
#'
TT_MASTER_ENV <- new.env()
TT_MASTER_ENV$TT_MASTER_FILE <- data.frame(
  Week = integer(0),
  ate = character(0),
  ear = integer(0),
  data_files = character(0),
  data_type = character(0),
  delim = character(0)
)

#' Parameters used in multiple functions
#'
#' Reused parameter definitions are gathered here for easier editing.
#'
#' @param auth A GitHub token. See [gh::gh_token()] for more details.
#' @param call (`environment`) The caller environment for error messages.
#' @param files Which file names to download. Default "All" downloads all files
#'   for the specified week.
#' @param path The relative path to the directory to hold your submission files
#'   (`tt_submission` by default). If this directory does not exist, it will be
#'   created.
#' @param tt A `tt` object, output from [tt_load_gh()].
#' @param week Which week number to use within a given year. Only used when `x`
#'   is a valid year.
#' @param x The date of data to pull (in "YYYY-MM-dd" format), or the four-digit
#'   year as a number.
#' @param year What year of TidyTuesday to use
#'
#' @name .shared-params
#' @keywords internal
NULL

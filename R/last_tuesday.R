#' Find the most recent tuesday
#'
#' Identify the most recent 'TidyTuesday' date relative to a specified date.
#'
#' @param date A date as a date object or character string in `YYYY-MM-DD`
#'   format. Defaults to today's date.
#'
#' @return The TidyTuesday date in the same week as the specified date, using
#'   Monday as the start of the week.
#'
#' @examples
#' last_tuesday() # get last Tuesday relative to today's date
#' last_tuesday("2020-01-01") # get last Tuesday relative to a specified date
#'
#' @export
last_tuesday <- function(date = today(tzone = "America/New_York")) {
  if (!valid_date(date)) {
    cli::cli_abort(
      "{.val {date}} cannot be coerced to a {.cls Date}.",
      class = "tt-error-invalid_date"
    )
  }
  date <- as.Date(tt_date_format(date))
  diff_tuesday <- subtract_tuesday(date)
  tuesday <- date + diff_tuesday

  # data is usually released on a monday
  #
  # TODO: Don't do this logic here, do it where this is called when that makes
  # sense.
  if (diff_tuesday > 1) {
    tuesday <- tuesday - 7
  }

  return(tuesday)
}

subtract_tuesday <- function(date) {
  diff_tuesday <- 3 - lubridate::wday(date, week_start = 7)

  if (diff_tuesday < 0) {
    diff_tuesday <- diff_tuesday + 7
  }
  diff_tuesday
}

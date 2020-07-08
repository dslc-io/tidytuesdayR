#' Find the most recent tuesday
#'
#' Utility function to assist users in identifying the most recent 'tidytuesday' date
#'
#' @param date todays date as a date object
#'
#' @importFrom lubridate wday today
#' @examples
#'
#' last_tuesday() # get last tuesday from todays date
#' last_tuesday(as.Date("2020-01-01")) # get last tuesday from specified date
#'
#' @export

last_tuesday <- function(date = today(tz = "America/New_York")) {

  stopifnot(inherits(date,"Date"))

  diff_tuesday <- 3 - lubridate::wday(date)

  if (diff_tuesday < 0) {
    diff_tuesday <- diff_tuesday + 7
  }

  tuesday <- date + diff_tuesday

  # data is usually released on a monday
  if(tuesday - date > 1){
    tuesday = tuesday - 7
  }

  return(tuesday)
}

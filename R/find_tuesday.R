last_tuesday <- function(
  today = lubridate::today(tz = "America/New_York")
  ) {
  diff_tuesday <- 2 - lubridate::wday(today)
  if (diff_tuesday < 0) {
    diff_tuesday <- diff_tuesday + 7
  }
    today - diff_tuesday
}

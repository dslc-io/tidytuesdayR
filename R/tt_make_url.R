#' @title given inputs generate valid TidyTuesday URL
#' @description Given multiple types of inputs, generate
#' @param x either a string or numeric entry indicating the full date of
#' @param week left empty unless x is a numeric year entry, in which case the week of interest should be entered
#'
tt_check_date <- function(x, week) {
  if (valid_date(x)) {
    tt_make_url.date(x)
  } else if (valid_year(x)) {
    tt_make_url.year(x, week)
  } else {
    stop("Entries must render to a valid date or year")
  }
}

tt_make_url.date <- function(x) {
  tt_year <- lubridate::year(x)
  tt_formatted_date <- tt_date_format(x)
  tt_folders <- tt_weeks(tt_year)
  if (!as.character(tt_formatted_date) %in% tt_folders[["folders"]]) {
    stop(
      paste0(
        tt_formatted_date,
        " is not a date that has TidyTuesday data.\n\tDid you mean: ",
        tt_closest_date(tt_formatted_date, tt_folders$folders),
        "?"
      )
    )
  }
  tt_formatted_date
}

tt_make_url.year <- function(x, week) {
  tt_folders <- tt_weeks(x)
  if (week > nrow(tt_folders[["week_desc"]])) {
    stop(paste0("Only ", length(tt_folders), " TidyTuesday Weeks exist in ", x, ". Please enter a value for week between 1 and ", length(tt_folders)))
  } else if (week < 1) {
    stop(paste0("Week entry must be a valid positive integer between 1 and ", length(tt_folders$week_desc), "."))
  }

  tt_date <- tt_folders[["week_desc"]][week,"Date"]

  if (!tt_date %in% tt_folders[["folders"]]) {
    stop(paste0("Week ", week, " of TidyTuesday for ", x," does not have data available for download from github."))
  }

  tt_date
}



tt_weeks <- function(year) {

  tt_year <- tt_years()

  if (!as.character(year) %in% tt_year) {
    stop(paste0(
      "TidyTuesday did not exist for ", year, ". \n\t TidyTuesday has only existed from ",
      min(tt_year)), " to ", max(tt_year)
    )
  }

  ttmf <- tt_master_file()
  tt_week <- unique(basename(ttmf$weeks[ttmf$year == year]))

  weekNum <- tt_week %>%
    as.Date(format = "%Y-%m-%d") %>%
    `+`(3) %>%  # move to accomodate
    lubridate::week()

  list(
    week_desc = weekNum,
    folders = tt_week
  )

}

tt_years <- function() {
  unique(tt_master_file()$year)
}

#' @importFrom lubridate as_date is.Date
valid_date <- function(x) {
  suppressWarnings({
    !is.na(lubridate::as_date(as.character(x))) | lubridate::is.Date(x)
  })
}

valid_year <- function(x) {
  suppressWarnings({
    !is.na(lubridate::as_date(paste0(as.character(x), "-01-01")))
  })
}

#' @importFrom lubridate year month day ymd
tt_date_format <- function(x) {
  lubridate::ymd(paste0(lubridate::year(x), "-", lubridate::month(x), "-", lubridate::day(x)))
}

tt_closest_date <- function(inputdate, availabledates) {
  availabledates[which.min(abs(difftime(inputdate, availabledates, units = "days")))]
}

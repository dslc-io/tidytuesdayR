#' Get date of TidyTuesday, given the year and week
#'
#' Sometimes we don't know the date we want, but we do know the week. This
#' function provides the ability to pass the year and week we are interested in
#' to get the correct date
#'
#' @inheritParams gh_get
#' @inheritParams shared-params
#' @keywords internal
tt_date <- function(year, week = NULL, auth = gh::gh_token()) {
  tt_check_date(year, week, auth = auth)
}

#' Generate valid TidyTuesday URL
#'
#' Given multiple types of inputs, generate a valid TidyTuesday URL.
#'
#' @inheritParams gh_get
#' @inheritParams shared-params
#' @keywords internal
tt_check_date <- function(x, week = NULL, auth = gh::gh_token()) {
  if (missing(x)) {
    .pkg_abort(
      "Provide either the year & week or the date of the TidyTuesday dataset.",
      "invalid_date"
    )
  }

  if (valid_date(x)) {
    tt_check_date.date(x, auth = auth)
  } else if (valid_year(x)) {
    tt_check_date.year(x, week, auth = auth)
  } else {
    .pkg_abort("Entries must render to a valid date or year", "invalid_date")
  }
}

tt_check_date.date <- function(x, auth = gh::gh_token()) {
  tt_year <- lubridate::year(x)
  tt_formatted_date <- tt_date_format(x)
  if (as.character(tt_formatted_date) %in% c("2018-05-15", "2018-05-21")) {
    .pkg_abort(
      "The dataset for {tt_formatted_date} is dirty and cannot be automatically loaded.",
      "invalid_date"
    )
  }

  tt_folders <- tt_weeks(tt_year, auth = auth)
  if (!as.character(tt_formatted_date) %in% tt_folders[["folders"]]) {
    closest <- tt_closest_date(tt_formatted_date, tt_folders$folders)
    .pkg_abort(
      c(
        "{tt_formatted_date} does not have TidyTuesday data.",
        i = "Did you mean {closest}?"
      ),
      "invalid_date"
    )
  }
  tt_formatted_date
}

tt_check_date.year <- function(x, week, auth = gh::gh_token()) {
  if (x == 2018 && week %in% c(7, 8)) {
    .pkg_abort(
      "The dataset for 2018 week {week} is dirty and cannot be automatically loaded.",
      "invalid_date"
    )
  }

  tt_folders <- tt_weeks(x, auth = auth)

  if (!week %in% tt_folders$week_desc && week >= 1) {
    weeks <- contiguous_weeks(tt_folders$week_desc)
    .pkg_abort(
      c(
        "Week {week} does not have TidyTuesday data in {x}.",
        i = "Please choose a valid week from {weeks}"
      ),
      "invalid_date"
    )
  } else if (week < 1) {
    .pkg_abort(
      c(
        "{.arg week} must be a valid positive integer value."
      ),
      "invalid_date"
    )
  }

  tt_date <- tt_folders$folders[tt_folders$week_desc == week]

  if (
    !tt_date %in% tt_folders[["folders"]] ||
      !tt_folders[["data"]][tt_folders[["folders"]] == tt_date]
  ) {
    .pkg_abort(
      "Week {week} of {x} does not have data available for download.",
      "invalid_date"
    )
  }

  tt_date_format(tt_date)
}

tt_check_year <- function(year, auth = gh::gh_token()) {
  tt_yrs <- tt_years(auth = auth)
  if (year %in% tt_yrs) {
    return(invisible(year))
  }
  .pkg_abort(
    c(
      "TidyTuesday did not exist in {year} (or {year} is in the future).",
      i = "Available years: {tt_yrs}"
    ),
    "invalid_year"
  )
}


tt_weeks <- function(year, auth = gh::gh_token()) {
  tt_check_year(year, auth = auth)

  ttmf <- tt_master_file(auth = auth)

  tt_week <- aggregate(
    data_files ~ Week + Date,
    ttmf[ttmf$year == year, ],
    FUN = function(x) {
      !anyNA(x)
    },
    na.action = na.pass
  )

  list(
    week_desc = tt_week$Week,
    folders = tt_week$Date,
    data = tt_week$data_files
  )
}

tt_years <- function(auth = gh::gh_token()) {
  unique(tt_master_file(auth = auth)$year)
}

valid_date <- function(x) {
  suppressWarnings({
    lubridate::is.Date(x) || !is.na(lubridate::as_date(as.character(x)))
  })
}

valid_year <- function(x) {
  suppressWarnings({
    !is.na(lubridate::as_date(paste0(as.character(x), "-01-01")))
  })
}

tt_date_format <- function(x) {
  lubridate::ymd(paste0(
    lubridate::year(x),
    "-",
    lubridate::month(x),
    "-",
    lubridate::day(x)
  ))
}

tt_closest_date <- function(inputdate, availabledates) {
  availabledates[
    which.min(abs(difftime(inputdate, availabledates, units = "days")))
  ]
}

# covr doesn't understand that this is tested in `test-zzz.R`.
#
# nocov start
.onLoad <- function(libname, pkgname) {
  options("tidytuesdayR.tt_repo" = "rfordatascience/tidytuesday")
  options("tidytuesdayR.tt_testing" = FALSE)
  options("tidytuesdayR.tt_internet_connectivity" = NA)
  check_connectivity()
  rate_limit_update()
}

## message only displayed on attachment
.onAttach <- function(libname, pkgname) {
  if (!get_connectivity()) {
    packageStartupMessage(
      paste(
        "--- WARNING ---",
        "\n  No Internet Connection was found -",
        " Functions in {tidytuesdayR} that rely on an internet connection",
        "will only return NULL"
      )
    )
  }
}
# nocov end

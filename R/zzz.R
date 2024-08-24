# covr doesn't understand that this is tested in `test-zzz.R`.
#
# nocov start
.onLoad <- function(libname, pkgname) {
  options("tidytuesdayR.tt_repo" = "rfordatascience/tidytuesday")
  options("tidytuesdayR.tt_testing" = FALSE)
  options("tidytuesdayR.tt_internet_connectivity" = NA)
}
# nocov end

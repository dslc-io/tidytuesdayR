# covr doesn't understand that this is tested in `test-zzz.R`.
#
# nocov start
.onLoad <- function(libname, pkgname) {
  options("tidytuesdayR.tt_repo" = "rfordatascience/tidytuesday")
}
# nocov end

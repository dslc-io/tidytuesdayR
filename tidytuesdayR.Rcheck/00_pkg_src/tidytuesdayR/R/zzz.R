.onLoad <- function(libname, pkgname) {
  options("tidytuesdayR.tt_repo" = "rfordatascience/tidytuesday")
  rate_limit_update()
}

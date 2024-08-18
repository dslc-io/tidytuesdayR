# Provide a wrapper to temporarily change location set for tidytuesday
# reference to preserve consistency

tt_ref_test_that <- function(desc, ...) {
  ref_repo <- getOption("tidytuesdayR.tt_repo")
  options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
  on.exit({
    options("tidytuesdayR.tt_repo" = ref_repo)
  })
  if (get_connectivity()) {
    testthat::test_that(desc = desc, ...)
  }
}

#' @importFrom testthat skip skip_if_offline
check_api <- function(n = 30) {
  skip_if_offline("github.com")
  if (!get_connectivity()) {
    skip("Connection to Github.com not available")
  }
  if (rate_limit_check(quiet = TRUE) <= n) {
    skip("Rate Limit Met")
  }
}

#' @importFrom withr local_options
local_test_repo <- function(.env = parent.frame()) {
  withr::local_options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
}

tt_no_internet_test_that <- function(desc, ...) {
  connectivity <- getOption("tidytuesdayR.tt_internet_connectivity")
  options("tidytuesdayR.tt_internet_connectivity" = FALSE)
  options("tidytuesdayR.tt_testing" = TRUE)
  on.exit({
    options("tidytuesdayR.tt_internet_connectivity" = connectivity)
    options("tidytuesdayR.tt_testing" = FALSE)
  })
  testthat::test_that(desc = desc, ...)
}

tt_ref_encoding <- function(desc, encoding, ...) {
  if (get_connectivity()) {
    withr::local_options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
    expect_warning(
      withr::local_locale(LC_CTYPE = encoding),
      "using locale code page other than 65001"
    )
    test_that(desc = desc, ...)
  }
}

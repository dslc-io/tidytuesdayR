# Provide a wrapper to temporarily change location set for tidytuesday
# reference to preserve consistency

tt_ref_test_that <- function(desc, ...) {
  if (get_connectivity()) {
    withr::local_options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
    test_that(desc = desc, ...)
  }
}

check_api <- function(n = 30) {
  skip_if_offline("github.com")
  if (!get_connectivity()) {
    skip("Connection to Github.com not available")
  }
  if (rate_limit_check(quiet = TRUE) <= n) {
    skip("Rate Limit Met")
  }
}

local_test_repo <- function(.env = parent.frame()) {
  withr::local_options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
}

tt_no_internet_test_that <- function(desc, ...) {
  withr::local_options(
    "tidytuesdayR.tt_internet_connectivity" = FALSE,
    "tidytuesdayR.tt_testing" = TRUE
  )
  test_that(desc = desc, ...)
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

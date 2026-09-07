test_that("valid dates work", {
  local_tt_master_file()
  tt_date <- tt_check_date("2019-04-02")
  expect_equal(
    tt_date,
    as.Date("2019-04-02")
  )
})

test_that("valid year-week combinations work", {
  local_tt_master_file()
  tt_date_1 <- tt_check_date(2019, 14)
  tt_date_2 <- tt_check_date("2019", 14)

  expect_equal(tt_date_1, as.Date("2019-04-02"))
  expect_equal(tt_date_2, as.Date("2019-04-02"))
})

test_that("Close dates are suggested if provided date is incorrect", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  local_tt_master_file()
  stbl::expect_pkg_error_snapshot(
    tt_check_date("2019-04-04"),
    "tidytuesdayR",
    "invalid_date"
  )
})

test_that("Invalid weeks throw errors", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  local_tt_master_file()
  stbl::expect_pkg_error_snapshot(
    tt_check_date(2018, 20),
    "tidytuesdayR",
    "invalid_date"
  )
  stbl::expect_pkg_error_snapshot(
    tt_check_date(2018, 0),
    "tidytuesdayR",
    "invalid_date"
  )
  stbl::expect_pkg_error_snapshot(
    tt_check_date(2018, 7),
    "tidytuesdayR",
    "invalid_date"
  )
  stbl::expect_pkg_error_snapshot(
    tt_check_date(2018, 8),
    "tidytuesdayR",
    "invalid_date"
  )
  stbl::expect_pkg_error_snapshot(
    tt_check_date(2020, 1),
    "tidytuesdayR",
    "invalid_date"
  )
})

test_that("invalid entries are flagged", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  local_tt_master_file()
  stbl::expect_pkg_error_snapshot(
    tt_check_date("xyz"),
    "tidytuesdayR",
    "invalid_date"
  )
})

test_that("tt_check_year checks years", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  local_tt_master_file()
  stbl::expect_pkg_error_snapshot(
    tt_check_year(2015),
    "tidytuesdayR",
    "invalid_year"
  )
})

test_that("tt_date also works", {
  # This is mostly just a wrapper around tt_check_date(), so most tests are
  # handled above.
  local_tt_master_file()
  tt_date_1 <- tt_date(2019, 14)
  tt_date_2 <- tt_date("2019", 14)

  expect_equal(tt_date_1, as.Date("2019-04-02"))
  expect_equal(tt_date_2, as.Date("2019-04-02"))
})

test_that("tt_check_date errors informatively with no args", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  local_tt_master_file()
  stbl::expect_pkg_error_snapshot(
    tt_check_date(),
    "tidytuesdayR",
    "invalid_date"
  )
})

test_that("tt_check_date errors informatively for the dirtiest dataset", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  local_tt_master_file()
  stbl::expect_pkg_error_snapshot(
    tt_check_date("2018-05-15"),
    "tidytuesdayR",
    "invalid_date"
  )
})

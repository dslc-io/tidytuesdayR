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
  local_tt_master_file()
  expect_error(
    tt_check_date("2019-04-04"),
    "2019-04-02",
    class = "tt-error-invalid_date"
  )
})

test_that("Invalid weeks throw errors", {
  local_tt_master_file()
  expect_error(
    tt_check_date(2018, 20),
    "1-19",
    class = "tt-error-invalid_date"
  )
  expect_error(
    tt_check_date(2018, 0),
    "positive integer",
    class = "tt-error-invalid_date"
  )
  expect_error(
    tt_check_date(2020, 1),
    "data available for download",
    class = "tt-error-invalid_date"
  )
})

test_that("invalid entries are flagged", {
  local_tt_master_file()
  expect_error(
    tt_check_date("xyz"),
    "Entries must render to a valid date or year"
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

test_that("tt_check_year checks years", {
  local_tt_master_file()
  expect_error(
    tt_check_year(2015),
    "did not exist",
    class = "tt-error-invalid_year"
  )
})

tt_ref_test_that("valid dates work", {
  check_api()
  tt_date <- tt_check_date("2019-04-02")
  expect_equal(
    tt_date,
    as.Date("2019-04-02")
  )
})

tt_ref_test_that("valid year-week combinations work", {
  check_api()
  tt_date_1 <- tt_check_date(2019, 14)
  tt_date_2 <- tt_check_date("2019", 14)

  expect_equal(tt_date_1, as.Date("2019-04-02"))
  expect_equal(tt_date_2, as.Date("2019-04-02"))
})

tt_ref_test_that("Close dates are suggested if provided date is incorrect", {
  check_api()
  expect_error(
    tt_check_date("2019-04-04"),
    paste0(
      "2019-04-04 is not a date that has TidyTuesday data.",
      "\n\tDid you mean: 2019-04-02?"
    ),
    fixed = TRUE
  )
})

tt_ref_test_that("invalid entries are flagged", {
  check_api()
  expect_error(
    tt_check_date("xyz"),
    "Entries must render to a valid date or year"
  )
})

tt_ref_test_that("Check that tt_compile lists all files for the date", {
  check_api()

  tt_c <- tt_compile("2019-01-15")

  expect_equal(
    tt_c$files$data_files,
    c("agencies.csv", "launches.csv")
  )

  expect_equal(
    tt_c$files$data_type,
    c("csv", "csv")
  )

  expect_equal(
    tt_c$files$delim,
    c(",", ",")
  )

  expect_true(
    !is.null(tt_c$readme)
  )
})

tt_ref_test_that("Check that tt_compile returns NULL for missing readme's", {
  check_api()

  tt_c <- tt_compile("2018-04-02")

  expect_equal(
    tt_c$files$data_files,
    "us_avg_tuition.xlsx"
  )
  expect_equal(
    tt_c$files$data_type,
    "xlsx"
  )
  expect_true(
    is.na(tt_c$files$delim)
  )
  expect_true(
    is.null(tt_c$readme)
  )
})

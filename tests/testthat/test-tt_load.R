tt_ref_test_that("tt_load loads all data available", {
  check_api()

  expect_snapshot({
    tt_obj <- tt_load("2019-01-15")
  })
  expect_s3_class(tt_obj, "tt_data")
  expect_length(tt_obj, 2)
  expect_named(tt_obj, c("agencies", "launches"))

  # Save fixtures for comparison.
  # download.file(
  #   file.path(
  #     "https://raw.githubusercontent.com/thebioengineer/tt_ref",
  #     "master/data/2019/2019-01-15/agencies.csv"
  #   ),
  #   test_path("testfiles", "agencies.csv")
  # )
  # download.file(
  #   file.path(
  #     "https://raw.githubusercontent.com/thebioengineer/tt_ref",
  #     "master/data/2019/2019-01-15/launches.csv"
  #   ),
  #   test_path("testfiles", "launches.csv")
  # )
  agencies <- readr::read_csv(
    test_path("testfiles", "agencies.csv"),
    show_col_types = FALSE
  )
  launches <- readr::read_csv(
    test_path("testfiles", "launches.csv"),
    show_col_types = FALSE
  )
  expect_equal(
    tt_obj$agencies,
    agencies
  )
  expect_equal(
    tt_obj$launches,
    launches
  )
})

tt_ref_test_that("tt_load loads excel files properly", {
  check_api()

  expect_snapshot({
    tt_obj <- tt_load("2018-04-02")
  })
  expect_s3_class(tt_obj, "tt_data")
  expect_length(tt_obj, 1)
  expect_named(tt_obj, "us_avg_tuition")

  # File was saved manually from
  # https://github.com/thebioengineer/tt_ref/blob/master/data/2018/2018-04-02/us_avg_tuition.xlsx
  # because that's easier for setting this up than essentially duplicating the
  # code in tt_load.
  us_avg_tuition <- readxl::read_xlsx(test_path("testfiles", "us_avg_tuition.xlsx"))
  expect_equal(
    tt_obj$us_avg_tuition,
    us_avg_tuition
  )
})


tt_no_internet_test_that("When there is no internet, returns NULL", {
  expect_message(
    {tt_obj <- tt_load("2018-04-02")},
    "Warning - No Internet Connectivity"
  )
  expect_null(tt_obj)
})

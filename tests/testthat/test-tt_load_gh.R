context("test-tt_load_gh")

# check that correct data are returned
test_that("tt_load_gh returns tt object when provided proper date", {
  tt <- tt_load_gh("2019-01-15")

  testthat::expect_s3_class(tt, "tt")
  testthat::expect_equal(attr(tt, ".files"), c("agencies.csv", "launches.csv"))
  testthat::expect_equal(attr(tt, ".url"), "https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-01-15")
})

# check that correct data are returned
test_that("tt_load_gh returns tt object when provided proper year and TT week number", {
  tt <- tt_load_gh(2019, 3)

  testthat::expect_s3_class(tt, "tt")
  testthat::expect_equal(attr(tt, ".files"), c("agencies.csv", "launches.csv"))
  testthat::expect_equal(attr(tt, ".url"), "https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-01-15")
})


# check that errors are returned
test_that("tt_load_gh returns error when incorrect date", {
  nullout <- capture.output({
    testthat::expect_error(tt_load_gh("2019-01-16"), "is not a date that has TidyTuesday data")
  })
})
test_that("tt_load_gh returns error when incorrect years or week number entries", {
  testthat::expect_error(tt_load_gh(2018, 92), "Please enter a value for week between 1")
  testthat::expect_error(tt_load_gh(2017, 92), "TidyTuesday did not exist for")
})
# check that error is thrown when requesting data from a week that did not exist for that year
test_that("tt_load_gh returns tt object when provided proper year and TT week number", {
  testthat::expect_error(tt_load_gh(2020, 1), "does not have data available for download from github")

})

test_that(
  "tt_load_gh returns error when incorrect years or week number entries",
  {
    expect_error(
      tt_load_gh(2018, 92),
      "Please enter a value for week between 1"
    )
    expect_error(
      tt_load_gh(2017, 92),
      "TidyTuesday did not exist for"
    )
  }
)

test_that("tt_load_gh returns error when incorrect years or week number entries", {
  expect_error(
    tt_load_gh(2018, 92),
    "Please enter a value for week between 1"
  )
  expect_error(
    tt_load_gh(2017, 92),
    "TidyTuesday did not exist for"
  )
})

test_that("tt_load_gh returns error when nothing is entered", {
  nullout <- capture.output({
    testthat::expect_error(tt_load_gh(), "Enter either the year or date of the TidyTuesday Data")
  })
})
test_that("tt_load_gh returns error when week is not a valid entry between 1 and n weeks", {
  testthat::expect_error(
    tt_load_gh(2019, 0),
    "Week entry must be a valid positive integer"
  )
})

# test driven dev, new feature to add
test_that("Returns simple list of object when no readme.md available", {
  tt <- tt_load_gh("2018-04-09")
  expect_s3_class(tt, "tt")
  expect_true(length(attr(tt, ".readme")) == 0) # object should not exist
})


test_that("tt_load loads all data available", {
  tt_obj <- tt_load("2019-01-15")
  expect_equal(
    tt_obj$agencies,
    readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-01-15/agencies.csv")
  )
  expect_equal(
    tt_obj$launches,
    readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-01-15/launches.csv")
  )
})

test_that("tt_load loads excel files properly", {
  tt_obj <- tt_load("2018-04-02")

  tempExcelFile <- tempfile(fileext = ".xlsx")
  utils::download.file(
    paste0(
      "https://www.github.com/rfordatascience/tidytuesday/raw/master/data/",
      "2018/2018-04-02/us_avg_tuition.xlsx?raw=true"
    ),
    tempExcelFile,
    quiet = TRUE,
    mode = "wb"
  )

  expect_equal(tt_obj$us_avg_tuition, readxl::read_xlsx(tempExcelFile))
})

test_that("tt_load_gh ignores extra files/diretory paths", {
  tt_obj <- tt_load_gh("2019-04-02")
  tt_obj_2 <- tt_load_gh("2019-04-09")

  expect_equal(length(tt_obj),1)
  expect_equal(tt_obj[1],"bike_traffic.csv")

  expect_equal(length(tt_obj_2),3)
  expect_equal(tt_obj_2[1:3],c("grand_slam_timeline.csv","grand_slams.csv","player_dob.csv"))
})


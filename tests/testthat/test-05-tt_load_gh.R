context("Load all information from Github")

ref_repo <- options("tidytuesdayR.tt_repo")
options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
on.exit({
  options("tidytuesdayR.tt_repo" = ref_repo[[1]])
})

# check that correct data are returned
tt_ref_test_that(
  "tt_load_gh returns tt object when provided proper date", {
  check_api()

  tt <- tt_load_gh("2019-01-15")

  testthat::expect_s3_class(tt, "tt")
  testthat::expect_equal(attr(tt, ".files")$data_files,
                         c("agencies.csv", "launches.csv"))

})

# check that correct data are returned
tt_ref_test_that(
  "tt_load_gh returns tt object when provided proper year and TT week number", {
  check_api()
  tt <- tt_load_gh(2019, 3)

  testthat::expect_s3_class(tt, "tt")
  testthat::expect_equal(attr(tt, ".files")$data_files,
                         c("agencies.csv", "launches.csv"))
  })


# check that errors are returned
tt_ref_test_that(
  "tt_load_gh returns error when incorrect date", {
  check_api()
  nullout <- capture.output({
    testthat::expect_error(tt_load_gh("2019-01-16"),
                           "is not a date that has TidyTuesday data")
  })
})
tt_ref_test_that(
  "tt_load_gh returns error when incorrect years or week number entries",{
    check_api()

    testthat::expect_error(tt_load_gh(2018, 92),
                           "Please enter a value for week between 1")
    testthat::expect_error(tt_load_gh(2017, 92),
                           "TidyTuesday did not exist for")
})
# check that error is thrown when requesting data from a week that did not
# exist for that year
tt_ref_test_that(
  "tt_load_gh returns tt object when provided proper year and TT week number", {
  check_api()
  testthat::expect_error(
    tt_load_gh(2020, 1),
    "does not have data available for download from github")

})

tt_ref_test_that(
  "tt_load_gh returns error when incorrect years or week number entries",
  {
    check_api()
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

tt_ref_test_that(
  "tt_load_gh returns error when incorrect years or week number entries", {
  check_api()
  expect_error(
    tt_load_gh(2018, 92),
    "Please enter a value for week between 1"
  )
  expect_error(
    tt_load_gh(2017, 92),
    "TidyTuesday did not exist for"
  )
})

tt_ref_test_that(
  "tt_load_gh returns error when nothing is entered", {
  check_api()
    expect_error(
      tt_load_gh(),
      "Enter either the year or date of the TidyTuesday Data"
      )
})

tt_ref_test_that(
  paste("tt_load_gh returns error when week is not",
        "a valid entry between 1 and n weeks"), {
  check_api()
  testthat::expect_error(
    tt_load_gh(2019, 0),
    "Week entry must be a valid positive integer"
  )
})

# test driven dev, new feature to add
tt_ref_test_that(
  "Returns simple list of object when no readme.md available", {
  check_api()
  tt <- tt_load_gh("2018-04-09")
  expect_s3_class(tt, "tt")
  expect_true(length(attr(tt, ".readme")) == 0) # object should not exist
})

tt_ref_test_that(
  "tt_load_gh ignores extra files/diretory paths", {
  check_api()
  tt_obj <- tt_load_gh("2019-04-02")
  tt_obj_2 <- tt_load_gh("2019-04-09")

  expect_equal(length(tt_obj),1)
  expect_equal(tt_obj[1],"bike_traffic.csv")

  expect_equal(length(tt_obj_2),3)
  expect_equal(tt_obj_2[1:3],
               c(
                 "grand_slam_timeline.csv",
                 "grand_slams.csv",
                 "player_dob.csv"
               ))
  })

tt_ref_test_that(
  "tt_load_gh finds all the files in the readme", {
  check_api()
  tt_obj <- tt_load_gh("2020-04-21")

  expect_equal(length(tt_obj),2)
  expect_equal(tt_obj[1:2],c("gdpr_text.tsv", "gdpr_violations.tsv"))

})

tt_no_internet_test_that("When there is no internet, returns NULL",{

  message <- capture_messages(tt_obj <- tt_load_gh("2018-04-02"))

  expect_equal(message, "Warning - No Internet Connectivity\n")
  expect_true(is.null(tt_obj))

})

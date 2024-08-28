test_that("tt_compile lists all files for the date", {
  local_tt_master_file()
  local_tt_week_readme_html()
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

test_that("tt_compile returns NULL for missing readme's", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_warning(
    {
      tt_c <- tt_compile("2018-04-02")
    },
    "No readme found",
    class = "tt-warning-no_readme"
  )

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

test_that("tt_load_gh returns tt object when provided proper date", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(
    {
      expect_message(
        {
          tt <- tt_load_gh("2019-01-15")
        },
        "Compiling #TidyTuesday"
      )
    },
    "There are 2 files"
  )
  expect_s3_class(tt, "tt")
  expect_equal(
    attr(tt, ".files")$data_files,
    c("agencies.csv", "launches.csv")
  )
})

test_that("tt_load_gh returns tt object when provided proper year and TT week number", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(
    {
      expect_message(
        {
          tt <- tt_load_gh(2019, 3)
        },
        "Compiling #TidyTuesday"
      )
    },
    "There are 2 files"
  )
  expect_s3_class(tt, "tt")
  expect_equal(
    attr(tt, ".files")$data_files,
    c("agencies.csv", "launches.csv")
  )
})

test_that("tt_load_gh errors when incorrect date", {
  local_tt_master_file()
  expect_error(
    tt_load_gh("2019-01-16"),
    class = "tt-error-invalid_date"
  )
})

test_that("tt_load_gh returns list of object when no readme.md available", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(
    {
      expect_message(
        {
          expect_warning(
            {
              tt <- tt_load_gh("2018-04-09")
            },
            class = "tt-warning-no_readme"
          )
        },
        "Compiling #TidyTuesday"
      )
    },
    "There is 1 file"
  )
  expect_s3_class(tt, "tt")
  expect_true(length(attr(tt, ".readme")) == 0) # object should not exist
})

test_that("tt_load_gh ignores extra files/diretory paths", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(
    {
      expect_message(
        {
          tt_obj <- tt_load_gh("2019-04-02")
        },
        "Compiling #TidyTuesday"
      )
    },
    "There is 1 file"
  )
  expect_equal(length(tt_obj), 1)
  expect_equal(tt_obj[1], "bike_traffic.csv")

  expect_message(
    {
      expect_message(
        {
          tt_obj_2 <- tt_load_gh("2019-04-09")
        },
        "Compiling #TidyTuesday"
      )
    },
    "There are 3 files"
  )
  expect_equal(length(tt_obj_2), 3)
  expect_equal(
    tt_obj_2[1:3],
    c(
      "grand_slam_timeline.csv",
      "grand_slams.csv",
      "player_dob.csv"
    )
  )
})

test_that("tt_load_gh works with tsvs", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(
    {
      expect_message(
        {
          tt_obj <- tt_load_gh("2020-04-21")
        },
        "Compiling #TidyTuesday"
      )
    },
    "There are 2 files"
  )

  expect_equal(length(tt_obj), 2)
  expect_equal(tt_obj[1:2], c("gdpr_text.tsv", "gdpr_violations.tsv"))
})

test_that("print.tt lists all the available files for the weeks tt", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(expect_message({
    tt <- tt_load_gh("2019-01-15")
  }))
  expect_snapshot({
    test_result <- print(tt)
  })
  expect_identical(test_result, tt)
})

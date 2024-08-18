tt_ref_test_that(
  "tt_read_data only works for numeric, integer, or character entries",
  {
    check_api()
    expect_message(
      {
        expect_message(
          {tt_gh_data <- tt_load_gh("2019-01-15")},
          "Compiling #TidyTuesday"
        )
      },
      "There are 2 files"
    )

    numericRead <- tt_download_file(tt_gh_data, 1)
    integerRead <- tt_download_file(tt_gh_data, 1L)
    characterRead <- tt_download_file(tt_gh_data, "agencies.csv")

    numericRead <- tt_download_file(tt_gh_data, 1)
    integerRead <- tt_download_file(tt_gh_data, 1L)
    characterRead <- tt_download_file(tt_gh_data, "agencies.csv")

    readURL <- readr::read_csv(
      github_blob("data/2019/2019-01-15/agencies.csv", as_raw = TRUE),
      show_col_types = FALSE
    )

    expect_equal(numericRead, readURL)
    expect_equal(integerRead, readURL)
    expect_equal(characterRead, readURL)

    # fails when not expected class
    expect_error(
      {
        tt_download_file(tt_gh_data, factor("agencies.csv"))
      },
      "No method for entry of class:"
    )
  }
)

tt_ref_test_that(
  "tt_read_data informs when selection is out of range/not available",
  {
    check_api()
    expect_message(
      {
        expect_message(
          {tt_gh_data <- tt_load_gh("2019-01-15")},
          "Compiling #TidyTuesday"
        )
      },
      "There are 2 files"
    )

    expect_error(
      {
        tt_download_file(tt_gh_data, "wrong_entry.csv")
      },
      "That is not an available file"
    )
    expect_error(
      {
        tt_download_file(tt_gh_data, 45)
      },
      "That is not an available index"
    )
    expect_error(
      {
        tt_download_file(tt_gh_data, 45L)
      },
      "That is not an available index"
    )
  }
)


tt_ref_test_that(
  "tt_read_data can load RDS files just as easily as text files",
  {
    check_api()
    skip_on_cran()

    expect_message(
      {
        expect_message(
          {tt_gh_data <- tt_load_gh("2019-01-01")},
          "Compiling #TidyTuesday"
        )
      },
      "There are 2 files"
    )

    expect_s3_class(
      tt_download_file(tt_gh_data, 2),
      c("tbl_df", "tbl", "data.frame")
    )
  }
)


tt_ref_test_that(
  "read_rda will not arbitrarily assign the object to the current environment",
  {
    check_api()
    new_dataset <- read_rda(testthat::test_path("testfiles/test.rda"))
    expect_false(exists("testdf"))
    expect_equal(
      data.frame(x = c(1, 2, 3), y = c("A", "B", "C"), stringsAsFactors = TRUE),
      new_dataset
    )
  }
)

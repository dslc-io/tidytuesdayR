test_that("tt_download errors for bad file", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(expect_message({
    tt <- tt_load_gh("2019-01-15")
  }))
  expect_error(
    {
      tt_download(tt, "bad_filename")
    },
    "must be one or more of",
    class = "tt-error-bad_file"
  )
})

test_that("tt_download downloads all files", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  expect_message(expect_message({
    tt <- tt_load_gh("2019-01-15")
  }))
  # Extract expect_message level to catch newline.
  expect_message(expect_message(
    expect_message(
      expect_message(
        {
          tt_data <- tt_download(tt)
        },
        "Downloading files"
      ),
      "1 of 2",
      class = "tt-message-download"
    ),
    "2 of 2",
    class = "tt-message-download"
  ))
  expect_type(tt_data, "list")
  expect_length(tt_data, 2)
  expect_named(tt_data, c("agencies", "launches"))
  expect_s3_class(tt_data$agencies, "tbl_df")
  expect_s3_class(tt_data$launches, "tbl_df")
})

test_that("tt_download downloads specific files", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  expect_message(expect_message({
    tt <- tt_load_gh("2019-01-15")
  }))
  # Extract expect_message level to catch newline.
  expect_message(expect_message(
    expect_message(
      {
        tt_data <- tt_download(tt, files = "agencies.csv")
      },
      "Downloading files"
    ),
    "1 of 1",
    class = "tt-message-download"
  ))
  expect_type(tt_data, "list")
  expect_length(tt_data, 1)
  expect_s3_class(tt_data$agencies, "tbl_df")
})

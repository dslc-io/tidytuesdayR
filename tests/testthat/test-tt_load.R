test_that("tt_load loads data", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  expect_message(expect_message(expect_message(expect_message(expect_message(expect_message({
    tt_data <- tt_load("2019-01-15")
  }))))))
  expect_s3_class(tt_data, "tt_data")
  expect_length(tt_data, 2)
  expect_named(tt_data, c("agencies", "launches"))
})

test_that("print.tt_data lists the available datasets", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  local_readme()

  expect_message(expect_message(expect_message(expect_message(expect_message(
    expect_message({
      tt_data <- tt_load("2019-01-15")
    })
  )))))
  expect_snapshot({
    test_result <- print(tt_data)
  })

  expect_identical(test_result, tt_data)
})

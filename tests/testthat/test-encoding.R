test_that("Korean: Non-English encodings don't fail reading unicode from github", {
  skip_if_not(.Platform$OS.type == "windows")
  local_encoding("Korean")
  local_tt_master_file()
  local_tt_datasets()
  tt_data <- tt_datasets("2019")
  res <- nrow(data.frame(unclass(tt_data)))
  expect_equal(res, 52)
})

test_that("Japanese: Non-English encodings don't fail reading unicode from github", {
  skip_if_not(.Platform$OS.type == "windows")
  local_encoding("Japanese")
  local_tt_master_file()
  local_tt_datasets()
  tt_data <- tt_datasets("2019")
  res <- nrow(data.frame(unclass(tt_data)))
  expect_equal(res, 52)
})

test_that("Russian: Non-English encodings don't fail reading unicode from github", {
  skip_if_not(.Platform$OS.type == "windows")
  local_encoding("Russian")
  local_tt_master_file()
  local_tt_datasets()
  tt_data <- tt_datasets("2019")
  res <- nrow(data.frame(unclass(tt_data)))
  expect_equal(res, 52)
})

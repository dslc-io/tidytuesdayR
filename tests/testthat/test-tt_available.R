context("test-tt_available")

test_that("tt_available returns object of class 'tt_dataset_table_list", {
  ds <- tt_available()
  testthat::expect_s3_class(ds, "tt_dataset_table_list")
})

test_that("tt_available returns all years", {
  ds <- tt_available()
  years <- tt_years()
  testthat::expect_equivalent(names(ds), years[order(years, decreasing = TRUE)])
})


test_that("tt_datasets prints to console when rstudio viewer is not available", {
  ds <- tt_datasets(2018)
  consoleOutput <- print(ds, printConsole = TRUE)
  testthat::expect_equivalent(attr(ds, ".html") %>% rvest::html_table(), consoleOutput)
})

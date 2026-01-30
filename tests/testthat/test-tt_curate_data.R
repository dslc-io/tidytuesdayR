test_that("tt_curate_data returns the path to the curation script", {
  rlang::local_interactive(FALSE)
  test_result <- tt_curate_data()
  expect_equal(
    test_result,
    system.file("templates", "tt_curation.R", package = "tidytuesdayR")
  )
})

test_that("tt_curate_data respects open parameter", {
  # When open = FALSE, should not attempt to open file
  test_result <- tt_curate_data(open = FALSE)
  expect_equal(
    test_result,
    system.file("templates", "tt_curation.R", package = "tidytuesdayR")
  )
})

test_that("options are set on load", {
  expect_equal(getOption("tidytuesdayR.tt_repo"), "rfordatascience/tidytuesday")
})

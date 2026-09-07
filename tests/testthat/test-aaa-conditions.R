test_that(".pkg_abort() throws a classed tidytuesdayR error (#149)", {
  skip_if_not_installed("stbl", "0.4.0.9000")
  stbl::expect_pkg_error_snapshot(
    .pkg_abort("This is a test error.", "test_subclass"),
    "tidytuesdayR",
    "test_subclass"
  )
})

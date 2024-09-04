test_that("use_tidytemplate processes inputs", {
  local_mocked_bindings(
    use_template = function(...) {
      list(...)
    },
    .package = "usethis"
  )
  local_mocked_bindings(
    today = function() {
      as.Date("2024-08-19")
    }
  )
  expect_identical(
    use_tidytemplate(open = FALSE),
    list(
      "tidytemplate.Rmd",
      save_as = "2024_08_20_tidy_tuesday.Rmd",
      data = list(
        call_date = as.Date("2024-08-19"),
        call_tuesday = "2024-08-20"
      ),
      package = "tidytuesdayR",
      open = FALSE
    )
  )
})

context("test-utils")

tt_data <- structure(
  list(
    value1 = "value1",
    value2 = "value2"
  ),
  .tt = structure(
    c("value1.csv", "value2.csv"),
    .files = c("value1.csv", "value2.csv"),
    .url = "fake_url",
    .readme = "<p class=\"contents\">README contents</p>",
    class = "tt_gh"
  ),
  class = "tt_data"
)

test_that("tt_make_html generates a properly formatted html doc", {
  enteredValues <- read_html(tt_make_html(attr(tt_data, ".tt"))) %>%
    html_nodes(".contents") %>%
    as.character()
  testthat::expect_equal(enteredValues, "<p class=\"contents\">README contents</p>")
})

test_that("print.tt_data lists the available datasets", {
  tt_data <- structure(
    list(
      value1 = "value1",
      value2 = "value2"
    ),
    .tt = structure(
      c("value1.csv", "value2.csv"),
      .files = c("value1.csv", "value2.csv"),
      .url = "fake_url",
      .readme = "README",
      class = "tt_gh"
    ),
    class = "tt_data"
  )

  capturedOutput <- capture_message({
    print(tt_data)
  })

  testthat::expect_equal(
    capturedOutput$message,
    "Available Datasets:\n\tvalue1 \n\tvalue2 \n\t\n"
  )
})

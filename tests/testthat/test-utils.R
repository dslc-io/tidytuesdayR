context("test-utils")

test_that("tt_make_html generates a properly formatted html doc", {
  tt_data <- structure(
    list(
      tt = list(readme = "<p class=\"contents\">README contents</p>")
    )
  )
  enteredValues <- read_html(tt_make_html(tt_data)) %>%
    html_nodes(".contents") %>%
    as.character()

  expect_equal(enteredValues, "<p class=\"contents\">README contents</p>")
})

test_that("`$` accesses the data from the tt_data object", {
  value1 <- "value1"
  value2 <- data.frame(
    x = 1:5,
    y = c(1, 1, 1, 2, 2)
  )

  tt_data <- structure(
    list(data = list(value1 = value1, value2 = value2)),
    class = "tt_data"
  )

  expect_equal(tt_data$value1, value1)
  expect_equal(tt_data$value2, value2)
})

test_that("print.tt_data lists the available datasets", {
  tt_data <- structure(
    list(
      data = list(value1 = "value1", value2 = "value2"),
      tt = list(files = c("value1.csv", "value2.csv"))
    ),
    class = "tt_data"
  )

  capturedOutput <- capture_message({
    print(tt_data)
  })

  expect_equal(
    capturedOutput$message,
    "Available Datasets:\n\tvalue1 \n\tvalue2 \n\t\n"
  )
})

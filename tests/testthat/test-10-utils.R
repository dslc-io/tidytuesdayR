tt_data <- structure(
  list(
    value1 = "value1",
    value2 = "value2"
  ),
  .tt = structure(
    c("value1.csv", "value2.csv"),
    .files = c("value1.csv", "value2.csv"),
    .readme = NULL,
    class = "tt_gh"
  ),
  class = "tt_data"
)

tt_ref_test_that("print.tt_data lists the available datasets", {
  tt_data <- structure(
    list(
      value1 = "value1",
      value2 = "value2"
    ),
    .tt = structure(
      c("value1.csv", "value2.csv"),
      .files = c("value1.csv", "value2.csv"),
      .url = "fake_url",
      .readme = NULL,
      class = "tt_gh"
    ),
    class = "tt_data"
  )

  capturedOutput <- capture_message({
    print(tt_data)
  })

  testthat::expect_equal(
    capturedOutput$message,
    "Available datasets:\n\tvalue1 \n\tvalue2 \n\t\n"
  )
})

tt_ref_test_that("print.tt lists all the available files for the weeks tt",{
  tt_obj <- tt_load_gh(2019, week = 16)

  capturedOutput <- capture_message({
    print(tt_obj)
    })$message

  expect_equal(
    capturedOutput,
    "Available datasets in this TidyTuesday:\n\tbrexit.csv \n\tcorbyn.csv \n\tdogs.csv \n\teu_balance.csv \n\tpensions.csv \n\ttrade.csv \n\twomen_research.csv \n\t\n"
  )

})

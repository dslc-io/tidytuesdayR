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
  check_api()

  tt_obj <- tt_load_gh(2019, week = 16)

  capturedOutput <- capture_message({
    print(tt_obj)
    })$message

  expect_equal(
    capturedOutput,
    paste0("Available datasets in this TidyTuesday:\n\tbrexit.csv ",
           "\n\tcorbyn.csv \n\tdogs.csv \n\teu_balance.csv ",
           "\n\tpensions.csv \n\ttrade.csv \n\twomen_research.csv \n\t\n")
  )

})

test_that("html_viewer returns NULL when running not in interactive mode",{

  res <- html_viewer("www.google.com", is_interactive = FALSE)

  expect_equal(res, NULL)

})


test_that("readme() will attempt to display the contents of the readme attribute",{

  tt_data <- structure(
    list(
      value1 = "value1",
      value2 = "value2"
    ),
    .tt = structure(
      c("value1.csv", "value2.csv"),
      .files = c("value1.csv", "value2.csv"),
      .readme = xml2::read_html("<body><p>hello world</p></body>"),
      class = "tt_gh"
    ),
    class = "tt_data"
  )

  existing_files <- list.files(tempdir())
  readme(tt_data)
  readme_html <- setdiff(list.files(tempdir()), existing_files)

  expect_equal(
    xml2::read_html(file.path(tempdir(),readme_html)),
    attr(attr(tt_data,".tt"),".readme")
  )

})

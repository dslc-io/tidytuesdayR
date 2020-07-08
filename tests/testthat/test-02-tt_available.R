context("tt_available lists available weeks of tidy tuesday")

tt_ref_test_that(
  "tt_datasets prints to console when rstudio viewer is not available", {
  check_api()
  ds <- tt_datasets(2018)
  consoleOutput <- data.frame(unclass(ds), stringsAsFactors=FALSE)
  expect_equivalent(
    rvest::html_table(attr(ds, ".html"))[[1]],
    consoleOutput
  )
})

tt_ref_test_that(
  "tt_datasets throws errors when asking for invalid years", {
  check_api()
  expect_error(
    tt_datasets(2017),
    paste0("Invalid `year` provided to list available tidytuesday datasets.",
           "\n\tUse one of the following years:")
  )
})

tt_ref_test_that(
  paste0("printing tt_datasets returns all the values as a",
         "printed data.frame if not interactive"), {
  check_api()
  ds <- tt_datasets(2018)

  printed_ds <- capture.output(print(ds, is_interactive = FALSE))
  consoleOutput <-
    capture.output(print(data.frame(unclass(ds), stringsAsFactors = FALSE)))

  expect_equal(
    printed_ds,
    consoleOutput
  )
})


tt_ref_test_that(
  "tt_available returns object of with all years data available", {
  check_api()
  ds <- tt_available()

  testthat::expect_s3_class(ds, "tt_dataset_table_list")
  expect_equivalent(names(ds), as.character(rev( tt_years())))

  ds_content <- as.list(unclass(ds))

  ds_content_data <-
    lapply(ds_content, function(x)
      data.frame(unclass(x), stringsAsFactors = FALSE))
  ds_content_html <-
    lapply(ds_content, function(x)
      rvest::html_table(attr(x, ".html"))[[1]])

  expect_equivalent(
    ds_content_html,
    ds_content_data
  )

})

tt_ref_test_that(
  paste("printing tt_available returns all the values",
        "as a printed data.frame if not interactive"), {
  check_api()
  ds <- tt_available()

  printed_ds <- capture.output(print(ds, is_interactive = FALSE))
  consoleOutput <-
    capture.output(quiet <-
                     lapply(as.list(unclass(ds)), function(x)
                       print(
                         data.frame(unclass(x), stringsAsFactors = FALSE)
                       )))

  printed_ds <-
    printed_ds[!(grepl("^Year:", printed_ds) | printed_ds == "")]
  consoleOutput <-
    consoleOutput[!(grepl("^Year:", consoleOutput) |
                      consoleOutput == "")]

  expect_equal(
    printed_ds,
    consoleOutput
  )
})


tt_ref_test_that(
  "tt_dataset_table and tt_dataset_table_list objects can make html outputs",{
  check_api()
  ds_tl <- tt_available()
  ds_t <- tt_datasets(2019)

  tmpfile <- tempfile(fileext = ".html")
  ds_tl_html <- make_tt_dataset_list_html(ds_tl, file = tmpfile)

  tmpfile2 <- tempfile(fileext = ".html")
  ds_t_html <- make_tt_dataset_html(ds_t, file = tmpfile2)

  expect_true(file.exists(tmpfile))
  expect_true(file.exists(tmpfile2))
  expect_equal(
    xml2::read_html(tmpfile),
    ds_tl_html
  )
  expect_equal(
    xml2::read_html(tmpfile2),
    ds_t_html
  )
})

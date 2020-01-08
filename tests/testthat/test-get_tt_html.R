context("Read URLS Gracefully")

test_that("Returns html when url is successful", {
  google <- get_tt_html("https://www.google.com")
  expect_s3_class(google,"xml_document")
})

test_that("Returns error when url is unsuccessful", {
  expect_error(get_tt_html("https://www.THISISAFAKEURL.com"))
})

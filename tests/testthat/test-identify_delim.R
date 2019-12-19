context("test-identify_delim")

test_that("Correctly identify the delimeter", {
  delim_file <- tempfile()
  writeLines(c("test,the,delim", "this,is,a comma"), delim_file)
  expect_equal(identify_delim(delim_file), ",")
})

test_that("If multiple possible delimeter exist, pick the `simplest` one", {
  delim_file <- tempfile()
  writeLines(c("test\t,the\t,delim", "this\t,is\t,a twofer"), delim_file)

  expect_warning(
    identify_delim(delim_file),
    "Detected multiple possible delimeters:"
  )
  suppressWarnings({
    expect_equal(
      identify_delim(delim_file),
      "\t"
    )
  })
})

test_that("If unable to identify a delimeter, give a warning", {
  delim_file <- tempfile()
  writeLines(c("test\tthe\tdelim", "this,is|a twofer"), delim_file)
  expect_warning(identify_delim(delim_file), "Not able to detect delimiter for")
  suppressWarnings({
    expect_equal(
      identify_delim(delim_file),
      " "
    )
  })
})

test_that("Can skip lines with comments to find delimeters, or ones identified to skip", {
  delim_file <- tempfile()
  writeLines(c("#this,line|isskipped", "test,the,delim", "this,is,a comma"), delim_file)
  expect_equal(identify_delim(delim_file), ",")
  expect_equal(identify_delim(delim_file, skip = 1), ",")
})

test_that("Can handle new line values in quotes", {
  delim_file <- tempfile()
  writeLines(c("test,the,\"delim\nnewline\"", "this,is,\"a comma\nwith a new line\""), delim_file)
  expect_equal(identify_delim(delim_file), ",")
})

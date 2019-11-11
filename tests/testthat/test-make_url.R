context("test-make_url")

test_that("valid dates work", {
  url <- tt_make_url("2019-04-02")
  expect_equal(basename(url),
               "2019-04-02")

})

test_that("valid year-week combinations work", {
  url <- tt_make_url(2019,14)
  url2 <- tt_make_url("2019",14)

  expect_equal(basename(url),
               "2019-04-02")
  expect_equal(basename(url2),
               "2019-04-02")
})

test_that("invalid entries are flagged", {
  expect_error(tt_make_url("xyz"),
               "Entries must render to a valid date or year")
})


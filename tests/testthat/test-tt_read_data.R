context("test-tt_read_data")

test_that("tt_read_data only works for numeric,integer, or character entries", {
  tt_gh_data <- tt_load_gh("2019-01-15")

  numericRead <- tt_read_data(tt_gh_data, 1)
  integerRead <- tt_read_data(tt_gh_data, 1L)
  characterRead <- tt_read_data(tt_gh_data, "agencies.csv")

  numericRead <- tt_read_data(tt_gh_data, 1)
  integerRead <- tt_read_data(tt_gh_data, 1L)
  characterRead <- tt_read_data(tt_gh_data, "agencies.csv")

  url <- paste0(
    gsub("tree", "blob", file.path(attr(tt_gh_data, ".url"), "agencies.csv")),
    "?raw=true"
  )

  readURL <- read_csv(url)

  expect_equal(numericRead, readURL)
  expect_equal(integerRead, readURL)
  expect_equal(characterRead, readURL)

  # fails when not expected class
  expect_error(
    {
      tt_read_data(tt_gh_data, factor("agencies.csv"))
    },
    "No method for entry of class:"
  )
})

test_that("tt_read_data informs when selection is out of range/not available", {
  tt_gh_data <- tt_load_gh("2019-01-15")

  expect_error(
    {
      tt_read_data(tt_gh_data, "wrong_entry.csv")
    },
    "That is not an available file"
  )
  expect_error(
    {
      tt_read_data(tt_gh_data, 45)
    },
    "That is not an available index"
  )
  expect_error(
    {
      tt_read_data(tt_gh_data, 45L)
    },
    "That is not an available index"
  )
})


test_that("tt_read_data can load RDS files just as easily as text files",{
  tt_gh_data <- tt_load_gh("2019-01-01")

  expect_is(
    tt_read_data(tt_gh_data, 1),
    c("tbl_df","tbl","data.frame")
  )

})


test_that("read_rda will not arbitrarily assign the object to the current environment",{
  new_dataset<-read_rda("testfiles/test.rda")
  expect_false(exists("testdf"))
  expect_equal(data.frame(x=c(1,2,3),y=c("A","B","C")),
               new_dataset)
})

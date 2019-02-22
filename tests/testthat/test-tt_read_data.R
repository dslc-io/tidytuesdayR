context("test-tt_read_data")

test_that("tt_read_data only works for numeric,integer, or character entries", {

  tt_gh_data<-tt_load_gh("2019-01-15")

  numericRead<-tt_read_data(tt_gh_data,1)
  integerRead<-tt_read_data(tt_gh_data,1L)
  characterRead<-tt_read_data(tt_gh_data,'agencies.csv')

  url<-paste0(gsub("tree","blob",file.path(tt_gh_data$url,"agencies.csv")),"?raw=true")
  readURL<-read_csv(url)


  expect_equal(numericRead, readURL)
  expect_equal(integerRead, readURL)
  expect_equal(characterRead, readURL)

  #fails when not expected class
  expect_error({tt_read_data(tt_gh_data,factor("agencies.csv"))},"No method for entry of class:")

})

test_that("tt_read_data informs when selection is out of range/not available", {

  tt_gh_data<-tt_load_gh("2019-01-15")

  expect_error({tt_read_data(tt_gh_data,"wrong_entry.csv")},"That is not an available file")
  expect_error({tt_read_data(tt_gh_data,45)},"That is not an available index")
  expect_error({tt_read_data(tt_gh_data,45L)},"That is not an available index")

})



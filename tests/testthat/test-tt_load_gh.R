context("test-tt_load_gh")

#check that correct data are returned
test_that("tt_load_gh returns tt_gh object", {

  tt_gh<-tt_load_gh("2019-01-15")

  testthat::expect_s3_class(tt_gh,"tt_gh")
  testthat::expect_equal(tt_gh$files,c("agencies.csv","launches.csv"))
  testthat::expect_equal(tt_gh$url,"https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-01-15")
})

#check that errors are returned
test_that("tt_load_gh returns error when incorrect date", {

  tt_gh<-tt_load_gh("2019-01-16")

  testthat::expect_error(tt_load_gh("2019-01-16"),"HTTP error 404")
})

#test driven dev, new feature to add
test_that("Returns simple list of object when no readme.md available", {

  tt_gh<-tt_load_gh("2018-06-15")

  testthat::expect_s3_class(tt_gh,"tt_gh")

  testthat::expect_true(tt_gh$readme,"") #object should not exist
})



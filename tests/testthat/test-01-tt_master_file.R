context("tt_master_file API")

tt_ref_test_that("`tt_master_file()` will update the masterfile reference if is null", {
  check_api()

  TT_MASTER_ENV$TT_MASTER_FILE <- NULL

  expect_true(is.null(TT_MASTER_ENV$TT_MASTER_FILE))

  ttmf <- tt_master_file()

  expect_true(!is.null(TT_MASTER_ENV$TT_MASTER_FILE))

})

tt_ref_test_that("`tt_update_master_file()` will update if the sha is old", {
  check_api()

  setup_df <- data.frame(x=1)
  attr(setup_df, ".sha") <- "old sha"
  tt_master_file( assign = setup_df )

  ttmf <- tt_master_file()


  tt_update_master_file()
  updated_ttmf <- tt_master_file()

  expect_true(identical(ttmf, setup_df))
  expect_true(!identical(updated_ttmf, setup_df))

})


tt_ref_test_that("`tt_update_master_file()` will update if the sha is old", {
  check_api()

  ttmf <- tt_master_file()
  expect_equal(colnames(ttmf), c("Week", "Date", "year","data_files", "data_type",  "delim"))

})



test_that(
  "`tt_master_file()` updates the masterfile reference",
  {
    local_gh_get_sha_in_folder()
    local_gh_get_csv_data_type()
    ttmf <- tt_master_file()
    expect_true(is.data.frame(TT_MASTER_ENV$TT_MASTER_FILE))
    expect_true(nrow(TT_MASTER_ENV$TT_MASTER_FILE) > 0)
  }
)

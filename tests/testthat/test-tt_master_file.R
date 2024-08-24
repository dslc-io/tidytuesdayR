tt_ref_test_that(
  "`tt_master_file()` will update the masterfile reference if is null or old",
  {
    check_api()

    TT_MASTER_ENV$TT_MASTER_FILE <- data.frame()

    expect_true(is.data.frame(TT_MASTER_ENV$TT_MASTER_FILE))
    expect_true(nrow(TT_MASTER_ENV$TT_MASTER_FILE) == 0)

    ttmf <- tt_master_file()

    expect_true(is.data.frame(TT_MASTER_ENV$TT_MASTER_FILE))
    expect_true(nrow(TT_MASTER_ENV$TT_MASTER_FILE) > 0)

    old_sha <- attr(TT_MASTER_ENV$TT_MASTER_FILE, ".sha")
    TT_MASTER_ENV$TT_MASTER_FILE <- data.frame()
    attr(TT_MASTER_ENV$TT_MASTER_FILE, ".sha") <- old_sha
    ttmf <- tt_master_file()
    expect_true(is.data.frame(TT_MASTER_ENV$TT_MASTER_FILE))
    expect_true(nrow(TT_MASTER_ENV$TT_MASTER_FILE) > 0)
  }
)

# tt_ref_test_that(
#   "`tt_update_master_file()` will update if the sha is old",
#   {
#     check_api()
#
#     ttmf <- tt_master_file()
#     expect_equal(
#       colnames(ttmf),
#       c("Week", "Date", "year", "data_files", "data_type", "delim")
#     )
#   }
# )

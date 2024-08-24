test_that("tt_download_file errors for bad index", {
  local_tt_master_file()
  local_tt_week_readme_html()
  expect_message(expect_message({tt <- tt_load_gh("2019-01-15")}))
  expect_error(
    {tt_download_file(tt, 3)},
    "File 3 not found",
    class = "tt-error-bad_index"
  )
  expect_error(
    {tt_download_file(tt, "bad_filename")},
    "File bad_filename not found",
    class = "tt-error-bad_index"
  )
})

test_that("tt_download_file works for a valid tt", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  expect_message(expect_message({tt <- tt_load_gh("2019-01-15")}))
  test_result <- tt_download_file(tt, 1)
  expect_s3_class(test_result, c("tbl_df", "data.frame"))
  expect_setequal(
    colnames(test_result),
    c(
      "agency", "count", "ucode", "state_code", "type", "class", "tstart",
      "tstop", "short_name", "name", "location", "longitude", "latitude",
      "error", "parent", "short_english_name", "english_name", "unicode_name",
      "agency_type"
    )
  )
})

test_that("tt_download_file works when delim isn't explicitly provided", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  expect_message(expect_message({tt <- tt_load_gh("2022-05-10")}))
  test_result <- tt_download_file(tt, "nyt_titles.tsv")
  expect_s3_class(test_result, c("tbl_df", "data.frame"))
  expect_setequal(
    colnames(test_result),
    c(
      "id", "title", "author", "year", "total_weeks", "first_week",
      "debut_rank", "best_rank"
    )
  )
})

test_that("tt_download_file downloads and parses xlsx", {
  local_tt_master_file()
  local_tt_week_readme_html()
  local_tt_download_file_raw()
  expect_message(expect_message(expect_warning(
    {tt <- tt_load_gh("2018-04-02")}
  )))
  test_result <- tt_download_file(tt, 1)
  expect_s3_class(test_result, c("tbl_df", "data.frame"))
  expect_setequal(
    colnames(test_result),
    c(
      "State", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
      "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16"
    )
  )
})

# test_that("tt_download_file downloads and parses rds", {
#   local_tt_master_file()
#   local_tt_week_readme_html()
#   local_tt_download_file_raw()
#   expect_message(expect_message(expect_warning(
#     {tt <- tt_load_gh("2018-04-02")}
#   )))
#   test_result <- tt_download_file(tt, 1)
#   expect_s3_class(test_result, c("tbl_df", "data.frame"))
#   expect_setequal(
#     colnames(test_result),
#     c(
#       "State", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
#       "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16"
#     )
#   )
# })

# test_that("tt_download_file downloads and parses xls", {
#   local_tt_master_file()
#   local_tt_week_readme_html()
#   local_tt_download_file_raw()
#   expect_message(expect_message(expect_warning(
#     {tt <- tt_load_gh("2018-04-02")}
#   )))
#   test_result <- tt_download_file(tt, 1)
#   expect_s3_class(test_result, c("tbl_df", "data.frame"))
#   expect_setequal(
#     colnames(test_result),
#     c(
#       "State", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
#       "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16"
#     )
#   )
# })

# test_that("tt_download_file downloads and parses vgz", {
#   local_tt_master_file()
#   local_tt_week_readme_html()
#   local_tt_download_file_raw()
#   expect_message(expect_message(expect_warning(
#     {tt <- tt_load_gh("2018-04-02")}
#   )))
#   test_result <- tt_download_file(tt, 1)
#   expect_s3_class(test_result, c("tbl_df", "data.frame"))
#   expect_setequal(
#     colnames(test_result),
#     c(
#       "State", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
#       "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16"
#     )
#   )
# })

# test_that("tt_download_file downloads and parses zip", {
#   local_tt_master_file()
#   local_tt_week_readme_html()
#   local_tt_download_file_raw()
#   expect_message(expect_message(expect_warning(
#     {tt <- tt_load_gh("2018-04-02")}
#   )))
#   test_result <- tt_download_file(tt, 1)
#   expect_s3_class(test_result, c("tbl_df", "data.frame"))
#   expect_setequal(
#     colnames(test_result),
#     c(
#       "State", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
#       "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16"
#     )
#   )
# })

# Most of this function is tested via other tests right now.
test_that("tt_download messages for bad connectivity", {
  local_mocked_bindings(
    get_connectivity = function() FALSE,
    check_connectivity = function(rerun) NULL
  )
  expect_message(
    {expect_null(tt_download())},
    "Warning - No Internet Connectivity"
  )
})

test_that("tt_download returns NULL when no rate limit available", {
  local_mocked_bindings(
    get_connectivity = function() TRUE,
    rate_limit_check = function() 0
  )
  expect_null(tt_download())
})

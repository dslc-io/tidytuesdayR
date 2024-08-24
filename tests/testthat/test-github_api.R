test_that("gh_get_sha_in_folder gets sha for a file in a folder", {
  local_mocked_bindings(
    gh_get = function(path, auth) {
      return(readRDS(test_path("fixtures", "static_contents.rds")))
    }
  )
  expect_equal(
    {gh_get_sha_in_folder("static", "tt_data_type.csv")},
    "5b7d51181d18d1af90caedd4e008509722612efb"
  )
  expect_equal(
    {gh_get_sha_in_folder("static", "tt_logo.png")},
    "61ab36921f82e35c621c2c4086c38b177bc89ea1"
  )
})

test_that("gh_get_csv gets and parses csv", {
  local_mocked_bindings(
    gh_get = function(path, auth) {
      return(readRDS(test_path("fixtures", "tt_data_type_response.rds")))
    }
  )
  test_response <- gh_get_csv("static/tt_data_type.csv")
  expect_s3_class(test_response, "data.frame")
  expect_setequal(
    names(test_response),
    c("Week", "Date", "year", "data_files", "data_type", "delim")
  )
  expect_equal(nrow(test_response), 683)
})

test_that("gh_get_readme_html gets readme html", {
  local_mocked_bindings(
    gh_get = function(path, auth, ...) {
      if (path == "data/2020") {
        return(readRDS(test_path("fixtures", "folder2020_response.rds")))
      } else if (path == "data/2020/readme.md") {
        return(readRDS(test_path("fixtures", "readme2020_response.rds")))
      }
    }
  )
  test_result <- gh_get_readme_html("data/2020")
  expected_result <- xml2::read_html(
    readRDS(test_path("fixtures", "readme2020_response.rds"))$message
  )
  expect_equal(test_result, expected_result)
})

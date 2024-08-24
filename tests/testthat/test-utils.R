test_that("html_viewer returns NULL when running not in interactive mode", {
  res <- html_viewer("www.google.com", is_interactive = FALSE)
  expect_equal(res, NULL)
})

test_that("html_viewer works in interactive mode", {
  local_mocked_bindings(
    rstudio_is_available = function() {
      return(TRUE)
    },
    rstudio_viewer = function(url) {
      return("viewer")
    },
    browse_url = function(url) {
      return("browse_url")
    }
  )
  expect_equal(
    html_viewer("www.google.com", is_interactive = TRUE),
    "viewer"
  )

  local_mocked_bindings(
    rstudio_is_available = function() {
      return(FALSE)
    }
  )
  expect_equal(
    html_viewer("www.google.com", is_interactive = TRUE),
    "browse_url"
  )
})


test_that("readme() will attempt to display the contents of the readme attribute", {
  tt_data <- structure(
    list(
      value1 = "value1",
      value2 = "value2"
    ),
    .tt = structure(
      c("value1.csv", "value2.csv"),
      .files = c("value1.csv", "value2.csv"),
      .readme = xml2::read_html("<body><p>hello world</p></body>"),
      class = "tt_gh"
    ),
    class = "tt_data"
  )

  existing_files <- list.files(tempdir())
  readme(tt_data)
  readme_html <- setdiff(list.files(tempdir()), existing_files)

  expect_equal(
    xml2::read_html(file.path(tempdir(), readme_html)),
    attr(attr(tt_data, ".tt"), ".readme")
  )
})


test_that("contiguous_weeks() will attempt to display the contiguous weeks, collapsing continuous weeks", {
  expect_equal(contiguous_weeks(1), "1")

  expect_equal(contiguous_weeks(c(1, 2)), "1-2")

  expect_equal(contiguous_weeks(c(1:5)), "1-5")

  expect_equal(contiguous_weeks(c(1:5, 7)), "1-5, 7")

  expect_equal(contiguous_weeks(c(1:5, 7, 8)), "1-5, 7-8")

  expect_equal(contiguous_weeks(c(1:5, 7, 9)), "1-5, 7, 9")

  expect_equal(contiguous_weeks(c(1:5, 7, 9:11)), "1-5, 7, 9-11")

  expect_equal(contiguous_weeks(c(1:5, 7, 9:11, 15)), "1-5, 7, 9-11, 15")

  expect_equal(contiguous_weeks(c(5, 7, 9:11, 15)), "5, 7, 9-11, 15")

  expect_equal(contiguous_weeks(c(5, 7, 9:11, 15:100)), "5, 7, 9-11, 15-100")
})

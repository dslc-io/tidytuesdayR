test_that("tt_datasets throws errors when asking for invalid years", {
  local_tt_mocked_bindings(
    tt_years = function(...) {
      2018:2024
    }
  )
  expect_error(
    {tt_datasets(2017)},
    class = "tt-error-invalid_year"
  )
})

test_that("printing tt_datasets returns all the values as a printed data.frame if not interactive", {
  ds <- structure(
    data.frame(a = 1:2, b = 3:4),
    .html = "the_html",
    class = "tt_dataset_table"
  )
  expect_snapshot({
    print(ds, is_interactive = FALSE)
  })
})

test_that("tt_available returns object with all years data available", {
  local_tt_mocked_bindings(
    tt_years = function(...) {
      2019:2020
    },
    gh_get_readme_html = function(...) {
      xml2::read_html(test_path("fixtures", "readme2020.html"))
    }
  )
  ds <- tt_available()
  expect_s3_class(ds, "tt_dataset_table_list")
  expect_setequal(names(ds), as.character(tt_years()))

  ds_content <- as.list(unclass(ds))
  ds_content_data <-
    lapply(ds_content, function(x) {
      data.frame(unclass(x), stringsAsFactors = FALSE)
    })
  ds_content_html <-
    lapply(ds_content, function(x) {
      rvest::html_table(attr(x, ".html"))[[1]]
    })
  expect_equal(
    ds_content_html,
    ds_content_data,
    ignore_attr = TRUE
  )
})

test_that("printing tt_available returns all the values as a printed data.frame if not interactive", {
  ds <- structure(
    list(test_year = data.frame(a = 1:2, b = 3:4)),
    class = c("tt_dataset_table_list")
  )
  expect_snapshot({
    print(ds, is_interactive = FALSE)
  })
}
)

test_that("tt_dataset_table and tt_dataset_table_list objects can make html outputs", {
  local_tt_mocked_bindings(
    tt_years = function(...) {
      2019:2020
    },
    gh_get_readme_html = function(...) {
      xml2::read_html(test_path("fixtures", "readme2020.html"))
    }
  )
  ds_tl <- tt_available()
  ds_t <- tt_datasets(2019)

  tmpfile <- withr::local_tempfile(fileext = ".html")
  ds_tl_html <- make_tt_dataset_list_html(ds_tl, file = tmpfile)

  tmpfile2 <- withr::local_tempfile(fileext = ".html")
  ds_t_html <- make_tt_dataset_html(ds_t, file = tmpfile2)

  expect_true(file.exists(tmpfile))
  expect_true(file.exists(tmpfile2))
  expect_equal(
    xml2::read_html(tmpfile),
    ds_tl_html
  )
  expect_equal(
    xml2::read_html(tmpfile2),
    ds_t_html
  )
})

test_that("save_tt_object saves an html file", {
  expect_true(
    grepl("html$", {save_tt_object("", function(x, file) x)})
  )
})

test_that("tt_dataset_table and tt_dataset_table_list objects print through html_viewer when interactive", {
  local_mocked_bindings(
    html_viewer = function(url) {
      message(url)
    },
    save_tt_object = function(x, fn) {
      "tmpfile_path"
    }
  )
  ds <- structure("", class = "tt_dataset_table")
  expect_message(
    {print(ds, is_interactive = TRUE)},
    "tmpfile_path"
  )
  ds <- structure("", class = "tt_dataset_table_list")
  expect_message(
    {print(ds, is_interactive = TRUE)},
    "tmpfile_path"
  )
})

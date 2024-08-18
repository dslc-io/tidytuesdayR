context("parsing blob/text")

test_that("`tt_parse_text` can parse text", {
  result_comma <-
    tt_parse_text(
      "col1,col2\nval1,val2\nval3,val4",
      func = readr::read_delim,
      delim = ","
    )

  result_tab <-
    tt_parse_text(
      "col1\tcol2\nval1\tval2\nval3\tval4",
      func = readr::read_delim,
      delim = "\t"
    )

  result_special <-
    tt_parse_text(
      "col1|col2\nval1|val2\nval3|val4",
      func = readr::read_delim,
      delim = "|"
    )

  expected <- tibble::tribble(
    ~col1, ~col2,
    "val1", "val2",
    "val3", "val4"
  )


  expect_equivalent(result_comma, expected)
  expect_equivalent(result_tab, expected)
  expect_equivalent(result_special, expected)
})


test_that("`tt_parse_binary` can parse raw inputs", {
  input_raw <- serialize("RAW VALUE", connection = NULL)

  result_rds <-
    tt_parse_binary(
      input_raw,
      func = readRDS,
      filename = "test_rds.rds"
    )

  expect_equal(result_rds, "RAW VALUE")
})


test_that("`tt_parse_blob` can figure out how to handle text or raw", {
  input_raw <- serialize("RAW VALUE", connection = NULL)

  expected_text <- tibble::tribble(
    ~col1, ~col2,
    "val1", "val2",
    "val3", "val4"
  )

  result_text_comma <-
    tt_parse_blob(
      blob = "col1,col2\nval1,val2\nval3,val4",
      file_info = data.frame(
        data_files = "text.txt",
        data_type = "txt",
        delim = ",",
        stringsAsFactors = FALSE
      )
    )

  result_text_tab <-
    tt_parse_blob(
      "col1\tcol2\nval1\tval2\nval3\tval4",
      file_info = data.frame(
        data_files = "text.txt",
        data_type = "txt",
        delim = "\t",
        stringsAsFactors = FALSE
      )
    )

  result_text_special <-
    tt_parse_blob(
      "col1|col2\nval1|val2\nval3|val4",
      file_info = data.frame(
        data_files = "text.txt",
        data_type = "txt",
        delim = "|", stringsAsFactors = FALSE
      )
    )

  result_raw_rda <-
    tt_parse_blob(
      input_raw,
      file_info = data.frame(
        data_files = "test_rds.rds",
        data_type = "rds",
        delim = ""
      )
    )

  result_text_guess <-
    tt_parse_blob(
      blob = "col1,col2\nval1,val2\nval3,val4",
      file_info = data.frame(
        data_files = "text.csv",
        data_type = "csv",
        delim = NA,
        stringsAsFactors = FALSE
      )
    )

  expect_equivalent(result_text_comma, expected_text)
  expect_equivalent(result_text_tab, expected_text)
  expect_equivalent(result_text_special, expected_text)
  expect_equivalent(result_raw_rda, "RAW VALUE")
  expect_equivalent(result_text_guess, expected_text)
})

tt_ref_test_that("tt_parse_blob can handle a xls file", {
  check_api()
  xls_blob <- github_blob("data/2019/2019-11-26/PCA_Report_FY17Q3.xls",
    sha = "e2313e902423c398883c01d3ecdfe77ae1b84862",
    as_raw = TRUE
  )

  xls_object <- try(tt_parse_blob(
    xls_blob,
    file_info = data.frame(
      data_files = "PCA_Report_FY17Q3.xls",
      data_type = "xls",
      stringsAsFactors = FALSE
    ),
    skip = 4
  ), silent = TRUE)

  expect_true(!inherits(xls_object, "try-error"))
  expect_equal(
    xls_object[1:4, 1:3],
    tibble::tribble(
      ~`Agency Name`, ~`At Start of Quarter`, ~`Added`,
      NA, NA, NA,
      "Account Control Technology, Inc.", 10659143750, 0,
      "Coast Professional, Inc.", 7251296633, 0,
      "ConServe", 10025995146, 0
    )
  )
})

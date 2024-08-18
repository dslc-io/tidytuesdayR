tt_ref_encoding(
  encoding = "Korean",
  "Korean: Non-English encodings don't fail reading unicode from github",
  {
    check_api()
    tt_data <- try(tt_datasets("2019"), silent = TRUE)
    res <- nrow(data.frame(unclass(tt_data)))
    expect_true(!inherits(tt_data, "try-error"))
    expect_equal(res, 52)
  }
)

tt_ref_encoding(
  encoding = "Japanese",
  "Japanese: Non-English encodings don't fail reading unicode from github",
  {
    check_api()
    tt_data <- try(tt_datasets("2019"), silent = TRUE)
    res <- nrow(data.frame(unclass(tt_data)))
    expect_true(!inherits(tt_data, "try-error"))
    expect_equal(res, 52)
  }
)

tt_ref_encoding(
  encoding = "Russian",
  "Russian: Non-English encodings don't fail reading unicode from github",
  {
    check_api()
    tt_data <- try(tt_datasets("2019"), silent = TRUE)
    res <- nrow(data.frame(unclass(tt_data)))
    expect_true(!inherits(tt_data, "try-error"))
    expect_equal(res, 52)
  }
)

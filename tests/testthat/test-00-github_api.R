context("Github API")

tt_ref_test_that(
  "github_contents returns contents as text", {
  check_api()

  license_text <- github_contents("LICENSE")

  expect_is(license_text, "character")
  expect_equivalent(
    substr(license_text, 0, 76),
    paste("MIT License\n\nCopyright (c)",
          "2018 R for Data Science online learning community"))
})

tt_ref_test_that(
  paste("github_contents flips to github_blob and",
        "returns contents as text by default when larger than 1MB"), {
  check_api()

  tweets_text <- github_contents("static/tidytuesday_tweets.csv")

  expect_is(tweets_text, "character")
  expect_true(object.size(tweets_text) > 1000000)
  expect_equivalent(
    substr(tweets_text, 0, 84),
    paste0("\"user_id\",\"status_id\",\"created_at\",\"screen_name\",",
           "\"text\",\"pic1\",\"pic2\",\"pic3\",\"pic4\"\n"))
})

tt_ref_test_that(
  "github_contents throw informative error on failure", {
  check_api()
  expect_error(
    github_contents("static/BAD_ENTRY"),
    "Response Code 404: Not Found",
  )
})


tt_ref_test_that(
  "github_html returns contents that can be html as html", {
  check_api()
  README <- github_html("README.md")

  expect_s3_class(README,"xml_document")
  expect_error(
    github_html("bad_file"),
    "Response Code 404: Not Found",
  )
})

tt_ref_test_that(
  "github_sha get a data.frame with the sha for all files in the directory",{
  check_api()
  SHA <- github_sha("static")

  expect_is(SHA, "data.frame")
  expect_equal(colnames(SHA), c("path","sha"))
})

tt_ref_test_that(
  "github_sha returns error when bad entry",{
  check_api()
  expect_error(
    github_sha("bad_file_path"),
    "Response Code 404: Not Found",
  )
})

tt_ref_test_that(
  "github_blob gets contents as either text or raw",{
  check_api()
  license_text <- github_blob("LICENSE")
  license_raw  <- github_blob("LICENSE", as_raw = TRUE)

  expect_is(license_text, "character")
  expect_equivalent(
    substr(license_text, 0, 76),
    paste("MIT License\n\nCopyright (c)",
          "2018 R for Data Science online learning community"))

  expect_is(license_raw, "raw")
  expect_equivalent(
    license_raw[1:76],
    charToRaw(paste("MIT License\n\nCopyright (c)",
                    "2018 R for Data Science online learning community")))

})

tt_ref_test_that(
  "github_blob retuns error on bad entry",{
  check_api()
  expect_error(
    github_blob("BAD_ENTRY", sha = "BAD_SHA"),
    "Response Code 422: The sha parameter must be exactly 40 characters",
  )

})

tt_ref_test_that(
  "rate_limit_check returns actual value in environment",{
  val <- rate_limit_check(quiet = TRUE)
  expect_equal(val,TT_GITHUB_ENV$RATE_REMAINING)
})

tt_ref_test_that("rate_limit_check throws warning when within n of 0",{
  rate_limit_update(list(limit = 50, remaining = 5, reset = 1000))
  on.exit({rate_limit_update()})
  expect_message(rate_limit_check(n = 10, quiet = FALSE))
})

tt_ref_test_that(
  "rate_limit_check throws error when 0, except when silent = TRUE",{

  options("tidytuesdayR.tt_testing" = TRUE)
  rate_limit_update(list(limit = 50, remaining = 0, reset = 1000))
  on.exit({
    rate_limit_update()
    options("tidytuesdayR.tt_testing" = FALSE)
  })
  expect_error(rate_limit_check(silent = FALSE))
  message <- capture_messages({output <- rate_limit_check(n = 10)})
  expect_equal(
    output,
    0
    )
  expect_true(grepl(x =
    message,
    pattern = paste("Github API Rate Limit hit.",
          "You must wait until")
  ))
})

tt_no_internet_test_that("When there is no internet, error -1 is returned",{

  expect_error(
    github_contents("static/BAD_ENTRY"),
    "Response Code -1: No Internet Connection",
  )
  expect_error(
    github_html("static/BAD_ENTRY"),
    "Response Code -1: No Internet Connection",
  )
  expect_error(
    github_sha("static/BAD_ENTRY"),
    "Response Code -1: No Internet Connection",
  )
  expect_error(
    github_blob("bad_path"),
    "Response Code -1: No Internet Connection"
  )

})

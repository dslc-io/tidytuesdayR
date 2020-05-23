context("Github API")

tt_ref_test_that("github_contents returns contents as text", {
  license_text <- github_contents("LICENSE")

  expect_is(license_text, "character")
  expect_equivalent(
    substr(license_text, 0, 76),
    "MIT License\n\nCopyright (c) 2018 R for Data Science online learning community")
})

tt_ref_test_that("github_contents flips to github_blob and returns contents as text by default when larger than 1MB", {

  tweets_text <- github_contents("static/tidytuesday_tweets.csv")

  expect_is(tweets_text, "character")
  expect_true(object.size(tweets_text) > 1000000)
  expect_equivalent(
    substr(tweets_text, 0, 84),
    "\"user_id\",\"status_id\",\"created_at\",\"screen_name\",\"text\",\"pic1\",\"pic2\",\"pic3\",\"pic4\"\n")
})

tt_ref_test_that("github_contents returns NULL on failure", {
  NULL_contents <- github_contents("static/BAD_ENTRY")
  expect_equal(NULL_contents, NULL)
})


tt_ref_test_that("github_html returns contents that can be html as html", {
  README <- github_html("README.md")
  BADFILE <- github_html("bad_file")

  expect_s3_class(README,"xml_document")
  expect_equal(BADFILE, NULL)
})

tt_ref_test_that("github_sha get a data.frame with the sha for all files in the directory",{
  SHA <- github_sha("static")

  expect_is(SHA, "data.frame")
  expect_equal(colnames(SHA), c("path","sha"))
})

tt_ref_test_that("github_sha returns NULL when bad entry",{
  NULL_SHA <- github_sha("bad_file_path")
  expect_equal(NULL_SHA, NULL)
})

tt_ref_test_that("github_blob gets contents as either text or raw",{
  license_text <- github_blob("LICENSE")
  license_raw  <- github_blob("LICENSE", as_raw = TRUE)

  expect_is(license_text, "character")
  expect_equivalent(
    substr(license_text, 0, 76),
    "MIT License\n\nCopyright (c) 2018 R for Data Science online learning community")

  expect_is(license_raw, "raw")
  expect_equivalent(
    license_raw[1:76],
    charToRaw("MIT License\n\nCopyright (c) 2018 R for Data Science online learning community"))

})

tt_ref_test_that("github_blob retuns NULL on bad entry",{
  NULL_blob <- github_blob("BAD_ENTRY", sha = "BAD_SHA")
  expect_equal(NULL_blob, NULL)
})

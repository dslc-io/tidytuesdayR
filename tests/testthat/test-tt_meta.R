test_that("tt_meta creates the expected file", {
  proj_dir <- withr::local_tempdir()
  full_submission_path <- fs::path(proj_dir, "tt_submission")
  usethis::local_project(proj_dir, force = TRUE, quiet = TRUE)
  test_result <- tt_meta(
    title = "The 50 US States",
    article_title = "U.S. Department of Commerce, Bureau of the Census",
    article_url = "https://www.census.gov/",
    source_title = "The R datasets package",
    source_url = "https://www.r-project.org/",
    image_filename = "states_population.png",
    image_alt = "A map of the continental United States, with each state colored in shades of blue by population as of 1975. California and New York are the lightest, indicating the highest population. Maine, New Hampshire, Vermont, and the Plains States are all quite dark, indicating low population.",
    attribution = "Jon Harmon, Data Science Learning Community",
    github = "jonthegeek",
    bluesky = "jonthegeek.com",
    linkedin = "jonthegeek",
    mastodon = "fosstodon.org/@jonthegeek"
  )
  expect_true(test_result)
  file_path <- fs::path(full_submission_path, "meta.yaml")
  expect_snapshot_file(file_path)
})

test_that("ensure_arg_filled errors informatively", {
  expect_snapshot(
    {
      ensure_arg_filled("", question = "", arg_name = "myArg")
    },
    error = TRUE
  )
})

test_that("format_image_data errors informatively", {
  expect_snapshot(
    {
      format_image_data(c("a", "b"), "c")
    },
    error = TRUE
  )
})

test_that("format_social_name returns NULL for NULL", {
  expect_null(format_social_name(NULL))
})

test_that("format_mastodon returns NULL for NULL", {
  expect_null(format_mastodon(NULL))
})

test_that("format_mastodon extracts mastodon info from non-URLs", {
  expect_identical(
    format_mastodon("jonthegeek@fosstodon.org"),
    glue::glue("@jonthegeek@fosstodon.org")
  )
})

test_that("ensure_arg_filled errors informatively for NULL (#142)", {
  expect_snapshot(
    {
      ensure_arg_filled(NULL, question = "", arg_name = "myArg")
    },
    error = TRUE
  )
})

test_that("tt_meta uses options for attribution fields (#142)", {
  proj_dir <- withr::local_tempdir()
  full_submission_path <- fs::path(proj_dir, "tt_submission")
  usethis::local_project(proj_dir, force = TRUE, quiet = TRUE)
  withr::local_options(
    tidytuesdayR.attribution = "Jon Harmon, Data Science Learning Community",
    tidytuesdayR.bluesky = "jonthegeek.com",
    tidytuesdayR.linkedin = "jonthegeek",
    tidytuesdayR.mastodon = "fosstodon.org/@jonthegeek"
  )
  test_result <- tt_meta(
    title = "The 50 US States",
    article_title = "U.S. Department of Commerce, Bureau of the Census",
    article_url = "https://www.census.gov/",
    source_title = "The R datasets package",
    source_url = "https://www.r-project.org/",
    image_filename = "states_population.png",
    image_alt = "A map of the continental United States, with each state colored in shades of blue by population as of 1975. California and New York are the lightest, indicating the highest population. Maine, New Hampshire, Vermont, and the Plains States are all quite dark, indicating low population.",
    github = "jonthegeek"
  )
  expect_true(test_result)
  file_path <- fs::path(full_submission_path, "meta.yaml")
  expect_snapshot_file(file_path, name = "meta-from-options.yaml")
})


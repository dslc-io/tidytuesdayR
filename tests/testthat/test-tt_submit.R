test_that("tt_find_dataset_files finds expected files", {
  expect_identical(
    tt_find_dataset_files(test_path("fixtures", "tt_submission")),
    c(
      test_path("fixtures", "tt_submission", "cleaning.R"),
      test_path("fixtures", "tt_submission", "intro.md"),
      test_path("fixtures", "tt_submission", "meta.yaml"),
      test_path("fixtures", "tt_submission", "states.csv"),
      test_path("fixtures", "tt_submission", "states.md"),
      test_path("fixtures", "tt_submission", "states_population.png")
    )
  )
})

test_that("tt_find_dataset_files errors informatively for extra files", {
  expect_snapshot(
    {
      tt_find_dataset_files(test_path("fixtures", "tt_submission_extra"))
    },
    error = TRUE
  )
})

test_that("tt_find_dataset_files errors informatively for missing files", {
  expect_snapshot(
    {
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing"))
    },
    error = TRUE
  )
})

test_that("tt_find_dataset_files errors informatively for missing images", {
  expect_snapshot(
    {
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing_image1"))
    },
    error = TRUE
  )
  expect_snapshot(
    {
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing_image2"))
    },
    error = TRUE
  )
})

test_that("tt_find_dataset_files errors informatively for missing dictionary", {
  expect_snapshot(
    {
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing_md"))
    },
    error = TRUE
  )
})

test_that("tt_submit informs about the PR url", {
  local_mocked_bindings(
    tt_user = function(auth) {
      return("testuser")
    },
    tt_fork = function(...) {
      return("fork_path")
    },
    tt_branch_create = function(...) {
      return("branch_response")
    },
    tt_branch_populate = function(...) {
      return("populate_response")
    },
    today = function() {
      return("2025-01-01")
    }
  )
  expect_message(
    {
      test_result <- expect_invisible({
        tt_submit(
          test_path("fixtures", "tt_submission"),
          auth = "noauth",
          open = FALSE
        )
      })
    },
    "Create PR at"
  )
  expect_identical(
    test_result,
    glue::glue(
      "https://github.com/rfordatascience/tidytuesday/compare/main...testuser:submission-2025-01-01"
    )
  )
})

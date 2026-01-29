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

test_that("tt_find_branch deals with branch names", {
  path <- withr::local_tempdir()
  branch <- tt_find_branch(path)
  expect_match(
    branch,
    "submission-\\d{4}-\\d{2}-\\d{2}",
    all = TRUE
  )
  branch_file_path <- fs::path(path, "branch.txt")
  expect_true(fs::file_exists(branch_file_path))
  branch2 <- tt_find_branch(path)
  expect_identical(branch2, branch)
})

test_that("tt_user extracts login from GitHub response", {
  local_mocked_call_gh(function(endpoint, ..., auth) {
    expect_equal(endpoint, "GET /user")
    expect_equal(auth, "test_token")
    return(list(login = "testuser", id = 12345))
  })
  
  result <- tt_user(auth = "test_token")
  expect_equal(result, "testuser")
})

test_that("tt_fork returns fork info from GitHub", {
  local_mocked_call_gh(function(endpoint, repo, auth, ...) {
    expect_equal(endpoint, "POST /repos/{repo}/forks")
    expect_equal(repo, "rfordatascience/tidytuesday")
    expect_equal(auth, "test_token")
    return(list(
      full_name = "testuser/tidytuesday",
      default_branch = "main",
      owner = list(login = "testuser")
    ))
  })
  
  result <- tt_fork(
    user = "testuser",
    repo = "rfordatascience/tidytuesday",
    auth = "test_token"
  )
  expect_equal(result$full_name, "testuser/tidytuesday")
  expect_equal(result$default_branch, "main")
})

test_that("tt_branch_create creates new branch from default branch", {
  local_mocked_call_gh(function(endpoint, fork_repo, default_branch, auth, ref, sha, ...) {
    if (endpoint == "GET /repos/{fork_repo}/git/refs/heads/{default_branch}") {
      expect_equal(fork_repo, "testuser/tidytuesday")
      expect_equal(default_branch, "main")
      return(list(object = list(sha = "abc123")))
    }
    if (endpoint == "GET /repos/{fork_repo}/git/refs/heads") {
      expect_equal(fork_repo, "testuser/tidytuesday")
      return(list()) # No existing branches
    }
    if (endpoint == "POST /repos/{fork_repo}/git/refs") {
      expect_equal(fork_repo, "testuser/tidytuesday")
      expect_equal(ref, "refs/heads/test-branch")
      expect_equal(sha, "abc123")
      return(list(ref = "refs/heads/test-branch"))
    }
  })
  
  fork_info <- list(full_name = "testuser/tidytuesday", default_branch = "main")
  result <- tt_branch_create(fork_info, "test-branch", auth = "test_token")
  expect_equal(result, "refs/heads/test-branch")
})

test_that("tt_branch_create skips if branch already exists", {
  local_mocked_call_gh(function(endpoint, fork_repo, default_branch, auth, ...) {
    if (endpoint == "GET /repos/{fork_repo}/git/refs/heads/{default_branch}") {
      return(list(object = list(sha = "abc123")))
    }
    if (endpoint == "GET /repos/{fork_repo}/git/refs/heads") {
      return(list(
        list(ref = "refs/heads/main"),
        list(ref = "refs/heads/test-branch") # Branch already exists
      ))
    }
    # Should not call POST if branch exists
    stop("Should not create branch if it already exists")
  })
  
  fork_info <- list(full_name = "testuser/tidytuesday", default_branch = "main")
  result <- tt_branch_create(fork_info, "test-branch", auth = "test_token")
  expect_equal(result, "refs/heads/test-branch")
})

test_that("tt_branch_content returns file info from GitHub", {
  local_mocked_call_gh(function(endpoint, fork_repo, ref, auth, ...) {
    expect_equal(endpoint, "GET /repos/{fork_repo}/contents/data/curated/new_submission")
    expect_equal(fork_repo, "testuser/tidytuesday")
    expect_equal(ref, "refs/heads/test-branch")
    return(list(
      list(name = "data.csv", sha = "sha123"),
      list(name = "meta.yaml", sha = "sha456")
    ))
  })
  
  result <- tt_branch_content("testuser/tidytuesday", "test-branch", auth = "test_token")
  expect_equal(names(result), c("data.csv", "meta.yaml"))
  expect_equal(result[["data.csv"]], "sha123")
  expect_equal(result[["meta.yaml"]], "sha456")
})

test_that("tt_branch_content returns empty list if folder doesn't exist", {
  local_mocked_call_gh(function(endpoint, fork_repo, ref, auth, ...) {
    stop("404 error")
  })
  
  result <- tt_branch_content("testuser/tidytuesday", "test-branch", auth = "test_token")
  expect_equal(result, structure(list(), names = character(0)))
})

test_that("git_blob_sha1 calculates git blob SHA correctly", {
  # Create a temporary test file
  temp_file <- withr::local_tempfile()
  writeLines("test content", temp_file)
  
  result <- git_blob_sha1(temp_file)
  
  # Should return a 40-character hex string (SHA-1 hash)
  expect_type(result, "character")
  expect_match(result, "^[a-f0-9]{40}$")
  
  # Same file should produce same hash
  result2 <- git_blob_sha1(temp_file)
  expect_equal(result, result2)
})

test_that("tt_branch_populate adds new file when it doesn't exist", {
  temp_file <- withr::local_tempfile()
  writeLines("test content", temp_file)
  
  local_mocked_bindings(
    tt_branch_content = function(...) {
      return(structure(list(), names = character(0))) # No existing files
    }
  )
  local_mocked_call_gh(function(endpoint, fork_repo, filename, message, content, branch, sha, auth, ...) {
    expect_equal(endpoint, "PUT /repos/{fork_repo}/contents/data/curated/new_submission/{filename}")
    expect_equal(fork_repo, "testuser/tidytuesday")
    expect_match(message, "^Add ")
    expect_null(sha)
    return(list(content = list(name = filename)))
  })
  
  expect_no_error(
    tt_branch_populate(
      fork_repo = "testuser/tidytuesday",
      branch = "test-branch",
      files = temp_file,
      auth = "test_token"
    )
  )
})

test_that("tt_branch_populate updates existing file when SHA differs", {
  temp_file <- withr::local_tempfile()
  writeLines("new content", temp_file)
  
  local_mocked_bindings(
    tt_branch_content = function(...) {
      return(structure(
        list("different_sha"),
        names = basename(temp_file)
      ))
    }
  )
  local_mocked_call_gh(function(endpoint, fork_repo, filename, message, content, branch, sha, auth, ...) {
    expect_equal(endpoint, "PUT /repos/{fork_repo}/contents/data/curated/new_submission/{filename}")
    expect_match(message, "^Update ")
    expect_equal(sha, "different_sha")
    return(list(content = list(name = filename)))
  })
  
  expect_no_error(
    tt_branch_populate(
      fork_repo = "testuser/tidytuesday",
      branch = "test-branch",
      files = temp_file,
      auth = "test_token"
    )
  )
})

test_that("tt_branch_populate skips file when SHA matches", {
  temp_file <- withr::local_tempfile()
  writeLines("test content", temp_file)
  
  # Get the actual SHA for this file
  file_sha <- git_blob_sha1(temp_file)
  
  local_mocked_bindings(
    tt_branch_content = function(...) {
      return(structure(
        list(file_sha),
        names = basename(temp_file)
      ))
    }
  )
  local_mocked_call_gh(function(...) {
    stop("Should not be called when SHA matches")
  })
  
  expect_no_error(
    tt_branch_populate(
      fork_repo = "testuser/tidytuesday",
      branch = "test-branch",
      files = temp_file,
      auth = "test_token"
    )
  )
})

test_that("tt_submit informs about the PR url", {
  local_mocked_bindings(
    gh_auth_check = function(...) {
      return("auth")
    },
    tt_user = function(auth) {
      return("testuser")
    },
    tt_fork = function(...) {
      return(list(full_name = "testuser/tidytuesday", default_branch = "main"))
    },
    tt_find_branch = function(...) {
      return("submission-2025-01-01")
    },
    tt_branch_create = function(...) {
      return("branch_response")
    },
    tt_branch_populate = function(...) {
      return("populate_response")
    }
  )
  local_mocked_call_gh(function(endpoint, ...) {
    # Mock the call to check for existing PRs
    if (grepl("/pulls", endpoint)) {
      return(list()) # No existing PRs
    }
    stop("Unexpected call_gh endpoint: ", endpoint)
  })
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

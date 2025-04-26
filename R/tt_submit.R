#' Submit a TidyTuesday dataset
#'
#' Submit a curated dataset for review by uploading it to GitHub and creating a
#' pull request. The dataset should be prepared using [tt_clean()],
#' [tt_save_dataset()], [tt_intro()], and [tt_meta()]. You can also use this
#' function to submit changes to your local copies of the files.
#'
#' @inheritParams shared-params
#' @param open Whether to open the pull request in a browser. Defaults to `TRUE`
#'   in an interactive session.
#'
#' @returns The URL of the pull request, invisibly.
#' @export
#'
#' @examplesIf interactive()
#' # First set up a dataset in the "tt_submission" folder.
#' tt_submit()
tt_submit <- function(path = "tt_submission",
                      auth = gh::gh_token(),
                      open = rlang::is_interactive()) {
  rlang::check_installed("base64enc", "to prepare files for a submission.")
  files <- tt_find_dataset_files(path)

  user <- tt_user(auth = auth)
  repo <- getOption("tidytuesdayR.tt_repo", "rfordatascience/tidytuesday")
  branch <- tt_find_branch(path)

  fork_repo <- tt_fork(user = user, repo = repo, auth = auth)
  tt_branch_create(fork_repo = fork_repo, branch = branch, auth = auth)
  tt_branch_populate(
    fork_repo = fork_repo,
    branch = branch,
    files = files,
    auth = auth
  )

  existing_prs <- gh::gh(
    "/repos/{repo}/pulls",
    head = glue::glue("{user}:{branch}"),
    repo = repo,
    state = "open"
  )

  if (length(existing_prs)) {
    # I tested this manually, leaving it at that for now.
    pr_url <- existing_prs[[1]]$html_url # nocov
    cli::cli_inform("View PR at {.url {pr_url}}") # nocov
  } else {
    pr_url <- glue::glue(
      "https://github.com/{repo}/compare/main...{user}:{branch}"
    )
    cli::cli_inform("Create PR at {.url {pr_url}}")
  }

  if (open) {
    utils::browseURL(pr_url) # nocov
  }
  return(invisible(pr_url))
}

tt_find_dataset_files <- function(path = "tt_submission") {
  files <- list.files(path, full.names = TRUE)
  files <- setdiff(files, fs::path(path, "branch.txt"))
  expected_files <- tt_find_expected_files(path)
  csv_files <- unname(fs::dir_ls(path, glob = "*.csv"))
  dictionary_files <- tt_find_dictionaries(csv_files)
  img_files <- tt_find_images(path)
  known_files <- c(expected_files, csv_files, dictionary_files, img_files)
  extra_files <- setdiff(files, known_files)
  if (rlang::is_empty(extra_files)) {
    return(known_files)
  }
  cli::cli_abort(c(
    "{.arg path} should only contain submission files.",
    x = "Extra files: {extra_files}"
  ))
}

tt_find_expected_files <- function(path = "tt_submission") {
  expected_files <- fs::path(
    path,
    c("cleaning.R", "intro.md", "meta.yaml")
  )
  missing_files <- expected_files[!fs::file_exists(expected_files)]
  if (rlang::is_empty(missing_files)) {
    return(expected_files)
  }
  cli::cli_abort(c(
    "All expected files must exist in {.arg path}.",
    x = "Missing files: {missing_files}"
  ))
}

tt_find_images <- function(path = "tt_submission") {
  rlang::check_installed("yaml", "to verify image files.")
  yaml_path <- fs::path(path, "meta.yaml")
  if (fs::file_exists(yaml_path)) {
    meta <- yaml::read_yaml(yaml_path)
    if (length(meta$images)) {
      expected_images <- fs::path(path, purrr::map_chr(meta$images, "file"))
      missing_files <- expected_images[!fs::file_exists(expected_images)]
      if (rlang::is_empty(missing_files)) {
        return(expected_images)
      }
      cli::cli_abort(c(
        "All images in meta.yaml must exist in {.arg path}.",
        x = "Missing images: {missing_files}"
      ))
    }
  }
  cli::cli_abort("No images found in meta.yaml")
}

tt_find_dictionaries <- function(csv_files) {
  expected_md_files <- fs::path_ext_set(csv_files, "md")
  missing_files <- expected_md_files[!fs::file_exists(expected_md_files)]
  if (rlang::is_empty(missing_files)) {
    return(expected_md_files)
  }
  cli::cli_abort(c(
    "All datasets must have an associated md file in {.arg path}.",
    x = "Missing dictionaries: {missing_files}"
  ))
}

tt_find_branch <- function(path = "tt_submission") {
  branch_tag_path <- fs::path(path, "branch.txt")
  if (fs::file_exists(branch_tag_path)) {
    return(stringr::str_trim(readLines(branch_tag_path)))
  }
  branch <- unclass(
    glue::glue("submission-{today()}-{round(runif(1)*100000)}")
  )
  writeLines(branch, branch_tag_path)
  return(branch)
}

# Skipping coverage of the gh stuff for now.
# nocov start
tt_user <- function(auth = gh::gh_token()) {
  gh::gh("GET /user", .token = auth)$login
}

tt_fork <- function(user, repo, auth = gh::gh_token()) {
  # Check if the fork exists and is linked to the original repo
  forks <- gh::gh("GET /repos/{repo}/forks", repo = repo, .token = auth)
  my_fork <- purrr::keep(forks, ~ .x$owner$login == user)
  if (length(my_fork)) {
    my_fork <- my_fork[[1]]
  } else {
    my_fork <- gh::gh("POST /repos/{repo}/forks", repo = repo, .token = auth)
  }
  return(my_fork$full_name)
}

tt_branch_create <- function(fork_repo, branch, auth = gh::gh_token()) {
  main_sha <- gh::gh(
    "GET /repos/{fork_repo}/git/refs/heads/main",
    fork_repo = fork_repo,
    .token = auth
  )$object$sha
  target_ref <- glue::glue("refs/heads/{branch}")
  existing <- gh::gh(
    "GET /repos/{fork_repo}/git/refs/heads",
    fork_repo = fork_repo,
    .token = auth
  )
  if (!target_ref %in% purrr::map_chr(existing, "ref")) {
    gh::gh(
      "POST /repos/{fork_repo}/git/refs",
      fork_repo = fork_repo,
      ref = glue::glue("refs/heads/{branch}"),
      sha = main_sha,
      .token = auth
    )
  }
  return(invisible(target_ref))
}

tt_branch_populate <- function(fork_repo,
                               branch,
                               files,
                               auth = gh::gh_token()) {
  existing_content <- tt_branch_content(fork_repo, branch, auth)
  purrr::walk(files, function(file) {
    content <- base64enc::base64encode(file)
    filename <- basename(file)
    sha <- existing_content[[filename]]
    if (!identical(sha, git_blob_sha1(file))) {
      action <- ifelse(is.null(sha), "Add", "Update")
      gh::gh(
        "PUT /repos/{fork_repo}/contents/data/curated/new_submission/{filename}",
        fork_repo = fork_repo,
        filename = filename,
        message = glue::glue("{action} {filename}"),
        content = content,
        branch = branch,
        sha = sha,
        .token = auth
      )
    }
  })
}

tt_branch_content <- function(fork_repo, branch, auth = gh::gh_token()) {
  # If the branch has a "new_submission" folder, return the contents of that
  # folder.
  new_submission <- tryCatch(
    gh::gh(
      "GET /repos/{fork_repo}/contents/data/curated/new_submission",
      fork_repo = fork_repo,
      ref = glue::glue("refs/heads/{branch}"),
      .token = auth
    ),
    error = function(e) {
      NULL
    }
  )
  existing_file_names <- purrr::map_chr(new_submission, "name")
  existing_file_shas <- purrr::map(new_submission, "sha")
  return(rlang::set_names(existing_file_shas, existing_file_names))
}

git_blob_sha1 <- function(file) {
  rlang::check_installed("openssl", "to check for file changes.")
  size <- file.info(file)$size
  contents <- readBin(file, "raw", size)
  unclass(
    as.character(
      openssl::sha1(
        c(
          charToRaw(sprintf("blob %d", size)),
          as.raw(0),
          contents
        )
      )
    )
  )
}


# nocov end

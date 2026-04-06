#' Submit a TidyTuesday dataset
#'
#' Submit a curated dataset for review by uploading it to GitHub and creating a
#' pull request. The dataset should be prepared using [tt_clean()],
#' [tt_save_dataset()], [tt_intro()], and [tt_meta()]. You can also use this
#' function to submit changes to your local copies of the files.
#'
#' @inheritParams .shared-params
#' @param open Whether to open the pull request in a browser. Defaults to `TRUE`
#'   in an interactive session.
#'
#' @returns The URL of the pull request, invisibly.
#' @export
#'
#' @examplesIf interactive()
#' # First set up a dataset in the "tt_submission" folder.
#' tt_submit()
tt_submit <- function(
  path = "tt_submission",
  auth = gh::gh_token(),
  open = rlang::is_interactive()
) {
  rlang::check_installed("base64enc", "to prepare files for a submission.")

  files <- tt_find_dataset_files(path)

  auth <- gh_auth_check(auth)
  user <- tt_user(auth = auth)
  repo <- getOption("tidytuesdayR.tt_repo", "rfordatascience/tidytuesday")
  branch <- tt_find_branch(path)

  fork_info <- tt_fork(user = user, repo = repo, auth = auth)
  tt_branch_create(fork_info = fork_info, branch = branch, auth = auth)
  tt_branch_populate(
    fork_repo = fork_info$full_name,
    branch = branch,
    files = files,
    auth = auth
  )

  existing_prs <- call_gh(
    "/repos/{repo}/pulls",
    head = glue::glue("{user}:{branch}"),
    repo = repo,
    state = "open",
    auth = auth
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
  csv_files <- tt_find_csv_files(path)
  dictionary_files <- tt_find_dictionaries(csv_files)
  img_files <- tt_find_images(path)
  known_files <- c(expected_files, csv_files, dictionary_files, img_files)
  extra_files <- setdiff(files, known_files)
  if (length(extra_files)) {
    .pkg_abort(
      c(
        "{.arg path} should only contain submission files.",
        x = "Extra files: {extra_files}"
      ),
      "extra_files"
    )
  }
  return(known_files)
}

tt_find_expected_files <- function(path = "tt_submission") {
  expected_files <- fs::path(
    path,
    c("cleaning.R", "intro.md", "meta.yaml")
  )
  missing_files <- expected_files[!fs::file_exists(expected_files)]
  if (length(missing_files)) {
    .pkg_abort(
      c(
        "All expected files must exist in {.arg path}.",
        x = "Missing files: {missing_files}"
      ),
      "missing_expected"
    )
  }
  return(expected_files)
}

tt_find_csv_files <- function(path = "tt_submission") {
  csv_files <- unname(fs::dir_ls(path, glob = "*.csv"))
  return(tt_validate_csv_sizes(csv_files))
}

tt_validate_csv_sizes <- function(csv_files) {
  max_size <- fs::fs_bytes("25MB")
  file_sizes <- fs::file_size(csv_files)
  too_large <- file_sizes > max_size
  if (any(too_large)) {
    large_files <- csv_files[too_large]
    large_sizes <- file_sizes[too_large]
    .pkg_abort(
      c(
        "CSV files must be <= 25MB to upload to GitHub.",
        x = "Files too large:",
        rlang::set_names(
          purrr::map2_chr(
            large_files,
            large_sizes,
            \(file, size) paste0(file, " (", format(size), ")")
          ),
          rep("*", length(large_files))
        )
      ),
      "csv_size"
    )
  }
  return(csv_files)
}

tt_find_images <- function(path = "tt_submission") {
  rlang::check_installed("yaml", "to verify image files.")
  yaml_path <- fs::path(path, "meta.yaml")
  if (fs::file_exists(yaml_path)) {
    meta <- yaml::read_yaml(yaml_path)
    if (length(meta$images)) {
      expected_images <- fs::path(path, purrr::map_chr(meta$images, "file"))
      missing_files <- expected_images[!fs::file_exists(expected_images)]
      if (length(missing_files)) {
        .pkg_abort(
          c(
            "All images in meta.yaml must exist in {.arg path}.",
            x = "Missing images: {missing_files}"
          ),
          "missing_images"
        )
      }
      # Check and resize images if needed
      for (image in meta$images) {
        tt_check_and_resize_image_single(image, path)
      }
      return(expected_images)
    }
  }
  .pkg_abort(
    "No images found in meta.yaml",
    "no_images"
  )
}

tt_check_and_resize_image_single <- function(image, path) {
  max_bsky_size <- fs::fs_bytes("976.56KB")
  img_path <- fs::path(path, image$file)
  img_size <- fs::file_size(img_path)

  if (img_size > max_bsky_size) {
    rlang::check_installed("magick", "to resize images.")
    tt_inform_image_resize(image$file, img_size, max_bsky_size)
    ratio <- tt_calculate_resize_ratio(img_size, max_bsky_size)
    resized_img <- tt_resize_image(img_path, ratio)
    tt_confirm_resized_image(resized_img, img_path, ratio)
    magick::image_write(resized_img, img_path)
    new_size <- fs::file_size(img_path)
    tt_inform_resize_complete(img_size, new_size)
  }

  return(invisible(NULL))
}

tt_inform_image_resize <- function(filename, current_size, max_size) {
  cli::cli_inform(c(
    "i" = "Image {.file {filename}} is {format(current_size)}, which exceeds the Bluesky limit of {format(max_size)}.",
    "i" = "Resizing image to fit within the limit..."
  ))
}

COMPRESSION_SAFETY_FACTOR <- 90L

tt_calculate_resize_ratio <- function(img_size, max_size) {
  # Round down to make sure we're *under* 1MB. This isn't actually guaranteed to
  # work because image size isn't directly proportional to file size, but it
  # errs on the side of making things smaller than they need to be.
  floor(as.integer(max_size) / as.integer(img_size) * COMPRESSION_SAFETY_FACTOR)
}

tt_resize_image <- function(img_path, ratio) {
  magick::image_read(img_path) |>
    magick::image_resize(magick::geometry_size_percent(ratio))
}

tt_confirm_resized_image <- function(resized_img, img_path, ratio) {
  if (!rlang::is_interactive() || is.null(getOption("viewer"))) {
    return(invisible(NULL))
  }

  temp_preview <- withr::local_tempfile(fileext = fs::path_ext(img_path))
  magick::image_write(resized_img, temp_preview)
  viewer <- getOption("viewer")
  viewer(temp_preview)

  response <- utils::menu(
    choices = c("Yes, use resized image", "No, cancel submission"),
    title = sprintf(
      "Image resized to %d%% of original. Does it look acceptable?",
      ratio
    )
  )

  if (response != 1) {
    .pkg_abort("Submission cancelled by user.", "cancelled")
  }

  return(invisible(NULL))
}

tt_inform_resize_complete <- function(original_size, new_size) {
  cli::cli_inform(c(
    "v" = "Image resized from {format(original_size)} to {format(new_size)}."
  ))
}

tt_find_dictionaries <- function(csv_files) {
  expected_md_files <- fs::path_ext_set(csv_files, "md")
  missing_files <- expected_md_files[!fs::file_exists(expected_md_files)]
  if (length(missing_files)) {
    .pkg_abort(
      c(
        "All datasets must have an associated md file in {.arg path}.",
        x = "Missing dictionaries: {missing_files}"
      ),
      "missing_dictionaries"
    )
  }
  return(expected_md_files)
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
call_gh <- function(..., auth = gh::gh_token()) {
  gh::gh(..., .token = auth)
}
# nocov end

tt_user <- function(auth = gh::gh_token()) {
  call_gh("GET /user", auth = auth)$login
}

tt_fork <- function(user, repo, auth = gh::gh_token()) {
  # GitHub automatically returns existing fork if it exists, no need to check
  my_fork <- call_gh("POST /repos/{repo}/forks", repo = repo, auth = auth)
  tt_sync_fork(
    fork_repo = my_fork$full_name,
    branch = my_fork$default_branch,
    auth = auth
  )
  return(my_fork)
}

tt_sync_fork <- function(fork_repo, branch, auth = gh::gh_token()) {
  call_gh(
    "POST /repos/{fork_repo}/merge-upstream",
    fork_repo = fork_repo,
    branch = branch,
    auth = auth
  )
  return(invisible(NULL))
}

tt_branch_create <- function(fork_info, branch, auth = gh::gh_token()) {
  fork_repo <- fork_info$full_name
  default_branch <- fork_info$default_branch

  main_sha <- call_gh(
    "GET /repos/{fork_repo}/git/refs/heads/{default_branch}",
    fork_repo = fork_repo,
    default_branch = default_branch,
    auth = auth
  )$object$sha
  target_ref <- glue::glue("refs/heads/{branch}")
  existing <- call_gh(
    "GET /repos/{fork_repo}/git/refs/heads",
    fork_repo = fork_repo,
    auth = auth
  )
  if (!target_ref %in% purrr::map_chr(existing, "ref")) {
    call_gh(
      "POST /repos/{fork_repo}/git/refs",
      fork_repo = fork_repo,
      ref = glue::glue("refs/heads/{branch}"),
      sha = main_sha,
      auth = auth
    )
  }
  return(invisible(target_ref))
}

tt_branch_populate <- function(
  fork_repo,
  branch,
  files,
  auth = gh::gh_token()
) {
  existing_content <- tt_branch_content(fork_repo, branch, auth)
  purrr::walk(files, function(file) {
    content <- base64enc::base64encode(file)
    filename <- basename(file)
    sha <- existing_content[[filename]]
    if (!identical(sha, git_blob_sha1(file))) {
      action <- ifelse(is.null(sha), "Add", "Update")
      call_gh(
        "PUT /repos/{fork_repo}/contents/data/curated/new_submission/{filename}",
        fork_repo = fork_repo,
        filename = filename,
        message = glue::glue("{action} {filename}"),
        content = content,
        branch = branch,
        sha = sha,
        auth = auth
      )
    }
  })
}

tt_branch_content <- function(fork_repo, branch, auth = gh::gh_token()) {
  # If the branch has a "new_submission" folder, return the contents of that
  # folder.
  new_submission <- tryCatch(
    call_gh(
      "GET /repos/{fork_repo}/contents/data/curated/new_submission",
      fork_repo = fork_repo,
      ref = glue::glue("refs/heads/{branch}"),
      auth = auth
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

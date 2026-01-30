#' Set up a directory for dataset curation
#'
#' @inheritParams usethis::use_template
#' @inheritParams shared-params
#'
#' @returns The resolved path (invisibly).
#' @keywords internal
prep_tt_curate <- function(
  path = "tt_submission",
  ignore = FALSE,
  env = rlang::caller_env()
) {
  rlang::check_installed("usethis", "to use curation templates.")
  rlang::check_installed("fs", "to use curation templates.")
  prep_proj(tt_submission_path = path, env = env)
  path <- usethis::proj_path(path)
  fs::dir_create(path)
  if (ignore) {
    usethis::use_build_ignore(path)
  }
  invisible(path)
}

prep_proj <- function(tt_submission_path, env = rlang::caller_env()) {
  rlang::check_installed("usethis", "to set up a temporary project.")
  tryCatch(
    usethis::proj_get(),
    # I can't easily test this, since the tests take place inside a project. At
    # most I can create a temporary project, but that's still a project.
    error = function(e) {
      # nocov start
      rlang::check_installed("fs", "to set up a temporary project.")
      proj_root <- fs::path_abs("..", tt_submission_path)
      here_path <- withr::local_file(
        fs::path(proj_root, ".here"),
        .local_envir = env
      )
      fs::file_create(here_path)
    } # nocov end
  )
}

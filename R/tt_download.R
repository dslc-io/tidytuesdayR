#' Download TidyTuesday data
#'
#' Download all or specific files identified in a TidyTuesday dataset.
#'
#' @inheritParams shared-params
#' @inheritParams tt_download_file
#'
#' @return A list of tibbles from the downloaded files.
#'
#' @export
#' @examplesIf interactive()
#' # Get the list of files for a week.
#' tt_output <- tt_load_gh("2019-01-15")
#'
#' # Download a specific file.
#' agencies <- tt_download(tt_output, files = "agencies.csv")
tt_download <- function(tt,
                        files = "All",
                        ...,
                        auth = gh::gh_token()) {
  files <- tt_check_files(tt, files)
  cli::cli_h1("Downloading files")
  files_len <- length(files)
  tt_data <- purrr::imap(files, function(file, file_n) {
    cli::cli_inform(
      c(" " = "{file_n} of {files_len}: {.val {file}}"),
      class = "tt-message-download"
    )
    tt_download_file(tt, file, ..., auth = auth)
  })
  names(tt_data) <- tools::file_path_sans_ext(files)
  return(tt_data)
}

tt_check_files <- function(tt, files, call = rlang::caller_env()) {
  all_files <- attr(tt, ".files")$data_files
  files <- rlang::try_fetch(
    {
      files <- match.arg(
        files,
        choices = c("All", all_files),
        several.ok = TRUE
      )
    },
    error = function(cnd) {
      cli::cli_abort(
        "{.arg files} must be one or more of {.or {.val {all_files}}}, or {.val All}.",
        class = "tt-error-bad_file",
        call = call
      )
    }
  )

  if ("All" %in% files) {
    files <- all_files
  }
  return(files)
}

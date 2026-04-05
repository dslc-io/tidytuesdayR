#' Raise a package-scoped error
#'
#' @inheritParams .shared-params
#' @inheritParams stbl::pkg_abort
#' @returns Does not return.
#' @keywords internal
.pkg_abort <- function(
  message,
  subclass,
  call = rlang::caller_env(),
  message_env = rlang::caller_env(),
  ...
) {
  stbl::pkg_abort(
    "tidytuesdayR",
    message,
    subclass,
    call = call,
    message_env = message_env,
    ...
  )
}

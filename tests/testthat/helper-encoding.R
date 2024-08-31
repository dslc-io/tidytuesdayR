local_encoding <- function(encoding, .env = parent.frame()) {
  expect_warning(
    withr::local_locale(LC_CTYPE = encoding, .local_envir = .env),
    "using locale code page other than 65001"
  )
}

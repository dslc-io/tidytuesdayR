tt_disable_mocking <- function() {
  options("tidytuesdayR.covr_check" = TRUE)
}

tt_enable_mocking <- function() {
  options("tidytuesdayR.covr_check" = FALSE)
}

local_tt_master_file <- function(.env = parent.frame()) {
  # Things that use mocks aren't reporting coverage properly.
  if (getOption("tidytuesdayR.covr_check", FALSE)) {
    return(invisible())
  }
  local_mocked_bindings(
    tt_master_file = function(...) {
      return(readRDS(test_path("fixtures", "ttmf.rds")))
    },
    .env = .env
  )
}

local_tt_mocked_bindings <- function(..., .env = parent.frame()) {
  # Things that use mocks aren't reporting coverage properly.
  if (getOption("tidytuesdayR.covr_check", FALSE)) {
    return(invisible())
  }
  local_mocked_bindings(..., .env = .env)
}

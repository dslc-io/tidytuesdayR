tt_enable_covr <- function() {
  options("tidytuesdayR.covr_check" = TRUE)
}

tt_disable_covr <- function() {
  options("tidytuesdayR.covr_check" = FALSE)
}

tt_is_checking_covr <- function() {
  return(getOption("tidytuesdayR.covr_check", FALSE))
}

local_tt_mocked_bindings <- function(..., .env = parent.frame()) {
  # Things that use mocks aren't reporting coverage properly.
  if (tt_is_checking_covr()) {
    return(invisible())
  }
  local_mocked_bindings(..., .env = .env)
}

local_tt_master_file <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    tt_master_file = function(...) {
      return(readRDS(test_path("fixtures", "ttmf.rds")))
    },
    .env = .env
  )
}

local_tt_datasets <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    gh_get_readme_html = function(path, auth = NULL) {
      year <- basename(path)
      file <- glue::glue("readme{year}.html")
      return(xml2::read_html(test_path("fixtures", file)))
    },
    .env = .env
  )
}

local_tt_week_readme_html <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    tt_week_readme_html = function(date, auth = NULL) {
      file <- glue::glue("readme{date}.html")
      path <- test_path("fixtures", file)
      if (file.exists(path)) {
        return(xml2::read_html(path))
      }
      cli::cli_warn(
        "No readme found in path.",
        class = "tt-warning-no_readme"
      )
      return(NULL)
    },
    .env = .env
  )
}

local_tt_download_file_raw <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    tt_download_file_raw = function(tt_date, target) {
      file <- glue::glue("response-{tt_date}-{target}.rds")
      path <- test_path("fixtures", file)
      if (file.exists(path)) {
        return(readRDS(path))
      }
      cli::cli_abort("Test file not found.")
    },
    .env = .env
  )
}

local_gh_get_sha_in_folder <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    gh_get_sha_in_folder = function(path, file, auth) {
      return("5b7d51181d18d1af90caedd4e008509722612efb")
    },
    .env = .env
  )
}

local_gh_get_csv_data_type <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    gh_get_csv = function(path, ...) {
      if (path == "static/tt_data_type.csv") {
        return(
          gh_extract_csv(
            readRDS(test_path("fixtures", "tt_data_type_response.rds"))
          )
        )
      } else {
        cli::cli_abort("Test broken.")
      }
    },
    .env = .env
  )
}

local_readme <- function(.env = parent.frame()) {
  local_tt_mocked_bindings(
    readme = function(tt) {
      return(NULL)
    },
    .env = .env
  )
}

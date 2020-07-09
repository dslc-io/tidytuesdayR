
# Provide a wrapper to temporarily change location set for tidytuesday
# reference to preserve consistency

tt_ref_test_that <- function(desc, ...){
  ref_repo <- getOption("tidytuesdayR.tt_repo")
  options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
  on.exit({
    options("tidytuesdayR.tt_repo" = ref_repo)
  })
  if(get_connectivity()){
    testthat::test_that(desc = desc, ...)
  }
}

check_api <- function(n = 30){
  if(rate_limit_check(quiet = TRUE) <= n ){
    skip("Rate Limit Met")
  }
}


tt_no_internet_test_that <- function(desc, ...){
  connectivity <- getOption("tidytuesdayR.tt_internet_connectivity")
  options("tidytuesdayR.tt_internet_connectivity" = FALSE)
  options("tidytuesdayR.tt_testing" = TRUE)
  on.exit({
    options("tidytuesdayR.tt_internet_connectivity" = connectivity)
    options("tidytuesdayR.tt_testing" = FALSE)

  })
  testthat::test_that(desc = desc, ...)
}

tt_ref_encoding <- function(desc, encoding, ...){
  ref_repo <- getOption("tidytuesdayR.tt_repo")
  options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")

  ref_local_ctype <- Sys.getlocale(category = "LC_CTYPE")
  quiet <- capture.output({
    Sys.setlocale(category = "LC_CTYPE",locale = encoding)
    })

  on.exit({
    options("tidytuesdayR.tt_repo" = ref_repo)
    Sys.setlocale("LC_CTYPE",ref_local_ctype)
  })

  if(get_connectivity()){
    testthat::test_that(desc = desc, ...)
  }

}

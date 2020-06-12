
#Provide a wraper to temporarily change location set for tidytuesday reference to preserve consistency

tt_ref_test_that <- function(desc, ...){
  ref_repo <- options("tidytuesdayR.tt_repo")
  options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
  on.exit({
    options("tidytuesdayR.tt_repo" = ref_repo[[1]])
  })
  testthat::test_that(desc = desc, ...)
}

check_api <- function(n = 20){
  if(rate_limit_check(silent = TRUE) <= n ){
    skip("Rate Limit Met")
  }
}

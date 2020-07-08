
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

  ref_local <- Sys.getlocale()
  quiet <- capture.output(Sys.setlocale(category = "LC_ALL",locale = encoding))

  on.exit({
    options("tidytuesdayR.tt_repo" = ref_repo)
    reset_local(ref_local)
  })

  if(get_connectivity()){
    testthat::test_that(desc = desc, ...)
  }

}


reset_local <- function(local_string){
  categories <- strsplit(local_string,";")[[1]]
  content <- strsplit(categories,"=")
  lapply(content,function(x){
    Sys.setlocale(category = x[[1]], locale = x[[2]])
  })
  invisible(local_string)
}


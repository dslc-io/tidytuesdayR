#' Call and open the tidytemplate
#'
#' Use the tidytemplate Rmd for starting your analysis with a leg up for
#' processing
#'
#' @inheritParams usethis::use_template
#' @param name A name for your generated TidyTuesday analysis Rmd, such as
#'   "My_TidyTuesday.Rmd".
#' @param refdate Date to use as reference to determine which TidyTuesday to use
#'   for the template. Either date object or character string in YYYY-MM-DD
#'   format.
#'
#' @return A logical vector indicating whether the file was created or modified,
#'   invisibly.
#'
#' @examplesIf interactive()
#'
#'   use_tidytemplate(name = "My_Awesome_TidyTuesday.Rmd")
#'
#' @export
use_tidytemplate <- function(name = NULL,
                             open = rlang::is_interactive(),
                             refdate = today(),
                             ignore = FALSE) {
  stopifnot(valid_date(refdate))
  last_tt <- last_tuesday(refdate)
  if (is.null(name)) {
    name <- paste0(format(last_tt, "%Y_%m_%d"), "_tidy_tuesday.Rmd")
  }

  usethis::use_template(
    "tidytemplate.Rmd",
    save_as = name,
    data = list(
      call_date = today(),
      call_tuesday = format(last_tt, "%Y-%m-%d")
    ),
    package = "tidytuesdayR",
    ignore = ignore,
    open = open
  )
}

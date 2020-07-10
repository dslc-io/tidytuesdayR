#' @title Call and open the tidytemplate
#' @description Use the tidytemplate Rmd for starting your analysis with a
#' leg up for processing
#' @param name name of your TidyTuesday analysis file
#' @param open should the file be opened after being created
#' @param ... arguments to be passed to \link[usethis]{use_template}
#' @param refdate date to use as reference to determine which TidyTuesday to
#' use for the template. Either date object or character string in
#' YYYY-MM-DD format.
#' @importFrom usethis use_template
#' @importFrom lubridate today
#' @examples
#' \donttest{
#' if(interactive()){
#'   use_tidytemplate(name = "My_Awesome_TidyTuesday.Rmd")
#' }
#' }
#'
#' @export
use_tidytemplate <-
  function(name = NULL,
           open = interactive(),
           ...,
           refdate = today()) {

  stopifnot(inherits(refdate,"Date") | valid_date(refdate))
  last_tt <- last_tuesday(refdate)

  if(is.null(name)){
    name <- paste0(format(last_tt,"%Y_%m_%d"),"_tidy_tuesday.Rmd")
  }

  use_template("tidytemplate.Rmd",
               save_as=name,
               data = list(
                 call_date = today(),
                 call_tuesday = format(last_tt,"%Y-%m-%d")),
               package = "tidytuesdayR", ..., open = open)
}

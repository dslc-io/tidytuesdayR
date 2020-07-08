#' @title Call and open the tidytemplate
#' @description Use the tidytemplate Rmd for starting your analysis with a leg up for processing
#' @param name name of your tidytuesday analysis file
#' @param open should the file be opened after being created
#' @param ... arguments to be passed to \link[usethis]{use_template}
#' @param date date to use as reference for the template.
#' @importFrom usethis use_template
#' @importFrom lubridate today
#' @usage use_tidytemplate(name = "My_Awesome_TidyTuesday_Plot.Rmd")
#' @examples
#' \donotrun
#'
#' @export
use_tidytemplate <- function(name = NULL, open = interactive(),..., date = today()){

  stopifnot(inherits(date,"Date"))

  last_tt <- last_tuesday(date)
  if(is.null(name)){
    name <- paste0(last_tt,"_tidy_tuesday_template.Rmd")
  }

  use_template("tidytemplate.Rmd",
               save_as=name,
               data = list(
                 call_date = date,
                 call_tuesday = last_tt),
               package = "tidytuesdayR", ..., open = open)
}

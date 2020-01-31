#' @title Call and open the tidytemplate
#' @description Use the tidytemplate Rmd for starting your analysis with a leg up for processing
#' @importFrom usethis use_template
#' @importFrom lubridate today
#' @usage use_tidytemplate(name = "My_Awesome_TidyTuesday_Plot.Rmd")
#'
#' @export
use_tidytemplate <- function(name = NULL, open = interactive(),...){
  today <- today()
  last_tt <- last_tuesday()
  if(is.null(name)){
    name <- paste0(last_tt,"_tidy_tuesday_template.Rmd")
  }

  use_template("tidytemplate.Rmd",
               save_as=name,
               data = list(
                 call_date = today,
                 call_tuesday = last_tt),
               package = "tidytuesdayR", ..., open = open)
}

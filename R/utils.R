#' print methods of the tt objects
#'
#' In tidytuesdayR there are nice print methods for the objects that were used
#' to download and store the data from the TidyTuesday repo. They will always
#'  print the available datasets/files. If there is a readme available,
#'  it will try to display the tidytuesday readme.
#'
#' @name printing
#'
#' @inheritParams base::print
#' @param x a tt_data or tt object
#'
#' @examples
#'
#' \dontrun{
#'
#' tt <- tt_load_gh("2019-01-15")
#' print(tt)
#'
#' tt_data <- tt_download(tt, files = "All")
#' print(tt_data)
#'
#' }
NULL

#' @rdname printing
#' @importFrom tools file_path_sans_ext
#' @export
#' @return used to show readme and list names of available datasets
#'
print.tt_data <- function(x, ...) {
  readme(x)
  message("Available datasets:\n\t",
          paste(tools::file_path_sans_ext(names(x)), "\n\t", collapse = ""))
  invisible(x)
}

#' @rdname printing
#' @importFrom tools file_path_sans_ext
#' @export
#' @return used to show available datasets for the tidytuesday
#'
print.tt <- function(x,...){
  message(
    "Available datasets in this TidyTuesday:\n\t",
    paste(attr(x, ".files")$data_files, "\n\t", collapse = "")
  )
  invisible(x)
}

#' @title Readme HTML maker and Viewer
#' @param tt tt_data object for printing
#' @importFrom xml2 write_html
#' @return NULL
#' @export
#' @return Does not return anything. Used to show readme of the downloaded
#'  tidytuesday dataset in the Viewer.
#' @examples
#' \dontrun{
#' tt_output <- tt_load_gh("2019-01-15")
#' readme(tt_output)
#' }
readme <- function(tt) {
  if ("tt_data" %in% class(tt)) {
    tt <- attr(tt, ".tt")
  }
  if (length(attr(tt, ".readme")) > 0) {
    xml2::write_html(attr(tt, ".readme"), file = tmpHTML <-
                       tempfile(fileext = ".html"))
    # if running in rstudio, print out that
    html_viewer(tmpHTML)
  }
  invisible(NULL)
}

#' @importFrom utils browseURL
#' @importFrom rstudioapi viewer isAvailable
#' @noRd
html_viewer <- function(url, is_interactive = interactive()){
  if(!is_interactive){
    invisible(NULL)
  } else if (isAvailable()) {
    viewer(url = url)
  } else{
    browseURL(url = url)
  }
}

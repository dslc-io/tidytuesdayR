
#' @title print utility for tt_data objects
#' @inheritParams base::print
#' @importFrom tools file_path_sans_ext
#' @export
print.tt_data <- function(x, ...) {
  readme(x)
  message("Available datasets:\n\t", paste(tools::file_path_sans_ext(names(x)), "\n\t", collapse = ""))
  invisible(x)
}

#' @title print utility for tt_data objects
#' @inheritParams base::print
#' @importFrom tools file_path_sans_ext
#' @export
print.tt <- function(x,...){
  message("Available datasets in this TidyTuesday:\n\t", paste(attr(x,".files")$data_files, "\n\t", collapse = ""))
  invisible(x)
}

#' @title Readme HTML maker and Viewer
#' @param tt tt_data object for printing
#' @importFrom xml2 write_html
#' @return NULL
#' @export
readme <- function(tt) {
  if ("tt_data" %in% class(tt)) {
    tt <- attr(tt, ".tt")
  }
  if (length(attr(tt, ".readme")) > 0) {
    write_html(attr(tt, ".readme"), file = tmpHTML <- tempfile(fileext = ".html"))
    # if running in rstudio, print out that
    html_viewer(tmpHTML)
  }
  invisible(NULL)
}

#' @importFrom utils browseURL
#' @importFrom rstudioapi viewer isAvailable
html_viewer <- function(url){
  if (isAvailable()) {
    viewer(url = url)
  } else{
    browseURL(url = url)
  }
}


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
#' @importFrom rstudioapi viewer
#' @importFrom xml2 write_html
#' @return NULL
#' @export
readme <- function(tt) {
  if ("tt_data" %in% class(tt)) {
    tt <- attr(tt, ".tt")
  }
  if (length(attr(tt, ".readme")) > 0) {
    # if running in rstudio, print out that
    if (rstudioapi::isAvailable()) {
      tmpdir <- tempfile(fileext = ".html")
      write_html(attr(tt, ".readme"), file = tmpdir)
      rstudioapi::viewer(url = tmpdir)
    }
  }
  invisible(NULL)
}

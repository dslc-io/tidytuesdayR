
#' @title print utility for tt_data objects
#' @inheritParams base::print
#' @importFrom tools file_path_sans_ext
#' @export
print.tt_data <- function(x, ...) {
  readme(x)
  message("Available datasets:\n\t", paste(tools::file_path_sans_ext(names(x)), "\n\t", collapse = ""))
}

#' @title print utility for tt_data objects
#' @inheritParams base::print
#' @importFrom tools file_path_sans_ext
#' @export
print.tt <- function(x,...){
  message("Available datasets for download:\n\t", paste(attr(x,".files"), "\n\t", collapse = ""))
}

#' @title Readme HTML maker and Viewer
#' @param tt tt_data object for printing
#' @importFrom rstudioapi viewer
#' @export
readme <- function(tt) {
  if ("tt_data" %in% class(tt)) {
    tt <- attr(tt, ".tt")
  }
  if (length(attr(tt, ".readme")) > 0) {
    # if running in rstudio, print out that
    if (rstudioapi::isAvailable()) {
      rstudioapi::viewer(url = tt_make_html(tt))
    }
  }
}

tt_make_html <- function(x) {
  tmpHTML <- tempfile(fileext = ".html")
  cat(c(
    "<!DOCTYPE html><html lang=\"en\"><head>",
    "<link rel=\"dns-prefetch\" href=\"https://github.githubassets.com\">",
    "<link crossorigin=\"anonymous\" media=\"all\" rel=\"stylesheet\"",
    "href=\"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\">",
    "</head><body>"
  ), file = tmpHTML, sep = " ")
  cat(attr(x, ".readme"), file = tmpHTML, append = TRUE)
  cat("</body></html>", file = tmpHTML, append = TRUE)
  return(tmpHTML)
}

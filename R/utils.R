#' print methods of the tt objects
#'
#' In tidytuesdayR there are nice print methods for the objects that were used
#' to download and store the data from the TidyTuesday repo. They will always
#'  print the available datasets/files. If there is a readme available,
#'  it will try to display the TidyTuesday readme.
#'
#' @name printing
#'
#' @inheritParams base::print
#' @param x a tt_data or tt object
#'
#' @examplesIf interactive()
#' tt <- tt_load_gh("2019-01-15")
#' print(tt)
#'
#' tt_data <- tt_download(tt, files = "All")
#' print(tt_data)
NULL

#' Readme HTML maker and Viewer
#'
#' @param tt tt_data object for printing
#'
#' @return Null, invisibly. Used to show readme of the downloaded TidyTuesday
#'   dataset in the Viewer.
#' @export
#' @examplesIf interactive()
#' if (rate_limit_check(quiet = TRUE) > 30) {
#'   tt_output <- tt_load_gh("2019-01-15")
#'   readme(tt_output)
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

html_viewer <- function(url, is_interactive = interactive()) {
  if (!is_interactive) {
    invisible(NULL)
  } else if (rstudio_is_available()) {
    rstudio_viewer(url = url)
  } else {
    browse_url(url = url)
  }
}

rstudio_is_available <- function() {
  rlang::is_installed("rstudioapi") && rstudioapi::isAvailable()
}

# For mocking in tests.
browse_url <- function(url) {
  utils::browseURL(url = url) # nocov
}

rstudio_viewer <- function(url) {
  rstudioapi::viewer(url = url)
}

contiguous_weeks <- function(week_vctr) {
  if (length(week_vctr) == 1) {
    text_out <- as.character(week_vctr)
  } else {
    is_not_contig <- which(diff(week_vctr) != 1)
    if (length(is_not_contig) == 0) {
      text_out <- paste0(week_vctr[1], "-", week_vctr[length(week_vctr)])
    } else {
      if (is_not_contig[[1]] == 1) {
        text_out <- as.character(week_vctr[1])
      } else {
        text_out <- paste0(week_vctr[1], "-", week_vctr[is_not_contig[[1]]])
      }
      contig_split <- 1
      while (contig_split < length(is_not_contig)) {
        if (diff(c(is_not_contig[contig_split], is_not_contig[contig_split + 1])) == 1) {
          text_out <- paste0(
            text_out, ", ", week_vctr[is_not_contig[contig_split] + 1]
          )
        } else {
          text_out <- paste0(
            text_out, ", ", paste0(week_vctr[is_not_contig[contig_split] + 1], "-", week_vctr[is_not_contig[contig_split + 1]])
          )
        }
        contig_split %+=% 1
      }

      if (length(week_vctr) == (is_not_contig[contig_split] + 1)) {
        text_out <- paste0(
          text_out, ", ", week_vctr[length(week_vctr)]
        )
      } else {
        text_out <- paste0(
          text_out, ", ", paste0(week_vctr[is_not_contig[contig_split] + 1], "-", week_vctr[length(week_vctr)])
        )
      }
    }
  }
  return(text_out)
}

`%+=%` <- function(x, y, env = parent.frame()) {
  x_name <- as.character(substitute(x))
  x_new <- x + y
  assign(
    x = x_name,
    value = x_new,
    envir = env
  )
}

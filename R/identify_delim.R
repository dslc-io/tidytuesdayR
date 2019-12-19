#' @title Identify potential delimeters of file
#'
#' @param path path to file
#' @param delims a vector of delimeters to try
#' @param n number of rows to look at in the file to determine the delimters
#' @param comment identify lines that are comments if this character is at the beginning
#' @param skip number of lines to skip at the beginning
#' @param quote set of quoting characters
#' @importFrom utils download.file
#'

identify_delim <- function(path,
                           delims = c("\t", ",", " ", "|", ";"),
                           n = 10,
                           comment = "#",
                           skip = 0,
                           quote = "\"") {

  # Attempt splitting on list of delimieters
  num_splits <- list()
  for (delim in delims) {

    test <- scan(path,
                 what = "character",
                 nlines = n,
                 allowEscapes = FALSE,
                 encoding = "UTF-8",
                 sep = delim,
                 quote = quote,
                 skip = skip,
                 comment.char = comment,
                 quiet = TRUE)

    num_splits[[delim]] <- length(test)
  }

  if(all(unlist(num_splits) < n)){
    n <- as.numeric(names(sort(table(unlist(num_splits)),decreasing = TRUE)[1]))
  }

  if (all(unlist(num_splits) == n)) {
    warning("Not able to detect delimiter for the file. Defaulting to `\t`.")
    return("\t")
  }

  # which delims that produced consistent splits and greater than 1?
  good_delims <- do.call("c", lapply(num_splits, function(cuts, nrows) {
    (cuts %% nrows == 0) & cuts > nrows
  }, n))

  good_delims <- names(good_delims)[good_delims]

  if (length(good_delims) == 0) {
    warning("Not able to detect delimiter for the file. Defaulting to ` `.")
    return(" ")
  } else if (length(good_delims) > 1) {
    warning(
      "Detected multiple possible delimeters:",
      paste0("`", good_delims, "`", collapse = ", "), ". Defaulting to ",
      paste0("`", good_delims[1], "`"), "."
    )
    return(good_delims[1])
  } else {
    return(good_delims)
  }
}

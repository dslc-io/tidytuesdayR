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

  # Load lines of file in
  test <- readLines(path, n = n + skip)
  if (skip > 0) {
    test <- test[-c(seq(skip))]
  }
  comment_lines <- grepl("^[#]", test)
  if (sum(comment_lines) > 0) {
    eof <- FALSE
    while ((length(test) - sum(comment_lines) < n) & !eof) {
      test <- readLines(path, n = n + skip + sum(comment_lines))
      if (length(test) < n + skip + sum(comment_lines)) {
        eof <- TRUE
      }
      if (skip > 0) {
        test <- test[-c(seq(skip))]
      }
      comment_lines <- grepl("^[#]", test)
    }
    test <- test[!comment_lines]
  }

  # Attempt splitting on list of delimieters
  num_splits <- list()
  for (delim in delims) {
    delim_regex <- paste0("[", delim, "](?=(?:[^", quote, "]*", quote, "[^", quote, "]*", quote, ")*[^", quote, "]*$)")
    num_splits[[delim]] <- do.call("c", lapply(strsplit(test, delim_regex, perl = TRUE), length))
  }

  if (all(unlist(num_splits) == 1)) {
    warning("Not able to detect delimiter for the file. Defaulting to `\t`.")
    return("\t")
  }

  # which delims that produced consistent splits and greater than 1?
  good_delims <- do.call("c", lapply(num_splits, function(cuts) {
    all(cuts == cuts[1]) & cuts[1] > 1
  }))

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

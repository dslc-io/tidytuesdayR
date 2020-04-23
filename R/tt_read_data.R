#' @title Reads in TidyTuesday datasets from Github repo
#'
#' @description  Reads in the actual data from the TidyTuesday github
#'
#' @param tt tt_gh object from tt_load_gh function
#' @param x index/name of data object to read in. string or int
#' @param guess_max number of rows to use to esimate col type, defaults to 5000. Only used for text files.
#' @return tibble
#' @export
#'
#' @importFrom readr read_csv read_delim
#' @import tools
#' @import readxl
#'
#' @family tt_read_data
#'
#' @examples
#' tt_gh <- tt_load_gh("2019-01-15")
#'
#' tt_dataset_1 <- tt_read_data(tt_gh, tt_gh[1])
tt_read_data <- function(tt, x, guess_max = 5000) {
  suppressMessages({
    switch(class(x),
      "character" = tt_read_data.character(tt, x, guess_max = guess_max ),
      "numeric" = tt_read_data.numeric(tt, x, guess_max = guess_max ),
      "integer" = tt_read_data.numeric(tt, x, guess_max = guess_max ),
      stop(paste("No method for entry of class:", class(x)))
    )
  })
}

tt_read_data.character <- function(tt, x, guess_max = 5000) {
  if (x %in% attr(tt, ".files")) {
    url <- paste0(gsub("/tree/", "/blob/", file.path(attr(tt, ".url"), x)), "?raw=true")
    tt_read_url(url, guess_max = guess_max)
  } else {
    stop(paste0(
      "That is not an available file for this TidyTuesday week!\nAvailable Datasets:\n",
      paste(attr(tt, ".files"), "\n\t", collapse = "")
    ))
  }
}

tt_read_data.numeric <- function(tt, x, guess_max = 5000) {
  if (x > 0 & x <= length(attr(tt, ".files"))) {
    url <- paste0(gsub("/tree/", "/blob/", file.path(attr(tt, ".url"), attr(tt, ".files")[x])), "?raw=true")
    tt_read_url(url, guess_max = guess_max)
  } else {
    stop(paste0(
      "That is not an available index for the files for this TidyTuesday week!\nAvailable Datasets:\n\t",
      paste0(seq(1, length(attr(tt, ".files"))), ": ", attr(tt, ".files"), "\n\t", collapse = "")
    ))
  }
}


tt_read_url <- function(url, guess_max = 5000) {
  url <- gsub(" ", "%20", url)
  switch(tools::file_ext(gsub("[?]raw=true", "", tolower(url))),
    "xls"  = download_read(url, readxl::read_xls, guess_max = guess_max, mode = "wb"),
    "xlsx" = download_read(url, readxl::read_xlsx, guess_max = guess_max, mode = "wb"),
    "rds"  = download_read(url, readRDS, mode = "wb"),
    "rda"  = download_read(url, read_rda, mode = "wb"),
    download_read(url, readr::read_delim, guess_max = guess_max, progress = FALSE, find_delim = TRUE)
  )
}

#' @title utility to assist with 'reading' urls that cannot normally be read by file functions
#'
#' @param url path to online file to be read
#' @param func the function to perform reading of url
#' @param ... args to pass to func
#' @param guess_max number of rows to use to predict column type. Only used if is an arg in `func`
#' @param mode mode passed to \code{utils::download.file}. default is "w"
#' @param find_delim should the delimeters be found for the file
#' @importFrom utils download.file
#'
download_read <- function(url, func, ..., guess_max, mode = "w", find_delim = FALSE) {
  temp_file <- tempfile(fileext = paste0(".", tools::file_ext(gsub("[?]raw=true", "",url))))
  utils::download.file(url, temp_file, quiet = TRUE, mode = mode)

  dots <- as.list(substitute(substitute(...)))[-1]
  func_call <- c(substitute(func), substitute(temp_file), dots)

  if (find_delim) {
    if (!(!is.null(names(func_call)) &
      "delim" %in% names(func_call)) &
      "delim" %in% names(as.list(args(func)))) {
      func_call$delim <- identify_delim(temp_file)
    }
  }

  if("guess_max"%in%names(as.list(args(func)))){
    func_call$guess_max = guess_max
  }

  return(eval(as.call(func_call)))
}

#' @title utility to load RDA with out using assigned name in envir
#'
#' @param path path to RDA file
#
read_rda <- function(path){
  load_env<-new.env()
  load(path,envir = load_env)
  load_env[[ ls(load_env)[1] ]]
}

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
#' @importFrom tools file_ext
#' @import readxl
#'
#' @family tt_read_data
#'
#' @examples
#' tt_gh <- tt_load_gh("2019-01-15")
#'
#' tt_dataset_1 <- tt_read_data(tt_gh, tt_gh[1])
tt_read_data <- function(filename, type, delim, dir, ...) {

  read_func <- switch(type,
    "xls"  = read_data(readxl::read_xls,..., raw = TRUE),
    "xlsx" = read_data(readxl::read_xlsx,..., raw = TRUE),
    "rds"  = read_data(readRDS, raw = TRUE),
    "rda"  = read_data(read_rda, raw = TRUE),
    read_data(readr::read_delim, progress = FALSE,...)
  )

  read_func(file.path(dir, filename))

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
read_data <- function(func, ..., raw = FALSE) {


  read_data_txt

  function(path){
     blob <- github_blob(path, as_raw = raw)



  }

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

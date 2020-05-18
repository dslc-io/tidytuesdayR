#' Get Master List of Files from TidyTuesday
#'
#' Import or update dataset from github that records the entire list of objects from tidytuesday
#'
#' @keywords internal
tt_update_master_file <- function(force = FALSE){
  # get sha to see if need to update
  sha_df <- github_sha("static")
  sha <- sha_df$sha[sha_df$path == "tt_data_type.csv"]

  if( is.null(tt_master_file()) || sha != attr(tt_master_file(), ".sha") || force ){
    file_text <- github_contents("static/tt_data_type.csv")
    content <- read.csv(text = file_text, header = TRUE, stringsAsFactors = FALSE)
    attr(content,".sha") <- file_text

    tt_master_file(content)
  }
}

#' Get Master List of Files from Local Environment
#'
#' return or update tt master file
#'
#' @param assign value to overwrite the TT_MASTER_ENV$TT_MASTER_FILE contents with
#'
#' @keywords internal
tt_master_file <- function(assign = NULL){
  if(!is.null(assign)){
    TT_MASTER_ENV$TT_MASTER_FILE <- assign
  }else{
    TT_MASTER_ENV$TT_MASTER_FILE
  }
}

#' The Master List of Files from TidyTuesday
#'
#' @keywords internal

TT_MASTER_ENV <- new.env()
TT_MASTER_ENV$TT_MASTER_FILE <- NULL



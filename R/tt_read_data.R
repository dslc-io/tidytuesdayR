#' @title Reads in TidyTuesday datasets from Github repo
#'
#' @description  Reads in the actual data from the TidyTuesday github
#'
#' @param tt tt_gh object from tt_load_gh function
#' @param x index/name of data object to read in. string or int
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
#' tt_gh<-tt_load_gh("2019-01-15")
#'
#' tt_dataset_1<-tt_read_data(tt_gh,tt_gh$files[1])
tt_read_data<-function(tt,x){
  switch (class(x),
          "character" = tt_read_data.character(tt,x),
          "numeric" = tt_read_data.numeric(tt,x),
          "integer" = tt_read_data.numeric(tt,x),
          stop(paste("No method for entry of class:",class(x)))
  )
}

tt_read_data.character<-function(tt,x){
  if(x%in%tt$files){
    url<-paste0(gsub("tree","blob",file.path(tt$url,x)),"?raw=true")
    tt_read_url(url)
  }else{
    stop(paste0("That is not an available file for this TidyTuesday week!\nAvailable Datasets:\n",
                paste(tt$files,"\n\t",collapse="")))
  }
}

tt_read_data.numeric<-function(tt,x){
  if(x>0 & x <= length(tt$files)){
    url<-paste0(gsub("tree","blob",file.path(tt$url,tt$files[x])),"?raw=true")
    tt_read_url(url)
  }else{
    stop(paste0("That is not an available index for the files for this TidyTuesday week!\nAvailable Datasets:\n\t",
                paste0(seq(1,length(tt$files)),": ",tt$files,"\n\t",collapse="")))
  }
}

tt_read_url<-function(url){
  switch(file_ext(gsub("[?]raw=true","",url)),
         "xls"=download_read(url,readxl::read_xls,mode="wb"),
         "xlsx"=download_read(url,readxl::read_xlsx,mode="wb"),
         "tsv"=readr::read_delim(url,"\t"),
         "csv"=readr::read_delim(url,","))
}

#' @title utility to assist with 'reading' urls that cannot normally be read by file functions
#'
#' @param url path to online file to be read
#' @param func the function to perform reading of url
#' @param ... args to pass to func
#' @param mode mode passed to \code{utils::download.file}. default is "w"
#' @importFrom utils download.file
#'
download_read<-function(url,func,...,mode="w"){
  temp_excel<-tempfile(fileext = paste0(".",tools::file_ext(url)))
  utils::download.file(url,temp_excel,quiet = TRUE,mode=mode)
  func(temp_excel,...)
}


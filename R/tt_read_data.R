#' Reads in TidyTuesday datasets from Github repo
#' 
#' Reads in the actual data from the TidyTuesday github 
#' 
#' @param tt tt_gh object from tt_load_gh function
#' @param x index/name of data object to read in. string or int
#' @return tibble
#' @export
#' 
#' @import tidyverse
#' @import tools
#' @import readxl
#' 
#' @family tt_read_data
#' 
#' @example 
#' tt_gh<-tt_load_gh("2019-01-15")
#' 
#' tt_dataset_1<-tt_read_data(tt_gh,tt_gh$files[1])
#' 
#' 

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
    url<-gsub("tree/master","master",gsub("github.com","raw.githubusercontent.com",file.path(tt$url,x)))
    tt_read_url(url)
  }else{
    stop(paste0("That is not an available file for this TidyTuesday week!\nAvailable Datasets:\n",
                paste(x$files,"\n\t",collapse="")))
  }
}

tt_read_data.numeric<-function(tt,x){
  if(x>0 & x <= length(tt$files)){
    url<-gsub("tree/master","master",gsub("github.com","raw.githubusercontent.com",file.path(tt$url,tt$files[x])))
    tt_read_url(url)
  }else{
    stop(paste0("That is not an available index for the files for this TidyTuesday week!\nAvailable Datasets:\n\t",
                paste0(seq(1,length(tt$files)),": ",tt$files,"\n\t",collapse="")))
  }
}

tt_read_url<-function(path){
  switch(file_ext(tt$files[x]),
         "xls"=read_xls(url),
         "xlsx"=read_xlsx(url),
         "tsv"=read_delim(url,"\t"),
         "csv"=read_delim(url,","))
}
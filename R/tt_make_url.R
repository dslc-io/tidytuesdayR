#' @title given inputs generate valid TidyTuesday URL
#' @description Given multiple types of inputs, generate
#' @param x either a string or numeric entry indicating the full date of
#' @param week left empty unless x is a numeric year entry, in which case the week of interest should be entered
#'
tt_make_url<-function(x,week){
 if(valid_date(x)){
      tt_make_url.date(x)
   }else if(is.numeric(x)){
      tt_make_url.year(x,week)
   }
}

tt_make_url.date<-function(x){
  tt_year <- year(x)
  tt_formatted_date<-tt_date_format(x)
  tt_folders<-tt_weeks(tt_year)
  if(!as.character(tt_formatted_date)%in%tt_folders){
    stop(paste0(tt_formatted_date," is not a date that has TidyTuesday data.\n\tDid you mean: ",tt_closest_date(tt_formatted_date,tt_folders),"?"))
  }
  tt_url<-file.path("https://github.com/rfordatascience/tidytuesday/tree/master/data",tt_year,tt_formatted_date)
}

tt_make_url.year<-function(x,week){
  tt_folders<-tt_weeks(x)
  if(week>length(tt_folders)){
    stop(paste0("Only ",length(tt_folders)," TidyTuesday Weeks exist in ",x,". Please enter a value for week between 1 and ",length(tt_folders)))
  }
  tt_url<-file.path("https://github.com/rfordatascience/tidytuesday/tree/master/data",x,tt_folders[week])
}

tt_weeks<-function(year){
  tt_years<-html_attr(html_nodes(html_nodes(html_nodes(
    read_html("https://github.com/rfordatascience/tidytuesday/tree/master/data"),
    ".files"),".content"),"a"),"title")
  tt_years<-suppressWarnings({tt_years[!is.na(as.numeric(tt_years))]})
  if(!as.character(year)%in%tt_years){
    stop(paste0("TidyTuesday did not exist for ",year,". \n\t TidyTuesday has only existed from ",
                min(as.numeric(tt_years))," to ",max(as.numeric(tt_years))))
  }
  tt_base_url<-file.path("https://github.com/rfordatascience/tidytuesday/tree/master/data",year)
  tt_folders<-html_attr(html_nodes(html_nodes(html_nodes(read_html(tt_base_url),".files"),".content"),"a"),"title")
  tt_folders<-tt_folders[valid_date(tt_folders)]
}

#' @importFrom lubridate as_date is.Date
valid_date<-function(x){
  suppressWarnings({!is.na(as_date(as.character(x))) | is.Date(x)})
}

#' @importFrom lubridate year month day ymd
tt_date_format<-function(x){
  lubridate::ymd(paste0(lubridate::year(x),"-",lubridate::month(x),"-",lubridate::day(x)))
}

tt_closest_date<-function(inputdate,availabledates){
  availabledates[which.min(abs(difftime(inputdate,availabledates,units = "days")))]
}

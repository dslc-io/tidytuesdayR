#' @title Get TidyTuesday URL and HTML
get_tt_html<-function(git_url){

  tt_html<-try(read_html(git_url),silent = TRUE)
  if(inherits(tt_html,"try-error")){
    stop(tt_html[1])
  }else{
    return(tt_html)
  }

}

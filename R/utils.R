
#' @title print utilities for tt_data objects
#' @importFrom tools file_path_sans_ext
#' @export
print.tt_data<-function(x,...){
  readme(x)
  message("Available Datasets:\n\t",paste(file_path_sans_ext(x[['tt']]$files),"\n\t",collapse=""))
}

#' @title Access TidyTuesday data from tt_data object
#' @inheritParams base::`[.data.frame`
#' @export
`$.tt_data`<-function(x,i){
  x[['data']][[i]]
}

#' @title Readme HTML maker and Viewer
#' @importFrom rstudioapi viewer
readme<-function(tt){
  if(length(tt[['tt']]$readme)>0 & rstudioapi::isAvailable()){
    readmeURL<-tt_make_html(tt)
    rstudioapi::viewer(url = readmeURL)
  }
}

tt_make_html<-function(x){
  tmpHTML<-tempfile(fileext = ".html")
  cat("<!DOCTYPE html><html lang=\"en\"><head>
      <link rel=\"dns-prefetch\" href=\"https://github.githubassets.com\">
      <link crossorigin=\"anonymous\" media=\"all\" rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\">
      </head><body>",file=tmpHTML)
  cat(x[['tt']]$readme,file = tmpHTML,append = TRUE)
  cat("</body></html>",file = tmpHTML,append = TRUE)
  return(tmpHTML)
}

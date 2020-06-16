pkgname <- "tidytuesdayR"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "tidytuesdayR-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('tidytuesdayR')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("Available_Printing")
### * Available_Printing

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: Available_Printing
### Title: Printing Utilities for Listing Available Datasets
### Aliases: Available_Printing print.tt_dataset_table
###   print.tt_dataset_table_list

### ** Examples

# check to make sure there are requests still available
if(rate_limit_check(silent = TRUE) > 10){

 available_datasets_2018 <- tt_datasets(2018)
 print(available_datasets_2018)

 all_available_datasets <- tt_available()
 print(all_available_datasets)

}



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("Available_Printing", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("available")
### * available

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: available
### Title: Listing all available TidyTuesdays
### Aliases: available tt_available tt_datasets

### ** Examples

# check to make sure there are requests still available
if(rate_limit_check(silent = TRUE) > 10){
 ## show data available from 2018
 tt_datasets(2018)

 ## show all data available ever
 tt_available()
}




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("available", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("github_pat")
### * github_pat

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: github_pat
### Title: Return the local user's GitHub Personal Access Token
### Aliases: github_pat

### ** Examples


## if you have a personal access token saved, this will return that value
github_pat()




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("github_pat", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("printing")
### * printing

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: printing
### Title: print methods of the tt objects
### Aliases: printing print.tt_data print.tt

### ** Examples


## Not run: 
##D 
##D tt <- tt_load_gh("2019-01-15")
##D print(tt)
##D 
##D tt_data <- tt_download(tt, files = "All")
##D print(tt_data)
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("printing", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("rate_limit_check")
### * rate_limit_check

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: rate_limit_check
### Title: Get Rate limit left for GitHub Calls
### Aliases: rate_limit_check

### ** Examples


rate_limit_check(silent = TRUE)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("rate_limit_check", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("readme")
### * readme

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: readme
### Title: Readme HTML maker and Viewer
### Aliases: readme

### ** Examples

## Not run: 
##D tt_output <- tt_load_gh("2019-01-15")
##D readme(tt_output)
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("readme", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("tt_download")
### * tt_download

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: tt_download
### Title: download tt data Download all or specific files identified in
###   the tt dataset
### Aliases: tt_download

### ** Examples

## Not run: 
##D tt_output <- tt_load_gh("2019-01-15")
##D agencies <- tt_download(tt_output, files = "agencies.csv")
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("tt_download", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("tt_download_file")
### * tt_download_file

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: tt_download_file
### Title: Reads in TidyTuesday datasets from Github repo
### Aliases: tt_download_file

### ** Examples

## Not run: 
##D tt_gh <- tt_load_gh("2019-01-15")
##D 
##D agencies <- tt_download_file(tt_gh, 1)
##D launches <- tt_download_file(tt_gh, "launches.csv")
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("tt_download_file", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("tt_load")
### * tt_load

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: tt_load
### Title: Load TidyTuesday data from Github
### Aliases: tt_load

### ** Examples


# check to make sure there are requests still available
if(rate_limit_check(silent = TRUE) > 10){

tt_output <- tt_load("2019-01-15")
tt_output
agencies <- tt_output$agencies

}




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("tt_load", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("tt_load_gh")
### * tt_load_gh

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: tt_load_gh
### Title: Load TidyTuesday data from Github
### Aliases: tt_load_gh

### ** Examples

# check to make sure there are requests still available
if(rate_limit_check(silent = TRUE) > 10){
 tt_gh <- tt_load_gh("2019-01-15")
 readme(tt_gh)
}




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("tt_load_gh", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')

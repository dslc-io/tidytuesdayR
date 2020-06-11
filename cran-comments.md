## Resubmission
This is a resubmission. In this version I have:

* Surrounded the non-English usage, package names, software names and API names in undirected single quotes

* Capitalized the names, sentence beginnings and abbreviations/acronyms in the description text of the DESCRIPTION file

* Removed the reference to the function in the description text

* Added a web reference to the TidyTuesday Project on Github, wapped in angle brackets. Please let me know if there was a different web reference that should be used

* Corrected the unexecutable code in man/tt_load_gh.Rd

* Added \Value to the .Rd files of the exported methods, function results, and structure of output classes

* Removed the cases of examples with unexported functions

* I would like to maintain the use of \dontrun in the examples due to rate limiting by GitHub. The functions fail
gracefully with an informative error message informing the user they are out of calls against the API, but 
un-authenicated calls are limited to 60 calls an hour from a single IP address. Please let me know if I should
be using a different wrapper. The purpose of the package is to connect and pull information from GitHub so there can be no
"toy" examples.


## Test environments
* local R installation, R 4.0.0
* ubuntu 16.04 (on github actions), R 4.0.0
* mac OS 10.15.4 (on github actions) R-devel, R 4.0.0,
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Downstream dependencies

There are currently no downstream dependencies on this package as it is the first CRAN submission

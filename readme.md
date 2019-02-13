tidytuesdayR
================
Ellis Hughes

[![Travis build status](https://travis-ci.org/thebioengineer/tidytuesdayR.svg?branch=master)](https://travis-ci.org/thebioengineer/tidytuesdayR)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/thebioengineer/tidytuesdayR?branch=master&svg=true)](https://ci.appveyor.com/project/thebioengineer/tidytuesdayR)
[![Coverage status](https://codecov.io/gh/thebioengineer/tidytuesdayR/branch/master/graph/badge.svg)](https://codecov.io/github/thebioengineer/tidytuesdayR?branch=master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

tidytuesdayR is made to assist with the import of data posted for #TidyTuesday by the [R4DataScience](https://github.com/rfordatascience) team. Just enter a string formatted as "YYYY-MM-dd", and if there is a tidytuesday dataset available, it will download the readme and the data. 

## Installation

Currently this package is only available on GitHub:
``` r
devtools::install_github("thebioengineer/tidytuesdayR")
```

## Usage

The way this is used is by simply calling the 'tt_load' function and entering the date to pull

``` r 
library(tidytuesdayR)
tt_data<-tt_load("2019-01-15")
```

To view the readme and the datasets available, simply print the tt_data object

``` r
print(tt_data)
```

    ## Available Datasets:
    ##  agencies 
    ##  launches 
    ##  

Finally, to access the datasets, use the `$` access and the name of the dataset

``` r
tt_data$agencies
```

    ## # A tibble: 74 x 19
    ##    agency count ucode state_code type  class tstart tstop short_name name 
    ##    <chr>  <dbl> <chr> <chr>      <chr> <chr> <chr>  <chr> <chr>      <chr>
    ##  1 RVSN    1528 RVSN  SU         O/LA  D     1960   1991~ RVSN       Rake~
    ##  2 UNKS     904 GUKOS SU         O/LA  D     1986 ~ 1991  UNKS       Upra~
    ##  3 NASA     469 NASA  US         O/LA~ C     1958 ~ -     NASA       Nati~
    ##  4 USAF     388 USAF  US         O/LA~ D     1947 ~ -     USAF       Unit~
    ##  5 AE       258 AE    F          O/LA  B     1980 ~ *     Arianespa~ Aria~
    ##  6 AFSC     247 AFSC  US         LA    D     1961 ~ 1992~ AFSC       US A~
    ##  7 VKSR     200 GUKOS RU         O/LA  D     1997 ~ 2001~ VKS RVSN   Voen~
    ##  8 CALT     181 CALT  CN         LA/L~ C     1957 ~ -     CALT       Zhon~
    ##  9 FKA      128 MOM   RU         O/LA  C     2004   2016~ Roskosmos  Fede~
    ## 10 SAST     105 SBA   CN         O/LA~ B     1993   -     SAST       Shan~
    ## # ... with 64 more rows, and 9 more variables: location <chr>,
    ## #   longitude <chr>, latitude <chr>, error <chr>, parent <chr>,
    ## #   short_english_name <chr>, english_name <chr>, unicode_name <chr>,
    ## #   agency_type <chr>
    
    
## Contributing
Please note that the 'tidytuesdayR' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.



# tidytuesdayR <img src="man/figures/logo.png" align="right" height=140/>

Ellis Hughes

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/tidytuesdayR)](https://CRAN.R-project.org/package=tidytuesdayR)
[![R build status](https://github.com/thebioengineer/tidytuesdayR/workflows/R-CMD-check/badge.svg)](https://github.com/thebioengineer/tidytuesdayR/actions)
[![Coverage
status](https://codecov.io/gh/thebioengineer/tidytuesdayR/branch/master/graph/badge.svg)](https://codecov.io/github/thebioengineer/tidytuesdayR?branch=master)
[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/tidytuesdayR)](https://cran.r-project.org/package=tidytuesdayR)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

{tidytuesdayR} has the main goal to make it easy to participate in the
weekly [\#TidyTuesday](https://github.com/rfordatascience/tidytuesday)
project. Currently this is done by assisting with the import of data
posted on the [R4DataScience](https://github.com/rfordatascience) Tidy
Tuesday repository.

## Installation

This package is available on CRAN via:

``` r
install.packages("tidytuesdayR")
```

To get the latest in-development features, install the development version from GitHub:

``` r
#install.packages("remotes")
remotes::install_github("thebioengineer/tidytuesdayR")
```

## Usage

There are currently two methods to access the data from the respository.

### Load the Data!

The simplest way is to use the ‘tt\_load()’ function. This
function has accepts two types of inputs to determine which data to
grab. It can be a date as a string in the YYYY-MM-DD format like below.

``` r
library(tidytuesdayR)
tt_data <- tt_load("2019-01-15")
```

Or the function can accept the year as the first argument, and which
week of the year as the second.

``` r
tt_data <- tt_load(2019, week=3) 
```

`tt_load()` naively downloads *all* the data that is available and
stores them in the resulting `tt_data` object. To access the data, use
the `$` or `[[` notation and the name of the dataset.

``` r
tt_data$agencies
tt_data[["agencies"]]
```

To view the readme, either print the `tt_data` object or use the `readme()`
function. When you print the `tt_data` object, you also get the available 
datasets names printed in the console.

``` r
readme(tt_data)
print(tt_data)
```

``` 
## Available Datasets:
##  agencies 
##  launches 
##  
```

### TidyTemplate

As part of the goal of making participating in #TidyTuesday easier, {tidytuesdayR} now also provides a template!
To use it, just use the `use_tidytemplate()` function!

By default, the template will assume to be using the most recent TidyTuesday.
However, you can pass a date object or character string in YYYY-MM-DD format 
defining a different date you want to use. If you don't recall the exact date, 
no worries, you can use the `tt_available()` function to figure out which date
and get the date to use!

```r
## this weeks TidyTuesday!
tidytuesdayR::use_tidytemplate()

## TidyTuesday from Week 42 of 2019
tidytuesdayR::use_tidytemplate(refdate = "2019-10-15")
```

Additionally, by default the template will create the new file in your working 
directory, using the "YYYY_MM_DD" format per good practices.
However, if you are so inclined, you can rename it to whatever you wish.

```r
tidytuesdayR::use_tidytemplate(name = "My Super Great TidyTuesday.Rmd")
```



## Contributing

Please note that the ‘tidytuesdayR’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.

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

### tt\_load()

The first and simplest way is to use the ‘tt\_load()’ function. This
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

### tt\_load\_gh() and tt\_download\_file()

The second method to access the data from the repository is to use the
combination of `tt_load_gh()` and `tt_download_file()` functions.
`tt_load_gh()` takes similar arguments as `tt_load()`, in that either
the date or a combination of year and week can be entered.

``` r
tt <- tt_load_gh("2019-01-15")
```

The `tt` object lists the available files for download. To download the
data, use the `tt_download_file()` function. `tt_download_file()` expects the
first argument to be the `tt` object. The second argument can be a
string indicating the name of the file to download from the repository,
or the index in the `tt` object

``` r
agencies <- tt %>% 
  tt_download_file("agencies.csv")

# The first index of the tt object is `agencies.csv`
# agencies <- tt %>% 
#   tt_download_file(1)
```

## Tidy Tuesday Details

The tt\_data and tt objects both have a function for showing the readme
for that week called `readme()`. In addition, the print methods for both
objects show the readme in a viewer and the available datasets in the
console.

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

## Contributing

Please note that the ‘tidytuesdayR’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.

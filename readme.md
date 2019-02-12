tidytuesdayR
================
Ellis Hughes


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

Finally, to access the datasets, use the `$` access and the name of the dataset

``` r 
tt_data$agencies
```



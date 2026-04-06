# tt_load_gh errors when incorrect date

    Code
      (expect_pkg_error_classes(tt_load_gh("2019-01-16"), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.date()`:
      ! 2019-01-16 does not have TidyTuesday data.
      i Did you mean 2019-01-15?

# print.tt lists all the available files for the weeks tt

    Code
      test_result <- print(tt)
    Message
      Available datasets in this TidyTuesday:
      	agencies.csv 
      	launches.csv 
      	


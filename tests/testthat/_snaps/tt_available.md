# tt_datasets throws errors when asking for invalid years

    Code
      tt_datasets(2017)
    Condition <tidytuesdayR-error-invalid_year>
      Error in `tt_check_year()`:
      ! TidyTuesday did not exist in 2017 (or 2017 is in the future).
      i Available years: 2018, 2019, 2020, 2021, 2022, 2023, and 2024

# printing tt_datasets returns all the values as a printed data.frame if not interactive

    Code
      print(ds, is_interactive = FALSE)
    Output
        a b
      1 1 3
      2 2 4

# printing tt_available returns all the values as a printed data.frame if not interactive

    Code
      print(ds, is_interactive = FALSE)
    Output
      Year: test_year
      
        a b
      1 1 3
      2 2 4
      
      


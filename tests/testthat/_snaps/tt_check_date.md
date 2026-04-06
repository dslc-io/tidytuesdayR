# Close dates are suggested if provided date is incorrect

    Code
      (expect_pkg_error_classes(tt_check_date("2019-04-04"), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.date()`:
      ! 2019-04-04 does not have TidyTuesday data.
      i Did you mean 2019-04-02?

# Invalid weeks throw errors

    Code
      (expect_pkg_error_classes(tt_check_date(2018, 20), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.year()`:
      ! Week 20 does not have TidyTuesday data in 2018.
      i Please choose a valid week from 1-19, 21-38

---

    Code
      (expect_pkg_error_classes(tt_check_date(2018, 0), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.year()`:
      ! `week` must be a valid positive integer value.

---

    Code
      (expect_pkg_error_classes(tt_check_date(2018, 7), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.year()`:
      ! The dataset for 2018 week 7 is dirty and cannot be automatically loaded.

---

    Code
      (expect_pkg_error_classes(tt_check_date(2018, 8), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.year()`:
      ! The dataset for 2018 week 8 is dirty and cannot be automatically loaded.

---

    Code
      (expect_pkg_error_classes(tt_check_date(2020, 1), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.year()`:
      ! Week 1 of 2020 does not have data available for download.

# invalid entries are flagged

    Code
      (expect_pkg_error_classes(tt_check_date("xyz"), "tidytuesdayR", "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date()`:
      ! Entries must render to a valid date or year

# tt_check_year checks years

    Code
      (expect_pkg_error_classes(tt_check_year(2015), "tidytuesdayR", "invalid_year"))
    Output
      <error/tidytuesdayR-error-invalid_year>
      Error in `tt_check_year()`:
      ! TidyTuesday did not exist in 2015 (or 2015 is in the future).
      i Available years: 2024, 2023, 2022, 2021, 2020, 2019, and 2018

# tt_check_date errors informatively with no args

    Code
      (expect_pkg_error_classes(tt_check_date(), "tidytuesdayR", "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date()`:
      ! Provide either the year & week or the date of the TidyTuesday dataset.

# tt_check_date errors informatively for the dirtiest dataset

    Code
      (expect_pkg_error_classes(tt_check_date("2018-05-15"), "tidytuesdayR",
      "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `tt_check_date.date()`:
      ! The dataset for 2018-05-15 is dirty and cannot be automatically loaded.


# last_tuesday errors with bad dates

    Code
      (expect_pkg_error_classes(last_tuesday("blue"), "tidytuesdayR", "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `last_tuesday()`:
      ! "blue" cannot be coerced to a <Date>.

---

    Code
      (expect_pkg_error_classes(last_tuesday(1), "tidytuesdayR", "invalid_date"))
    Output
      <error/tidytuesdayR-error-invalid_date>
      Error in `last_tuesday()`:
      ! 1 cannot be coerced to a <Date>.


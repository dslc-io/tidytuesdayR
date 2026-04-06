# tt_download_file errors for bad index

    Code
      (expect_pkg_error_classes(tt_download_file(tt, 3), "tidytuesdayR", "bad_index"))
    Output
      <error/tidytuesdayR-error-bad_index>
      Error:
      ! File 3 not found in the available files for 2019-01-15.

---

    Code
      (expect_pkg_error_classes(tt_download_file(tt, "bad_filename"), "tidytuesdayR",
      "bad_index"))
    Output
      <error/tidytuesdayR-error-bad_index>
      Error:
      ! File bad_filename not found in the available files for 2019-01-15.


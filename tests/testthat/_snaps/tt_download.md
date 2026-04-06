# tt_download errors for bad file

    Code
      (expect_pkg_error_classes(tt_download(tt, "bad_filename"), "tidytuesdayR",
      "bad_file"))
    Output
      <error/tidytuesdayR-error-bad_file>
      Error in `tt_download()`:
      ! `files` must be one or more of "agencies.csv" or "launches.csv", or "All".


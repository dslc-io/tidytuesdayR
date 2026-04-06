# ensure_arg_filled errors informatively

    Code
      (expect_pkg_error_classes(ensure_arg_filled("", question = "", arg_name = "myArg"),
      "tidytuesdayR", "required_arg"))
    Output
      <error/tidytuesdayR-error-required_arg>
      Error:
      ! `myArg` is required.

# format_image_data errors informatively

    Code
      (expect_pkg_error_classes(format_image_data(c("a", "b"), "c"), "tidytuesdayR",
      "image_data"))
    Output
      <error/tidytuesdayR-error-image_data>
      Error in `format_image_data()`:
      ! Please provide at least one image filename and corresponding alt text.

# ensure_arg_filled errors informatively for NULL (#142)

    Code
      (expect_pkg_error_classes(ensure_arg_filled(NULL, question = "", arg_name = "myArg"),
      "tidytuesdayR", "required_arg"))
    Output
      <error/tidytuesdayR-error-required_arg>
      Error:
      ! `myArg` is required.


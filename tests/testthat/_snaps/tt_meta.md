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

# format_image_data errors when alt text exceeds 1000 characters (#163)

    Code
      (expect_pkg_error_classes(format_image_data("a.png", strrep("x", 1001)),
      "tidytuesdayR", "image_data", "alt_text"))
    Output
      <error/tidytuesdayR-error-image_data-alt_text>
      Error in `format_image_data()`:
      ! Alt text must be 1000 characters or fewer (Mastodon limit).

# ensure_arg_filled errors informatively for NULL (#142)

    Code
      (expect_pkg_error_classes(ensure_arg_filled(NULL, question = "", arg_name = "myArg"),
      "tidytuesdayR", "required_arg"))
    Output
      <error/tidytuesdayR-error-required_arg>
      Error:
      ! `myArg` is required.


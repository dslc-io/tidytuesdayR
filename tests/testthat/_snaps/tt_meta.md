# ensure_arg_filled errors informatively

    Code
      ensure_arg_filled("", question = "", arg_name = "myArg")
    Condition <tidytuesdayR-error-required_arg>
      Error:
      ! `myArg` is required.

# format_image_data errors informatively

    Code
      format_image_data(c("a", "b"), "c")
    Condition <tidytuesdayR-error-image_data>
      Error in `format_image_data()`:
      ! Please provide at least one image filename and corresponding alt text.

# format_image_data errors when alt text exceeds 1000 characters (#163)

    Code
      format_image_data("a.png", strrep("x", 1001))
    Condition <tidytuesdayR-error-image_data-alt_text>
      Error in `format_image_data()`:
      ! Alt text must be 1000 characters or fewer (Mastodon limit).

# ensure_arg_filled errors informatively for NULL (#142)

    Code
      ensure_arg_filled(NULL, question = "", arg_name = "myArg")
    Condition <tidytuesdayR-error-required_arg>
      Error:
      ! `myArg` is required.


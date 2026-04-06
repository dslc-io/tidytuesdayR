# ensure_arg_filled errors informatively

    Code
      ensure_arg_filled("", question = "", arg_name = "myArg")
    Condition
      Error:
      ! `myArg` is required.

# format_image_data errors informatively

    Code
      format_image_data(c("a", "b"), "c")
    Condition
      Error in `format_image_data()`:
      ! Please provide at least one image filename and corresponding alt text.

# ensure_arg_filled errors informatively for NULL (#142)

    Code
      ensure_arg_filled(NULL, question = "", arg_name = "myArg")
    Condition
      Error:
      ! `myArg` is required.


# Extracted from test-tt_meta.R:63

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "tidytuesdayR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
expect_snapshot(
    {
      ensure_arg_filled(NULL, question = "", arg_name = "myArg")
    },
    error = TRUE
  )

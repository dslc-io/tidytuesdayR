# .pkg_abort() throws a classed tidytuesdayR error (#149)

    Code
      (expect_pkg_error_classes(.pkg_abort("This is a test error.", "test_subclass"),
      "tidytuesdayR", "test_subclass"))
    Output
      <error/tidytuesdayR-error-test_subclass>
      Error:
      ! This is a test error.


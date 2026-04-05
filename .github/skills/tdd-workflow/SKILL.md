---
name: tdd-workflow
trigger: writing or reviewing tests
description: Test-driven development workflow. Use when writing any R code (writing new features, fixing bugs, refactoring, or reviewing tests).
---

# TDD workflow

## Core principle

Write a failing test first, then implement the minimal code to make it pass, then refactor. Never write implementation code without a failing test driving it.

## File naming

Tests for `R/{name}.R` go in `tests/testthat/test-{name}.R`. Place new tests next to similar existing ones.

## Running tests

```r
# Full suite
devtools::test(reporter = "check")

# Single file
devtools::test(filter = "name", reporter = "check")
```

Testing functions load code automatically. You do not need to call `library()` or `devtools::load_all()` separately.

## Coverage

Goal: **100%** for every edited file. After editing `R/file_name.R`, verify:

```r
covr_res <- devtools:::test_coverage_active_file("R/file_name.R")
which(purrr::map_int(covr_res, "value") == 0)
```

Files excluded from the coverage requirement:
- `R/*-package.R`
- `R/aaa-shared_params.R`
- Files matching `R/import-standalone-*.R`

## Test types

### Unit tests

Test individual functions in isolation:

```r
test_that("fetch_records() returns a tibble (#2)", {
  result <- fetch_records(sample_input)
  expect_s3_class(result, "tbl_df")
})
```

### Integration tests

Test end-to-end pipelines through multiple functions:

```r
test_that("build_report() produces expected output (#15)", {
  input <- data.frame(value = c(1.123, 2.456, NA))
  result <- build_report(input, tempfile())
  expect_equal(nrow(result), 2L)
})
```

### Snapshot tests

For complex outputs that are hard to specify with equality assertions:

```r
test_that("build_summary print method is stable (#123)", {
  expect_snapshot(print(build_summary(sample_data)))
})
```

When snapshots change intentionally, check the content of the file corresponding to the edited test file, then accept:

```r
testthat::snapshot_accept("test_name")
```

Snapshots are stored in `tests/testthat/_snaps/`. The filename corresponds to the R file being tested, ending with `.md`.

## Test design principles

- **Self-sufficient:** each test contains its own setup, execution, and assertion. Tests must be runnable in isolation.
- **Duplication over factoring:** repeat setup code rather than extracting it. Clarity beats DRY in tests.
- **One concept per test:** a failing test should tell you exactly what broke.
- **Minimal with few comments:** keep tests lean. Avoid over-commenting.
- **Issue reference in description:** the `desc` of every new `test_that()` call should end with one or more parenthetical issue references for the issue(s) *verified by those tests* — typically the issue currently being solved. **Never guess or invent issue numbers.** Determine the number from the user's prompt, the branch name (`git branch --show-current`), or `gh issue list`. Before writing a number, verify you can trace it to one of these sources. If no tracked issue applies, use `#noissue`. The numbers in the examples below are illustrative placeholders — do not copy them:
  ```r
  test_that("fetch_records() returns correct columns (#1)", { ... })
  test_that("build_summary() returns correct columns (#2, #3)", { ... })
  test_that(".check_record() errors on empty input (#noissue)", { ... })
  ```

## testthat Edition 3 — deprecated patterns

```r
# Deprecated → Modern
context("Data validation")        # Remove — filename serves this purpose
expect_equivalent(x, y)          # expect_equal(x, y, ignore_attr = TRUE)
with_mock(...)                    # local_mocked_bindings(...)
expect_is(x, "data.frame")       # expect_s3_class(x, "data.frame")
```

## Essential expectations

### Equality & identity

```r
expect_equal(x, y)                        # with numeric tolerance
expect_equal(x, y, tolerance = 0.001)
expect_equal(x, y, ignore_attr = TRUE)
expect_identical(x, y)                    # exact match
```

### Conditions

**Errors thrown by this package** (via `.pkg_abort()`) should always be tested
with `stbl::expect_pkg_error_snapshot()`, which captures both the error class
hierarchy and the user-facing message in one snapshot:

```r
test_that("process_data() errors on empty input (#42)", {
  stbl::expect_pkg_error_snapshot(
    process_data(data.frame()),
    "tidytuesdayR",
    "empty_input"
  )
})
```

Pass `transform = stbl::.transform_path(path)` to scrub volatile values (e.g. temp
paths) from the snapshot before comparison.

**Errors thrown by `stbl`** (via `stbl::to_*()` / `stbl::stabilize_*()`)
should be tested with `stbl::expect_pkg_error_classes()`. Since the message
text is controlled by `stbl`, only the class hierarchy needs to be asserted:

```r
test_that("process_data() errors on non-integer page_size (#43)", {
  stbl::expect_pkg_error_classes(
    process_data(sample_data, page_size = "abc"),
    "stbl",
    "incompatible_type"
  )
})
```

For **composite** stbl error classes (where the class name contains dashes,
e.g. `stbl-error-coerce-character`), pass each dash-separated component as a
separate argument. Underscores within a component are kept as-is:

```r
test_that("process_data() errors on non-coercible input (#43)", {
  stbl::expect_pkg_error_classes(
    process_data(sample_data, value = list(bad = "input")),
    "stbl",
    "coerce",
    "character"
  )
})
```

**Errors from other packages** can be tested with `expect_error()`, optionally
wrapped in `expect_snapshot()` to lock down the message text:

```r
expect_error(code, "pattern")
expect_error(code, class = "some-error-class")

# Lock down both class and message text:
test_that("fetch_records errors on invalid input (#456)", {
  expect_snapshot(
    (expect_error(
      fetch_records("not valid input"),
      class = "pkg-error"
    ))
  )
})
```

```r
expect_warning(code)
expect_no_warning(code)
expect_message(code)
expect_no_message(code)
```

### Collections

```r
expect_setequal(x, y)           # same elements, any order
expect_in(element, set)
expect_named(x, c("a", "b"))
```

### Type & structure

```r
expect_type(x, "double")
expect_s3_class(x, "tbl_df")
expect_length(x, 10)
expect_null(x)
```

### Logical

These expectations are a last resort when more-specific checks aren't available.

```r
expect_true(x)
expect_false(x)
```

## `withr` patterns for temporary state

```r
withr::local_options(list(tidytuesdayR.verbose = TRUE))
withr::local_envvar(MY_VAR = "value")
withr::local_tempfile(lines = c("a", "b"))
```

## Fixtures

Store static test data in `tests/testthat/fixtures/` and access via:

```r
test_path("fixtures", "sample.rds")
```

## Mocking

Mock functions that might have unstable output, hit external servers, etc.

```r
local_mocked_bindings(
  .other_fn = function(...) "mocked_result"
)
result <- my_function_that_calls_other_fn()
```

## Common mistakes

- **Do not modify tests to make them pass.** Fix the implementation.
- **Do not write tests that depend on other tests' state.** Each test must be independently runnable.
- **Ask for help if test is bad.** If you think a test might be invalid, do not loop through trying to make impossible tests pass. Ask for help if possible.

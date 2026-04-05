---
name: document
trigger: document functions
description: Document package functions. Use when asked to document functions.
---

# Document functions

*All* R functions in `R/` should be documented in roxygen2 `#'` style, including internal/unexported functions.

- Run `air format .` then `devtools::document()` after changing any roxygen2 docs.
- Use sentence case for all headings.
- Wrap roxygen comments at 80 characters.
- Files matching `R/import-standalone-*.R` are imported from other packages and have their own conventions. Do not modify their documentation.
- After documenting functions, run `devtools::document(roclets = c('rd', 'collate', 'namespace'))`.
- If `_pkgdown.yml` exists and contains a `reference` section:
  - Whenever you add a new (non-internal) documentation topic, also add the topic to `_pkgdown.yml`.
  - Use `pkgdown::check_pkgdown()` to check that all topics are included in the reference index.

## Shared parameters

**Parameters used in more than one function** go in `R/aaa-shared_params.R` under `@name .shared-params`. Functions inherit them with `@inheritParams .shared-params`. See `R/aaa-shared_params.R` for current definitions (if it exists).

Shared params blocks: alphabetize parameters, use `@name .shared-params` (with leading dot), include `@keywords internal`, end with `NULL`.

Multiple shared-params groups (e.g. `.shared-params-io`, `.shared-params-parsing`) are appropriate when parameters are only shared within a file and closely related files.

## Parameter documentation format

```r
#' @param param_name (`TYPE`) Brief description (usually 1-3 sentences. Can
#'   include [cross_references()]. Additional details on continuation lines if
#'   needed.
```

Function-specific `@param` definitions always appear *before* any `@inheritParams` lines. If all parameters are defined locally, omit `@inheritParams` entirely.

### Type notation

| Notation | Meaning |
|----------|---------|
| ``(`character`)`` | Character vector |
| ``(`character(1)`)`` | Single string |
| ``(`logical(1)`)`` | Single logical |
| ``(`integer`)`` | Integer vector |
| ``(`integer(1)`)`` | Single integer |
| ``(`double`)`` | Double vector |
| ``(`vector(0)`)`` | A prototype (zero-length vector) |
| ``(`vector`)`` | A vector of unspecified type |
| ``(`list`)`` | List |
| ``(`data.frame`)`` | Data frame or tibble |
| ``(`function` or `NULL`)`` | A function or NULL |
| ``(`my_class`)`` | A class-specific type (use the actual class name) |
| ``(`any`)`` | Any type |

### Enumerated values

When a parameter takes one of a fixed set of values, document them with a bullet list:

```r
#' @param method (`character(1)`) The aggregation method. Can be one of:
#'   * `"mean"`: Arithmetic mean.
#'   * `"median"`: Median value.
#'   * `"sum"`: Total sum.
```

## Returns

Use `@returns` (not `@return`). Include a type when it's informative:

```r
#' @returns A summary tibble.
#' @returns (`logical(1)`) `TRUE` if `x` is a valid record.
#' @returns Either a tibble or a list, depending on the input.
#' @returns `NULL` (invisibly).
```

**Structured returns with columns:**

```r
#' @returns A [tibble::tibble()] with columns:
#'   - `name`: Record name.
#'   - `value`: Numeric value.
#'   - `status`: Status (`"active"` or `"inactive"`).
```

## Exported functions

```r
#' Title in sentence case
#'
#' Description paragraph providing context and details.
#'
#' @param param_name (`TYPE`) Description.
#' @inheritParams .shared-params
#'
#' @returns Description of return value.
#' @seealso [related_function()]
#' @export
#'
#' @examples
#' example_code()
```

- Blank `#'` lines separate: title/description, description/params, and `@export`/`@examples`.
- `@seealso` (optional) goes between `@returns` and `@export`.
- `@details` can supplement the description when needed.

## Internal (unexported) functions

Internal helpers (identified by a dot prefix, e.g. `.parse_response()`) use abbreviated documentation. Mark them with `@keywords internal` and omit `@export`:

```r
#' Title in sentence case
#'
#' @param one_off_param (`TYPE`) Description.
#' @inheritParams .shared-params
#' @returns (`TYPE`) What it returns.
#' @keywords internal
```

Description paragraph is optional (only include when usage isn't obvious), fewer blank `#'` lines, and no `@examples`.

## S3 methods and `@rdname` grouping

Use `@rdname` to group related functions under one help page. This applies to:
- **S3 methods we own** (generic defined in this package): generic gets full docs, methods get `@rdname` + `@export`.
- **Related exported functions** (e.g. multiple variants of the same operation): primary function gets full docs, variants get `@rdname` + `@export`.

```r
#' Format a summary object
#'
#' @param x (`any`) The object to format.
#' @param ... Additional arguments passed to methods.
#' @returns A formatted character string.
#' @keywords internal
.format_summary <- function(x, ...) {
  UseMethod(".format_summary")
}

#' @rdname .format_summary
#' @export
.format_summary.data_summary <- function(x, ...) {
  # method implementation
}
```

**S3 methods we don't own** (generic from another package) need standalone documentation:

```r
#' Title describing the method
#'
#' @param x (`TYPE`) Description.
#' @param ... Additional arguments (ignored).
#' @returns Description.
#' @exportS3Method pkg::generic
method.class <- function(x, ...) { ... }
```

## Style notes

**Cross-references:** Use square brackets — `[fetch_records()]` (internal), `[tibble::tibble()]` (external), `[topic_name]` (topics).

**Section comment headers** optionally organize code within a file, lowercase with dashes to column 80:

```r
# helpers ----------------------------------------------------------------------
```

Only use such headers in complex files. The need for section comment headers might indicate that the file should be split into multiple files.

**Examples:** Exported functions include `@examples`. Use `@examplesIf interactive()` for network-dependent or slow functions. Use section-style comments (`# Section ---`) to organize longer example blocks. Internal functions do not get examples.

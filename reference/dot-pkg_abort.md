# Raise a package-scoped error

Raise a package-scoped error

## Usage

``` r
.pkg_abort(
  message,
  subclass,
  call = rlang::caller_env(),
  message_env = rlang::caller_env(),
  ...
)
```

## Arguments

- message:

  (`character`) The message for the new error. Messages will be
  formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- subclass:

  (`character`) Class(es) to assign to the error. Will be prefixed by
  "{package}-error-".

- call:

  (`environment`) The caller environment for error messages.

- message_env:

  (`environment`) The execution environment to use to evaluate variables
  in error messages.

- ...:

  Additional parameters passed to
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  and on to
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html).

## Value

Does not return.

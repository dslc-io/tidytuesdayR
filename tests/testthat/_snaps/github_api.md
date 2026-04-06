# gh_extract_text errors with empty response

    Code
      (expect_pkg_error_classes(gh_extract_text(list()), "tidytuesdayR",
      "bad_gh_response"))
    Output
      <error/tidytuesdayR-error-bad_gh_response>
      Error in `gh_extract_text()`:
      ! No content found in `gh_response`.

# gh_extract_html errors with empty response

    Code
      (expect_pkg_error_classes(gh_extract_html(list()), "tidytuesdayR",
      "bad_gh_response"))
    Output
      <error/tidytuesdayR-error-bad_gh_response>
      Error in `gh_extract_html()`:
      ! No html found in `gh_response`.

# gh_extract_sha_in_folder errors for missing file

    Code
      (expect_pkg_error_classes(gh_extract_sha_in_folder(list(), "missing_file_name"),
      "tidytuesdayR", "file_not_found"))
    Output
      <error/tidytuesdayR-error-file_not_found>
      Error in `gh_extract_sha_in_folder()`:
      ! File "missing_file_name" not found in folder.
      i Found no files:

---

    Code
      (expect_pkg_error_classes(gh_extract_sha_in_folder(list(list(name = "found_file_name")),
      "missing_file_name"), "tidytuesdayR", "file_not_found"))
    Output
      <error/tidytuesdayR-error-file_not_found>
      Error in `gh_extract_sha_in_folder()`:
      ! File "missing_file_name" not found in folder.
      i Found 1 file: "found_file_name"

# gh_auth_check makes sure auth looks valid

    Code
      (expect_pkg_error_classes(gh_auth_check(""), "tidytuesdayR", "bad_gh_auth"))
    Output
      <error/tidytuesdayR-error-bad_gh_auth>
      Error in `gh_auth_check()`:
      x `auth` is not a valid github token.
      i See the `vignette(gh::managing-personal-access-tokens)` vignette.

---

    Code
      (expect_pkg_error_classes(gh_auth_check(structure("", class = "gh_pat")),
      "tidytuesdayR", "bad_gh_auth"))
    Output
      <error/tidytuesdayR-error-bad_gh_auth>
      Error in `gh_auth_check()`:
      x `auth` is not a valid github token.
      i See the `vignette(gh::managing-personal-access-tokens)` vignette.


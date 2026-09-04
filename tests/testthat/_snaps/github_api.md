# gh_extract_text errors with empty response

    Code
      gh_extract_text(list())
    Condition <tidytuesdayR-error-bad_gh_response>
      Error in `gh_extract_text()`:
      ! No content found in `gh_response`.

# gh_extract_html errors with empty response

    Code
      gh_extract_html(list())
    Condition <tidytuesdayR-error-bad_gh_response>
      Error in `gh_extract_html()`:
      ! No html found in `gh_response`.

# gh_extract_sha_in_folder errors for missing file

    Code
      gh_extract_sha_in_folder(list(), "missing_file_name")
    Condition <tidytuesdayR-error-file_not_found>
      Error in `gh_extract_sha_in_folder()`:
      ! File "missing_file_name" not found in folder.
      i Found no files:

---

    Code
      gh_extract_sha_in_folder(list(list(name = "found_file_name")),
      "missing_file_name")
    Condition <tidytuesdayR-error-file_not_found>
      Error in `gh_extract_sha_in_folder()`:
      ! File "missing_file_name" not found in folder.
      i Found 1 file: "found_file_name"

# gh_auth_check makes sure auth looks valid

    Code
      gh_auth_check("")
    Condition <tidytuesdayR-error-bad_gh_auth>
      Error in `gh_auth_check()`:
      x `auth` is not a valid github token.
      i See the `vignette(gh::managing-personal-access-tokens)` vignette.

---

    Code
      gh_auth_check(structure("", class = "gh_pat"))
    Condition <tidytuesdayR-error-bad_gh_auth>
      Error in `gh_auth_check()`:
      x `auth` is not a valid github token.
      i See the `vignette(gh::managing-personal-access-tokens)` vignette.


#' Create and open intro.md
#'
#' When curating a TidyTuesday dataset, you need to introduce the dataset. This
#' function creates a simple `intro.md` file in the specified path (creating
#' that path if it does not already exist), and (if possible) opens it for
#' editing.
#'
#' @inheritParams usethis::use_template
#' @inheritParams .shared-params
#'
#' @returns A logical vector indicating whether the file was created or
#'   modified, invisibly.
#' @export
#'
#' @examplesIf interactive()
#'
#'   tt_intro()
tt_intro <- function(
  path = "tt_submission",
  open = rlang::is_interactive(),
  ignore = FALSE
) {
  prep_tt_curate(path, ignore = ignore)
  intro_path <- fs::path(path, "intro.md")

  usethis::use_template(
    "intro.md",
    save_as = intro_path,
    ignore = ignore,
    open = open,
    package = "tidytuesdayR"
  )
}

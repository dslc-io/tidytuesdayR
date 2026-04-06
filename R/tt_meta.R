#' Create and open meta.yaml
#'
#' We need a set of metadata information about each TidyTuesday dataset. Use
#' this function to set up the `meta.yaml` file for your submission (and create
#' the submission directory if it does not already exist). If you do not provide
#' values for the parameters, you will be prompted to enter them in an
#' interactive session.
#'
#' @inheritParams usethis::use_template
#' @inheritParams shared-params
#' @param title A short title for your submission. It should fit into the
#'   sentence "This week we're exploring `title`!" For example, for "This week
#'   we're exploring The 50 US States!", the `title` would be `"The 50 US
#'   States"`.
#' @param article_title The title of an article or other website that has
#'   something to do with the data. This should usually be an article that uses
#'   or describes the dataset, but any related website is acceptable.
#' @param article_url The URL of the article whose title is `article_title`.
#' @param source_title The title of the source of the dataset. This is usually a
#'   website, but might be an R package or a journal article, for example.
#' @param source_url A URL associated with the source. Ideally this should be a
#'   URL where users can download the data, but, if that isn't possible, provide
#'   a URL that is somehow related to the source of the data.
#' @param image_filename A character vector with at least one file name for an
#'   image to accompany the post. This might be a plot of the data, or some othe
#'   image somehow connected to the data.
#' @param image_alt Text that can take the place of the image for a visually
#'   impaired user or anybody else who cannot see the image. Don't just say "A
#'   plot of the data", but rather describe what information you can glean from
#'   the plot, such as "A map of the continental United States, with each state
#'   colored in shades of blue by population as of 1975. California and New York
#'   are the lightest, indicating the highest population. Maine, New Hampshire,
#'   Vermont, and the Plains States are all quite dark, indicating low
#'   population."
#' @param attribution Your name as you would like it to appear when we credit
#'   you in the post for this dataset. You can include a title and/or
#'   affiliation if you like, such as "Jon Harmon, Executive Director, Data
#'   Science Learning Community". Defaults to
#'   `getOption("tidytuesdayR.attribution")`. We recommend setting this option
#'   in your `.Rprofile` with `usethis::edit_r_profile()` so you don't have to
#'   provide it every time you submit a dataset.
#' @param github Your GitHub username, or a link to your profile on GitHub.
#' @param bluesky Your Bluesky username, or a link to your profile on Bluesky.
#'   Leave as `NULL` if you do not wish to be credited on Bluesky. Defaults to
#'   `getOption("tidytuesdayR.bluesky")`.
#' @param linkedin Your LinkedIn username, or a link to your profile on LinkedIn.
#'   Leave as `NULL` if you do not wish to be credited on LinkedIn. Defaults to
#'   `getOption("tidytuesdayR.linkedin")`.
#' @param mastodon Your mastodon server and username, or a link to your profile
#'   on a mastodon server. Leave as `NULL` if you do not wish to be credited on
#'   Mastodon. Defaults to `getOption("tidytuesdayR.mastodon")`.
#'
#' @returns A logical vector indicating whether the file was created or
#'   modified, invisibly.
#' @export
#'
#' @examplesIf interactive()
#'
#'   tt_meta()
tt_meta <- function(
  path = "tt_submission",
  title,
  article_title,
  article_url,
  source_title,
  source_url,
  image_filename,
  image_alt,
  attribution = getOption("tidytuesdayR.attribution"),
  github = gh::gh_whoami()$login,
  bluesky = getOption("tidytuesdayR.bluesky"),
  linkedin = getOption("tidytuesdayR.linkedin"),
  mastodon = getOption("tidytuesdayR.mastodon"),
  open = rlang::is_interactive(),
  ignore = FALSE
) {
  prep_tt_curate(path, ignore = ignore)
  meta_path <- fs::path(path, "meta.yaml")

  title <- ensure_arg_filled(
    rlang::maybe_missing(title),
    "What is the title of your submission?"
  )
  article_title <- ensure_arg_filled(
    rlang::maybe_missing(article_title),
    "What is the title of an article related to your submission?"
  )
  article_url <- ensure_arg_filled(
    rlang::maybe_missing(article_url),
    "What is the url of an article related to your submission?"
  )
  source_title <- ensure_arg_filled(
    rlang::maybe_missing(source_title),
    "What is the title of the source of the data in your submission?"
  )
  source_url <- ensure_arg_filled(
    rlang::maybe_missing(source_url),
    "What is the url of the source of the data your submission?"
  )
  images <- format_image_data(
    rlang::maybe_missing(image_filename),
    rlang::maybe_missing(image_alt)
  )
  attribution <- ensure_arg_filled(
    rlang::maybe_missing(attribution),
    "How would you like us to credit you in the post (your name and possibly affiliation)?"
  )
  social_media <- format_social_media(
    github = github,
    bluesky = bluesky,
    linkedin = linkedin,
    mastodon = mastodon
  )
  credits <- c(
    list(
      c(
        attribution_type = "post",
        attribution_text = attribution
      )
    ),
    social_media
  )

  usethis::use_template(
    "meta.yaml",
    save_as = meta_path,
    data = list(
      title = title,
      article_title = article_title,
      article_url = article_url,
      source_title = source_title,
      source_url = source_url,
      images = images,
      credits = credits
    ),
    ignore = ignore,
    open = open,
    package = "tidytuesdayR"
  )
}

ensure_arg_filled <- function(
  var,
  question,
  arg_name = rlang::caller_arg(var),
  call = rlang::caller_env()
) {
  arg_name <- remove_caller_arg_missing(arg_name)
  if (
    rlang::is_interactive() && (rlang::is_missing(var) || rlang::is_null(var))
  ) {
    # nocov start
    question <- paste0("\n", stringr::str_trim(question), "\n")
    cat(question)
    var <- readline()
  } # nocov end
  if (rlang::is_empty(var) || identical(var, "")) {
    .pkg_abort(
      "{.arg {arg_name}} is required.",
      "required_arg",
      call = call
    )
  }
  return(var)
}

format_image_data <- function(image_filename, image_alt) {
  image_filename <- ensure_arg_filled(
    rlang::maybe_missing(image_filename),
    "What is the image filename?"
  )
  image_alt <- ensure_arg_filled(
    rlang::maybe_missing(image_alt),
    "What text could serve in place of the image for a visually impaired person?"
  )
  if (length(image_filename) && length(image_alt) == length(image_filename)) {
    return(
      purrr::map2(image_filename, image_alt, function(file, alt) {
        list(image_filename = file, image_alt = alt)
      })
    )
  }
  .pkg_abort(
    "Please provide at least one image filename and corresponding alt text.",
    "image_data"
  )
}

format_social_media <- function(
  github = gh::gh_whoami()$login,
  bluesky = NULL,
  linkedin = NULL,
  mastodon = NULL
) {
  socials <- list(
    c(
      attribution_type = "github",
      attribution_text = format_social_name(github)
    ),
    c(
      attribution_type = "bluesky",
      attribution_text = format_social_name(bluesky)
    ),
    c(
      attribution_type = "linkedin",
      attribution_text = format_social_name(linkedin)
    ),
    c(
      attribution_type = "mastodon",
      attribution_text = format_mastodon(mastodon)
    )
  )
  return(purrr::keep(socials, \(social) {
    "attribution_text" %in%
      names(social) &&
      length(social[["attribution_text"]]) > 0 &&
      social[["attribution_text"]] != ""
  }))
}

format_social_name <- function(social) {
  if (!length(social)) {
    return(NULL)
  }
  username <- stringr::str_extract(social, "([^/@]+)(/)?$", group = 1)
  return(paste0("@", username))
}

format_mastodon <- function(mastodon) {
  # Mastodon might come in as a url (eg, https://fosstodon.org/@jonthegeek), as
  # username@server (eg, jonthegeek@fosstodon.org), or as @username@server (eg,
  # @jonthegeek@fosstodon.org). Any of these should format as @username@server.
  # (eg, @jonthegeek@fosstodon.org).
  if (!length(mastodon)) {
    return(NULL)
  }
  username <- NA
  server <- NA
  if (stringr::str_detect(mastodon, "/")) {
    username <- stringr::str_extract(mastodon, "([^/@]+)(/)?$", group = 1)
    server <- stringr::str_extract(mastodon, "(https://)?([^/]+)", group = 2)
  } else {
    username <- stringr::str_extract(mastodon, "([^@]+)@", group = 1)
    server <- stringr::str_extract(mastodon, "@([^@]+)$", group = 1)
  }
  if (is.na(username) || is.na(server)) {
    .pkg_abort(
      c(
        "Please provide a valid mastodon username and server.",
        i = "eg, yourname@yourserver.org or https://yourserver.org/@yourname"
      ),
      "mastodon_format"
    )
  }
  return(glue::glue("@{username}@{server}"))
}

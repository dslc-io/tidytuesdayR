# Create and open meta.yaml

We need a set of metadata information about each TidyTuesday dataset.
Use this function to set up the `meta.yaml` file for your submission
(and create the submission directory if it does not already exist). If
you do not provide values for the parameters, you will be prompted to
enter them in an interactive session.

## Usage

``` r
tt_meta(
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
)
```

## Arguments

- path:

  The relative path to the directory to hold your submission files
  (`tt_submission` by default). If this directory does not exist, it
  will be created.

- title:

  A short title for your submission. It should fit into the sentence
  "This week we're exploring `title`!" For example, for "This week we're
  exploring The 50 US States!", the `title` would be
  `"The 50 US States"`.

- article_title:

  The title of an article or other website that has something to do with
  the data. This should usually be an article that uses or describes the
  dataset, but any related website is acceptable.

- article_url:

  The URL of the article whose title is `article_title`.

- source_title:

  The title of the source of the dataset. This is usually a website, but
  might be an R package or a journal article, for example.

- source_url:

  A URL associated with the source. Ideally this should be a URL where
  users can download the data, but, if that isn't possible, provide a
  URL that is somehow related to the source of the data.

- image_filename:

  A character vector with at least one file name for an image to
  accompany the post. This might be a plot of the data, or some othe
  image somehow connected to the data.

- image_alt:

  Text that can take the place of the image for a visually impaired user
  or anybody else who cannot see the image. Don't just say "A plot of
  the data", but rather describe what information you can glean from the
  plot, such as "A map of the continental United States, with each state
  colored in shades of blue by population as of 1975. California and New
  York are the lightest, indicating the highest population. Maine, New
  Hampshire, Vermont, and the Plains States are all quite dark,
  indicating low population."

- attribution:

  Your name as you would like it to appear when we credit you in the
  post for this dataset. You can include a title and/or affiliation if
  you like, such as "Jon Harmon, Executive Director, Data Science
  Learning Community". Defaults to
  `getOption("tidytuesdayR.attribution")`. We recommend setting this
  option in your `.Rprofile` with
  [`usethis::edit_r_profile()`](https://usethis.r-lib.org/reference/edit.html)
  so you don't have to provide it every time you submit a dataset.

- github:

  Your GitHub username, or a link to your profile on GitHub.

- bluesky:

  Your Bluesky username, or a link to your profile on Bluesky. Leave as
  `NULL` if you do not wish to be credited on Bluesky. Defaults to
  `getOption("tidytuesdayR.bluesky")`.

- linkedin:

  Your LinkedIn username, or a link to your profile on LinkedIn. Leave
  as `NULL` if you do not wish to be credited on LinkedIn. Defaults to
  `getOption("tidytuesdayR.linkedin")`.

- mastodon:

  Your mastodon server and username, or a link to your profile on a
  mastodon server. Leave as `NULL` if you do not wish to be credited on
  Mastodon. Defaults to `getOption("tidytuesdayR.mastodon")`.

- open:

  Open the newly created file for editing? Happens in RStudio, if
  applicable, or via
  [`utils::file.edit()`](https://rdrr.io/r/utils/file.edit.html)
  otherwise.

- ignore:

  Should the newly created file be added to `.Rbuildignore`?

## Value

A logical vector indicating whether the file was created or modified,
invisibly.

## Examples

``` r
if (FALSE) { # interactive()

  tt_meta()
}
```

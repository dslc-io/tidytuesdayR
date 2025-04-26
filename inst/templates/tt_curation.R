# Using vignette: https://dslc-io.github.io/tidytuesdayR/articles/curating.html
#
# Also available via vignette("curating", "tidytuesdayR")

# Load packages
library(tidytuesdayR)

# Run tt_clean() to create submission folder and cleaning script. The final
# result of the script should be one or more data frames, which we'll save in
# later steps. If the data is already clean, still provide a cleaning script in
# which you comment where the data came from and load it as a data frame.
tt_clean()

# Replace "your_dataset_name" with the name of the data frame created in
# tt_clean(). Run this once per data frame.
tt_save_dataset(your_dataset_name)

# Fill in data dictionary files. If you're using an IDE, they should be open.

# Create introduction to the dataset replacing comments inside "<!--" and "-->".
tt_intro()

# Save a .png image to the tt_submission folder. You might need to create one.

# Provide metadata about your submission.
#
# Example:
tt_meta(
  title = "The 50 US States",
  article_title = "U.S. Department of Commerce, Bureau of the Census",
  article_url = "https://www.census.gov/",
  source_title = "The R datasets package",
  source_url = "https://www.r-project.org/",
  image_filename = "states_population.png",
  image_alt = "A map of the continental United States, with each state colored in shades of blue by population as of 1975. California and New York are the lightest, indicating the highest population. Maine, New Hampshire, Vermont, and the Plains States are all quite dark, indicating low population.",
  attribution = "Jon Harmon, Data Science Learning Community",
  github = "jonthegeek",
  bluesky = "jonthegeek.com",
  linkedin = "jonthegeek",
  mastodon = "fosstodon.org/@jonthegeek"
)

# SAVE ALL YOUR FILES BEFORE SUBMITTING!!
tt_submit()

# If you make changes, run tt_submit() again to update the pull request.

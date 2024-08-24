# Fixtures used in various tests, created by actually hitting APIs while online.
ttmf <- tt_master_file()
saveRDS(ttmf, test_path("fixtures", "ttmf.rds"))

static_contents <- gh_get("static") |>
  purrr::keep(~ .x$name %in% c("tt_data_type.csv", "tt_logo.png"))
saveRDS(static_contents, test_path("fixtures", "static_contents.rds"))
tt_data_type_response <- gh_get("static/tt_data_type.csv")
saveRDS(tt_data_type_response, test_path("fixtures", "tt_data_type_response.rds"))
folder2020_response <- gh_get("data/2020")
saveRDS(folder2020_response, test_path("fixtures", "folder2020_response.rds"))
readme2020_response <- gh_get(
  "data/2020/readme.md",
  .accept = "application/vnd.github.v3.html"
)
saveRDS(readme2020_response, test_path("fixtures", "readme2020_response.rds"))

sample_readme <- gh_get_readme_html(file.path("data", 2020))
xml2::write_html(sample_readme, test_path("fixtures", "year_readme.html"))

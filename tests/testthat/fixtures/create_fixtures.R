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

# Year readmes
readme2018 <- gh_get_readme_html(file.path("data", 2018))
xml2::write_html(readme2018, test_path("fixtures", "readme2018.html"))
readme2019 <- gh_get_readme_html(file.path("data", 2019))
xml2::write_html(readme2019, test_path("fixtures", "readme2019.html"))
readme2020 <- gh_get_readme_html(file.path("data", 2020))
xml2::write_html(readme2020, test_path("fixtures", "readme2020.html"))
readme2021 <- gh_get_readme_html(file.path("data", 2021))
xml2::write_html(readme2021, test_path("fixtures", "readme2021.html"))
readme2022 <- gh_get_readme_html(file.path("data", 2022))
xml2::write_html(readme2022, test_path("fixtures", "readme2022.html"))
readme2023 <- gh_get_readme_html(file.path("data", 2023))
xml2::write_html(readme2023, test_path("fixtures", "readme2023.html"))
readme2024 <- gh_get_readme_html(file.path("data", 2024))
xml2::write_html(readme2024, test_path("fixtures", "readme2024.html"))

# Week readmes
save_readme <- function(date) {
  tt_year <- lubridate::year(date)
  readme <- gh_get_readme_html(file.path("data", tt_year, date))
  xml2::write_html(readme, test_path("fixtures", glue::glue("readme{date}.html")))
}
save_readme("2019-01-15")
save_readme("2019-04-02")
save_readme("2019-04-09")
save_readme("2020-04-21")
save_readme("2022-05-10")

# Files
save_file_response <- function(tt_date, target) {
  file <- glue::glue("response-{tt_date}-{target}.rds")
  path <- test_path("fixtures", file)
  saveRDS(
    tt_download_file_raw(tt_date, target),
    path
  )
}
save_file_response("2019-01-15", "agencies.csv")
save_file_response("2019-01-15", "launches.csv")
save_file_response("2018-04-02", "us_avg_tuition.xlsx")
save_file_response("2022-05-10", "nyt_titles.tsv")


simple_tt_data <- structure(
  list(
    value1 = "value1",
    value2 = "value2"
  ),
  .tt = structure(
    c("value1.csv", "value2.csv"),
    .files = c("value1.csv", "value2.csv"),
    .readme = NULL,
    class = "tt_gh"
  ),
  class = "tt_data"
)
saveRDS(simple_tt_data, test_path("fixtures", "simple_tt_data.rds"))

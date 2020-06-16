context("Load and Download all data from Github")

ref_repo <- options("tidytuesdayR.tt_repo")
options("tidytuesdayR.tt_repo" = "thebioengineer/tt_ref")
on.exit({
  options("tidytuesdayR.tt_repo" = ref_repo[[1]])
})

tt_ref_test_that(
  "tt_load loads all data available", {
  check_api()

  output <- capture.output({
    tt_obj <- tt_load("2019-01-15")
    agencies <- readr::read_csv(
      file.path("https://raw.githubusercontent.com/rfordatascience/tidytuesday",
                "master/data/2019/2019-01-15/agencies.csv"))
    launches <- readr::read_csv(
      file.path("https://raw.githubusercontent.com/rfordatascience/tidytuesday",
                "master/data/2019/2019-01-15/launches.csv"))
  })

  expect_equal(
    tt_obj$agencies,
    agencies
  )

  expect_equal(
    tt_obj$launches,
    launches
  )

})

tt_ref_test_that("tt_load loads excel files properly", {
  check_api()
  output <- capture.output({
    tt_obj <- tt_load("2018-04-02")

    tempExcelFile <- tempfile(fileext = ".xlsx")
    utils::download.file(
      paste0(
        "https://www.github.com/rfordatascience/tidytuesday/raw/master/data/",
        "2018/2018-04-02/us_avg_tuition.xlsx?raw=true"
      ),
      tempExcelFile,
      quiet = TRUE,
      mode = "wb"
    )
  })

  expect_equal(tt_obj$us_avg_tuition, readxl::read_xlsx(tempExcelFile))
})

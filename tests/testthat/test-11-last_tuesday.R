
test_that("last_tuesday will give you the most recent tuesday", {

  ## Look backwards to the last tt
  date_1 <- as.Date("2020-01-01")
  last_tuesday_1 <- last_tuesday(date_1)

  ## Look forwards to the "next" tt (they can be posted on mondays)
  date_2 <- as.Date("2020-01-06")
  last_tuesday_2 <- last_tuesday(date_2)

  ## day of returns same day
  date_3 <- as.Date("2020-01-07")
  last_tuesday_3 <- last_tuesday(date_2)

  expect_equal(
    last_tuesday_1,
    as.Date("2019-12-31")
  )
  expect_equal(
    last_tuesday_2,
    as.Date("2020-01-07")
  )
  expect_equal(
    last_tuesday_3,
    as.Date("2020-01-07")
  )
})


test_that("tt_date will give you the date of the tuesday", {

  ## Look backwards to the last tt
  refdate1 <- tt_date(2018, week = 1)
  refdate2 <- tt_date(2019, week = 1)
  refdate3 <- tt_date(2020, week = 2) # no data available for week 1!

  expect_equal(refdate1,
               as.Date("2018-04-02"))
  expect_equal(refdate2,
               as.Date("2019-01-01"))
  expect_equal(refdate3,
               as.Date("2020-01-07"))
})

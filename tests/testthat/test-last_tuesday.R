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

test_that("last_tuesday errors with bad dates", {
  expect_error(
    {
      last_tuesday("blue")
    },
    "cannot be coerced",
    class = "tt-error-invalid_date"
  )
  expect_error(
    {
      last_tuesday(1)
    },
    "cannot be coerced",
    class = "tt-error-invalid_date"
  )
})

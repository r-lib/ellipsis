context("test-safe")

test_that("warn if unused dots", {
  expect_error(safe_median(1:10), NA)
  expect_error(safe_median(1:10, na.rm = TRUE), NA)
  expect_error(safe_median(1:10, y = 1), class = "rlib_error_dots_unnused")
})

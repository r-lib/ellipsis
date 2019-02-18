context("test-safe")

test_that("warn if unused dots", {
  expect_warning(safe_median(1:10), NA)
  expect_warning(safe_median(1:10, na.rm = TRUE), NA)
  expect_warning(safe_median(1:10, y = 1), "were not used")
})

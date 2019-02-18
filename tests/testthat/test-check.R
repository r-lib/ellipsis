context("test-check")

test_that("can warn if dots named", {
  f <- function(..., xyz = 1) {
    check_dots_unnamed()
  }

  expect_warning(f(1, 2, 3), NA)
  expect_warning(f(1, 2, 3, xyz = 4), NA)
  expect_warning(f(1, 2, 3, xy = 4), "unexpected names")
})

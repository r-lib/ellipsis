context("test-check")

test_that("can warn if dots named", {
  f <- function(..., xyz = 1) {
    check_dots_unnamed()
  }

  expect_warning(f(1, 2, 3), NA)
  expect_warning(f(1, 2, 3, xyz = 4), NA)
  expect_warning(f(1, 2, 3, xy = 4), "unexpected names")
})

test_that("can warn if dots not empty", {
  f <- function(..., xyz = 1) {
    check_dots_empty(...)
  }

  expect_error(f(xyz = 1), NA)
  expect_error(f(xy = 4), "not empty", class = "rlib_error_dots_not_empty")
})

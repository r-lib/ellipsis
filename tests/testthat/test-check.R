context("test-check")

test_that("can warn if dots named", {
  f <- function(..., xyz = 1) {
    check_dots_unnamed(...)
  }

  expect_error(f(1, 2, 3), NA)
  expect_error(f(1, 2, 3, xyz = 4), NA)
  expect_error(f(1, 2, 3, xy = 4), class = "rlib_error_dots_named")
})

test_that("can warn if dots not empty", {
  f <- function(..., xyz = 1) {
    check_dots_empty(...)
  }

  expect_error(f(xyz = 1), NA)
  expect_error(f(xy = 4), class = "rlib_error_dots_nonempty")
})

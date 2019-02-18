context("test-dots")

capture_dots <- function(..., auto_name = TRUE) dots(auto_name = auto_name)

test_that("errors with bad inputs", {
  expect_error(dots(), "No ... found")
  expect_error(dots(1), "not an environment")
})

test_that("no dots yields empty list", {
  expect_equal(capture_dots(), list())
})

test_that("captures names if present", {
  expect_named(capture_dots(x = 1, y = 2), c("x", "y"))
})

test_that("constructs names if absent", {
  expect_named(capture_dots(1, 2), c("..1", "..2"))
})

test_that("unless auto_name = FALSE", {
  expect_named(capture_dots(x = 1, 2, auto_name = FALSE), c("x", NA))
})

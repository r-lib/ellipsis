#' Check that all dots have been used
#'
#' Automatically sets exit handler to run when function terminates, checking
#' that all elements of `...` have been evaluated. If you use [on.exit()]
#' elsewhere in your function, make sure to use `add = TRUE` so that you
#' don't override the handler set up by `check_dots_used()`.
#'
#' @usage NULL
#' @param action The action to take when the dots have not been used. One of
#'   [rlang::abort()], [rlang::warn()], [rlang::inform()] or [rlang::signal()].
#' @param env Environment in which to look for `...` and to set up handler.
#' @export
#' @examples
#' f <- function(...) {
#'   check_dots_used()
#'   g(...)
#' }
#'
#' g <- function(x, y, ...) {
#'   x + y
#' }
#' f(x = 1, y = 2)
#'
#' try(f(x = 1, y = 2, z = 3))
#' try(f(x = 1, y = 2, 3, 4, 5))
check_dots_used <- NULL # Assigned at load time

#' Check that all dots are unnamed
#'
#' Named arguments in ... are often a sign of misspelled argument names.
#'
#' @usage NULL
#' @inheritParams check_dots_used
#' @param env Environment in which to look for `...`.
#' @export
#' @examples
#' f <- function(..., foofy = 8) {
#'   check_dots_unnamed()
#'   c(...)
#' }
#'
#' f(1, 2, 3, foofy = 4)
#' try(f(1, 2, 3, foof = 4))
check_dots_unnamed <- NULL # Assigned at load time

#' Check that dots are unused
#'
#' Sometimes you just want to use `...` to force your users to fully name
#' the details arguments. This function warns if `...` is not empty.
#'
#' @usage NULL
#' @inheritParams check_dots_used
#' @param env Environment in which to look for `...`.
#' @export
#' @examples
#' f <- function(x, ..., foofy = 8) {
#'   check_dots_empty()
#'   x + foofy
#' }
#'
#' try(f(1, foof = 4))
#' f(1, foofy = 4)
check_dots_empty <- NULL # Assigned at load time

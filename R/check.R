#' Check that all dots have been used
#'
#' Automatically sets exit handler to run when function terminates, checking
#' that all elements of `...` have been evaluated. If you use [on.exit()]
#' elsewhere in your function, make sure to use `add = TRUE` so that you
#' don't override the handler set up by `check_dots_used()`.
#'
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
check_dots_used <- function(env = parent.frame()) {
  eval_bare(exit_handler, env)
  invisible()
}

check_dots <- function(env = parent.frame()) {
  if (.Call(ellipsis_dots_used, env)) {
    return(invisible())
  }

  proms <- dots(env)
  used <- vapply(proms, promise_forced, logical(1))

  unnused <- names(proms)[!used]
  stop_dots(
    message = paste0(length(unnused), " components of `...` were not used."),
    dot_names = unnused,
    .subclass = "rlib_error_dots_unnused"
  )
}

exit_handler <- bquote(
  on.exit({
    .(check_dots)(environment())
  }, add = TRUE)
)

#' Check that all dots are unnamed
#'
#' Named arguments in ... are often a sign of misspelled argument names.
#'
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
check_dots_unnamed <- function(env = parent.frame()) {
  proms <- dots(env, auto_name = FALSE)
  if (length(proms) == 0) {
    return()
  }

  unnamed <- is.na(names(proms))
  if (all(unnamed)) {
    return(invisible())
  }

  named <- names(proms)[!unnamed]
  stop_dots(
    message = paste0(length(named), " components of `...` had unexpected names."),
    dot_names = named,
    .subclass = "rlib_error_dots_named"
  )
}


#' Check that dots are unused
#'
#' Sometimes you just want to use `...` to force your users to fully name
#' the details arguments. This function warns if `...` is not empty.
#'
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
check_dots_empty <- function(env = parent.frame()) {
  dots <- dots(env)
  if (length(dots) == 0) {
    return()
  }

  stop_dots(
    message = "`...` is not empty.",
    dot_names = names(dots),
    note = "These dots only exist to allow future extensions and should be empty.",
    .subclass = "rlib_error_dots_nonempty"
  )
}

stop_dots <- function(message, dot_names, note = NULL, .subclass = NULL, ...) {
  message <- paste_line(
    message,
    "",
    "We detected these problematic arguments:",
    paste0("* `", dot_names, "`"),
    "",
    note,
    "Did you misspecify an argument?"
  )
  abort(message, .subclass = c(.subclass, "rlib_error_dots"), ...)
}

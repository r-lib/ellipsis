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
check_dots_used <- function(env = parent.frame(), action = abort) {
  eval_bare(exit_handler(action), env)
  invisible()
}
on_load({
  check_dots_used <- replace_from("check_dots_used", "rlang")
})

check_dots <- function(env = parent.frame(), action) {
  if (.Call(ellipsis_dots_used, env)) {
    return(invisible())
  }

  proms <- dots(env)
  used <- vapply(proms, promise_forced, logical(1))

  unused <- names(proms)[!used]
  action_dots(
    action = action,
    message = paste0(length(unused), " components of `...` were not used."),
    dot_names = unused,
    .subclass = "rlib_error_dots_unused",
  )
}

exit_handler <- function(action) {
  expr(
    on.exit((!!check_dots)(environment(), !!action), add = TRUE)
  )
}

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
check_dots_unnamed <- function(env = parent.frame(), action = abort) {
  proms <- dots(env, auto_name = FALSE)
  if (length(proms) == 0) {
    return()
  }

  unnamed <- is.na(names(proms))
  if (all(unnamed)) {
    return(invisible())
  }

  named <- names(proms)[!unnamed]
  action_dots(
    action = action,
    message = paste0(length(named), " components of `...` had unexpected names."),
    dot_names = named,
    .subclass = "rlib_error_dots_named",
  )
}
on_load({
  check_dots_unnamed <- replace_from("check_dots_unnamed", "rlang")
})


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
check_dots_empty <- function(env = parent.frame(), action = abort) {
  dots <- dots(env)
  if (length(dots) == 0) {
    return()
  }

  action_dots(
    action = action,
    message = "`...` is not empty.",
    dot_names = names(dots),
    note = "These dots only exist to allow future extensions and should be empty.",
    .subclass = "rlib_error_dots_nonempty"
  )
}
on_load({
  check_dots_empty <- replace_from("check_dots_empty", "rlang")
})

action_dots <- function(action, message, dot_names, note = NULL, .subclass = NULL, ...) {
  message <- paste_line(
    message,
    "",
    "We detected these problematic arguments:",
    paste0("* `", dot_names, "`"),
    "",
    note,
    "Did you misspecify an argument?"
  )
  action(message, .subclass = c(.subclass, "rlib_error_dots"), ...)
}

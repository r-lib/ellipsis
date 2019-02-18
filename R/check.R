#' Check that all dots have been used
#'
#' Automatically sets exit handler to run when function terminates, checking
#' that all elements of `...` have been evaluated.
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
#' f(x = 1, y = 2, z = 3)
#' f(x = 1, y = 2, 3, 4, 5)
check_dots_used <- function(env = parent.frame()) {
  exit_handler <- bquote(
    on.exit({
      .(check_dots)(environment())
    }, add = TRUE)
  )
  eval_bare(exit_handler, env)

  invisible()
}

check_dots <- function(env = parent.frame()) {
  proms <- dots(env)
  used <- vapply(proms, promise_forced, logical(1))

  if (all(used)) {
    return(invisible())
  }

  unnused <- names(proms)[!used]
  warning(
    "Some components of ... were not used: ",
    paste0(unnused, collapse = ", "),
    call. = FALSE,
    immediate. = TRUE
  )
}

#' Check that all dots are unnamed
#'
#' Named arguments in ... are often a sign of misspelled argument names.
#'
#' @param env Environment in which to look for ...
#' @export
#' @examples
#' f <- function(..., foofy = 8) {
#'   check_dots_unnamed()
#'   c(...)
#' }
#'
#' f(1, 2, 3, foofy = 4)
#' f(1, 2, 3, foof = 4)
check_dots_unnamed <- function(env = parent.frame()) {
  proms <- dots(env, auto_name = FALSE)

  unnamed <- is.na(names(proms))
  if (all(unnamed)) {
    return(invisible())
  }

  named <- names(proms)[!unnamed]
  warning(
    "Some components of ... had unexpected names: ",
    paste0(named, collapse = ", "),
    call. = FALSE,
    immediate. = TRUE
  )
}

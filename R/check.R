#' Check that all dots in current environment have been used
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
  eval(exit_handler, env)

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

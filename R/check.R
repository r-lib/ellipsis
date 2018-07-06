#' Check that all dots in current environment have been used
#'
#' Typically used in `on.exit()`. Generates warning if any dots have not
#' been forced (i.e. evaluated)
#'
#' @param env Environment in which to look for `...`. This is a temporary
#'   API until we have a C API that can follow promises up multiple levels
#'   in the call stack.
#' @export
#' @examples
#' f <- function(...) {
#'   on.exit(check_dots_used())
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
check_dots_used <- function(env = caller_env()) {
  proms <- env_dots_promises(env)
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

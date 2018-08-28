#' @import rlang
NULL

#' @useDynLib ellipsis, .registration = TRUE
dots <- function(env = caller_env()) {
  .Call(ellipsis_dots, env)
}

promise_forced <- function(x) {
  .Call(ellipsis_promise_forced, x)
}

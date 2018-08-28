NULL

#' @useDynLib ellipsis, .registration = TRUE
dots <- function(env = parent.frame()) {
  .Call(ellipsis_dots, env)
}

promise_forced <- function(x) {
  .Call(ellipsis_promise_forced, x)
}

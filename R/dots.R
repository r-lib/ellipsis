NULL

#' @useDynLib ellipsis, .registration = TRUE
dots <- function(env = parent.frame(), auto_name = TRUE) {
  .Call(ellipsis_dots, env, auto_name)
}

promise_forced <- function(x) {
  .Call(ellipsis_promise_forced, x)
}

eval_bare <- function(expr, env) {
  .Call(ellipsis_eval_bare, expr, env)
}

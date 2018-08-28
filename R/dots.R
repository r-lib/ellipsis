#' @import rlang
NULL

env_dots_promises <- function(env = caller_env()) {
  dots <- env_get(env, "...")
  if (missing(dots)) {
    return(list())
  }

  n <- length(dots)

  list <- vector("list", n)
  for (i in seq_len(n)) {
    list[[i]] <- node_car(dots)
    names(list)[[i]] <- as.character(node_tag(dots) %||% paste0("..", i))

    dots <- node_cdr(dots)
  }

  list
}

#' @useDynLib ellipsis, .registration = TRUE
promise_forced <- function(x) {
  .Call(ellipsis_promise_forced, x)
}

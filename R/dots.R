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

promise_forced <- function(x) {
  # Something we expect to be a promise not be, b/c of byte code compiler
  if (typeof(x) != "promise")
    return(TRUE)

  !identical(rlang:::promise_value(x), quote(R_UnboundValue))
}

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

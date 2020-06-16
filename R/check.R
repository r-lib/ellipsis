#' Check that all dots have been used
#'
#' Automatically sets exit handler to run when function terminates, checking
#' that all elements of `...` have been evaluated. If you use [on.exit()]
#' elsewhere in your function, make sure to use `add = TRUE` so that you
#' don't override the handler set up by `check_dots_used()`.
#'
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


#' Check that dots are unused
#'
#' Sometimes you just want to use `...` to force your users to fully name
#' the details arguments. This function warns if `...` is not empty.
#'
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

#' Check that all dot parameter names are a valid subset of a function's parameter names.
#'
#' This function ensures that [dots (...)][base::dots()] are either empty (if `.empty_ok = TRUE`), or all named dot parameter names are a valid subset of a
#' function's parameter names. In case of an invalid or `.forbidden` argument, an informative message is shown and the defined `.action` is taken.
#'
#' `check_dots_named()` is intended to combat the second one of the two major downsides that using `...` usually brings. In chapter 6.6 of the book
#' _Advanced R_ it is [phrased](https://adv-r.hadley.nz/functions.html#fun-dot-dot-dot) as follows:
#'
#' _Using `...` comes with two downsides:_
#'
#' - _When you use it to pass arguments to another function, you have to carefully explain to the user where those arguments go. This makes it hard to
#'   understand what you can do with functions like `lapply()` and `plot()`._
#'
#' - **_A misspelled argument will not raise an error. This makes it easy for typos to go unnoticed._**
#'
#' @param ... The dots argument to check.
#' @param .function The function the `...` will be passed on to.
#' @param .forbidden Parameter names within `...` that should be treated as
#'   invalid. A character vector.
#' @param .empty_ok Set to `TRUE` if empty `...` should be allowed, or to `FALSE`
#'   otherwise.
#' @param .action The action to take when the check fails. One of [rlang::abort()],
#'   [rlang::warn()], [rlang::inform()] or [rlang::signal()].
#' @export
#' @examples
#' # We can use `check_dots_named()` to address this second downside:
#' sum_safe <- function(...,
#'                      na.rm = FALSE) {
#'   check_dots_named(...,
#'                    .function = sum)
#'   sum(...,
#'       na.rm = na.rm)
#' }
#'
#' # note how the misspelled `na_rm` (instead of `na.rm`) silently gets ignored
#' # in the original function
#' sum(1, 2, NA, na_rm = TRUE)
#'
#' \dontrun{
#' # whereas our safe version properly errors
#' sum_safe(1, 2, NA, na_rm = TRUE)}
#'
#' # we can even build an `sapply()` function that fails "intelligently"
#' sapply_safe <- function(X,
#'                         FUN,
#'                         ...,
#'                         simplify = TRUE,
#'                         USE.NAMES = TRUE) {
#'   check_dots_named(...,
#'                    .function = FUN)
#'   sapply(X = X,
#'          FUN = FUN,
#'          ...,
#'          simplify = TRUE,
#'          USE.NAMES = TRUE)
#' }
#'
#' # while the original `sapply()` silently ignores misspelled arguments,
#' sapply(1:5, paste, "hour workdays", sep = "-", colaspe = " ")
#'
#' \dontrun{
#' # `sapply_safe()` will throw an informative error message
#' sapply_safe(1:5, paste, "hour workdays", sep = "-", colaspe = " ")}
#'
#' \dontrun{
#' # but be aware that `check_dots_named()` might be a bit rash
#' sum_safe(a = 1, b = 2)}
#'
#' # while the original function actually has nothing to complain about
#' sum(a = 1, b = 2)
#'
#' \dontrun{
#' # also, it doesn't play nicely with functions that don't expose all of
#' # their arg names (`to` and `by` in the case of `seq()`)
#' sapply_safe(X = c(0,50),
#'             FUN = seq,
#'             to = 100,
#'             by = 5)}
#'
#' # but providing `to` and `by` *unnamed* is fine of course:
#' sapply_safe(X = c(0,50),
#'             FUN = seq,
#'             100,
#'             5)
check_dots_named <- function(...,
                             .function,
                             .forbidden = NULL,
                             .empty_ok = TRUE,
                             .action = abort) {
  if (...length()) {

    # determine original function name the `...` will be passed on to
    fun_arg_name <- deparse1(substitute(.function))
    parent_call <- as.list(sys.call(-1L))
    parent_param_names <- methods::formalArgs(sys.function(-1L))

    if (fun_arg_name %in% parent_param_names) {
      fun_name <- as.character(parent_call[which(parent_param_names == fun_arg_name) + 1][[1]])
    } else {
      fun_name <- fun_arg_name
    }

    # determine param names of the function the `...` will be passed on to
    dots_param_names <- methods::formalArgs(checkmate::assert_function(.function))

    # check named `...` args
    purrr::walk(
      .x = setdiff(names(c(...)), ""),
      .f = check_dot_named,
      values = dots_param_names,
      allowed_values = setdiff(dots_param_names,
                               checkmate::assert_character(.forbidden,
                                                           any.missing = FALSE,
                                                           null.ok = TRUE)),
      fun_name = fun_name,
      action = .action
    )

  } else if (!.empty_ok) {
    .action("`...` must be provided (!= `NULL`).",
            .subclass = c("rlib_error_dots_empty", "rlib_error_dots"))
  }
}

# The following code is largely borrowed from `rlang::arg_match()`
check_dot_named <- function(dot,
                            values,
                            allowed_values,
                            fun_name,
                            action) {
  i <- match(dot, allowed_values)

  if (is_na(i)) {

    is_forbidden <- dot %in% values
    is_restricted <- !setequal(values,
                               allowed_values)

    msg <- paste0(ifelse(is_forbidden, "Forbidden", "Invalid"),
                  " argument provided in `...`: `", dot, "`\n")

    if (length(allowed_values) > 0) {
      msg <- paste0(msg, ifelse(is_restricted,
                                "Arguments allowed to pass on to ",
                                "Valid arguments for "),
                    "`", fun_name, "()` include: ",
                    prose_ls(allowed_values, wrap = "`"), "\n")
    } else {
      msg <- paste0(msg, "Only unnamed arguments are ",
                    ifelse(is_restricted, "allowed", "valid"),
                    " for `", fun_name, "()`.")
    }

    i_partial <- pmatch(dot, allowed_values)

    if (!is_na(i_partial)) {
      candidate <- allowed_values[[i_partial]]
    }

    i_close <- utils::adist(dot, allowed_values)/nchar(allowed_values)

    if (any(i_close <= 0.5)) {
      candidate <- allowed_values[[which.min(i_close)]]
    }

    if (exists("candidate")) {
      candidate <- prose_ls(candidate, wrap = "`")
      msg <- paste0(msg, "\n", "Did you mean ", candidate, "?")
    }

    action(msg, .subclass = c("rlib_error_dots_invalid_name", "rlib_error_dots"))
  }
}

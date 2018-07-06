#' Safer version of risky functions
#'
#' These functions warn if some elements of `...` never get used.
#'
#' @param x Vector input
#' @param f Function to apply to each element
#' @param ... For `safe_map()`, additional arguments passed on to `f`.
#'   For `safe_median()`, additional arguments passed on to methods.
#' @name safe
#' @examples
#' x <- safe_map(iris[1:4], median, na.rm = TRUE)
#' x <- safe_map(iris[1:4], median, na.mr = TRUE)
NULL

#' @rdname safe
#' @export
safe_map <- function(x, f, ...) {
  check_dots_used()

  out <- vector("list", length(x))
  for (i in seq_along(out)) {
    out[[i]] <- f(x[[i]], ...)
  }

  out
}

#' @rdname safe
#' @export
safe_median <- function(x, ...) {
  check_dots_used()
  UseMethod("safe_median")
}

#' @export
safe_median.numeric <- function(x, ..., na.rm = TRUE) {
  mean(x, na.rm = na.rm)
}

#' Safe version of median
#'
#' `safe_median()` works [stats::median()] but warns if some elements of `...`
#' are never used.
#'
#' @param x Numeric vector
#' @param ... Additional arguments passed on to methods.
#' @param na.rm For numeric method, should missing values be removed?
#' @export
#' @examples
#' x <- c(1:10, NA)
#' safe_median(x, na.mr = TRUE)
#' safe_median(x, na.rm = TRUE)
safe_median <- function(x, ...) {
  check_dots_used()
  UseMethod("safe_median")
}

#' @export
#' @rdname safe_median
safe_median.numeric <- function(x, ..., na.rm = TRUE) {
  stats::median(x, na.rm = na.rm)
}

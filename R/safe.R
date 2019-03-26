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
#' safe_median(x, na.rm = TRUE)
#' median(x, na.rm = TRUE)
#'
#' try(median(x, na.mr = TRUE))
#' try(safe_median(x, na.mr = TRUE))
#'
#' try(median(1, 2, 3))
#' try(safe_median(1, 2, 3))
safe_median <- function(x, ...) {
  check_dots_used()
  UseMethod("safe_median")
}

#' @export
#' @rdname safe_median
safe_median.numeric <- function(x, ..., na.rm = TRUE) {
  stats::median(x, na.rm = na.rm)
}

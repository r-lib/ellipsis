#' Safe version of median
#'
#' `safe_median()` works [base::median()] but warns if some elements of `...`
#' are never used.
#'
#' @param x Numeric vector
#' @param f Function to apply to each element
#' @param ... Additional arguments passed on to methods.
#' @export
#' @examples
#' x <- c(1:10, NA)
#' median(x, na.mr = TRUE)
#' safe_median(x, na.mr = TRUE)
safe_median <- function(x, ...) {
  check_dots_used()
  UseMethod("safe_median")
}

#' @export
safe_median.numeric <- function(x, ..., na.rm = TRUE) {
  median(x, na.rm = na.rm)
}

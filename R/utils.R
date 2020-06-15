
paste_line <- function(...) {
  paste(c(...), collapse = "\n")
}

#' List items concatenated in prose-style (..., ... and ...)
#'
#' This function takes a vector or list and concatenates its elements to a single string separated in prose-style.
#'
#' @param x A vector or a list.
#' @param wrap The string (usually a single character) in which `x` is to be wrapped.
#' @param separator The separator to delimit the elements of `x`.
#' @param last_separator The separator to delimit the second-last and last element of `x`.
#'
#' @return A character scalar.
#' @keywords internal
prose_ls <- function(x,
                     wrap = "",
                     separator = ", ",
                     last_separator = " and ") {
  if (length(x) < 2) {
    paste0(checkmate::assert_string(wrap), x, wrap)

  } else {
    paste0(wrap,
           paste0(x[-length(x)],
                  collapse = paste0(checkmate::assert_string(wrap), separator, wrap)),
           wrap,
           checkmate::assert_string(last_separator),
           wrap,
           x[length(x)],
           wrap)
  }
}

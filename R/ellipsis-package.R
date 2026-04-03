#' @keywords internal
#' @import rlang
"_PACKAGE"

.onLoad <- function(...) {
  check_dots_used <<- rlang::check_dots_used
  check_dots_unnamed <<- rlang::check_dots_unnamed
  check_dots_empty <<- rlang::check_dots_empty
}

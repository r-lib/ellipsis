
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ellipsis

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/ellipsis)](https://cran.r-project.org/package=ellipsis)
[![Travis build
status](https://travis-ci.org/r-lib/ellipsis.svg?branch=master)](https://travis-ci.org/r-lib/ellipsis)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/ellipsis/branch/master/graph/badge.svg)](https://codecov.io/gh/r-lib/ellipsis?branch=master)
<!-- badges: end -->

Adding `...` to a function is a powerful technique because it allows you
to accept any number of additional arguments. Unfortunately it comes
with a big downside: any misspelled or extraneous arguments will be
silently ignored. This package provides tools for making `...` safer:

  - `check_dots_used()` errors if any components of `...` are not
    evaluated. This allows an S3 generic to state that it expects every
    input to be evaluated.

  - `check_dots_unnamed()` errors if any components of `...` are named.
    This allows you to collect arbitrary unnamed arguments, warning if
    the user misspells a named argument.

  - `check_dots_empty()` errors if `...` is used. This allows you to use
    `...` to force the user to supply full argument names, while still
    warning if an argument name is misspelled.

Thanks to [Jenny Bryan](http://github.com/jennybc) for the idea, and
[Lionel Henry](http://github.com/lionel-) for the heart of the
implementation.

## Installation

Install the released version from CRAN:

``` r
install.packages("ellipsis")
```

Or the development version from GitHub:

``` r
devtools::install_github("r-lib/ellipsis")
```

## Example

`mean()` is a little dangerous because you might expect it to work like
`sum()`:

``` r
sum(1, 2, 3, 4)
#> [1] 10
mean(1, 2, 3, 4)
#> [1] 1
```

This silently returns the incorrect result because `mean()` has
arguments `x` and `...`. The `...` silently swallows up the additional
arguments. We can use `ellipsis::check_dots_used()` to check that every
input to `...` is actually used:

``` r
safe_mean <- function(x, ..., trim = 0, na.rm = FALSE) {
  ellipsis::check_dots_used()
  mean(x, ..., trim = trim, na.rm = na.rm)
}

safe_mean(1, 2, 3, 4)
#> Error: 3 components of `...` were not used.
#> 
#> We detected these problematic arguments:
#> * `..1`
#> * `..2`
#> * `..3`
#> 
#> Did you misspecify an argument?
```

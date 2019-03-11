
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ellipsis

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/ellipsis)](https://cran.r-project.org/package=ellipsis)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/ellipsis/branch/master/graph/badge.svg)](https://codecov.io/gh/r-lib/ellipsis?branch=master)
<!-- badges: end -->

Adding `...` to an S3 generic allows methods to take additional
arguments, but it comes with a big downside: any misspelled or
extraneous arguments will be silently ignored. This package explores an
approach to making `...` safer, by supply a function that a generic can
use to warn if any elements of `...` were not evaluated.

In the long run, this code is likely to live elsewhere (maybe R-core
might be interested in making it part of base R). This repository tracks
the current state of the experiment.

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

`safe_median()` works like `median()` but warns if any elements of `...`
are never evaluated

``` r
library(ellipsis)
x <- c(1:10, NA)

safe_median(x)
#> [1] 5.5
safe_median(x, TRUE)
#> Warning: Some components of ... were not used: ..1
#> [1] 5.5
safe_median(x, na.rm = TRUE)
#> [1] 5.5
safe_median(x, na.mr = TRUE)
#> Warning: Some components of ... were not used: na.mr
#> [1] 5.5
```

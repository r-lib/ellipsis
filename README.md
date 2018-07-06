
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ellipsis

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

Adding `...` to a function specification usually comes with a big
downside: any mispelled or extraneous arguments will be silently
ignored. This package explores an approach to making `...` safer, by
inspecting its contents and warning if any elements were not evaluated.

In the long run, this code is likely to live elsewhere. This repository
tracks the current state of the experiment.

## Installation

``` r
devtools::install_gituhb("hadley/ellipsis")
```

## Example

ellipsis comes with two functions that illustrates how we can make
functionals (which pass `...` to another argument) and S3 generics
(which pass `...` on to their methods) safer. `safe_map()` and
`safe_median()` warn if you supply arguments that are never evaluated.

``` r
library(ellipsis)

x <- safe_map(iris[1:4], median, na.mr = TRUE)
#> Warning: Some components of ... were not used: na.mr
x <- safe_map(iris[1:4], median, na.rm = TRUE)
x <- safe_map(iris[1:4], median, 2)
x <- safe_map(iris[1:4], median, 2, 3)
#> Warning: Some components of ... were not used: ..2

x <- safe_median(1:10)
x <- safe_median(1:10, FALSE)
#> Warning: Some components of ... were not used: ..1
x <- safe_median(1:10, na.rm = FALSE)
x <- safe_median(1:10, na.mr = TRUE)
#> Warning: Some components of ... were not used: na.mr
```

The top-level function handles all evaluation failures so that this only
generates a single warning (not one warning from `safe_map()` and four
from `safe_median()`)

``` r
x <- safe_map(iris[1:4], safe_median, na.mr = TRUE)
#> Warning: Some components of ... were not used: na.mr
```

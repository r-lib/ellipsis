
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ellipsis

Adding `...` to a function specification usually comes with a big
downside: any mispelled or extraneous arguments will be silently
ignored. This package explores an approach to making `...` safer, by
inspecting its contents and warning if any elements were not evaluated.

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

## Limitations

Currently combining a safe functional with a safe S3 generic is rather
noisy

``` r
x <- safe_map(iris[1:4], safe_median, na.mr = TRUE)
#> Warning: Some components of ... were not used: na.mr

#> Warning: Some components of ... were not used: na.mr

#> Warning: Some components of ... were not used: na.mr

#> Warning: Some components of ... were not used: na.mr

#> Warning: Some components of ... were not used: na.mr
```

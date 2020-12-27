# Ephemeris R package

[![R build status](https://github.com/dankelley/ephemeris/workflows/R-CMD-check/badge.svg)](https://github.com/dankelley/ephemeris/actions)


## Overview

The key function in this package is `ephemeris()`, which downloads and extends
Ephemeris data from a server (reference 1).

## Installation

`ephemeris` is not on CRAN, but may be installed with
```R
remotes::install_github("dankelley/ephemeris")
```

## Example

Running the example
```R
library(ephemeris)
example(ephemeris)
```
on 2020-12-25 produced the following.

![Example 1.](ex1.png)

1. https://ssp.imcce.fr/webservices/miriade/api/ephemcc/


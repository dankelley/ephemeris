# Ephemeris R package

[![R build status](https://github.com/dankelley/ephemeris/workflows/R-CMD-check/badge.svg)](https://github.com/dankelley/ephemeris/actions)
[![codecov](https://codecov.io/gh/dankelley/ephemeris/branch/main/graph/badge.svg)](https://codecov.io/gh/dankelley/ephemeris)


## Overview

The only function in this package is `ephemeris()`, which downloads and extends
Ephemeris data from an Observatoire de Paris webserver (Reference 1). Some
familiarity with that website will be of use to people trying to use this
package.

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
shows a typical use for the package.

## References

1. Institut de mécanique céleste et de calcul des éphémérides
   (https://ssp.imcce.fr/webservices/miriade/api/ephemcc/)


# Ephemeris R package

## Overview

The key function in this package is `epheremis()`, which downloads and extends
Ephemeris data from a server (reference 1).

## Installation

`epheremis` is not on CRAN, but may be installed with
```R
remotes::install_github("dankelley/ephemeris")
```

## Example

Running the example
```R
library(epheremis)
example(epheremis)
```
on 2020-12-25 produced the following.

![Example 1.](ex1.png)

## Limitations and Bugs

1. The time step must be in integral days. (In theory we can give e.g. `"1 h"`
   but that seems to fail in my tests.)

# References

1. https://ssp.imcce.fr/webservices/miriade/api/ephemcc/


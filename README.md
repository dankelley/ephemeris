# Ephemeris downloader

## Overview

`eph.R` is an R script to download and plot Ephemeris data from a server.  The
query used for the download is constructed from only a cursory glance at the
rather extensive documentation (see Resource 1), and so this is really quite
limited.

## Usage

Use
```R
Rscript eph.R
```
to create a simple plot of 28 days of data, starting at the present time.

## Limitations and Bugs

1. The time step must be in integral days. (In theory we can give e.g. `"1 h"`
   but that seems to fail in my tests.)

# Resources

1. https://ssp.imcce.fr/webservices/miriade/api/ephemcc/


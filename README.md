# Ephemeris downloader

## Overview

This is an R script to download and plot Ephemeris data from a server.  The
query used for the download is constructed from only a cursory glance at the
rather extensive documentation (see Resource 1), and so this is really quite
limited.

## Usage

Use
```R
Rscript esph.R
```
to create a simple plot of 28 days of data, starting at the present time.

## Limitations and Bugs

1. The time step must be in integral days.
2. How can we set the start time?

# Resources
1. https://ssp.imcce.fr/webservices/miriade/api/ephemcc/


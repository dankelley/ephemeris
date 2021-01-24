## vim:textwidth=80:expandtab:shiftwidth=2:softtabstop=2
library(ephemeris)

context("ephemeris")

C <- function(a, b, c)
  a + b/60 + c/3600

test_that("sun ephemeris vs in-the-sky.org on 2020-01-04",
          {
            ## Reference: the site
            ## https://in-the-sky.org/ephemeris.php?ird=1&objtype=1&objpl=Sun&objtxt=the+Sun&tz=1&startday=3&startmonth=1&startyear=2020&interval=1&rows=25
            ## RA:   18h55m37s
            ## DEC: -22°49'16"
            E <- ephemeris::ephemeris(name="p:Sun", t0="2020-01-04", nbd=1)
            # We only check 2 decimal places, because numbers after that changed
            # between Dec 2020 and Jan 2021.  Perhaps the formulae changed.
            expect_equal(substr(E$RA,  1, 12), "+18 55 37.55") # self-consistency check
            expect_equal(substr(E$DEC, 1, 12), "-22 49 16.28") # self-consistency check
            expect_equal(E$RAdec,   C(18,55,37), tolerance=1/3600, scale=1)
            expect_equal(E$DECdec, -C(22,49,16), tolerance=1/3600, scale=1)
          }
)

test_that("moon ephemeris vs in-the-sky.org on 2020-01-04",
          {
            ## Reference: For 2002-01-04
            ## https://in-the-sky.org/ephemeris.php?ird=1&objtype=1&objpl=Moon&objtxt=the+Moon&tz=1&startday=3&startmonth=1&startyear=2020&interval=1&rows=25
            ## RA:   01h27m21s
            ## DEC: +03°37'39"
            E <- ephemeris::ephemeris(name="s:Moon", t0="2020-01-04", nbd=1)
            # We only check 2 decimal places, because numbers after that changed
            # between Dec 2020 and Jan 2021.  Perhaps the formulae changed.
            expect_equal(substr(E$RA,  1, 12), "+01 27 23.68") # consistency check
            expect_equal(substr(E$DEC, 1, 12), "+03 37 53.58") # consistency check
            expect_equal(E$RAdec,  C(01,27,21), tolerance=3/3600, scale=1)
            expect_equal(E$DECdec, C(03,37,39), tolerance=15/3600, scale=1)
          }
)

test_that("error messages",
          {
            expect_error(ephemeris(theory="junk"), "theory must be")
            expect_error(ephemeris(teph=5), "teph must be")
            expect_error(ephemeris(tcoor=6), "tcoor must be")
            expect_error(ephemeris(rplane=3), "rplane must be")
          }
)

test_that("debug messages",
          {
            expect_output(ephemeris(debug=TRUE), "https://")
          }
)


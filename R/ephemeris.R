# See README.md and Makefile


#' Get ephemeris data
#'
#' This function infers ephemeris data by querying a website (reference 1),
#' and so it requires a web connection to work. It is aimed at people who
#' already know the ideas and terminology of ephemeris computations. Tests
#' against the *In the Sky* website suggest RA and DEC accuracy to within
#' 1 arc-second for the sun, and 15 arc-seconds for the moon.
#'
#' The names of parameters, and their explanaations, are patterned on Reference 1.
#' In particular, the moon is `"s:Moon"` and the sun is (oddly) `"p:Sun"`.
#'
#' Apart from the listed parameters of this function, the other specifications for
#' the query are set up in the same way as is used in the query-generation examples
#' provided in Reference 1.
#' For example, the 'observer' is set to `@500`, designating the centre of the earth.
#'
#' Users who are curious about the query should specify `debug=TRUE` when calling
#' this function, and they are encouraged to contact the package author, if
#' they would like any of these hard-wired defaults to be transformed
#' into a user-adjustable value, via the creation of new parameters
#' to this function.
#'
#' @param name character value of object in question. There are many objects
#' that can be checked, e.g. `"p:Sun"` for the sun and
#' `"s:Moon"` for the moon.  Default: `"p:Sun"`.
#'
#' @param longitude decimal value of the longitude. Default: 0.
#'
#' @param latitude decimal value of the latitude.  Default: 0.
#'
#' @param t0 POSIXct time (UTC) for the first retrieval, or a string from which
#' [as.POSIXct()] can infer such a time. Default: start of present day.
#' In Reference 1, this is called `ep` and referred to as the requested epoch.
#'
#' @param nbd integer value of the number of times to be retrieved. Default: 5.
#'
#' @param step numeric value for the time increment, in days.  Default: 1.
#'
#' @param theory character value indicating the planetary theory, with choices
#' `"INPOP"`, `"DE200"`, `"BDL82"`, `"SLP98"`, `"DE403"`,
#' `"DE405"`, `"DE406"`, `"DE430"`, and `"DE431"`. Default: `"INPOP"`.
#'
#' @param teph integer value for the type of ephemeris, with 1
#' for astrometric J2000, 2 for apparent of the date, 3 for mean
#' of the date, or 4 for mean J2000. Default: 1.
#'
#' @param tcoor integer value for the type of coordinate, with 1
#' for spherical, 2 for rectangular, 3 for local, 4 for hour angle, and
#' 5 dedicated to observation. Default: 1.
#'
#' @param rplane integer value for the reference plane, with 1
#' for equator and 2 for ecliptic. Default: 1.
#'
#' @param debug logical value indicating whether to print debugging information. At the moment,
#' the only information printed is the query string. Default: `FALSE`.
#'
#' @return `ephemeris` returns a data frame containing columns named
#' `"time"`, `"RA"`, `"RAdec"` (decimal hour angle),
#' `"DEC"` (string hour angle), `"DECdec"` (decimal hour angle),
#' `"Dobs"`, `"VMag"`, `"Phase"`, `"Elong."`,
#' `"dRAcosDEC"`, `"dDEC"`, and `"RV"`.  In addition, *PROVISIONALLY*
#' decimal values of `RA` and `DEC` are computed if `tcoor=1`, but
#' these may be incorrect.
#'
#' @examples
#' # Plot daily Right Ascension and Declination values over a 28-day period.
#' library(ephemeris)
#' s <- ephemeris("p:Sun", nbd=28)
#' m <- ephemeris("s:Moon", nbd=28)
#' par(mfrow=c(2, 1), mar=c(3,3,1,2), mgp=c(2,0.7,0))
#' RAlim <- range(c(s$RAdec, m$RAdec))
#' plot(s$time, s$RAdec, type="o", xlab="", ylab="Right Ascension [hour]", col=2, ylim=RAlim)
#' lines(m$time, m$RAdec, col=4, type="o")
#' mtext("Red: sun", col=2, adj=0)
#' mtext("Blue: moon", col=4, adj=1)
#' DEClim <- range(c(s$DECdec, m$DECdec))
#' plot(s$time, s$DECdec, type="o", xlab="", ylab="Declination [angle]", col=2, ylim=DEClim)
#' lines(m$time, m$DECdec, col=4, type="o")
#'
#' @author Dan Kelley
#'
#' @references
#' 1. The *Institut de mécanique céleste et de calcul des éphémérides* website
#' \url{https://ssp.imcce.fr/webservices/miriade/api/ephemcc/} is the source of
#' data returned by `ephemeris`.
#'
#' 2. The *In The Sky* website used for tests demonstrating 1 arc-second
#' consistency for sun RA and DEC, and 15 arc-second consistency for moon:
#' \url{https://in-the-sky.org/ephemeris.php}
#'
#' @importFrom utils read.csv tail
#' @export
ephemeris <- function(name="p:Sun", longitude=0, latitude=0, t0=Sys.Date(), nbd=5, step=1,
                     theory="INPOP", teph=1, tcoor=1, rplane=1, debug=FALSE)
{
    ## Check argument validity
    if (!theory %in% c("INPOP", "DE200", "BDL82", "SLP98", "DE403", "DE405", "DE406", "DE430", "DE431"))
        stop("theory must be \"INPOP\", \"DE200\", \"BDL82\", \"SLP98\", \"DE403\", \"DE405\", \"DE406\", \"DE430\", or \"DE431\"")
    teph <- as.integer(teph)
    if (!teph %in% 1:4)
        stop("teph must be 1, 2, 3 or 4")
    tcoor <- as.integer(tcoor)
    if (!tcoor %in% 1:5)
        stop("tcoor must be 1, 2, 3, 4 or 5")
    rplane <- as.integer(rplane)
    if (!rplane %in% 1:2)
        stop("rplane must be 1 or 2")
    ## Format time as required by the IMCCE website
    if (is.character(t0))
        t0 <- as.POSIXct(t0, tz="UTC")
    ep <- format(t0, "%Y-%m-%d&nbsp;12h")
    query <- paste0("https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?",
                    "-name=", name,
                    "&-type=",
                    "&-ep=\"", ep, "\"",
                    "&-long=", -longitude, # convention: negative to East
                    "&-lat=", latitude,
                    "&-nbd=", nbd,
                    "&-step=", step, "d",
                    "&-tscale=UTC",
                    "&-observer=@500",
                    "&-theory=", theory,
                    "&-teph=", teph,
                    "&-tcoor=", tcoor,
                    "&-rplane=", rplane,
                    "&-oscelem=astorb",
                    "&-mime=text/csv",
                    "&-from=R/ephemeris")
    if (debug)
        cat(query, "\n")
    eph <- readLines(query)
    headerEnd <- tail(grep("^#", eph), 1)
    if (debug)
        cat("headerEnd: ", headerEnd, "\n")
    object <- tail(strsplit(trimws(strsplit(eph[headerEnd],"\\|")[[1]][1]), " ")[[1]],1)
    queryNames <- strsplit(eph[1 + tail(grep("^#", eph),1)], ", ")[[1]]
    if (debug) {
        cat("Object: ", object, "\n", sep="")
        cat("QueryNames: \"", paste(queryNames, collapse="\", \""), "\"\n", sep="")
    }
    ##OLD col.names <- c("time", "RA", "DEC", "Dobs", "VMag", "Phase", "Elong.", "dRAcosDEC", "dDEC", "RV")
    col.names <- gsub("[ ]+(.*)$","", queryNames)
    if (debug)
        cat("col.names: \"", paste(col.names, collapse="\", \""), "\"\n", sep="")
    data <- read.csv(text=eph, skip=headerEnd+1, header=FALSE, col.names=col.names)
    ## Remove annoying initial whitespace
    if ("RA" %in% names(data))
        data$RA <- trimws(data$RA)
    if ("DEC" %in% names(data))
        data$DEC <- trimws(data$DEC)
    if (tcoor == 1) {
        ## RA and DEC are in '[sign]hour min sec' format.
        data$RAdec <- sapply(data$RA, function(x) {
                             sign <- if (grepl("^\\-", x)) -1 else 1
                             s <- strsplit(x, " ")[[1]]
                             as.numeric(s[1]) + sign * (as.numeric(s[2])/60 + as.numeric(s[3])/3600)
                    })
        data$DECdec <- sapply(data$DEC, function(x) {
                              sign <- if (grepl("^\\-", x)) -1 else 1
                              s <- strsplit(x, " ")[[1]]
                              as.numeric(s[1]) + sign * (as.numeric(s[2])/60 + as.numeric(s[3])/3600)
                    })
    }
    ## Add a POSIX time field, if we can.  Note that for tcoor=2,
    ## data$Date is an integer.  If we really need to figure this out,
    ## it might be worth decoding this, but for now we don't bother.
    if (is.character(data$Date))
        data$time <- as.POSIXct(data$Date, tz="UTC")
    data
}


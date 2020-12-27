# See README.md and Makefile


#' Get ephemeris data
#'
#' This function infers ephemeris data by querying a website (reference 1),
#' and so it requires a web connection to work.
#'
#' @param name character value of object in question, e.g. `"s:Sun"` for the sun and
#' `"s:Moon"` for the moon.  Default: `"s:Sun"`.
#'
#' @param longitude decimal value of the longitude. Default: 0.
#'
#' @param latitude decimal value of the latitude.  Default: 0.
#'
#' @param t0 POSIXct time (UTC) for the first retrieval, or a string from which
#' [as.POSIXct()] can infer such a time. Default: start of present day.
#'
#' @param nbd integer value of the number of times to be retrieved. Default: 5.
#'
#' @param step numeric value for the time increment, in days.  Default: 1.
#'
#' @param debug logical value indicating whether to print debugging information. At the moment,
#' the only information printed is the query string. Default: `FALSE`.
#'
#' @return a data frame containing columna named
#' `"time"`, `"RA"`, `"RAdeg"`, `"DEC"`, `"DECdeg"`, `"Dobs"`, `"VMag"`, `"Phase"`, `"Elong."`,
#' `"dRAcosDEC"`, `"dDEC"`, and `"RV"`.  All items except those ending in `deg` are as is
#' returned form the sever.  However, since the angles `"RA"` and `"DEC"` are in a non-numeric
#' format, `ephemeris` computes degimal forms, stored in `"RAdeg"` and `DECdeg"`.
#'
#' @examples
#' # Plot daily Right Ascension and Declination values over a 28-day period.
#' library(ephemeris)
#' s <- ephemeris(nbd=28)
#' m <- ephemeris("s:Moon", nbd=28)
#' par(mfrow=c(2, 1), mar=c(3,3,1,2), mgp=c(2,0.7,0))
#' RAlim <- range(c(s$RAdeg, m$RAdeg))
#' plot(s$time, s$RAdeg, type="o", xlab="", ylab="Right Ascension", col=2, ylim=RAlim)
#' lines(m$time, m$RAdeg, col=4, type="o")
#' mtext("Red: sun", col=2, adj=0)
#' mtext("Blue: moon", col=4, adj=1)
#' DEClim <- range(c(s$DECdeg, m$DECdeg))
#' plot(s$time, s$DECdeg, type="o", xlab="", ylab="Declination", col=2, ylim=DEClim)
#' lines(m$time, m$DECdeg, col=4, type="o")
#'
#' @author Dan Kelley
#'
#' @references
#' 1. The *Institut de mécanique céleste et de calcul des éphémérides* website
#' \url{https://ssp.imcce.fr/webservices/miriade/api/ephemcc/} is the source of
#' data returned by `ephemeris`.
#'
#' @importFrom utils read.csv
#' @export
ephemeris <- function(name="s:Sun", longitude=0, latitude=0, t0=Sys.Date(), nbd=5, step=1, debug=FALSE)
{
    if (is.character(t0))
        t0 <- as.POSIXct(t0)
    t0string <- format(t0, "%Y-%m-%d&nbsp;12h")
    query <- paste0("https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?",
                    "-name=", name,
                    "&-type=",
                    "&-ep=\"", t0string, "\"", # BUG: ignored
                    "&-long=", -longitude, # convention: negative to East
                    "&-lat=", latitude,
                    "&-nbd=", nbd,
                    "&-step=", step, "d",
                    "&-tscale=UTC",
                    "&-observer=@500",
                    "&-theory=INPOP",
                    "&-teph=1",
                    "&-tcoor=1",
                    "&-oscelem=astorb",
                    "&-mime=text/csv",
                    "&-from=MiriadeDoc")
    if (debug)
        cat(query, "\n")
    eph <- readLines(query)
    col.names <- c("time", "RA", "DEC", "Dobs", "VMag", "Phase", "Elong.", "dRAcosDEC", "dDEC", "RV")
    data <- read.csv(text=eph, skip=4, header=FALSE, col.names=col.names)
    ## RA and DEC are in '[sign]deg min sec' format
    data$RAdeg <- sapply(data$RA, function(x) {
                         x <- trimws(x)
                         sign <- if (grepl("^\\-", x)) -1 else 1
                         s <- strsplit(x, " ")[[1]]
                         as.numeric(s[1]) + sign * (as.numeric(s[2])/60 + as.numeric(s[3])/3600)
                    })
    data$DECdeg <- sapply(data$DEC, function(x) {
                          x <- trimws(x)
                          sign <- if (grepl("^\\-", x)) -1 else 1
                          s <- strsplit(x, " ")[[1]]
                          as.numeric(s[1]) + sign * (as.numeric(s[2])/60 + as.numeric(s[3])/3600)
                    })
    data$time <- as.POSIXct(data$time, tz="UTC")
    data
}


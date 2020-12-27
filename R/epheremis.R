# See README.md and Makefile


#' Get ephemeris data
#'
#' This function infers ephemeris data by querying a website (reference 1),
#' and so it requires a web connection to work. It is aimed at people who
#' already know the ideas and terminology of ephemeris computations.
#'
#' Apart from the parameters of this function, the other specifications for
#' the query are set up in the same way as is used in the query-generation examples.
#' For example, the 'observer' is set to `@500`, designating the centre of the earth.
#' Users who are curious about the query should specify `debug=TRUE` when calling
#' this function, and they are encouraged to contact the package author, if
#' they would like any of these hard-wired defaults to be transformed
#' into a user-adjustable value, via the creation of new parameters
#' to this function.
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
#' @return `ephemeris` returns a data frame containing columns named
#' `"time"`, `"RA"` (string hour angle), `"RAdec"` (decimal hour angle),
#' `"DEC"` (string hour angle), `"DECdec"` (decimal hour angle),
#' `"Dobs"`, `"VMag"`, `"Phase"`, `"Elong."`,
#' `"dRAcosDEC"`, `"dDEC"`, and `"RV"`.  Note that the numeric values
#' `RAdec` and `DECdec` are computed from the string values `RA` and `DEC` retrieved
#' from the server.
#'
#' @examples
#' # Plot daily Right Ascension and Declination values over a 28-day period.
#' library(ephemeris)
#' s <- ephemeris(nbd=28)
#' m <- ephemeris("s:Moon", nbd=28)
#' par(mfrow=c(2, 1), mar=c(3,3,1,2), mgp=c(2,0.7,0))
#' RAlim <- range(c(s$RAdeg, m$RAdeg))
#' plot(s$time, s$RAdeg, type="o", xlab="", ylab="RA [hour angle]", col=2, ylim=RAlim)
#' lines(m$time, m$RAdeg, col=4, type="o")
#' mtext("Red: sun", col=2, adj=0)
#' mtext("Blue: moon", col=4, adj=1)
#' DEClim <- range(c(s$DECdeg, m$DECdeg))
#' plot(s$time, s$DECdeg, type="o", xlab="", ylab="DEC [hour angle]", col=2, ylim=DEClim)
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


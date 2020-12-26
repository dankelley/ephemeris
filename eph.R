# See README.md and Makefile

library(oce)

getEphemeris <- function(name="s:Sun", longitude=0, latitude=0, nbd=5, step=1, debug=TRUE)
{
    query <- paste0("https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?",
                    "-name=", name,
                    "&-type=",
                    "&-ep=(2020-01-01T00:00:00)", # BUG: ignored
                    "&-long=", -longitude, # convention: negative to East
                    "&-lat=", latitude,
                    "&-nbd=", nbd,
                    "&-step=", step, "d", # FIXME: how to specify in e.g. hours?
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

s <- getEphemeris(nbd=28, step=1)
m <- getEphemeris("s:Moon", nbd=28, step=1)

par(mfrow=c(2, 1))

RAlim <- range(c(s$RAdeg, m$RAdeg))
oce.plot.ts(s$time, s$RAdeg, type="o", ylab="Right Ascension", col=2, ylim=RAlim, grid=TRUE)
lines(m$time, m$RAdeg, col=4, type="o")

DEClim <- range(c(s$DECdeg, m$DECdeg))
oce.plot.ts(s$time, s$DECdeg, type="o", ylab="Declination", col=2, ylim=DEClim, drawTimeRange=FALSE, grid=TRUE)
lines(m$time, m$DECdeg, col=4, type="o")
mtext("Red: sun; Blue: moon")


# See README.md and Makefile

library(oce)

getEphemeris <- function(name="s:Moon", nbd=5, step=1)
{
    query <- paste0("https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?",
                    "-name=", name,
                    "&-type=",
                    "&-ep=(2020-01-01)",
                    "&-nbd=", nbd,
                    "&-step=", step, "d", # FIXME: how to specify in e.g. hours?
                    "&-tscale=UTC&-observer=@500",
                    "&-theory=INPOP",
                    "&-teph=1",
                    "&-tcoor=1",
                    "&-oscelem=astorb",
                    "&-mime=text/csv",
                    "&-from=MiriadeDoc")
    eph <- readLines(query)
    col.names <- c("time", "RA", "DEC", "Dobs", "VMag", "Phase", "Elong.", "dRAcosDEC", "dDEC", "RV")
    data <- read.csv(text=eph, skip=4, header=FALSE, col.names=col.names)
    ## RA and DEC are in '[sign]deg min sec' format
    data$RAdeg <- sapply(data$RA, function(x) {
                         s <- strsplit(trimws(x), " ")[[1]]
                         as.integer(s[1]) + as.integer(s[2])/60 + as.integer(s[3])/3600
                    })
    data$DECdeg <- sapply(data$DEC, function(x) {
                          s <- strsplit(trimws(x), " ")[[1]]
                          as.integer(s[1]) + as.integer(s[2])/60 + as.integer(s[3])/3600
                    })
    data$time <- as.POSIXct(data$time, tz="UTC")
    data
}

d <- getEphemeris(nbd=28, step=1)
par(mfrow=c(2, 1))
oce.plot.ts(d$time, d$RAdeg, type="o", ylab="Right Ascension")
oce.plot.ts(d$time, d$DECdeg, type="o", ylab="Declination")
